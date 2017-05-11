/* -------------------------------------------------------
                         i2c_rtc_temp.c

     Liest DS1307 (Realtime-Clock-Chip) aus und zeigt
     diese auf der seriellen  Schnittstelle an

     Benoetigte Hardware;

              DS1307   RTC-Modul
              LM75     Temperatursensor
              TM1637   4-stellige 7-Segmentanzeige
              UART

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     31.05.2016  R. Seelig
   ------------------------------------------------------ */

#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "my_printf.h"
#include "uart.h"
#include "i2c.h"
#include "tm1637.h"

#define printf               my_printf


#define rtc_addr            0xd0


uint8_t   std,min,sek;
uint8_t   dow, day,month;
int       year;


/* --------------------------------------------------
      RTC_READ

      liest eine Speicherzelle des DS1307 Uhrenbau-
      steins aus
   -------------------------------------------------- */
uint8_t rtc_read(uint8_t addr)
{

  uint8_t value;

  i2c_start();
  i2c_write(rtc_addr);
  delay_ms(1);
  i2c_write(addr);
  delay_ms(1);
  i2c_stop();
  delay_ms(1);
  i2c_start();
  i2c_write(rtc_addr | 1);
  delay_ms(1);
  value= i2c_read_nack();
  delay_ms(1);
  i2c_stop();

  return value;
}

/* --------------------------------------------------
      RTC_WRITE

      beschreibt eine Speicherzelle des DS1307
      Uhrenbausteins

      addr  =>  Registeradresse
      value =>  zu setzender Wert
   -------------------------------------------------- */
void rtc_write(uint8_t addr, uint8_t value)
{

  i2c_start();
  i2c_write(rtc_addr);
  delay_ms(1);
  i2c_write(addr);
  delay_ms(1);
  i2c_write(value);
  delay_ms(1);
  i2c_stop;

}

/* --------------------------------------------------
      RTC_SHOWTIME

      liest das DS1307 Uhrenmodul aus und zeigt die
      Zeit an.
   -------------------------------------------------- */
void rtc_showtime(void)
{
  uint8_t sek,min,std;
  uint8_t day,month,year;

//  printf("\n\r%x.%x.20%x  %x.%x:%x\n\r",day,month,year,std,min,sek);

  sek= rtc_read(0) & 0x7f;
  min= rtc_read(1) & 0x7f;
  std= rtc_read(2) & 0x3f;
  day= rtc_read(4) & 0x3f;
  month= rtc_read(5) & 0x1f;
  year= rtc_read(6);

  printf("\n\r%x.%x.20%x  %x.%x:%x\n\r",day,month,year,std,min,sek);

}

/* --------------------------------------------------
      GETWTAG

      Berechnet zu einem bestimmten Datum den
      Wochentag (nach Carl Friedrich Gauss):

      Rueckgabe: der Tag der Woche, beginnend ab
                 Sonntag. Sonntag entspricht 0.

      Bsp.:      02.06.2016   ( das ist ein Donnerstag )
      Rueckgabe: 5

   -------------------------------------------------- */
char getwtag(int tag, int monat, int jahr)
{
  int w_tag;

  if (monat < 3)
  {
     monat = monat + 12;
     jahr--;
  }
  w_tag = (tag+2*monat + (3*monat+3)/5 + jahr + jahr/4 - jahr/100 + jahr/400 + 1) % 7 ;
  return w_tag;
}

/* --------------------------------------------------
      DEZ2BCD

      wandelt eine dezimale Zahl in eine BCD
      Bsp: value = 45
      Rueckgabe    0x45
   -------------------------------------------------- */
uint8_t dez2bcd(uint8_t value)
{
  uint8_t hiz,loz,c;

  hiz= value / 10;
  loz= (value -(hiz*10));
  c= (hiz << 4) | loz;
  return c;
}

/* --------------------------------------------------
      CHECKINT16
      testet, ob eine String im Integerzahlenbereich
      liegt und wenn dem so ist, wird der String in
      einen Integer gewandelt.

      Uebergabe:
              *p    : Zeiger auf einen String
              *myi  : Zeiger auf den zurueck zu
                      gebenden Integer

      Rueckgabe:
              0     : wenn nicht im Zahlenbereich
              1     : wenn im Zahlenbereich
   -------------------------------------------------- */

int checkint16(char *p, int *myi)
{
  char     neg,l;
  char     *p2;
  int      x;
  long     z,z2;

  if ( *p == 0 )
  {
    *myi= 0;
    return 1;
  }
  p2= p;
  l= 0;
  while ( *p++) { l++; }          // ermittelt die Laenge des Strings
  p= p2;
  neg= 0;
  if ( *p == '-')                  // negative Zahl ?
  {
    neg= 1;
    p2++; p++;                   // Zahlenbereich nach dem Minuszeichen
    l--;                         // und Zahl ist eine Stelle kuerzer
  }
  p += (l-1);                    // Pointer auf die Einerzahlen setzen
  z= *p - 48;                    // nach Ziffer umrechnen
  z2= 1;
  if (l> 1)
  {
    l--;                         // Laenge "kuerzen" weil 10er Stelle
    p--;                         // Zeiger auf die 10er Stelle
    do
    {
      z2= z2*10;
      z= z+ (z2 * ( *p - 48 ));  // Ziffer * Multiplikator + alten Inhalt von z
      p--;
      l--;
    } while (l);                 // fuer alle Stellen wiederholen
  }
  if (((z> 32767) && (!neg)) | (z> 32768))
  {
    *myi= 0;
    return 0;
  }
  if (neg) { z= z * -1; }
  x= z;
  *myi= z;
  return 1;
}

/* --------------------------------------------------
                     UART_READINT
     liest einen Integerzahlenwert ueber die RS-232
     ein.
     Eine Ueberpruefung auf den Integerwertebereich
     findet statt !!!!
   -------------------------------------------------- */

signed int uart_readint()
{

  #define maxinlen   7         // max. 6 Zeichen + NULL

  char str[maxinlen];
  char *p;
  char *pz;
  char  ch, cnt, b;
  signed int i;


  p= &str[0];                  // p zeigt auf die Adresse von str
  pz= p;                       // pz zeigt immer auf erstes Zeichen im String
  *p = 0;                      // und setzt dort NULL Byte
  cnt= 0;
  do
  {
    do
    {
      ch= uart_getchar();
      if ((ch>= '0') && (ch<= '9'))
      {
        if (cnt < maxinlen-1)
        {
          *p++= ch;              // schreibt Char in den String und erhoeht Pointer
          *p= 0;                 // und schreibt neues NULL (Endekennung)
          cnt++;
          uart_putchar(ch);      // Echo des eingebenen Zeichens
        }
      }
      switch (ch)
      {
        case '-' :
          {
            if (cnt == 0)
            {
              *p++= ch;
              *p= 0;
              cnt++;
              uart_putchar(ch);
            }
            break;
          }
        case 8   :
          {
            if (cnt> 0)
            {
              uart_putchar(ch);
              p--;
              *p= 0;
              cnt--;
            }
            break;
          }
        default  :
          {
            break;
          };
      }
    } while (ch != 0x0d);        // wiederholen bis Returnzeichen eintrifft
    b=  (checkint16( &str[0], &i ));
    if (!b)
    {
      for (i= cnt; i> 0; i--)
      {
        uart_putchar(8);         // gemachte, fehlerhafte Eingabe durch Backspace
                                 // loeschen
      }
      cnt= 0;                    // und Zaehler zuruecksetzen
      p= pz;
      *p= 0;
    }
  } while (!b);      // Zahl soll im 16 Bit Integerbereich liegen
  return i;
}

/* --------------------------------------------------
     RTC_STELLEN

     die Uhr benutzerabgefragt stellen
   -------------------------------------------------- */

void rtc_stellen(void)
{
  int       i;
  uint8_t   b,cx;

  do
  {
    printf("\n\rStunde: ");
    i= uart_readint();
  } while ( !((i > -1) && (i < 24)));
  b= i;
  b= dez2bcd(b);
  cx= rtc_read(2);                  // Stunde der Uhr lesen
  cx &= 0xc0;                       // obere 2 Bits der Stunden belassen
  cx |= b;
  rtc_write(2,cx);                  // und Stunde neu setzen

  do
  {
    printf("\n\rMinute: ");
    i= uart_readint();
  } while ( !((i > -1) && (i < 60)));
  b= i;
  b= dez2bcd(b);
  cx= rtc_read(1);                  // Minute der Uhr lesen
  cx &= 0x80;                       // oberes Bit der Minuten belassen
  cx |= b;
  rtc_write(1,cx);                  // und Minuten neu setzen

  do
  {
    printf("\n\rSekunde: ");
    i= uart_readint();
  } while ( !((i > -1) && (i < 60)));
  b= i;
  b= dez2bcd(b);
  cx= rtc_read(0);                  // Sekunde der Uhr lesen
  cx &= 0x80;                       // oberes Bit der Sekunden (CH) belassen
  cx |= b;
  rtc_write(0,cx);                  // und Sekunden neu setzen

  do
  {
    printf("\n\rTag: ");
    i= uart_readint();
  } while ( !((i > -1) && (i < 32)));
  b= i;
  day= b;
  b= dez2bcd(b);
  cx= rtc_read(4);                  // Tag der Uhr lesen
  cx &= 0xc0;
  cx |= b;
  rtc_write(4,cx);                  // und Sekunden neu setzen

  do
  {
    printf("\n\rMonat: ");
    i= uart_readint();
  } while ( !((i > -1) && (i < 13)));
  b= i;
  month= b;
  b= dez2bcd(b);
  cx= rtc_read(5);                  // Monat der Uhr lesen
  cx &= 0xc0;
  cx |= b;
  rtc_write(5,cx);                  // und Monat neu setzen

  do
  {
    printf("\n\rJahr: ");
    i= uart_readint();
  } while ( !((i > -1) && (i < 100)));
  b= i;
  year= 2000+b;
  b= dez2bcd(b);
  rtc_write(6,b);                  // Jahr schreiben

  dow= getwtag(day,month,year);
  rtc_write(3,dow);

}

/* --------------------------------------------------
     LM75_READ

     "Extra". Liest einen eventuell angeschlossenen
     LM75 - Sensor aus und gibt die Temperatur multi-
     pliziert mit 10 als Argument zurueck.

     Ist kein LM75 am I2C Bus angeschlossen, wird als
     Wert -127 zurueck gegeben.
   -------------------------------------------------- */
int lm75_read(void)
{
  char       ack;
  char       t1;
  uint8_t    t2;
  int        lm75temp;

  i2c_start();

  ack= i2c_write(0x90);                     // LM75 Basisadresse
  if (ack)
  {

    i2c_write(0x00);                        // LM75 Registerselect: Temp. auslesen
    i2c_write(0x00);

    i2c_stop();
    delay_us(200);
    i2c_start();

    i2c_write(0x91);                        // LM75 zum Lesen anwaehlen
    delay_ms(1);                            // Reaktionszeit LM75
    t1= 0;
    t1= i2c_read();                         // hoeherwertigen 8 Bit
    delay_ms(1);
    t2= i2c_read_nack();                    // niederwertiges Bit (repraesentiert 0.5 Grad)
    i2c_stop();

  }
  else
  {
    i2c_stop();
    return -127;                            // Abbruch, Chip nicht gefunden
  }

  lm75temp= t1;
  lm75temp = lm75temp*10;
  if (t2 & 0x80) lm75temp += 5;             // wenn niederwertiges Bit gesetzt, sind das 0.5 Grad
  return lm75temp;
}


/* --------------------------------------------------
     PUTCHAR

     Diese Funktion wird von < my_printf > zur Ausgabe
     von Zeichen aufgerufen. Hier ist eine Hardware-
     zeichenausgabefunktion anzugeben, mit der
     my_printf zusammen arbeiten soll.
   -------------------------------------------------- */
void putchar(char ch)
{
  uart_putchar(ch);
}



/* ----------------------------------------------------------------------------------
                                           MAIN
   ---------------------------------------------------------------------------------- */

void main(void)
{

  uint8_t   oldsek;
  uint8_t   cx;
  int       b;


  char wtag[][3] = {"So","Mo","Di","Mi","Do","Fr","Sa"};

  sysclock_init(0);

  printfkomma= 1;

  i2c_init(2);
  uart_init(19200);
  tm1637_init();

  tm1637_clear();

  printf("\n\rI2C Realtimeclock DS1307\n\r--------------------------\n\r");
  cx= rtc_read(0x00);
  cx &= 0x7f;                  // CH Bit loeschen
  rtc_write(0x00,cx);
  cx= rtc_read(0x02);          // lese Stunde (die das 12 / 24 Std. Format Flag enthaellt)
  cx &= 0xbf;                  // Bit 6= 0 => 24 Std. Format
  rtc_write(0x02,cx);
  printf("Aktuelle Zeit ist: "); rtc_showtime();
  cx= 0; b= 255;

  printf("\n\n\rUhr stellen (j/n)");
  cx= uart_getchar();
  if (cx == 'j')
  {
    rtc_stellen();
  }

  printf("\n\r");
  oldsek= sek;

  while(1)
  {
    do
    {
      delay_ms(400);
      sek= rtc_read(0);
      tm1637_dp= 0;
      tm1637_sethex2(0,min);
      tm1637_sethex2(1,std);
      delay_ms(350);
      tm1637_dp= 1;
      tm1637_sethex2(0,min);
      tm1637_sethex2(1,std);

    } while(sek == oldsek);
    oldsek= sek;
    min= rtc_read(1);
    std= rtc_read(2) & 0x3f;
    dow= rtc_read(3) & 0x07;
    day= rtc_read(4) & 0x3f;
    month= rtc_read(5) & 0x1f;
    year= rtc_read(6);

    printf("  %s %x.%x.20%x  %x.%x:%x  Temp.= ",    \
             wtag[dow],day,month,year,std,min,sek);

    tm1637_sethex2(0,min);
    tm1637_sethex2(1,std);
    b= lm75_read();
    if (b== -127)
        {
          printf("n.a.\r");
        }
        else
        {
          printf("  %k  C   \r",b);
        }

  }
}
