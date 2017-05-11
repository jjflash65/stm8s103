/* vim: set sw=8 ts=8 si et: */
/*********************************************
* UART interface without interrupt
* Author: Guido Socher, Copyright: GPL
* Copyright: GPL
**********************************************/
//#include <avr/signal.h>
#include <avr/interrupt.h>
#include <string.h>
#include <avr/io.h>
#include "uart.h"
#include "avr_compat.h"
#include "timeout.h"


void uart_init(void)
{

  uint32_t baud= 115200;

  uint16_t ubrr;

  if (baud> 57600)
  {
    baud= baud>>1;
    ubrr= (F_CPU/16/baud);
    ubrr--;
    UCSR0A |= 1<<U2X0;                                  // Baudrate verdoppeln
  }
  else
  {
    ubrr= (F_CPU/16/baud-1);
  }
  UBRR0H = (unsigned char)(ubrr>>8);                    // Baudrate setzen
  UBRR0L = (unsigned char)ubrr;

#if defined (__AVR_ATmega328P__) || defined (__AVR_ATmega168__) || defined (__AVR_ATmega88__)

    UCSR0B = (1<<RXEN0)|(1<<TXEN0);                       // Transmitter und Receiver enable
    UCSR0C = (3<<UCSZ00);                                 // 8 Datenbit, 1 Stopbit

#else

    // ATmega8
    UCSR0B |= (1<<RXEN0) | (1<<TXEN0);
    UCSRC  = (1<<URSEL) | (1<<UCSZ01) | (1<<UCSZ00);

#endif
}


/* send one character to the rs232 */
void uart_sendchar(char c)
{
        /* wait for empty transmit buffer */
        while (!(UCSRA & (1<<UDRE)));
        UDR=c;
}
/* send string to the rs232 */
void uart_sendstr(char *s)
{
        while (*s){
                uart_sendchar(*s);
                s++;
        }
}

void uart_sendstr_p(const char *progmem_s)
/* print string from program memory on rs232 */
{
        char c;
        while ((c = pgm_read_byte(progmem_s++))) {
                uart_sendchar(c);
        }

}

/* get a byte from rs232
* this function does a blocking read */
unsigned char uart_getchar(unsigned char kickwd)
{
        while(!(UCSRA & (1<<RXC))){
                // we can not aford a watchdog timeout
                // because this is a blocking function
                if (kickwd){
                        wd_kick();
                }
        }
        return(UDR);
}

uint8_t uart_getchar51( void )
{
  uint8_t b;

  while(!(UCSR0A & (1<<RXC0)));                         // warten bis Zeichen eintrifft
  UCSR0A &= ~(1<<RXC0);
  b= UDR0;
  return b;
}


/* read and discard any data in the receive buffer */
void uart_flushRXbuf(void)
{
        unsigned char tmp;
        while(UCSRA & (1<<RXC)){
                tmp=UDR;
        }
}

/* --------------------------------------------------
                       UART_CRLF
     sendet auf der RS-232 ein Linefeed und ein
     Carriage Return
   -------------------------------------------------- */

void uart_crlf()
{
  uart_sendchar(0x0a);
  uart_sendchar(0x0d);
}

/* --------------------------------------------------
                  UART_PUTRAMSTRING
     gibt einen String aus dem RAM ueber die RS-232
     aus.
   -------------------------------------------------- */

void uart_putramstring(char *p)
{
  do
  {
    uart_sendchar( *p );
  } while( *p++);
}

/* --------------------------------------------------
                  UART_PUTROMSTRING
     gibt einen String aus dem ROM ueber die RS-232
     aus.

     Bsp.:

          uart_putromstring(PSTR("Hallo Welt"))
   -------------------------------------------------- */

void uart_putromstring(const unsigned char *dataPtr)
{
  unsigned char c;

  for (c=pgm_read_byte(dataPtr); c; ++dataPtr, c=pgm_read_byte(dataPtr))
  {
    uart_sendchar(c);
  }
}

/* --------------------------------------------------
                     UART_SENDHEX
      sendet einen Wert im Ascii - Hexformat ueber
      die serielle Schnittstelle
   -------------------------------------------------- */

void uart_sendhex(uint8_t value)
{
  uint8_t b;

  b= value >> 4;
  if (b> 9) b += 55; else b += 48;
  uart_sendchar(b);

  b= value & 0x0f;
  if (b> 9) b += 55; else b += 48;
  uart_sendchar(b);
}

/* --------------------------------------------------
                   UART_SENDHEX16
      sendet einen Wert im 16-Bit Ascii Wert im Hex-
      format ueber die serielle Schnittstelle
   -------------------------------------------------- */

void uart_sendhex16(uint16_t value)
{
  uint8_t b;

  b= value >> 8;
  uart_sendhex(b);
  b= value & 0xff;
  uart_sendhex(b);
}

/* --------------------------------------------------
                     UART_GETHEX
      liest ueber die serielle Schnittstelle einen
      ASCII Hexwert ein (2 Zeichen).
   -------------------------------------------------- */
uint8_t uart_gethex(void)
{
  uint8_t b, w;

  w= 0;
  b = uart_getchar51();

  b = b-48;
  if (b> 9) b = b-7;
  if (b> 9) b = b-32;
  w= b;
  w = (w << 4);

  b= uart_getchar51();

  b = b-48;
  if (b> 9) b = b-7;
  if (b> 9) b = b-32;
  b = b & 0x0f;
  w = w | b;
  return w;
}

/* --------------------------------------------------
                     UART_GETHEX16
      liest ueber die serielle Schnittstelle einen
      16-Bit Hexwert in ASCII ein (4 Zeichen).
      Nach dem 2. und dem 4. Byte werden jeweils
      2 Zeichen als Echo zum Sender zurueckgesendet
   -------------------------------------------------- */
uint16_t uart_gethex16()
{
  uint8_t ah,al;
  uint16_t ax;

  ah= uart_gethex();
  uart_sendhex(ah);
  al= uart_gethex();
  uart_sendhex(al);
  ax= (uint16_t) (ah << 8) + al;
  return ax;
}
