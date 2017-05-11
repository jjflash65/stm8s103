/* ------------------------- flash_s52_t2313.c  ---------------------------

   Mini-MCS51-Flasher

   Flasht 89S51 und 89S52 Controller ueber einen AVR - MCU

   hier: ATtiny2313

   20.04.2015    (c) R. Seelig

  ---------------------------------------------------------------------- */

#define F_CPU 16000000

#include <util/delay.h>
#include <avr/io.h>
#include <avr/pgmspace.h>
#include <stdio.h>

#define isp_ddr    DDRB
#define isp_port   PORTB
#define isp_pin    PINB
#define isp_res    PB2
#define isp_mosi   PB3
#define isp_miso   PB0
#define isp_sck    PB1

#define isp_setb(nr)  (isp_port |= (1<<nr))
#define isp_clrb(nr)  (isp_port &= (~(1<<nr)))
#define isp_getb()    (isp_pin & (1 << isp_miso))

#define clockdelay 3
#define datadelay  3
#define wrdelay    200

#define led_ddr    DDRD
#define led_port   PORTD
#define flashled   PD6

#define led_asoutput() (led_ddr |= (1<<flashled))
#define led_off()      (led_port |= (1<<flashled))       // LED ist gegen +Ub geschaltet
#define led_on()       (led_port &= (~(1<<flashled)))

#define uart_prints(tx)  uart_putromstring(PSTR(tx))     // Benutzung: uart_prints("Hallo Welt\n\r");


uint16_t  startadr, proglen;
char      progmode;

static const const char startmeld[] PROGMEM = {
  "\n\r\n\rMCS51 ISP-Flash Programmer / 4-Byte Protokoll"          \
  "\n\runterstuetzte Controller:  AT89S51  - AT89S52"              \
  "\n\r(c) 2015 by R. Seelig\n\r"                                  \
  "\n\rSteuerkommandos\n\r"                                        \
  "\n\r1 - Clear  / 2 - Startadresse  / 3 - Programmlaenge"        \
  "\n\r4 - Reset  / 5 - Meldung       / 6 - Flashen"               \
  "\n\r7 - Lesen  / 8 - Prog.Enable   / d - Hex-Dump\n\r" };

static const const char hdumptext[] PROGMEM = {
  "\n\n\r\rAddr: Hexdump                  Ascii"                   \
  "\n\r---------------------------------------" };

  /* --------------------------------------------------------------------
                         serielle Schnittstelle
   -------------------------------------------------------------------- */

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


/* --------------------------------------------------
    Initialisierung der seriellen Schnittstelle:

    Uebergabe: baud = Baudrate
    Protokoll: 8 Daten-, 1 Stopbit
   -------------------------------------------------- */

void uart_init(uint32_t baud)
{
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

#if defined (__AVR_ATmega328P__) || defined (__AVR_ATmega168__) || defined (__AVR_ATtiny2313__)

  UCSR0B = (1<<RXEN0)|(1<<TXEN0);                       // Transmitter und Receiver enable
  UCSR0C = (3<<UCSZ00);                                 // 8 Datenbit, 1 Stopbit

#else

  // ATmega8
  UCSR0B |= (1<<RXEN0) | (1<<TXEN0);
  UCSRC  = (1<<URSEL) | (1<<UCSZ01) | (1<<UCSZ00);

#endif
}

/* --------------------------------------------------
    Zeichen ueber die serielle Schnittstelle senden
   -------------------------------------------------- */

void uart_putchar(unsigned char ch)
{
  while (!( UCSR0A & (1<<UDRE0)));                      // warten bis Transmitterpuffer leer ist
  UDR0 = ch;                                            // Zeichen senden
}

/* --------------------------------------------------
    Zeichen von serieller Schnittstelle lesen
   -------------------------------------------------- */

uint8_t uart_getchar( void )
{
  uint8_t b;

  while(!(UCSR0A & (1<<RXC0)));                         // warten bis Zeichen eintrifft
  UCSR0A &= ~(1<<RXC0);
  b= UDR0;
  UDR0= 0;
  return b;
}

/* --------------------------------------------------
                       UART_CRLF
     sendet auf der RS-232 ein Linefeed und ein
     Carriage Return
   -------------------------------------------------- */

void uart_crlf()
{
  uart_putchar(0x0a);
  uart_putchar(0x0d);
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
    uart_putchar( *p );
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
    uart_putchar(c);
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
  uart_putchar(b);

  b= value & 0x0f;
  if (b> 9) b += 55; else b += 48;
  uart_putchar(b);
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
  b = uart_getchar();

  b = b-48;
  if (b> 9) b = b-7;
  if (b> 9) b = b-32;
  w= b;
  w = (w << 4);

  b= uart_getchar();

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

// --------------------- ENDE UART-Funktionen ------------------------


/* --------------------------------------------------------------------
                         ISP Schnittstelle
   -------------------------------------------------------------------- */

/* --------------------------------------------------
       Zeitverzoegerungsschleifen fuer
         - 15 Millisekunden
         - Takt (sck)
         - Datenbitlaenge
   -------------------------------------------------- */

void isp_del15(void)
{
  _delay_ms(15);
}

void isp_clkdel(void)
{
  _delay_us(clockdelay);
}

void isp_datdel(void)
{
  _delay_us(datadelay);
}

/* --------------------------------------------------
                       ISP_INIT
      initialisiert die Pins, die fuer ISP im Bit-
      bangmodus benoetigt wird als Ausgaenge (MISO
      als Eingang)
   -------------------------------------------------- */
void isp_init(void)
{
  isp_ddr |= (1 << isp_res) | (1 << isp_mosi) | (1 << isp_sck);
  isp_ddr &= ~(1 << isp_miso);
  isp_setb(isp_miso);                   // Pop-Up Widerstand an
}

/* --------------------------------------------------
                      ISP_SEND
      sendet ein Byte <value> als ISP-Byte
   -------------------------------------------------- */
void isp_send(uint8_t value)
{
  char    i;
  uint8_t smask;

  smask= 0x80;                          // 1000.0000
  for (i= 0; i< 8; i++)
  {
    if (value & smask)
    {
      isp_setb(isp_mosi);
    }
    else
    {
      isp_clrb(isp_mosi);
    }
    isp_datdel();
    isp_setb(isp_sck);
    isp_clkdel();
    isp_clrb(isp_sck);
    isp_datdel();

    smask= smask >> 1;
  }
  isp_clkdel();
}

/* --------------------------------------------------
                     ISP_SEND3FRAME
      sendet ein 3-Byte langes Frame auf dem ISP-
      Bus (bei einem 4-Byte Protokoll wird das
      4. Byte gelesen)
   -------------------------------------------------- */
void isp_send3frame(uint8_t w1, uint8_t w2, uint8_t w3)
{
  isp_send(w1);
  isp_send(w2);
  isp_send(w3);
}

/* --------------------------------------------------
                     ISP_SEND4FRAME
      sendet ein 4-Byte langes Frame auf dem ISP-
      Bus.
   -------------------------------------------------- */
void isp_send4frame(uint8_t w1, uint8_t w2, uint8_t w3, uint8_t w4)
{
  isp_send3frame(w1,w2,w3);
  isp_send(w4);
}

/* --------------------------------------------------
                     ISP_READ
      liest ein Byte vom ISP-Bus.

      Rueckgabe:   gelesenes Byte
   -------------------------------------------------- */
uint8_t isp_read(void)
{
  char      i;
  uint8_t   erg;

  erg= 0;
  for (i= 7; i > -1; i--)
  {
    isp_clkdel();
    isp_setb(isp_sck);
    if (isp_getb())
    {
      erg |= (1 << i);
    }
    isp_clkdel();
    isp_clrb(isp_sck);
  }
  return erg;
}

/* --------------------------------------------------
                    RESET51
      fuehrt einen Reset am MCS-51 Controller durch
   -------------------------------------------------- */
void reset51(void)
{
  isp_setb(isp_res);
  isp_clkdel();
  isp_clrb(isp_res);
  isp_del15();
  isp_setb(isp_res);
}


/* --------------------------------------------------
                     SETPROGENABLE
      Setzt den MCS51 zurueck und sendet Kommando
      "programming enable" sodass nachfolgende
      Flash- und/oder Leseoperationen durchgefuehrt
      werden koennen.
   -------------------------------------------------- */
char setprogenable(void)
// liefert 0x69 zurueck, wenn ein AT89S51 / S52 gefunden wurde, ansonsten
//   0xFF
{
  char b;

  reset51();
  isp_del15();
  isp_send3frame(0xac, 0x53, 0);                // senden : Programming enable
  b= isp_read();
  if (!b) return b;                             // b ist entweder 69h (Kennung fuer
                                                // 89S51 / S52 , dann 69h zurueckliefern
                                                // oder 0 bei anderem Chip
  progmode= 1;
  isp_setb(isp_sck);
  return 0;
}
// ---------------------- ENDE ISP-Funktionen ------------------------


// -------------------------------------------------------------------------------
//                                        M A I N
// -------------------------------------------------------------------------------


int main(void)
{
  uint8_t b, b2, h, hr, i;
  uint8_t al, ah;
  uint8_t writesucc;
  uint16_t adrx, cx;
  char ascvalues[8];

  led_asoutput();
  led_off();

  isp_init();
  isp_clrb(isp_mosi);
  isp_clrb(isp_res);
  isp_clrb(isp_sck);

  uart_init(115200);

  startadr = 0;
  proglen =  0;
  progmode = 0;

//  uart_prints(&startmeld);
  uart_putromstring(&startmeld[0]);
  reset51;
  isp_clrb(isp_res);


/*
  b= setprogenable();
  uart_sendhex(b);
  for (i= 0; i< 4; i++)
  {
    isp_send3frame(0x28, i, 0);                // senden : Programming enable
    b= isp_read();
    uart_crlf();
    uart_sendhex(b);
  }


  while(1);
*/

  while(1)
  {
    b= uart_getchar();
    switch (b)
    {
      case '1' :                       // Chip erase
        {
          if (setprogenable() == 0x69)
          {
            isp_del15();
            isp_del15();
            isp_send4frame(0xac, 0x80, 0, 0);           // senden : Chip erase
            isp_del15();
            isp_del15();
            isp_send4frame(0xac, 0x80, 0, 0);           // senden : Chip erase
            isp_del15();
            isp_del15();
          }
          break;
        }
      case '2' :
        {
          startadr= uart_gethex16();
          break;
        }
      case '3' :
        {
          proglen= uart_gethex16();
          break;
        }
      case '4' :
        {
          b= setprogenable();
          reset51;
          isp_clrb(isp_res);
          break;
        }
      case '5' :
        {
          uart_putromstring(&startmeld[0]);
          break;
        }
      case '6' :
        {
          led_on();
          if (setprogenable() == 0x69)
          {
            isp_del15();
            adrx= startadr;

            for (cx= 0; cx< (proglen+1); cx++)
            {
              h= uart_gethex();
              b2= 0;
              writesucc= 1;

              do
              {
                ah= (adrx >> 8);
                al= (adrx & 0xff);

                isp_send4frame(0x40, ah, al, h);
//                _delay_us(wrdelay);
                isp_send3frame(0x20, ah, al);
                isp_clkdel();
                hr= isp_read();
                if (h == hr) writesucc= 1;
                b2++;
              } while((b2 < 3) & (!writesucc));

              if (writesucc) uart_putchar('O'); else uart_putchar('E');
              adrx++;
            }
          }
          led_off();
          break;
        }
      case '7' :
        {
          if (setprogenable() == 0x69)
          {
            adrx= startadr;
            for (cx= 0; cx< (proglen+1); cx++)
            {
              // if ((cx % 16)== 0) uart_crlf();
              ah= (adrx >> 8);
              al= (adrx & 0xff);
              isp_send3frame(0x20, adrx >> 8, adrx & 0xff);
              isp_clkdel();
              hr= isp_read();
              uart_sendhex(hr);
              adrx++;
            }
            isp_clrb(isp_res);
          }
          break;
        }
      case 'd' :
        {
          if (setprogenable() == 0x69)
          {
            uart_putromstring(&hdumptext[0]);

            adrx= startadr;
            uart_crlf();
            for (b= 0; b< 8; b++)
            {
              ascvalues[b]= '.';
            }
            b2= 0;
            for (cx= 0; cx< (proglen+1); cx++)
            {
              if (!cx)
              {
                uart_sendhex16(adrx);
                uart_prints(": ");
              }
              if (((cx % 8)== 0) && (cx))
              {
                uart_prints(" ");
                for (b= 0; b< 8; b++)
                {
                  if (ascvalues[b]> 31) uart_putchar(ascvalues[b]); else uart_putchar('.');
                  ascvalues[b]= '.';
                }
                b2= 0;
                uart_crlf();
                uart_sendhex16(adrx);
                uart_prints(": ");
              }
              ah= (adrx >> 8);
              al= (adrx & 0xff);
              isp_send3frame(0x20, adrx >> 8, adrx & 0xff);
              isp_clkdel();
              hr= isp_read();
              ascvalues[b2]= hr;
              b2++;
              uart_sendhex(hr);
              uart_putchar(' ');
              adrx++;
            }
            adrx= 7-(proglen % 8);
            while (adrx)
            {
              uart_prints("   ");
              adrx--;
            }
            uart_putchar(' ');
            for (b= 0; b< b2; b++)
            {
              if (ascvalues[b]> 31) uart_putchar(ascvalues[b]); else uart_putchar('.');
              ascvalues[b]= '.';
            }
            uart_crlf();
            isp_clrb(isp_res);
          }
          break;
        }
      case '8' :
        {
          _delay_ms(15);
          al= setprogenable();
          uart_sendhex(al);
          break;
        }

      default :
        {
          break;
        }
    }
  }
}
