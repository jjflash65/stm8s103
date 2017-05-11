/* -------------------------------------------------------
                         tm1637.h

     Library fuer 4-stellige 7-Segmentanzeigemodul
     mit TM1637 Chip

     MCU   :  STM8S103F3

     23.06.2016  R. Seelig
   ------------------------------------------------------ */

/*

   Anschlussbelegung:
 ------------------------------------------------------

   TM1637 Modul       STM8S103F
       SCL   ---------- PC6
       SDA   ---------- PC5

   Anzeigenposition 0 ist das linke Segment des Moduls

        +---------------------------+
        |  POS0  POS1   POS2  POS3  |
        |  +--+  +--+   +--+  +--+  | --o  GND
        |  |  |  |  | o |  |  |  |  | --o  +5V
        |  |  |  |  | o |  |  |  |  | --o  DIO
        |  +--+  +--+   +--+  +--+  | --o  CLK
        |      4-Digit Display      |
        +---------------------------+

   Segmentbelegung der Anzeige:

       a
      ---
   f | g | b            Segment |  a  |  b  |  c  |  d  |  e  |  f  |  g  | Doppelpunkt (nur fuer POS1) |
      ---               ---------------------------------------------------------------------------------
   e |   | c            Bit-Nr. |  0  |  1  |  2  |  3  |  4  |  5  |  6  |              7              |
      ---
       d


   Bit 7 der 7-Segmentanzeige POS1 ist der Doppelpunkt


   ------------------------------------------------------
     Hinweis:
   ------------------------------------------------------

   Das Protokol des TM1637 Chip ist etwas "wunderlich", es arbeitet
   nach dem I2C Prinzip, jedoch hoert der Chip auf keine I2C-Adresse
   sondern ist grundsaetzlich aktiv. Aus diesem Grund wurde nicht das
   Hardware I2C des STM8S verwendet sondern der TM1637 wird mittels
   Bitbanging angesprochen.

   Ein Nebeneffekt hierbei ist, dass jeder beliebige I/O Pin verwendet
   werden kann.

*/

#ifndef in_tm1637
  #define in_tm1637

  #include "stm8s.h"
  #include "stm8_init.h"
  #include "stm8_gpio.h"

  #define scl_init()      PC6_output_init()
  #define scl_set()       PC6_set()
  #define scl_clr()       PC6_clr()

  #define sda_init()      PC5_output_init()
  #define sda_set()       PC5_set()
  #define sda_clr()       PC5_clr()



  #define puls_len()     delay_us(5)

  /* ----------------------------------------------------------
                        Globale Variable
     ---------------------------------------------------------- */

  extern uint8_t    hellig;                // beinhaltet Wert fuer die Helligkeit (erlaubt: 0x00 .. 0x0f);
  extern uint8_t    tm1637_dp;             // 0 : Doppelpunkt abgeschaltet
                                           // 1 : Doppelpunkt sichtbar
                                           //     tm1637_dp wird beim Setzen der Anzeigeposition 1 verwendet
                                           //     und hat erst mit setzen dieser Anzeige einen Effekt

  extern uint8_t    led7sbmp[16];          // Bitmapmuster fuer Ziffern von 0 .. F


  /* ----------------------------------------------------------
                        TM1637 - Prototypen
     ---------------------------------------------------------- */

  void tm1637_init(void);
  void tm1637_start(void);
  void tm1637_stop(void);
  void tm1637_write (uint8_t value);
  void tm1637_clear(void);
  void tm1637_selectpos(char nr);
  void tm1637_setbright(uint8_t value);
  void tm1637_setbmp(uint8_t pos, uint8_t value);
  void tm1637_setzif(uint8_t pos, uint8_t zif);
  void tm1637_setseg(uint8_t pos, uint8_t seg);
  void tm1637_setdez(int value);
  void tm1637_setdez2(char pos, uint8_t value);
  void tm1637_sethex(uint16_t value);
  void tm1637_sethex2(char pos, uint8_t value);


#endif
