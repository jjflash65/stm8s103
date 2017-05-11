/* -------------------------------------------------------
                      stm8_systimer.c

     Initialisierung eines Systemtimers. Hierfuer wird
     Timer1 verwendet.

     In der Hauptdatei muss eine Funktion

                   systimer_intervall()

     vorhanden sein. Der Systemtimer ruft diese
     Function jede Millisekunde auf !!!!

     Der Systemtimer stellt eine Softwareuhr zur Ver-
     fuegung. Die Werte der Uhr sind ueber globale
     Variable verfuegbar:

     int      millisek;
     uint8_t  std,min,sek;
     uint8_t  day,month;
     int      year;


     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz oder Quarz

     18.08.2016  R. Seelig
   ------------------------------------------------------ */

#include "stm8_systimer.h"

volatile int      millisek;
volatile uint8_t  std,min,sek;
volatile uint8_t  day,month;
volatile int      year;


/* --------------------------------------------------
               Timer1 overflow - interrupt

    wird jede Millisekunde aufgerufen (Initialisierung
    in tim1_init).
    Es wird eine Softwareuhr zur Verfuegung gestellt
    deren Inhalte ueber die globalen Variablen:

      uint8_t  std,min,sek;
      uint8_t  day,month;
      int      year;

    auslessbar sind.
    Der Interrupt ruft ausserdem jede Millisekunde
    eine im Gesamtprogramm zu definierende Funktion

            void (systimer_intervall)

    auf. Diese muss zwingend vorhanden sein !
    -------------------------------------------------- */
void tim1_ovf(void) __interrupt(11)
// 11 ist der Interruptvektor fuer Timer1 overflow
{

  millisek++;
  millisek= millisek % 1000;
  systimer_intervall();
  if ( !(millisek) )
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

      16 MHz / 16 = 1 MHz => 1 us
      Autoreloadwert 999 => Wert / 1000

      => 1 us / 1000 = 1 ms !!!!!
   -------------------------------------------------- */
void tim1_init(void)
{

  // Prescaler-Register = 15 entspricht Teilung / 16 .. ( 0..15 = 16 Schritte)
  // Timer wird somit bei F_CPU= 16 MHz mit 1uS getaktet
  #define clockdivisor     ((uint16_t) 15)

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

