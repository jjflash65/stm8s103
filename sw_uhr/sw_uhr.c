/* -------------------------------------------------------
                         sw_uhr.c

     Softwareuhr, mittels Timer1 und Timer1-Overflow
     realisiert

     Benoetigte Hardware;

              - UART
              - optional 7-Segmentanzeige anschliessbar
                (TM1637)

     MCU   :  STM8S103F3
     Takt  :  externer Takt 16 MHz

     29.06.2016  R. Seelig
   ------------------------------------------------------ */

#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "my_printf.h"
#include "tm1637.h"
#include "uart.h"


#define printf               my_printf

uint8_t   std,min,sek;
uint8_t   day,month;
int       year;


/* --------------------------------------------------
      GETWTAG

      Berechnet zu einem bestimmten Datum den
      Wochentag (nach Carl Friedrich Gauss):

      Rueckgabe: der Tag der Woche, beginnend ab
                 Sonntag. Sonntag entspricht 0.

      Bsp.:      02.06.2016   ( das ist ein Donnerstag )
      Rueckgabe: 5

   -------------------------------------------------- */
char getwtag(int day, int month, int year)
{
  int w_tag;

  if (month < 3)
  {
     month = month + 12;
     year--;
  }
  w_tag = (day+2*month + (3*month+3)/5 + year + year/4 - year/100 + year/400 + 1) % 7 ;
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
              Timer1 overflow - interrupt
    -------------------------------------------------- */
void tim1_ovf(void) __interrupt(11)
// 11 ist der Interruptvektor fuer Timer1 overflow
{

  sek++;
  if (sek==60)
  {
    sek= 0;
    min++;
    if (min==60)
    {
      min= 0;
      std++;
      if (std==24)
      {
        std= 0;

        // ab hier Kalenderfunktionen
        if (day< 28)                                            // Monatsende nicht erreicht
        {
          day++;
          return;
        }

        if (month== 2)
        {
          if ((year % 4)== 0)                                   // Schaltjahr
          {
            if (day==28)
            {
              day++;
              return;
            }
            else
            {
              month++;
              day= 1;
              return;
            }
          }
          else
          {
            month++;
            day= 1;
            return;
          }
        }

        if ((month==4) || (month==6) || (month== 9) || (month== 11))     // April, Juni, September, November
        {
          if (day< 30)
          {
            day++;
            return;
          }
          else
          {
            day= 1;
            month++;
            return;
          }
        }

        // ab hier alle Monate mit 31 Tagen

        if ((month== 12) && (day== 31))                                // Feuerwerk, es ist Sylvester
        {
          day= 1;
          month= 1;
          year++;
          return;
        }

        if (day< 31)                                                  // Monatsende nicht erreicht
        {
          day++;
          return;
        }

        day= 1;                                                       // monthsende der Monate mit 31 Tagen
        month++;
        return;

      }
    }
  }

  TIM1_SR1 &= ~TIM1_SR1_UIF;        // Interrupt quittieren

}

/* --------------------------------------------------
                       tim1_init
      intialisiert Timer mit Taktteiler / 16000
      (Prescaler somit = 15999) und startet diesen im
      Autoreloadmodus mit Autoreloadwert 999 (jeder
      1000ste Impuls erzeugt Interrupt)

      Bei F_CPU = 16 MHz gilt:

      16 MHz / 16000 = 1 KHz => 1 ms
      Autoreloadwert 999 => Wert / 1000

      => 1 ms / 1000 = 1 s !!!!!
   -------------------------------------------------- */
void tim1_init(void)
{

  // Prescaler-Register = 15999 entspricht Teilung / 16000 .. ( 0..15999 = 16000 Schritte)
  // Timer wird somit bei F_CPU= 16 MHz mit 1mS getaktet
  #define clockdivisor     ((uint16_t) 15999)

  TIM1_PSCRH= (uint8_t) (clockdivisor >> 8);
  TIM1_PSCRL= (uint8_t) (clockdivisor & 0x0000ff);

  // Enable overflow
  TIM1_IER |= TIM1_IER_UIE;

  // Timer1 starten
  TIM1_CR1 |= TIM1_CR1_CEN;     // Timer1 enable ( CEN = ClockENable )
  TIM1_CR1 |= TIM1_CR1_ARPE;    // Timer1 autoreload ( mit Werten in TIM1_ARR )

  // Autoreloadwert = 999 (jeder 1000ste Impuls ein Interrupt)
  TIM1_ARRH= (uint8_t) (999 >> 8);
  TIM1_ARRL= (uint8_t) (999 & 0x00ff);

  int_enable();
}

/* --------------------------------------------------
     UHR_STELLEN

     die Uhr benutzerabgefragt stellen
   -------------------------------------------------- */
void uhr_stellen(void)
{
  int       i;

  do
  {
    printf("\n\rTag    : ");
    i= uart_readint();
  } while ( !((i > -1) && (i < 32)));
  day= i;

  do
  {
    printf("\n\rMonat  : ");
    i= uart_readint();
  } while ( !((i > -1) && (i < 13)));
  month= i;

  do
  {
    printf("\n\rJahr   : ");
    i= uart_readint();
  } while ( !((i > -1) && (i < 100)));
  year= 2000+i;

  do
  {
    printf("\n\rStunde : ");
    i= uart_readint();
  } while ( !((i > -1) && (i < 24)));
  std= i;

  do
  {
    printf("\n\rMinute : ");
    i= uart_readint();
  } while ( !((i > -1) && (i < 60)));
  min= i;

  do
  {
    printf("\n\rSekunde: ");
    i= uart_readint();
  } while ( !((i > -1) && (i < 60)));
  sek= i;

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
  int       wt;


  char wtag[][3] = {"So","Mo","Di","Mi","Do","Fr","Sa"};

  sysclock_init(0);             // erstes Initialisieren interner Takt
  delay_ms(50);
//  sysclock_init(1);             // Taktumschaltung auf externem Quarz
  delay_ms(50);

  uart_init(19200);             // serielle Schnittstelle
  tim1_init();                  // Timer1 - Interrupt
  tm1637_init();                // 7 - Segmentanzeige
  tm1637_clear();
  tm1637_dp= 1;
  tm1637_setdez(0);

  std= 0; min= 0; sek= 0; year= 2016; month= 1; day= 1;
  printf("\n\n\rSTM8S103F3P6 - Softwareuhr\n\r");
  printf(      "---------------------------------\n\r");
  printf(      "CPU=16MHz 19200Bd 8N1\n\r");
  printf("\n\n\rUhr stellen:\n\r");

  uhr_stellen();

  printf("\n\n\r");
  oldsek= sek-1;

  while(1)
  {
    while(sek == oldsek);               // warten bis Sekunde "weiterspringt"

    oldsek= sek;
    wt= getwtag(day, month, year);

    // Umrechnung in BCD-Zahlen und Darstellung als Hexwerte, damit
    // eine fuehrende Null mit ausgegeben wird (ist den eingeschraenkten
    // Moeglichkeiten von - my_printf - geschuldet )
    printf(" %s:  %x.%x.%d  %x.%x:%x  \r", wtag[wt],           \
             dez2bcd(day), dez2bcd(month), year,   \
             dez2bcd(std), dez2bcd(min), dez2bcd(sek));


    // abschliessend Uhrzeit zusaetzlich auf 7-Segmentanzeige anzeigen
    delay_ms(490);
    tm1637_dp= 0;
    tm1637_setdez2(0,min);
    tm1637_setdez2(1,std);
    delay_ms(490);
    tm1637_dp= 1;
    tm1637_setdez2(0,min);
    tm1637_setdez2(1,std);

  }
}
