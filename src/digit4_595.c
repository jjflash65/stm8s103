/* -------------------------------------------------------
                        digit4_595.c

     Header Softwaremodul fuer 4 stelliges 7-Segmentmodul
     (China) mit 74HC595 Schieberegistern

     Anmerkung: leider muessen die Anzeigesegmente des
                Moduls gemultiplext werden, da nur
                2 Schieberegister enthalten sind.
                SR sind kaskadiert, zuerst ist der
                Datenwert der Ziffer, danach die
                Multiplexstelle auszuschieben.

     ==>  verwendet Timer2 zum Multiplexen  <==

     MCU      : STM8S103F3
     Takt     : ---

     18.10.2016  R. Seelig
   ------------------------------------------------------ */

/*
   Anschluesse:
 ------------------------------------------------------
   Pinbelegung:

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

#include "digit4_595.h"

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
  digit4_stpuls();                         // komplett ausgegebenes Byte ins Ausgangslatch

  segmpx++;
  segmpx= segmpx % 4;

  TIM2_SR1 &= ~TIM2_SR1_UIF;              // Interrupt quittieren

}
