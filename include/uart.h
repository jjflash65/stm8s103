/* -------------------------------------------------------
                      uart.h

     Library-Header fuer die serielle Schnittstelle

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     18.05.2016  R. Seelig
   ------------------------------------------------------ */

#ifndef in_uartinit
  #define in_uartinit

  #include "stm8s.h"
  #include <stdarg.h>


  #define uint8_t     unsigned char
  #define uint16_t    unsigned int


  void uart_putchar(char ch);
  void uart_putstring(char *p);
  char uart_getchar(void);
  char uart_ischar(void);
  void uart_init(unsigned int baudrate);
  void uart_putstring(char *p);

  #define uart_prints(s)   uart_putstring(s)

#endif
