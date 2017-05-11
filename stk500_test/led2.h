/* ---------------------------- led2.h -----------------------------
          Portpin der LED fuer den AVR500 - Programmer
   ----------------------------------------------------------------- */

#ifndef LED2_H
  #define LED2_H

  #include <avr/io.h>

// enable PD5 as output
#define LED_INIT DDRD|=_BV(PD6)
// led on, pin=0
#define LED_ON PORTD&=~_BV(PD6)
// led off, pin=1
#define LED_OFF PORTD|=_BV(PD6)



#endif //LED2_H
