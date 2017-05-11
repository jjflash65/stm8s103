/* -------------------------------------------------------
                        digit4_595.h

     Header Softwaremodul fuer 4 stelliges 7-Segmentmodul
     (China) mit 74HC595 Schieberegistern

     Anmerkung: leider muessen die Anzeigesegmente des
                Moduls gemultiplext werden, da nur
                2 Schieberegister enthalten sind.
                SR sind kaskadiert, zuerst ist der
                Datenwert der Ziffer, danach die
                Multiplexstelle auszuschieben.

     ==>  verwendet Timer2 zum Multiplexen  <==

     MCU      : STM8S103F3
     Takt     : ---

     18.10.2016  R. Seelig
   ------------------------------------------------------

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

#ifndef in_digit4_595
  #define in_digit4_595

  #include "stm8s.h"
  #include "stm8_init.h"
  #include "stm8_gpio.h"

  /* -----------------------------------------------------
                Anschlusspins des Moduls
     ----------------------------------------------------- */
  #define srdata_init()       PA3_output_init()
  #define srdata_set()        PA3_set()
  #define srdata_clr()        PA3_clr()

  #define srstrobe_init()     PD2_output_init()
  #define srstrobe_set()      PD2_set()
  #define srstrobe_clr()      PD2_clr()

  #define srclock_init()      PD1_output_init()
  #define srclock_set()       PD1_set()
  #define srclock_clr()       PD1_clr()

  /* -----------------------------------------------------
                     globale Variable
     ----------------------------------------------------- */


  // Pufferspeicher der anzuzeigenden Ziffern
  extern uint8_t seg7_4digit[4];

  // Bitmapmuster der Ziffern
  extern uint8_t    led7sbmp[16];

  // Sekundenzaehler Timer2 (Interruptgesteuert)
  extern uint8_t   tim2_sek;
  extern uint8_t   tim2_zsek;

  /* -----------------------------------------------------
                         Prototypen

       Beschreibung der Funktionen in digit4_595.c
     ----------------------------------------------------- */

  // Timer2 Funktionen
  void tim2_init(void);
  void tim2_ovf(void) __interrupt(13);

  // Steuerfunktionen
  void digit4_delay(void);
  void digit4_ckpuls(void);
  void digit4_stpuls(void);
  void digit4_outbyte(uint8_t value);

  // Userfunktionen
  void digit4_setdez(int value);
  void digit4_sethex(uint16_t value);
  void digit4_setdp(char pos);
  void digit4_clrdp(char pos);
  void digit4_init(void);

#endif
