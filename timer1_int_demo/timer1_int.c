/* -------------------------------------------------------
                         timer1_int.c

     Versuche zu Timer-Interruptprogrammierung


     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     15.06.2016  R. Seelig
   ------------------------------------------------------ */

#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"

#define led1_init()     PB5_output_init()
#define led1_set()      PB5_set()
#define led1_clr()      PB5_clr()

#define led2_init()     PD4_output_init()
#define led2_set()      PD4_set()
#define led2_clr()      PD4_clr()


/* --------------------------------------------------
      Timerversuche, noch ohne Interrupt, zum
      kennenlernen
   --------------------------------------------------_ */

void timer1_init(void)
{
  #define taktteilerpol     16000

  // Prescaler setzen
  // 0x3e7f = 15999
  // entspricht bei 16 MHz einem Takteingang des Zaehlers mit 1000 Hz = 1mS

  TIM1_PSCRH= taktteilerpol >> 8;
  TIM1_PSCRL= taktteilerpol & 0x00ff;


  TIM1_CR1 |= TIM1_CR1_CEN;     // Timer1 clock enable
}


uint16_t timvalue(void)
{
  uint16_t w;

  w= (uint16_t) ( (TIM1_CNTRH << 8) | TIM1_CNTRL);  // Timer1 Zaehlerstand lesen (CNTRH und CNTRL)
  w= w % 1000;
  return w;
}


void timer1_test(void)
{
  volatile uint16_t t;

  timer1_init();
  while(1)
  {
    t= timvalue();
    if (t< 500)
    {
      led1_set();
      led2_clr();
    }
    else
    {
      led2_set();
      led1_clr();
    }
  }
}
/* --------------------------------------------------
                Timerversuche Ende
   -------------------------------------------------- */

/* --------------------------------------------------
              Timer Interrupt-Versuche
    -------------------------------------------------- */

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
  TIM1_ARRH= 0x03;
  TIM1_ARRL= 0xe8;

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
  static volatile char ledflag = 0;

  if (ledflag)
  {
    led1_set();
    led2_clr();
    ledflag= 0;
  }
  else
  {
    led1_clr();
    led2_set();
    ledflag= 1;
  }

  TIM1_SR1 &= ~TIM1_SR1_UIF;        // Interrupt quittieren
}


/* ------------------------------------------------------------------------------
                                     M A I N
    ----------------------------------------------------------------------------- */
void main(void)
{

  sysclock_init(0);                     // erst Initialisieren mit internem RC
//  sysclock_init(1);                     // .. und dann auf externen Quarz umschalten

  led1_init();
  led2_init();
  led1_set();
  led2_set();

  tim1_intinit();

  while(1);                             // Endlosschleife, LED-Blinken geschieht im
                                        // Interruptvektor tim1_ovf
}
