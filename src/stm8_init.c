/* -------------------------------------------------------
                      stm8_init.c

     Initialisierung des STM8S103, interner Takt 16 MHz,
     alle Clocks fuer Peripherieeinheiten eingeschaltet

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz oder Quarz

     Hinweis: Delay-Funktionen sind auf Verwendung mit
     16 MHz abgestimmt

     18.05.2016  R. Seelig
   ------------------------------------------------------ */

#include "stm8_init.h"

/* ------------------------------------------------------
                     sysclock_init
      stellt den Taktgeber fuer den Controller ein.
      Bei Verwendung des internen Oszillators werden
      16MHz eingestellt

      (Xtal enable) xtalen = 1  => externer Quarz
                           = 0  => interner RC-Oszillator

      Anmerkung:
         soll der MCU mit externem Quarz laufen, ist
         zuerst ein Aufruf

            sysclock_init(0);

         gefolgt von einem Aufruf

            sysclock_init(1);

         zu erfolgen !
   ------------------------------------------------------ */
void sysclock_init(char xtalen)
{
  if (xtalen)
  {
    CLK_ICKR = 0;                                  //  Reset Register interner clock
    CLK_ECKR = HSEEN;

    while ((CLK_ECKR & HSERDY) == 0);              //  warten bis Quarz eingeschwungen ist;

    CLK_SWR = 0xb4;                                //  int. Generator als Taktquelle
//    while ((CLK_SWCR &  SWIF) != 0);               //  warten bis Takt stabil
    CLK_SWCR = SWEN;                               //  Enable switching.

    CLK_CKDIVR = 0;                                //  Taktteiler auf volle Geschwindigkeit
    CLK_PCKENR1 = 0xff;                            //  alle Peripherietakte an
    CLK_PCKENR2 = 0xff;                            //  dto.
  }
  else
  {
    CLK_ICKR = 0;                                  //  Reset Register interner clock
    CLK_ECKR = 0;                                  //  Reset Register externer clock (ext. clock disable)

    CLK_ICKR =  HSIEN;                             //  Interner clock enable
    while ((CLK_ICKR & (HSIRDY)) == 0);            //  warten bis int. Takt eingeschwungen ist


    CLK_CKDIVR = 0;                                //  Taktteiler auf volle Geschwindigkeit
    CLK_PCKENR1 = 0xff;                            //  alle Peripherietakte an
    CLK_PCKENR2 = 0xff;                            //  dto.

    CLK_CCOR = 0;                                  //  CCO aus
    CLK_HSITRIMR = 0;                              //  keine Taktjustierung
    CLK_SWIMCCR = 0;                               //  SWIM = clock / 2.
    CLK_SWR = 0xe1;                                //  int. Generator als Taktquelle
    CLK_SWCR = 0;                                  //  Reset clock switch control register.
    CLK_SWCR = SWEN;                               //  Enable switching.
    while ((CLK_SWCR &  SWBSY) != 0);              //  warten bis Peripherietakt stabil
  }
  delay_ms(50);
}

/* ------------------------------------------------------
                        delay_ms
     grobe Zeitverzoegerung in Millisekunden. Der
     Wert 1435 in cnt2 ist "ausgemessen" und stimmt nur
     fuer eine Taktfrequenz von 16Mhz so "halbwegs". Fuer
     eine genauere Zeit ist besser eine Interruptroutine
     mittels Timer zu verwenden.
  ------------------------------------------------------ */
void delay_ms(uint16_t cnt)
{
  volatile uint16_t cnt2;

  while (cnt)
  {
    cnt2= 1435;
    while(cnt2)
    {
      cnt2--;
    }
    cnt--;
  }
}

/* ------------------------------------------------------
                        delay_us
     grobe Zeitverzoegerung in Mikrosekunden. Fuer
     genauere Zeitverzoegerung  ist besser eine Interrupt-
     routine mittels Timer zu verwenden.
  ------------------------------------------------------ */
void delay_us(uint16_t anz)
{
  volatile uint16_t count;

  for (count= 0; count< anz; count++)
  {
    __asm
      nop
      nop
    __endasm;
  }
}

/* ------------------------------------------------------
                     int_enable
      grundsaetzlich Interrupts zulassen

      ( hier definiert, weil man diese Funktion bei
      jedem Programm benoetigt welches mit Interrupts
      arbeitet und somit nicht jedesmal implementiert
      werden muss und zudem nur sehr wenige Bytes Speicher
      benoetigt)
   ------------------------------------------------------ */
void int_enable(void)
{
  __asm;
    rim
  __endasm;
}

/* ------------------------------------------------------
                     int_disable
      grundsaetzlich Interrupts sperren

      ( hier definiert, weil man diese Funktion bei
      jedem Programm benoetigt welches mit Interrupts
      arbeitet und somit nicht jedesmal implementiert
      werden muss und zudem nur sehr wenige Bytes Speicher
      benoetigt)
   ------------------------------------------------------ */
void int_disable(void)
{
  __asm;
    sim
  __endasm;
}
