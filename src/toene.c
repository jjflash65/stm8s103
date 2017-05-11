/* -------------------------------------------------------
                         toene.c

     erzeugt Toene der C-Dur Tonleiter mittels Timer1-
     Overflow Interrupt, Lautsprecher an PD4 (ueber
     PNP-Transistor)

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     28.06.2016  R. Seelig
   ------------------------------------------------------ */

#include "toene.h"


volatile char           sound = 0;

// Frequenztabelle der Noten, beginnend mit Frequenz fuer c''  (12 Noten per Oktave)
// 2 Oktaven gespeichert = 24 Werte
uint16_t freqreload [24] = { 523,  555,  587,  623,  659,  699,  740,  784,  831,  881,  933, 988,
                             1047, 1109, 1175, 1245, 1318, 1397, 1480, 1568, 1661, 1760, 1865, 1975 };


/* --------------------------------------------------
              Timer1 overflow - interrupt
    -------------------------------------------------- */
void tim1_ovf(void) __interrupt(11)
// 11 ist der Interruptvektor fuer Timer1 overflow
{
  static volatile char spk_flag = 0;

  if (sound)
  {
    if (spk_flag)
    {
      spk_set();
      spk_flag= 0;
    }
    else
    {
      spk_clr();
      spk_flag= 1;
    }
  }
  else
  {
    spk_set();   // wenn Speaker ueber PNP-Transistor angeschlossen, muss
                 // Portpin gesetzt werden, damit Lautsprecher stromlos ist !
  }

  TIM1_SR1 &= ~TIM1_SR1_UIF;        // Interrupt quittieren

}

/* --------------------------------------------------
                       tim1_init
      intialisiert Timer mit Taktteiler / 16 (Pre-
      scaler somit = 15) und startet diesen im
      Autoreloadmodus.

      Bei F_CPU = 16 MHz gilt:

      16 MHz / 16 = 1 MHz => 1 uS
   -------------------------------------------------- */
void tim1_init(void)
{

  #define clockdivisor     ((uint16_t) 15)
  // Prescaler-Register = 15 entspricht Teilung / 16 .. ( 0..15 = 16 Schritte)
  // Timer wird somit bei F_CPU= 16 MHz mit 1uS getaktet

  TIM1_PSCRH= (clockdivisor >> 8);
  TIM1_PSCRL= (clockdivisor & 0xff);

  // Enable overflow
  TIM1_IER |= TIM1_IER_UIE;

  // Timer1 starten
  TIM1_CR1 |= TIM1_CR1_CEN;     // Timer1 enable ( CEN = ClockENable )
  TIM1_CR1 |= TIM1_CR1_ARPE;    // Timer1 autoreload ( mit Werten in TIM1_ARR )

  int_enable();
}


/* --------------------------------------------------
                       setfreq
     setzt das Autoreloadregister des Timer1 so, dass
     bei Toggeln eines Pins im Interruptvector sich
     die angegebee Frequenz einstellt.
   --------------------------------------------------*/
void setfreq(uint16_t freq)
{
  uint32_t regval;

  regval = 500000 / freq;
  regval--;
  TIM1_ARRH= (uint8_t) (regval >> 8);
  TIM1_ARRL= (uint8_t) (regval & 0x000000ff);
}

/* --------------------------------------------------
                          tonlen
      schaltet nach der Zeit - w - die Frequenz aus
      (und bestimmt somit, wie lange eine Note ge-
      spielt wird). Anschliessend erfolgt eine Warte-
      zeit.
   -------------------------------------------------- */
void tonlen(int w)
{
  int cx;

  w = w*100;
  for (cx= 0; cx< w; cx++) { delay_us(100); }
  sound= 0;
  delay_ms(30);
}

/* --------------------------------------------------
                       playnote
     erzeugt eine Frequenz entsprechend der Noten-
     tabelle. Frequenz wird solange erzeugt, wie die
     globale Variable - sound - groesser Null ist.
   -------------------------------------------------- */
void playnote(char note)
{
  setfreq(freqreload[note]);
  sound= 1;
}

/* --------------------------------------------------
                       playstring
     Interpretiert einen String als "Notenstring".
     Gueltig abspielbare Noten sind:

     c-d-e-f-g-a-h-c
         und
     C-D-F-G-A  (fuer Cis, Dis, Fis, Gis, Ais)

     Gueltige Werte fuer Notenlaengen sind:

     1-2-3-4-5-8

     Bspw. wird mit "d4" eine Viertelnote D gespielt

     + schaltet in die hoehere Oktave
     - schaltet in die untere Oktave
   -------------------------------------------------- */
void playstring(const uint8_t* const s)
{
  char ch;
  char aokt;
  int dind;

  aokt= 0; dind= 0;
  ch= s[dind];
  while (ch)
  {
    ch= s[dind];
    switch(ch)
    {
      case '-': { aokt= aokt-12; break; }
      case '+': { aokt= aokt+12; break; }
      case 'c': { playnote(aokt); break; }
      case 'C': { playnote(aokt+1); break; }
      case 'd': { playnote(aokt+2); break; }
      case 'D': { playnote(aokt+3); break; }
      case 'e': { playnote(aokt+4); break; }
      case 'f': { playnote(aokt+5); break; }
      case 'F': { playnote(aokt+6); break; }
      case 'g': { playnote(aokt+7); break; }
      case 'G': { playnote(aokt+8); break; }
      case 'a': { playnote(aokt+9); break; }
      case 'A': { playnote(aokt+10); break; }
      case 'h': { playnote(aokt+11); break; }
      case '1': { tonlen(16*playtempo); break; }
      case '2': { tonlen(8*playtempo); break; }
      case '3': { tonlen(6*playtempo); break; }
      case '4': { tonlen(4*playtempo); break; }
      case '5': { tonlen(3*playtempo); break; }
      case '8': { tonlen(2*playtempo); break; }
    }
    dind++;
  }
}
