/* vim: set sw=8 ts=8 si et: */
#ifndef LED_H
  #define LED_H

  #include <avr/io.h>

/*
// enable PC0 as output
#define LED_INIT DDRC|=_BV(PC0)
// led on, pin=0
#define LED_ON PORTC&=~_BV(PC0)
// led off, pin=1
#define LED_OFF PORTC|=_BV(PC0)
*/

// enable PD5 as output
#define LED_INIT DDRD|=_BV(PD5)
// led on, pin=0
#define LED_ON PORTD&=~_BV(PD5)
// led off, pin=1
#define LED_OFF PORTD|=_BV(PD5)



#endif //LED_H
