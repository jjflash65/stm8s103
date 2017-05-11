/* -------------------------------------------------------
                         rda5807_test.c

     Testprogramm fuer das UKW-Modul RDA5807M  mit
     I2C Interface. "Bedienung" ueber die serielle
     Schnittstelle.

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     31.05.2016  R. Seelig

   ------------------------------------------------------ */

/* ------------------------------------------------------

   Pinbelegung RDA5807 Modul

                                 RDA5807-Modul
                                --------------
                           SDA  |  1  +-+ 10  |  Antenne
                           SCL  |  2  +-+  9  |  GND
                           GND  |  3       8  |  NF rechts
                            NC  |  4 _____ 7  |  NF links
                         +3.3V  |  5 _____ 6  |  GND
                                 -------------

   ------------------------------------------------------ */

/* ------------------------------------------------------
   Pinbelegung 7-Segment Display:

   4 Bit LED Digital Tube Module                 STM8S103F
   -------------------------------------------------------

       (shift-clock)   Sclk   -------------------- PD1
       (strobe-clock)  Rclk   -------------------- PD2
       (ser. data in)  Dio    -------------------- PD3
       (+Ub)           Vcc
                       Gnd


   Anzeigenposition 0 ist das rechte Segment des Moduls

            +-----------------------------+
            |  POS3   POS2   POS1   POS0  |
    Vcc  o--|   --     --     --     --   |
    Sclk o--|  |  |   |  |   |  |   |  |  |
    Rclk o--|  |  |   |  |   |  |   |  |  |
    Dio  o--|   -- o   -- o   -- o   -- o |
    GND  o--|                             |
            |   4-Bit LED Digital Tube    |
            +-----------------------------+

   Segmentbelegung der Anzeige:

       a
      ---
   f | g | b            Segment |  a  |  b  |  c  |  d  |  e  |  f  |  g  | dp |
      ---               ---------------------------------------------------------
   e |   | c            Bit-Nr. |  0  |  1  |  2  |  3  |  4  |  5  |  6  |  7 |
      ---
       d

*/


#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "my_printf.h"
#include "uart.h"
#include "i2c.h"

#define printf       my_printf  // umleiten von my_printf nach printf

#define fbandmin     870        // 87.0  MHz unteres Frequenzende
#define fbandmax     1080       // 108.0 MHz oberes Frequenzende
#define sigschwelle  80         // Schwelle ab der ein Sender als "gut empfangen" gilt



uint16_t aktfreq =   1018;      // Startfrequenz ( 101.8 MHz )
uint8_t  aktvol  =   5;         // Startlautstaerke

uint8_t  rda5807_adrs = 0x10;   // I2C-addr. fuer sequientielllen Zugriff
uint8_t  rda5807_adrr = 0x11;   // I2C-addr. fuer wahlfreien Zugriff
uint8_t  rda5807_adrt = 0x60;   // I2C-addr. fuer TEA5767 kompatiblen Modus

uint16_t rda5807_regdef[10] ={
            0x0758,             // 00 default ID
            0x0000,             // 01 reserved
            0xF009,             // 02 DHIZ, DMUTE, BASS, POWERUPENABLE, RDS
            0x0000,             // 03 reserved
            0x1400,             // 04 SOFTMUTE
            0x84DF,             // 05 INT_MODE, SEEKTH=0110, unbekannt, Volume=15
            0x4000,             // 06 OPENMODE=01
            0x0000,             // 07 reserved
            0x0000,             // 08 reserved
            0x0000 };           // 09 reserved

uint16_t rda5807_reg[32];

//  Anschlusspins der 7-Segmentanzeige

#define srdata_init()       PD3_output_init()
#define srdata_set()        PD3_set()
#define srdata_clr()        PD3_clr()

#define srstrobe_init()     PD2_output_init()
#define srstrobe_set()      PD2_set()
#define srstrobe_clr()      PD2_clr()

#define srclock_init()      PD1_output_init()
#define srclock_set()       PD1_set()
#define srclock_clr()       PD1_clr()

//  "Onboard-LED"
#define obled_init()        PB5_output_init()
#define obled_set()         PB5_set()
#define obled_clr()         PB5_clr()


// Pufferspeicher der anzuzeigenden Ziffern
uint8_t seg7_4digit[4] = { 0xff, 0xff, 0xff, 0xff };

// Bitmapmuster der Ziffern
uint8_t    led7sbmp[16] =
                { 0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07,
                  0x7f, 0x6f, 0x77, 0x7c, 0x39, 0x5e, 0x79, 0x71 };

// Sekundenzaehler Timer2
uint8_t   tim2_sek;
uint8_t   tim2_zsek;


/* ----------------------------------------------------------
   digit4_delay

   Verzoegerungsfunktion zur Erzeugung von Takt und Strobe-
   impuls
   ---------------------------------------------------------- */
void digit4_delay(void)
{

  __asm;
    nop
    nop
  __endasm;
}

/* ----------------------------------------------------------
   digit4_ckpuls

   nach der Initialisierung besitzt die Taktleitung low-
   Signal. Hier wird ein Taktimpuls nach high und wieder
   low erzeugt
   ---------------------------------------------------------- */
void digit4_ckpuls(void)
// Schieberegister Taktimpuls
{
  digit4_delay();
  srclock_set();
  digit4_delay();
  srclock_clr();
}

/* ----------------------------------------------------------
   digit4_stpuls

   nach der Initialisierung besitzt die Strobeleitung low-
   Signal. Hier wird ein Taktimpuls nach high und wieder
   low erzeugt
   ---------------------------------------------------------- */
void digit4_stpuls(void)
// Strobe Taktimpuls
{
  digit4_delay();
  srstrobe_set();
  digit4_delay();
  srstrobe_clr();
}

/* ----------------------------------------------------------
   digit4_outbyte

   uebertraegt das Byte in - value - in das Schieberegister.
   ---------------------------------------------------------- */
void digit4_outbyte(uint8_t value)
{
  uint8_t mask, b;

  mask= 0x80;

  for (b= 0; b< 8; b++)
  {
    // Byte ins Schieberegister schieben, MSB zuerst
    if (mask & value) srdata_set();             // 1 oder 0 entsprechend Wert setzen
                 else srdata_clr();

    digit4_ckpuls();                             // ... Puls erzeugen und so ins SR schieben
    mask= mask >> 1;                            // naechstes Bit
  }
  digit4_stpuls();                               // komplett ausgegebenes Byte ins Ausgangslatch
}

/*  --------------------- DIGIT4_SETDEZ --------------------
       gibt einen 4-stelligen dezimalen Wert auf der
       Anzeige aus
    --------------------------------------------------------- */
void digit4_setdez(int value)
{
  uint8_t i,v;

  for (i= 0; i< 4; i++)
  {
    v= value % 10;
    seg7_4digit[i] &= 0x80;             // eventuellen DP belassen
    seg7_4digit[i] |= (~led7sbmp[v]) & 0x7f;
    value= value / 10;
  }
}

/*  -------------------- DIGIT4_SETHEX ---------------------
       gibt einen 4-stelligen hexadezimalen Wert auf der
       Anzeige aus
    --------------------------------------------------------- */
void digit4_sethex(uint16_t value)
{
  uint8_t i,v;

  for (i= 0; i< 4; i++)
  {
    v= value % 0x10;
    seg7_4digit[i] &= 0x80;             // eventuellen DP belassen
    seg7_4digit[i] |= (~led7sbmp[v]) & 0x7f;
    value= value / 0x10;
  }
}

/*  -------------------- DIGIT4_SETDP ---------------------
       zeigt Dezimalpunkt an angegebener Position an
    --------------------------------------------------------- */
void digit4_setdp(char pos)
{
  seg7_4digit[pos] &= 0x7f;
}

/*  -------------------- DIGIT4_CLRDP ---------------------
       loescht Dezimalpunkt an angegebener Position an
    --------------------------------------------------------- */
void digit4_clrdp(char pos)
{
  seg7_4digit[pos] |= 0x80;
}


/* ----------------------------------------------------------
   digit4_init

   initalisiert alle GPIO Pins die das Schieberegister
   benoetigt als Ausgaenge und setzt alle Ausgaenge des
   Schieberegisters auf 0
   ---------------------------------------------------------- */
void digit4_init(void)
// alle Pins an denen das Modul angeschlossen ist als
// Ausgang schalten
{
  srdata_init();
  srstrobe_init();
  srclock_init();

  srdata_clr();
  srclock_clr();
  srstrobe_clr();

  digit4_outbyte(0);
}

/* ------------------------------------------------------
                     tim2_init
      Initialisiert Timer2 als Overflow-Interrupt-Timer
      (Interruptvector 13)

      Berechnung:

      tim2_takt  = F_CPU / 2 ^ scalvalue
      time       = tim2_takt * (relvalue -1)

      Bsp.:
      scalvalue = 0;         Teilertakt / 1 => 0.0625 uS
      relvalue  = 15999;     time= (relvalue+1) * scalvalue = 16000 * 0.0625 uS
                                                            = 1 mS


      retvalue  = 15625
      scalvalue = 9
      =>          0.5 s

   ------------------------------------------------------ */
void tim2_init(void)
{
  // Konfiguration fuer einen Interruptaufruf alle 2.5 ms

  #define relvalue    9999
  #define scalvalue   2

  TIM2_PSCR= scalvalue;         // F_CPU / 2 ^  scalvalue = 16MHz / 4
  TIM2_IER |= TIM2_IER_UIE;     // enable overflow
  TIM2_CR1 |= TIM2_CR1_CEN;     // Timer2 enable ( CEN = ClockENable )
  TIM2_CR1 |= TIM2_CR1_ARPE;    // Timer2 autoreload ( mit Werten in TIM2_ARR )

  TIM2_ARRH= (uint8_t) (relvalue >> 8);
  TIM2_ARRL= (uint8_t) (relvalue & 0x00ff);

  int_enable();
}

/* ------------------------------------------------------
               I N T E R R U P T - VECTOR 13

     13 ist der Interruptvektor fuer Timer2 overflow
   ------------------------------------------------------ */
void tim2_ovf(void) __interrupt(13)
{
  static segmpx= 0;
  static intcnt= 0;

  intcnt++;
  intcnt= intcnt % 400;         // 400 + 2.5 ms

  if (!(intcnt % 40))
  {
    tim2_zsek++;
    tim2_zsek= tim2_zsek % 10;
  }
  if (!(intcnt))
  {
    tim2_sek++;
    tim2_sek= tim2_sek % 60;
  }

  digit4_outbyte(seg7_4digit[segmpx]);     // zuerst Zifferninhalt
  digit4_outbyte(1 << segmpx);             // ... dann Position ausschieben

  segmpx++;
  segmpx= segmpx % 4;

  TIM2_SR1 &= ~TIM2_SR1_UIF;              // Interrupt quittieren

}


/* --------------------------------------------------
     PUTCHAR

     Diese Funktion wird von < my_printf > zur Ausgabe
     von Zeichen aufgerufen. Hier ist eine Hardware-
     zeichenausgabefunktion anzugeben, mit der
     my_printf zusammen arbeiten soll.
   -------------------------------------------------- */
void putchar(char ch)
{
  uart_putchar(ch);
}

/* --------------------------------------------------
      i2c_startaddr

   startet den I2C-Bus und sendet Bauteileadresse
   rwflag bestimmt, ob das Device beschrieben oder
   gelesen werden soll
   -------------------------------------------------- */
void i2c_startaddr(uint8_t addr, uint8_t rwflag)
{
  addr = (addr << 1) | rwflag;

  i2c_start();
  i2c_write(addr);
}

/* --------------------------------------------------
      i2c_write16

   schreibt einen 16 Bit Integerwert mittels 2
   Bytewrite Vorgaengen auf dem I2C Bus
   -------------------------------------------------- */
void i2c_write16(uint16_t value)
{
  i2c_write(value >> 8);
  i2c_write(value & 0x00ff);
}

/* --------------------------------------------------
      rda5807_writereg

   einzelnes Register des RDA5807 schreiben
   -------------------------------------------------- */
void rda5807_writereg(char reg)
{
  i2c_startaddr(rda5807_adrr,0);
  i2c_write(reg);                        // Registernummer schreiben
  i2c_write16(rda5807_reg[reg]);         // 16 Bit Registerinhalt schreiben
  i2c_stop();
}

/* --------------------------------------------------
      rda5807_write

   alle Register es RDA5807 schreiben
   -------------------------------------------------- */
void rda5807_write(void)
{
  uint8_t i ;

  i2c_startaddr(rda5807_adrs,0);
  for (i= 2; i< 7; i++)
  {
    i2c_write16(rda5807_reg[i]);
  }
  i2c_stop();
}

/* --------------------------------------------------
      rda5807_reset
   -------------------------------------------------- */
void rda5807_reset(void)
{
  uint8_t i;
  for (i= 0; i< 7; i++)
  {
    rda5807_reg[i]= rda5807_regdef[i];
  }
  rda5807_reg[2]= rda5807_reg[2] | 0x0002;    // Enable SoftReset
  rda5807_write();
  rda5807_reg[2]= rda5807_reg[2] & 0xFFFB;    // Disable SoftReset
}

/* --------------------------------------------------
      rda5807_poweron
   -------------------------------------------------- */
void rda5807_poweron(void)
{
  rda5807_reg[3]= rda5807_reg[3] | 0x010;   // Enable Tuning
  rda5807_reg[2]= rda5807_reg[2] | 0x001;   // Enable PowerOn

  rda5807_write();

  rda5807_reg[3]= rda5807_reg[3] & 0xFFEF;  // Disable Tuning
}

/* --------------------------------------------------
      rda5807_setfreq

      setzt angegebene Frequenz * 0.1 MHz

      Bsp.:
         rda5807_setfreq(1018);    // setzt 101.8 MHz
                                   // die neue Welle
   -------------------------------------------------- */
int rda5807_setfreq(uint16_t channel)
{

  channel -= fbandmin;
  channel&= 0x03FF;
  rda5807_reg[3]= channel * 64 + 0x10;  // Channel + TUNE-Bit + Band=00(87-108) + Space=00(100kHz)

  i2c_startaddr(rda5807_adrs,0);
  i2c_write16(0xD009);
  i2c_write16(rda5807_reg[3]);
  i2c_stop();

  delay_ms(100);
  return 0;
}

/* --------------------------------------------------
      rda5807_setvol

      setzt Lautstaerke, zulaessige Werte fuer
      setvol 0 .. 15
   -------------------------------------------------- */
void rda5807_setvol(int setvol)
{
  rda5807_reg[5]=(rda5807_reg[5] & 0xFFF0) | setvol;
  rda5807_writereg(5);
}

/* --------------------------------------------------
      rda5807_setmono
   -------------------------------------------------- */
void rda5807_setmono(void)
{
  rda5807_reg[2]=(rda5807_reg[2] | 0x2000);
  rda5807_writereg(2);
}

/* --------------------------------------------------
      rda5807_setstero
   -------------------------------------------------- */
void rda5807_setstereo(void)
{
  rda5807_reg[2]=(rda5807_reg[2] & 0xdfff);
  rda5807_writereg(2);
}


/* --------------------------------------------------
     show_tune

     zeigt die Empfangsfrequenz und die aktuell
     eingestellte Lautstaerke an
   -------------------------------------------------- */
void show_tune(void)
{
  char i;

  if (aktfreq < 1000) { putchar(' '); }
  printf("  %k MHz  |  Volume: ",aktfreq);
  digit4_setdp(1);                      // Kommapunkt anzeigen
  digit4_setdez(aktfreq);

  if (aktvol)
  {
    putchar('0');
    for (i= 0; i< aktvol-1; i++) { putchar('-'); }
    putchar('x');
    i= aktvol;
    while (i< 15)
    {
      putchar('-');
      i++;
    }
  }
  else
  {
    printf("x--------------");
  }
  printf("  \r");
}

/* --------------------------------------------------
     setnewtune

     setzt eine neue Empfangsfrequenz und zeigt die
     neue Frequenz an.
   -------------------------------------------------- */
void setnewtune(uint16_t channel)
{
  aktfreq= channel;
  rda5807_setfreq(aktfreq);
  show_tune();

}



/* ---------------------------------------------------------------------
                                   MAIN
   --------------------------------------------------------------------- */
int main(void)
{
  char ch;

  sysclock_init(0);

  printfkomma= 1;                       // my_printf verwendet mit Formatter %k eine Kommastelle

  i2c_init(2);                          // 2 = ca. 15kHz I2C Clock-Takt
  uart_init(19200);
  digit4_init();                        // Modul initialisieren
  tim2_init();                          // Timer2 initialisieren

  printf("\n\n\r  ----------------------------------\n\r");
  printf(      "    UKW-Radio mit I2C-Chip RDA5807\n\r");
  printf(      "  ----------------------------------\n\n\r");
  printf(      "      (+)     Volume+\n\r");
  printf(      "      (-)     Volume-\n\n\r");
  printf(      "      (u)     Empfangsfrequenz up\n\r");
  printf(      "      (d)     Empfangsfrequenz dwn\n\r");
  printf(      "      (1..5)  Stationstaste\n\n\r");

  rda5807_reset();
  rda5807_poweron();
  rda5807_setmono();
  rda5807_setfreq(aktfreq);
  rda5807_setvol(aktvol);

  show_tune();

  while(1)
  {
    ch= uart_getchar();
    switch (ch)
    {
      case '+' :                            // Volume erhoehen
      {
        if (aktvol< 15)
        {
          aktvol++;
          rda5807_setvol(aktvol);
          putchar('\r');
          show_tune();
        }
        break;
      }

      case '-' :
      {
        if (aktvol> 0)                      // Volume verringern
        {
          aktvol--;
          rda5807_setvol(aktvol);
          putchar('\r');
          show_tune();
        }
        break;
      case 'd' :                           // Sendersuchlauf nach unten
        {
          if (aktfreq > fbandmin)
          {
            aktfreq--;
            setnewtune(aktfreq);
            show_tune();
          }
        }
        break;
      case 'u' :                           // Sendersuchlauf nach oben
        {
          if (aktfreq < fbandmax)
          {
            aktfreq++;
            setnewtune(aktfreq);
            show_tune();
          }
        }
        break;
      case '1' :                           // Stationstaste 1
        {
          setnewtune(1018);                // 101.8 MHz Die neue Welle
          break;
        }
      case '2' :                           // Stationstaste 2
        {
          setnewtune(1048);                // 104.8 MHz
          break;
        }
      case '3' :                           // Stationstaste 3
        {
          setnewtune(888);                 // 88.8 MHz
          break;
        }
      case '4' :                           // Stationstaste 4
        {
          setnewtune(970);                 // 97.0 MHz
          show_tune();
          break;
        }
      case '5' :                           // Stationstaste 5
        {
          setnewtune(978);                 // 97.8 MHz
          show_tune();
          break;
        }
      case '6' :                           // Stationstaste 6
        {
          setnewtune(999);                 // 99.9 MHz
          show_tune();
          break;
        }
        break;
      }
      default  : break;
    }
  }
}
