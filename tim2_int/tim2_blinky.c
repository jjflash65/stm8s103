/* -------------------------------------------------------
                        tim2_blinky.c

     Blinkprogramm mittels Timer2 - Interrupt

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     19.05.2016  R. Seelig
   ------------------------------------------------------ */

#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"


#define led1_init()     PB5_output_init()
#define led1_set()      PB5_set()
#define led1_clr()      PB5_clr()

/* ------------------------------------------------------
                     int_enable
      grundsaetzlich Interrupts zulassen
   ------------------------------------------------------ */
void int_enable(void)
{
  __asm;
    rim
  __endasm;
}

/* ------------------------------------------------------
                     int_disable
      grundsaetzlich Interrupts sperren
   ------------------------------------------------------ */
void int_disable(void)
{
  __asm;
    sim
  __endasm;
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

  #define relvalue    15625
  #define scalvalue   9

  TIM2_PSCR= scalvalue;         // F_CPU / 2 ^  scalvalue
  TIM2_IER |= TIM2_IER_UIE;     // enable overflow
  TIM2_CR1 |= TIM2_CR1_CEN;     // Timer2 enable ( CEN = ClockENable )
  TIM2_CR1 |= TIM2_CR1_ARPE;    // Timer2 autoreload ( mit Werten in TIM2_ARR )

  TIM2_ARRH= (uint8_t) (relvalue >> 8);
  TIM2_ARRL= (uint8_t) (relvalue & 0x00ff);

  int_enable();
}

void tim2_ovf(void) __interrupt(13)
// 13 ist der Interruptvektor fuer Timer3 overflow
{
  static ledflag = 0;

  if (!ledflag)
  {
    led1_set();
    ledflag= 1;
  }
  else
  {
    led1_clr();
    ledflag= 0;
  }

  TIM2_SR1 &= ~TIM2_SR1_UIF;        // Interrupt quittieren
}

int main(void)
{
  sysclock_init(0);                 // erst Initialisieren mit internem RC
//  sysclock_init(1);                     // .. und dann auf externen Quarz umschalten

  led1_init();
  led1_clr();

  tim2_init();

  while(1);                         // blinken geschieht im Interrupt
}
