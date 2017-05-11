/* -------------------------------------------------------
                         txlcd.h

     Library fuer HD44780 kompatible Displays

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     23.06.2016  R. Seelig
   ------------------------------------------------------ */

/*
      Anschluss am Bsp. Pollin-Display C0802-04

      ---------------------------------------------------
         o +5V
         |                            Display            STM8S103F3P6 Controller
         _                        Funktion   PIN            PIN    Funktion
        | |
        |_| 1,8k                     GND      1 ------------
         |                          +5V       2 ------------
         o----o Kontrast   ---    Kontrast    3 ------------
         |                            RS      4 ------------   12    PB4
         _                           GND      5 ------------
        | |                    (Takt) E       6 ------------   13    PC3
        |_| 150                      D4       7 ------------   14    PC4
         |                           D5       8 ------------   15    PC5
        ---  GND                     D6       9 ------------   16    PC6
                                     D7      10 ------------   11    PB5

      Anschluss am Bsp. Standarddisplay mit 14 Anschluessen (ohne LED)
      --------------------------------------------------------------------------
         o +5V
         |                            Display            STM8S103F3P6 Controller
         _                        Funktion   PIN            PIN    Funktion
        | |
        |_| 1,8k                     GND      1 ------------
         |                          +5V       2 ------------
         o----o Kontrast   ---    Kontrast    3 ------------
         |                            RS      4 ------------   12    PB4
         _                           GND      5 ------------
        | |                    (Takt) E       6 ------------   13    PC3
        |_| 150                      D0       7 ------------   n.c.
         |                           D1       8 ------------   n.c.
        ---  GND                     D2       9 ------------   n.c.
                                     D3      10 ------------   n.c.
                                     D4      11 ------------   14    PC4
                                     D5      12 ------------   15    PC5
                                     D6      13 ------------   16    PC6
                                     D7      14 ------------   11    PB5


         Portpins des Controllers MUESSEN Pop-Up Widerstaende 10 kOhm an
         +5V angeschlossen haben !!!
*/

#ifndef in_txlcd
  #define in_txlcd

  #include "stm8s.h"
  #include "stm8_init.h"
  #include "stm8_gpio.h"

  /* ---------------------------------------
          I/O Macros fuer das Display
     --------------------------------------- */

  #define txlcd_rs_init()   PB4_output_init()
  #define txlcd_e_init()    PC3_output_init()
  #define txlcd_d4_init()   PC4_output_init()
  #define txlcd_d5_init()   PC5_output_init()
  #define txlcd_d6_init()   PC6_output_init()
  #define txlcd_d7_init()   PB5_output_init()

  #define txlcd_rs_set()    PB4_set()
  #define txlcd_e_set()     PC3_set()
  #define txlcd_d4_set()    PC4_set()
  #define txlcd_d5_set()    PC5_set()
  #define txlcd_d6_set()    PC6_set()
  #define txlcd_d7_set()    PB5_set()

  #define txlcd_rs_clr()    PB4_clr()
  #define txlcd_e_clr()     PC3_clr()
  #define txlcd_d4_clr()    PC4_clr()
  #define txlcd_d5_clr()    PC5_clr()
  #define txlcd_d6_clr()    PC6_clr()
  #define txlcd_d7_clr()    PB5_clr()

  #define testbit(reg,pos) ((reg) & (1<<pos))               // testet an der Bitposition pos das Bit auf 1 oder 0


  void nibbleout(unsigned char wert, unsigned char hilo);
  void txlcd_takt(void);
  void txlcd_io(char wert);
  void txlcd_pininit(void);
  void txlcd_init(void);
  void gotoxy(char x, char y);
  void txlcd_setuserchar(char nr, const char *userchar);
  void txlcd_putchar(char ch);

#endif
