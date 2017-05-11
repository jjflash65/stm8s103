/* -------------------------------------------------------
                      uart.c

     Library fuer die serielle Schnittstelle

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     18.05.2016  R. Seelig
   ------------------------------------------------------ */

#include <stdarg.h>
#include "stm8s.h"
#include "uart.h"


void uart_putchar(char ch)
{
  while(!(USART1_SR & USART_SR_TXE));   // warten bis letztes Zeichen gesendet ist
  USART1_DR = ch;                       // Zeichen senden
}


void uart_putstring(char *p)
{
  do
  {
    uart_putchar( *p );
  } while( *p++);
}



/* ------------------------------------------------------------
                         UART_GETCHAR
     wartet so lange, bis auf der seriellen Schnittstelle
     ein Zeichen eintrifft und liest dieses ein
   ------------------------------------------------------------ */
char uart_getchar(void)
{
  while(!(USART1_SR & USART_SR_RXNE));    // solange warten bis ein Zeichen eingetroffen ist
  return USART1_DR;
}

/* ------------------------------------------------------------
                         UART_ISCHAR
      testet, ob auf der seriellen Schnittstelle ein Zeichen
      zum Lesen ansteht (liest dieses aber nicht und wartet
      auch nicht darauf)
   ------------------------------------------------------------ */
char uart_ischar(void)
{
  return (USART1_SR & USART_SR_RXNE);
}


/* ------------------------------------------------------------
                            UART_INIT
      Initialisieren der seriellen Schnittstelle. Mit internem
      Taktgeber funktioniert die Schnittstelle nur bis
      57600 Baud
   ------------------------------------------------------------ */

void uart_init(unsigned int baudrate)
{

  USART1_CR2 |= USART_CR2_TEN;                          // TxD enabled
  USART1_CR2 |= USART_CR2_REN;                          // RxD enable
  USART1_CR3 &= ~(USART_CR3_STOP1);                     // Stopbit

  // Baudratendivisor:
  //   Divisior = F_CPU / Baudrate
  //   Nibbles des Divisors N3 N2 N1 N0
  //   Bsp.:   16 MHz / 9600 bd = 1667d = 0683h
  //      Hier waere dann:
  //        N3 = 0   / N2 = 6  / N1 = 8  / N0 = 3

  //      BRR1 bekaeme N2 und N1 => 0x68
  //      BRR2 bekaeme N3 und N0 => 0x03

  //  USART1_BRR1 = 0x68; // 9600 Baud
  //  USART1_BRR2 = 0x03;

  switch (baudrate)
  {
    case 11520 :
    {
      USART1_BRR1 = 0x08;
      USART1_BRR2 = 0x0b;
      break;
    }
    case 57600 :
    {
      USART1_BRR1 = 0x11;
      USART1_BRR2 = 0x06;
      break;
    }
    case 38400 :
    {
      USART1_BRR1 = 0x1a;
      USART1_BRR2 = 0x0a;
      break;
    }
    case 28800 :
    {
      USART1_BRR1 = 0x22;
      USART1_BRR2 = 0x0c;
      break;
    }
    case 19200 :
    {
      USART1_BRR1 = 0x34;
      USART1_BRR2 = 0x02;
      break;
    }
    case 9600 :
    {
      USART1_BRR1 = 0x68;
      USART1_BRR2 = 0x03;
      break;
    }
    case 4800 :
    {
      USART1_BRR1 = 0xd0;
      USART1_BRR2 = 0x05;
      break;
    }
    default : break;
  }

}
