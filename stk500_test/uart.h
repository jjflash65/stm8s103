/* vim: set sw=8 ts=8 si et: */
/*************************************************************************
 Title:   C include file for uart
 Target:    atmega8
 Copyright: GPL
***************************************************************************/
#ifndef UART_H
#define UART_H
#include <avr/pgmspace.h>

  #if defined (__AVR_ATmega88__) || defined (__AVR_ATmega168__)  || defined (__AVR_ATmega328__) || defined (__AVR_ATmega328P__)

    #define UBRR       UBRR0
    #define UBRRL      UBRR0L
    #define UBRRH      UBRR0H
    #define UCSRA      UCSR0A
    #define UCSRB      UCSR0B
    #define UCSRC      UCSR0C
    #define U2X        U2X0
    #define RXEN       RXEN0
    #define TXEN       TXEN0
    #define UCSZ0      UCSZ00
    #define UCSZ1      UCSZ01
    #define UDRE       UDRE0
    #define UDR        UDR0
    #define RXC        RXC0

  #endif

  #if defined (__AVR_ATmega8__) || defined (__AVR_ATtiny2313__)  || defined (__AVR_ATmega8515__)

    #define UBRR0       UBRR
    #define UBRR0L      UBRRL
    #define UBRR0H      UBRRH
    #define UCSR0A      UCSRA
    #define UCSR0B      UCSRB
    #define UCSR0C      UCSRC
    #define U2X0        U2X
    #define RXEN0       RXEN
    #define TXEN0       TXEN
    #define UCSZ00      UCSZ0
    #define UCSZ01      UCSZ1
    #define UDRE0       UDRE
    #define UDR0        UDR
    #define RXC0        RXC

  #endif



extern void uart_init(void);
extern void uart_sendchar(char c);
extern void uart_sendstr(char *s);
extern void uart_sendstr_p(const char *progmem_s);
extern unsigned char uart_getchar(unsigned char kickwd);
unsigned char uart_getchar51(void);
extern void uart_flushRXbuf(void);
void uart_crlf();
void uart_putramstring(char *p);
void uart_putromstring(const unsigned char *dataPtr);
void uart_sendhex(uint8_t value);
void uart_sendhex16(uint16_t value);
uint8_t uart_gethex(void);
uint16_t uart_gethex16();


/*
** macros for automatically storing string constant in program memory
*/
#ifndef P
#define P(s) ({static const char c[] __attribute__ ((progmem)) = s;c;})
#endif
#define uart_sendstr_P(__s)         uart_sendstr_p(P(__s))

#endif /* UART_H */
