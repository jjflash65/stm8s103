/* -------------------------------------------------------
                         notendemo.c

     Spielt einen Notenstring ab, Lautsprecher an PD4
     (in toene.h festgelegt)

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     28.06.2016  R. Seelig
   ------------------------------------------------------ */

#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "toene.h"

#define led1_init()     PB5_output_init()
#define led1_set()      PB5_set()
#define led1_clr()      PB5_clr()

/* ------------------------------------------------------------------------------
                                     M-A-I-N
   ------------------------------------------------------------------------------ */

int main(void)
{

  sysclock_init(0);                     // erst Initialisieren mit internem RC
  spk_init();
  led1_init();
  tim1_init();

  led1_clr();

  // String fuer Schneewalzer
  playstring("c4d4e2g4e2g4e1d4e4f2g4f2g4f1g4a4h2+f4-h2+f4-h1a4h4+c2e4c2-a4g1e4g4+c1-h1+d1c1-a2+c4-a2+c4-a1");


  sound= 0;
  led1_set();
  while(1);
}
