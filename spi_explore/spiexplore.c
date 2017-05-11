/* ------------------------------------------------------
                       spiexplore.c

     "universelles" SPI Interface zum  "Spielen" ueber
     die serielle Schnittstelle.

     Zweck : Erleichterung von Experimenten (Evaluierung
             von ISP wie bspw. AVR Controller, MCS-51
             Controller der AT89S-Serie)

     Baudrate: 57600 / 8N1

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     23.06.2016  R. Seelig
   ------------------------------------------------------ */




#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "uart.h"
#include "spi.h"

char     rinv      = 0;
char     clkinv    = 0;

#define cmdanz   6
static const char cmds [cmdanz][9] =
{
//     1      2       3       4        5         6
    "rinv", "send", "read", "cmd4", "clkinv", "reset"
};

#define  isp_reset_init()  PC3_output_init()             // Resetleitung ISP als Ausgang

void isp_setrst(void)
{
  if (rinv) PC3_clr(); else PC3_set();
}

void isp_clrrst(void)
{
  if (rinv) PC3_set(); else PC3_clr();
}


/* --------------------------------------------------
     PRINTHEX
     gibt einen unsigned char als Hex-Wert auf der
     seriellen Schnittstelle aus
   -------------------------------------------------- */
void printhex(uint8_t value)
{
  uint8_t b;

  b= (value >> 4);
  if (b< 10) b += '0'; else b += 'A'-10;
  uart_putchar(b);
  b= value & 0x0f;
  if (b< 10) b += '0'; else b += 'A'-10;
  uart_putchar(b);
}

/* --------------------------------------------------
     GETHEX
     liest einen Hex-Wert von der seriellen Schnitt-
     stelle ein

     echo => 1 : gelesener Wert wird zurueckgesendet
             0 : nicht zuruecksenden
   -------------------------------------------------- */
uint8_t gethex(char echo)
{
  uint8_t ch;
  uint8_t value;

  ch= uart_getchar();
  if (echo) uart_putchar(ch);
  if (ch > 'F')
  {
    ch= (ch-'a')+10;
  }
  else
  {
    if (ch> '9') ch= (ch-'A')+10; else ch -= '0';
  }
  value= (ch<< 4);
  ch= uart_getchar();
  if (echo) uart_putchar(ch);

  if (ch > 'F')
  {
    ch= (ch-'a')+10;
  }
  else
  {
    if (ch> '9') ch= (ch-'A')+10; else ch -= '0';
  }
  value |= ch;
  return value;
}

void printhex16(uint16_t value)
{
  printhex(value >> 8);
  printhex(value & 0x00ff);
}

uint16_t gethex16(char echo)
{
  uint16_t i, i2;

  i= gethex(0);
  i= i & 0x00ff;
  i2= gethex(0);
  i2= i2 & 0x00ff;
  i2= i2 | (i << 8);
  if (echo) printhex16(i2);
  return i2;
}


/* --------------------------------------------------
     READSTR
     liest einen String von der seriellen Schnitt-
     stelle ein
   -------------------------------------------------- */
void readstr(char *string, char anz)
{
  char cnt, ch;

  cnt= 0;

  *string= 0;
  do
  {
    ch= uart_getchar();
    if (ch!= 0x0d)
    {
      if (ch!= 0x08)
      {
        if (cnt< anz)
        {
          uart_putchar(ch);
          *string= ch;
          string++;
          *string= 0;
          cnt++;
        }
      }
      else
      {
        if (cnt)
        {
          uart_putchar(0x08);
          string--;
          *string= 0;
          cnt--;
        }
      }
    }
  } while (ch != 0x0d);
}

/* --------------------------------------------------
     CRLF
     erzeugt einen Carriagereturn und linefeed auf
     der seriellen Schnittstelle
   -------------------------------------------------- */

void crlf(void)
{
  uart_putchar(0x0d);
  uart_putchar(0x0a);
}


char checkcmd(char *string)
{
  char  i,cp, ch;
  char  match;
  char  *s;

  i= 0;
  do
  {
    s= string;
    match= 1;
    cp= 0;
    do
    {
      ch= cmds[i][cp];
      if (ch!= *s) match= 0;
//      printf("%d: %.2x = %c  %.2x = %c\n\r",cp,ch,ch,*s,*s);
      cp++; s++;
    }while(ch && match);
    if (match) return i+1;
    i++;
  } while (i < cmdanz);
  return 0;
}


void showactrstmode(void)
{
  crlf();
  uart_prints("actual mode is: ");
  if (rinv) uart_prints("invert "); else uart_prints("not invert ");
}

void showactclkmode(void)
{
  crlf();
  uart_prints("actual mode is: ");
  if (clkinv) uart_prints("invert "); else uart_prints("not invert ");
}


void get4cmdbytes(uint8_t *v1, uint8_t *v2, uint8_t *v3, uint8_t *v4)
{
  uint8_t v;
  crlf();
  uart_prints("Enter 4 instruction bytes: ");
  v = gethex(1); uart_putchar(' ');
  *v1 = v;
  v = gethex(1); uart_putchar(' ');
  *v2 = v;
  v = gethex(1); uart_putchar(' ');
  *v3 = v;
  v = gethex(1); uart_putchar(' ');
  *v4 = v;
  crlf();
}

void send3cmdbytes(uint8_t v1, uint8_t v2, uint8_t v3)
{
  spi_out(v1);
  spi_out(v2);
  spi_out(v3);
}

uint8_t send4cmdbytes(uint8_t v1, uint8_t v2, uint8_t v3, uint8_t v4)
{
  uint8_t value;

  spi_out(v1);
  spi_out(v2);
  spi_out(v3);
  spi_out(v4);
  value= spi_read();
  return value;
}


void cmdinterpret(void)
{
  char ch;
  uint8_t b;
  uint8_t v1, v2, v3, v4;
  char inbuffer[13];

  do
  {
    uart_prints("SPI:> ");
    readstr(&inbuffer[0],8);
    ch= checkcmd(&inbuffer[0]);

    switch(ch)
    {
      case 1 :                               // Reset-Modus (invertiert oder nicht invertiert)
      {
        showactrstmode();
        uart_prints("[0/1]: ");
        ch= uart_getchar();
        uart_putchar(ch);
        if (ch== '1') {rinv= 1;} else {rinv= 0;}
        showactrstmode();
        crlf();
        break;
      }
      case 2 :                               // send Data-Byte
      {
        crlf();
        uart_prints("byte to send: ");
        b= gethex(1);
        spi_out(b);
        crlf();
        break;
      }
      case 3 :                               // read Data-Byte
      {
        crlf();
        uart_prints("readed byte: ");
        b= spi_read();
        printhex(b);
        crlf();
        break;
      }
      case 4 :                              // send 4-Byte instruction
      {
        get4cmdbytes(&v1, &v2, &v3, &v4);
        send4cmdbytes(v1, v2, v3, v4);
        break;
      }
      case 5 :                               // Clock-Modus (invertiert oder nicht invertiert)
      {
        showactclkmode();
        uart_prints("[0/1]: ");
        ch= uart_getchar();
        uart_putchar(ch);
        if (ch== '1') {clkinv= 1;} else {clkinv= 0;}
        showactclkmode();
        crlf();
        break;
      }
      case 6 :                                // Reset - Leitung
      {
        crlf();
        uart_prints("[0/1]: ");
        ch= uart_getchar();
        uart_putchar(ch);
        if (ch== '1') { isp_setrst(); } else { isp_clrrst(); }
        crlf();
        break;
      }

      default :
        {
          uart_putchar(ch);
          uart_prints("\n\runkown command\n\r");
          break;
        }
    }
  }while(ch != 15);
}



/* --------------------------------------------------

                       M A I N

   -------------------------------------------------- */

int main(void)
{
  uint16_t    baudrate;

  baudrate= 19200;

  sysclock_init(0);
  uart_init(baudrate);
  isp_reset_init();             // Ausgangspin der MCU wird zum Resetpin des Targets
  spi_init(1,0,0);              // Taktteiler / 2 = 4MHz, keine Taktinvertierung, Phase = 0

  uart_prints("\n\rSPI-Explorer 0.01\n\r");
  crlf();

  clkinv= 0;

  while(1)
  {
    cmdinterpret();
  }
}

