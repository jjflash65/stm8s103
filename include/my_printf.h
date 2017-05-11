/* -------------------------------------------------------
                      my_printf.h

     Library-Header eine eigene (sehr kleine) printf-
     Funktion.

     Compiler : SDCC

     fuer | myprintf | muss im Hauptprogramm irgendwo
     ein putchar vorhanden sein.

     Bsp.:

        void putchar(char ch)
        {
          uart_putchar(ch);
        }

     19.05.2016  R. Seelig
   ------------------------------------------------------ */

#ifndef in_myprintf
  #define in_myprintf

  #include <stdarg.h>

  #define uint8_t     unsigned char
  #define uint16_t    unsigned int

  extern char printfkomma;

  extern void putchar(char ch);
  void putint(int i, char komma);
  void hexnibbleout(uint8_t b);
  void puthex(uint16_t h);
  void putstring(char *p);
  void my_printf(const char *s,...);

#endif
