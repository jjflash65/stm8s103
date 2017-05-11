/* -------------------------------------------------------
                        digit4_demo.c

     Testprogramm fuer 4 stelliges 7-Segmentmodul (China)
     mit 74HC595 Schieberegistern

     Anmerkung: leider muessen die Anzeigesegmente des
                Moduls gemultiplext werden, da nur
                2 Schieberegister enthalten sind.
                SR sind kaskadiert, zuerst ist der
                Datenwert der Ziffer, danach die
                Multiplexstelle hinauszuschieben.

     Hardware : Chinamodul "4-Bit LED Digital Tube Modul"

     MCU      : STM8S103F3
     Takt     : interner Takt 16 MHz

     18.10.2016  R. Seelig
   ------------------------------------------------------ */

/*
   Anschluesse:
 ------------------------------------------------------
   Pinbelegung:

   4 Bit LED Digital Tube Module                 STM8S103F
   -------------------------------------------------------

       (shift-clock)   Sclk   -------------------- PD1
       (strobe-clock)  Rclk   -------------------- PD2
       (ser. data in)  Dio    -------------------- PD3
       (+Ub)           Vcc
                       Gnd


   Anzeigenposition 0 ist das rechte Segment des Moduls

            +-----------------------------+
            |  POS3   POS2   POS1   POS0  |
    Vcc  o--|   --     --     --     --   |
    Sclk o--|  |  |   |  |   |  |   |  |  |
    Rclk o--|  |  |   |  |   |  |   |  |  |
    Dio  o--|   -- o   -- o   -- o   -- o |
    GND  o--|                             |
            |   4-Bit LED Digital Tube    |
            +-----------------------------+

   Segmentbelegung der Anzeige:

       a
      ---
   f | g | b            Segment |  a  |  b  |  c  |  d  |  e  |  f  |  g  | dp |
      ---               ---------------------------------------------------------
   e |   | c            Bit-Nr. |  0  |  1  |  2  |  3  |  4  |  5  |  6  |  7 |
      ---
       d

*/


#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "digit4_595.h"


//  "Onboard-LED"
#define obled_init()        PB5_output_init()
#define obled_set()         PB5_set()
#define obled_clr()         PB5_clr()

/* ---------------------------------------------------------------------------------
                                      M-A-I-N
   ---------------------------------------------------------------------------------*/

int main(void)
{
  uint16_t   oldzsek = 1;
  uint16_t   counter = 0;

  sysclock_init(0);                     // zuerst System fuer internen Takt
//  sysclock_init(1);                     // ... danach evtl. mit ext. Takt

  digit4_init();                        // Modul initialisieren
  tim2_init();                          // Timer2 initialisieren

  digit4_setdp(1);                      // Kommapunkt anzeigen
  digit4_setdez(1111);
  digit4_setdez(0000);

  while(1)
  {
    if (oldzsek != tim2_zsek)
    {
      oldzsek= tim2_zsek;
      counter++;
      counter= counter % 10000;
      digit4_setdez(counter);
    }

  }
}
