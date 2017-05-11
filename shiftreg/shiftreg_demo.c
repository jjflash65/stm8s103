/* -------------------------------------------------------
                        shiftreg_demo.c

     Testprogramm fuer Schieberegister SN74HC595

     Anmerkung: ein HCT - Typ kann hier NICHT verwendet
                werden, da diese eine mindest UB von
                4,5V benoetigt

     Hardware : 74HC595
                8 LEDs, an den Ausgaengen des Schiebe-
                registers gegen +UB geschaltet !!!
                0 = LED leuchtet
                1 = LED aus

     MCU      : STM8S103F3
     Takt     : interner Takt 16 MHz

     01.07.2016  R. Seelig
   ------------------------------------------------------ */

#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "sn74hc595.h"

/*
 Pinbelegung:

 STM8S103F3      74HC595
                Pin  Funktion
 ----------------------------------------------------------
   PD3 -------- (14)   data
   PD2 -------- (12)   STCP ( Strobe, Uebernahme in Ausgangslatch )
   PD1 -------- (11)   SHCP ( Shift-clock, Takt )

                ( 8)   GND
                (10)   /MR  (Master Reset, auf +UB zu legen)
                (13)   /OE  (Output enable, fuer permanente Ausgabe
                             auf GND zu legen)
                (16)   +UB

                (15)   O0   Ausgang Datenbit 0
                ( 1)   O1   Ausgang Datenbit 1
                ( 2)   O2   Ausgang Datenbit 2
                ( 3)   O3   Ausgang Datenbit 3
                ( 4)   O4   Ausgang Datenbit 4
                ( 5)   O5   Ausgang Datenbit 5
                ( 6)   O6   Ausgang Datenbit 6
                ( 7)   O7   Ausgang Datenbit 7

*/

#define laufspeed           50          // Lauflichtgeschwindigkeit

/* ---------------------------------------------------------------------------------
                                      M-A-I-N
   ---------------------------------------------------------------------------------*/

int main(void)
{
  uint8_t laufbyte;
  uint8_t b;

  sysclock_init(0);
  sr595_init();

  sr595_outbyte(0xff);                 // LEDs sind gegen +Ub geschalten, alle aus

  // willkuerlich LEDs einschalten (zur Ueberpruefung der Moeglichkeit, einzelne
  // Bits zu setzen bzw. zu loeschen
  sr595_outbit(7,0);
  sr595_outbit(6,0);
  sr595_outbit(2,0);
  sr595_outbit(0,0);
  delay_ms(1500);
  // und eine LED ausschalten
  sr595_outbit(7,1);
  delay_ms(1500);

  // " Knightrider - Lauflicht "
  while(1)
  {
    laufbyte= 0x01;
    for (b= 0; b< 8; b++)
    {
      sr595_outbyte(~laufbyte);        // invertierte Ausgabe, LEDs sind gegen +Ub geschaltet
      laufbyte= laufbyte << 1;
      delay_ms(laufspeed);
    }
    laufbyte= 0x40;
    for (b= 0; b< 6; b++)
    {
      sr595_outbyte(~laufbyte);                     // invertierte Ausgabe, LEDs sind gegen +Ub geschaltet
      laufbyte= laufbyte >> 1;
      delay_ms(laufspeed);
    }
  }
}
