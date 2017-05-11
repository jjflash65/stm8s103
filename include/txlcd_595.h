/* -------------------------------------------------------
                        txlcd_595.h

     Header zur Ansteuerung eines HD44780 kompatibles
     Textdisplay welches ueber ein Schieberegister
     SN74HC595 angesprochen wird.

     Betrieb des Displays im 4-Bit Modus

     Anmerkung: ein HCT - Typ kann hier NICHT verwendet
                werden, da diese eine mindest UB von
                4,5V benoetigt

     Hardware : 74HC595
              : HD44780 komp. Display (hier 0802 Pollin
                Display)

     MCU      : STM8S103F3
     Takt     : interner Takt 16 MHz

     26.10.2016  R. Seelig
   ------------------------------------------------------ */

  /* --------------------------------------------------------

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


   --------------------------------------------------------
     Anschlussbelegung Textdisplay an das Schieberegister


         SN74HC595        Display              SR_GPIO

            O0      ---     D4
            O1      ---     D5
            O2      ---     D6
            O3      ---     D7
            O4      ---     RS
            O5      ---     E    ( Clk )
            06      --------------------------    0
            07      --------------------------    1
*/

#ifndef in_txlcd_595
  #define in_txlcd_595

  #include "stm8s.h"
  #include "stm8_init.h"
  #include "stm8_gpio.h"
  #include "sn74hc595.h"

  #define lcd_clk       5
  #define lcd_rs        4
  #define sr_gpio0      6
  #define sr_gpio1      7

  extern uint8_t sr_value;                // beinhaltet immer das zuletzt ausgegebene
                                          // Byte des Schieberegisters. Dieses Byte
                                          // wird per Bitoperationen manipuliert
                                          // um jeweils ein einzelnes Bit des
                                          // Schieberegisterausgangs setzen / loeschen
                                          // zu koennen !

  extern char wherex, wherey;

  /* -------------------------------------------------------
                        Funktionsmakros
     ------------------------------------------------------- */


  #define clk_set()     { sr_value |= 1 << lcd_clk;          \
                          sr595_outbyte(sr_value); }
  #define clk_clr()     { sr_value &= ~(1 << lcd_clk);       \
                          sr595_outbyte(sr_value); }

  #define rs_set()      { sr_value |= 1 << lcd_rs;           \
                          sr595_outbyte(sr_value); }
  #define rs_clr()      { sr_value &= ~(1 << lcd_rs);        \
                          sr595_outbyte(sr_value); }

  #define GPIO0_set()   { sr_value |= 1 << lcd_GPIO0;        \
                          sr595_outbyte(sr_value); }
  #define GPIO0_clr()     { sr_value &= ~(1 << lcd_GPIO0);   \
                          sr595_outbyte(sr_value); }

  #define GPIO1_set()   { sr_value |= 1 << lcd_GPIO1;        \
                          sr595_outbyte(sr_value); }
  #define GPIO1_clr()   { sr_value &= ~(1 << lcd_GPIO1);     \
                          sr595_outbyte(sr_value); }

  /* -------------------------------------------------------
                        Prototypen
     ------------------------------------------------------- */

  void nibbleout(unsigned char wert, unsigned char hilo);
  void txlcd_takt(void);
  void txlcd_io(char wert);
  void txlcd_init(void);
  void gotoxy(char x, char y);
  void txlcd_setuserchar(char nr, const char *userchar);
  void txlcd_putchar(char ch);

#endif