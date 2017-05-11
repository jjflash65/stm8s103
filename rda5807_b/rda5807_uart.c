/* -------------------------------------------------------
                         rda5807_uart.c

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


#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "my_printf.h"
#include "uart.h"
#include "sw_i2c.h"

#define printf       my_printf  // umleiten von my_printf nach printf

#define fbandmin     870        // 87.0  MHz unteres Frequenzende
#define fbandmax     1080       // 108.0 MHz oberes Frequenzende
#define sigschwelle  71         // Schwelle ab der ein Sender als "gut empfangen" gilt



uint16_t aktfreq =   1018;      // Startfrequenz ( 101.8 MHz )
uint8_t  aktvol  =   2;         // Startlautstaerke

const uint16_t festfreq[6] = { 1018, 1048, 888, 970, 978, 999 };

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

uint16_t rda5807_reg[16];


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

  i2c_start(addr);
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

uint8_t rda5807_getsig(void)
{
  static uint8_t b ,b2;
  static uint8_t i;

  delay_ms(100);
  i2c_startaddr(rda5807_adrs,1);
  for (i= 0; i < 3; i++)
  {
    b= i2c_read_ack();
    delay_ms(5);
    if (i == 2)
    {
      b2= b;
    }
  }
  b= i2c_read_nack();

  i2c_stop();
  return b2;
}

void rda5807_scandown(void)
{
  uint8_t siglev;

  rda5807_setvol(0);

  if (aktfreq== fbandmin) { aktfreq= fbandmax; }
  do
  {
    aktfreq--;
    setnewtune(aktfreq);
    siglev= rda5807_getsig();
    if (aktfreq < 1000) { printf(" "); }
    printf("  %k MHz  \r",aktfreq, siglev);
  }while ((siglev < sigschwelle) && (aktfreq > fbandmin));

  rda5807_setvol(aktvol);

}


void rda5807_scanup(void)
{
  uint8_t siglev;

  rda5807_setvol(0);

  if (aktfreq== fbandmax) { aktfreq= fbandmin; }
  do
  {
    aktfreq++;
    setnewtune(aktfreq);
    siglev= rda5807_getsig();
    if (aktfreq < 1000) { printf(" "); }
    printf("  %k MHz  \r",aktfreq, siglev);
  }while ((siglev < sigschwelle) && (aktfreq < fbandmax));

  rda5807_setvol(aktvol);

}


/* ---------------------------------------------------------------------
                                   MAIN
   --------------------------------------------------------------------- */
int main(void)
{
  char ch;

  sysclock_init(0);

  printfkomma= 1;                       // my_printf verwendet mit Formatter %k eine Kommastelle

  i2c_master_init();                    // 2 = ca. 15kHz I2C Clock-Takt
  uart_init(19200);

  printf("\n\n\r  ----------------------------------\n\r");
  printf(      "    UKW-Radio mit I2C-Chip RDA5807\n\r");
  printf(      "  ----------------------------------\n\n\r");
  printf(      "      (+)     Volume+\n\r");
  printf(      "      (-)     Volume-\n\n\r");
  printf(      "      (u)     Empfangsfrequenz hoch\n\r");
  printf(      "      (d)     Empfangsfrequenz runter\n\n\r");
  printf(      "      (a)     Sendersuchlauf hoch\n\r");
  printf(      "      (s)     Sendersuchlauf runter\n\n\r");
  printf(      "      (1..6)  Stationstaste\n\n\r");

  rda5807_reset();
  rda5807_poweron();
  rda5807_setmono();
  rda5807_setfreq(aktfreq);
  rda5807_setvol(aktvol);

  show_tune();
  while (uart_ischar()) { ch = uart_getchar(); }

  while(1)
  {
    ch= 0;
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
        }

      case 'd' :                           // Empfangsfrequenz nach unten
        {
          if (aktfreq > fbandmin)
          {
            aktfreq--;
            setnewtune(aktfreq);
            show_tune();
          }
        break;
        }
      case 'u' :                           // Empfangsfrequenz nach oben
        {
          if (aktfreq < fbandmax)
          {
            aktfreq++;
            setnewtune(aktfreq);
            show_tune();
          }
          break;
        }

      case 's' :                           // Suchlauf nach unten
        {
          rda5807_scandown();
          show_tune();

          break;
        }

      case 'a' :                         // Suchlauf nach oben
        {
          rda5807_scanup();
          show_tune();

          break;
        }

      default  : break;
    }

    if ((ch >= '1') && (ch <= '6'))
    {
      setnewtune(festfreq[ch-'0'-1]);
      show_tune();
    }
  }
}
