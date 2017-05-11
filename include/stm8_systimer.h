/* -------------------------------------------------------
                      stm8_systimer.h

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

#ifndef in_systimer
  #define in_systimer

  #include "stm8s.h"
  #include "stm8_init.h"

  extern volatile int      millisek;
  extern volatile uint8_t  std, min, sek;
  extern volatile uint8_t  day,month;
  extern volatile int      year;

  void tim1_ovf(void) __interrupt(11);
  void tim1_init(void);
  void systimer_intervall(void);

#endif
