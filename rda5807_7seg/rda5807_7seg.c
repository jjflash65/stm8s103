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
       (ser. data in)  Dio    -------------------- PA3
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
#include "sw_i2c.h"
#include "seg7anz_v2.h"


// Taster up
#define uptast_init()       PC3_input_init()
#define is_uptast()         (!(is_PC3()))

// Taster down
#define dwntast_init()      PC4_input_init()
#define is_dwntast()          (!(is_PC4()))

// Taster Mode select
#define mtast_init()        PC5_input_init()
#define is_mtast()          (!(is_PC5()))


#define fbandmin     870        // 87.0  MHz unteres Frequenzende
#define fbandmax     1080       // 108.0 MHz oberes Frequenzende
#define sigschwelle  81         // Schwelle ab der ein Sender als "gut empfangen" gilt


uint16_t aktfreq =   1018;      // Startfrequenz ( 101.8 MHz )
//uint16_t aktfreq =   978;
uint8_t  aktvol  =   1;         // Startlautstaerke
uint8_t  aktmode =   0;         // 0 = Frequenzwahl

// const uint16_t festfreq[6] = { 1018, 1048, 888, 970, 978, 999 };

// I2C-Adressen des RDA5807
/* ------------------------------------------------------
                          HINWEIS

   es wird angenommen, dass read-write Flag (Bit 0) der
   I2C - Adresse Bestandteil der Adresse ist, somit hat
   jedes I2C - Device 2 Adressen, eine fuer Schreib-
   zugriffe, eine fuer Lesezugriffe
   ------------------------------------------------------ */
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


volatile uint16_t tim1_ticker  = 0;

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

     zeigt die Empfangsfrequenz oder die aktuell
     eingestellte Lautstaerke an (von aktmode ab-
     haengig)
   -------------------------------------------------- */
void show_tune(void)
{
  if (aktmode== 1)
  {
    digit4_clrdp(1);
    digit4_setall(0xc7, 0xff, 0xff, 0xff);
    digit4_setdez8bit(aktvol,0);
  }
  else
  {
    digit4_setdp(1);
    digit4_setdez(aktfreq);
    if (aktfreq< 1000)  { seg7_4digit[3]= 0xff; }    // fuehrende 0 ausblenden bei F< 100 MHz
  }
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

/* --------------------------------------------------
                    tim1_intinit
      Timer1 und dessen Overflow-Interrupt init-
      ialisieren und starten
    -------------------------------------------------- */
void tim1_intinit(void)
{
  // Prescaler setzen (F_CPU / 16000 = 1 mS)
  #define taktteiler     15999

  TIM1_PSCRH= taktteiler >> 8;
  TIM1_PSCRL= taktteiler & 0x00ff;

  // Timer1 Reloadwert 0x03e8  => nach 1000 mS Ueberlauf
  // Timer1 Reloadwert 0x0064  => nach  100 mS Ueberlauf
  TIM1_ARRH= 0x00;
  TIM1_ARRL= 0x64;

  // Enable overflow
  TIM1_IER |= TIM1_IER_UIE;

  // Timer1 starten
  TIM1_CR1 |= TIM1_CR1_CEN;     // Timer1 enable ( CEN = ClockENable )
  TIM1_CR1 |= TIM1_CR1_ARPE;    // Timer1 autoreload ( mit Werten in TIM1_ARR )

  int_enable();                 // grundsaetzlich Interrupts zulassen
}

/* --------------------------------------------------
                       tim1_ovf
              Timer1 overflow - interrupt
    -------------------------------------------------- */
void tim1_ovf(void) __interrupt(11)
// 11 ist der Interruptvektor fuer Timer1 overflow
{
  tim1_ticker++;

  TIM1_SR1 &= ~TIM1_SR1_UIF;        // Interrupt quittieren
}


/* ---------------------------------------------------------------------
                                   MAIN
   --------------------------------------------------------------------- */
int main(void)
{
  char ch;

  sysclock_init(0);

  delay_ms(500);
  tim1_intinit();
  i2c_master_init();                    // 2 = ca. 15kHz I2C Clock-Takt
  digit4_init();                        // Modul initialisieren
  uptast_init();
  dwntast_init();
  mtast_init();

  rda5807_reset();
  rda5807_poweron();
  rda5807_setmono();
  rda5807_setfreq(aktfreq);
  rda5807_setvol(aktvol);

  show_tune();

  while(1)
  {

    if (is_mtast())
    {
      delay_ms(50);
      aktmode++;
      aktmode= aktmode % 2;
      show_tune();
      while(is_mtast());
      delay_ms(50);
      tim1_ticker= 0;
    }
    if ((aktmode> 0) && (tim1_ticker> 35))
    {
      aktmode= 0;
      show_tune();
    }

    if (aktmode== 0)                                      // Senderwahl
    {
      if (is_uptast())
      {

        delay_ms(100);
        while(is_uptast())
        {
          rda5807_setvol(0);
          if (aktfreq < fbandmax)
          {
            aktfreq++;
            show_tune();
          }
          rda5807_setvol(aktvol);
          setnewtune(aktfreq);
        }
      }

      if (is_dwntast())
      {

        delay_ms(100);
        while(is_dwntast())
        {
          rda5807_setvol(0);
          if (aktfreq > fbandmin)
          {
            aktfreq--;
            show_tune();
          }
          rda5807_setvol(aktvol);
          setnewtune(aktfreq);
        }
      }
    }

    if (aktmode== 1)                                    // Lautstaerkeeinstellung
    {
      if (is_uptast())
      {
        while(is_uptast())
        {
          delay_ms(250);
          if (aktvol< 15)
          {
            aktvol++;
            rda5807_setvol(aktvol);
            show_tune();
          }
        }
        tim1_ticker= 0;
      }
      if (is_dwntast())
      {
        while(is_dwntast())
        {
          delay_ms(250);
          if (aktvol> 0)
          {
            aktvol--;
            rda5807_setvol(aktvol);
            show_tune();
          }
        }
        tim1_ticker= 0;
      }
    }
  }
}
