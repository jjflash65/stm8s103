/* ------------------------------------------------
                ssd1306_softspi.h

   Softwaremodul fuer ein 0.96" OLED Display mit
   SSD1306 Controller

   Benoetigte Hardware;

            - SSD1306 OLED Display

   MCU   :  STM8S103F3
   Takt  :  externer Takt 16 MHz

   21.12.16 by R. Seelig

  -------------------------------------------------- */

/* ----------------------------------------------------
                         Pinbelegung
    Portpin STM8S                     OLED Display
   ----------------------------------------------------
          |                                  |
         PC6                          // D1 / Mosi
         PD1                          // CS
         PC4                          // RES
         PC3                          // DC (Data or command)
         PC5                          // D0 / SCK


                     G   V           R
                     N   c   D   D   E   D   C
                     D   c   0   1   S   C   s
                 +-------------------------------+
                 |   o   o   o   o   o   o   o   |
                 |                               |
                 |   -------------------------   |
                 |  |                         |  |
                 |  |                         |  |
                 |  |                         |  |
                 |  |                         |  |
                 |  |                         |  |
                 |  |                         |  |
                 |   -----+-------------+-----   |
                 |        |             |        |
                 |        +-------------+        |
                 +-------------------------------+

*/

#ifndef in_ssd1306_softspi
  #define in_ssd1306_softspi

  #include <stdlib.h>                             // fuer abs()
  #include "stm8s.h"
  #include "stm8_init.h"
  #include "stm8_gpio.h"


  #define  fb_enable            1                 //   Framebuffer enable
                                                  //   1 = es wird RAM fuer Framebuffer
                                                  //       reserviert und Grafikfunktionen implementiert
                                                  //   0 = kein Displayram und keine Grafikfunktionen
  #define  fb_size              516

  #define  showimage_enable     0                 //   1 = Bitmap-Anzeige verfuegbar
  #define  fillellipse_enable   0                 //   1 = gefuellte Ellipse und Kreise verfuegbar
  #define  fillrect_enable      0                 //   1 = gefuellte Rechtecke verfuegbar
  #define  circle_enable        1
  #define  rectangle_enable     0
  #define  line_enable          1


#define sw_mosiinit()         PC6_output_init()
#define sw_csinit()           PD1_output_init()
#define sw_resinit()          PC3_output_init()
#define sw_dcinit()           PC4_output_init()
#define sw_sckinit()          PC5_output_init()

#define dc_set()          ( PC4_set() )
#define dc_clr()          ( PC4_clr() )
#define ce_set()          ( PD1_set() )
#define ce_clr()          ( PD1_clr() )
#define rst_set()         ( PC3_set() )
#define rst_clr()         ( PC3_clr() )

#define mosi_set()        ( PC6_set() )
#define mosi_clr()        ( PC6_clr() )
#define sck_set()         ( PC5_set() )
#define sck_clr()         ( PC5_clr() )


#define oled_enable()     ( PD1_clr() )
#define oled_disable()    ( PD1_set() )
#define oled_cmdmode()    ( PC4_clr() )      // SPI-Wert als Kommando
#define oled_datamode()   ( PC4_set() )      // SPI-Wert als Datum


  #if (fb_enable == 1)

    extern uint8_t vram[fb_size];
    typedef enum {PIXEL_OFF=0,PIXEL_ON=1,PIXEL_XOR=2} PixelMode;

  #endif



  extern uint8_t aktxp;
  extern uint8_t aktyp;
  extern uint8_t doublechar;
  extern uint8_t bkcolor;
  extern uint8_t textcolor;


  void spi_out(uint8_t value);
  void oled_init(void);
  void oled_setxybyte(uint8_t x, uint8_t y, uint8_t value);
  void clrscr(void);
  void oled_setpageadr(uint8_t x, uint8_t y);
  void gotoxy(uint8_t x, uint8_t y);
  void oled_putchar(uint8_t ch);
  uint8_t reversebyte(uint8_t value);

  #if (showimage_enable == 1)
    void showimage_d(uint8_t ox, uint8_t oy, const unsigned char* const image, char mode);
  #endif

  #if (fb_enable == 1)

    void fb_putpixel(uint8_t x, uint8_t y, uint8_t f);
    void fb_show(uint8_t x, uint8_t y);
    void line(int x0, int y0, int x1, int y1, PixelMode mode);
    void rectangle(uint8_t x1, uint8_t y1, uint8_t x2, uint8_t y2, PixelMode mode);
    void ellipse(int xm, int ym, int a, int b, PixelMode mode );
    void circle(int x, int y, int r, PixelMode mode );
    void fastxline(uint8_t x1, uint8_t y1, uint8_t x2, PixelMode mode);
    void fillrect(int x1, int y1, int x2, int y2, PixelMode mode);
    void fillellipse(int xm, int ym, int a, int b, PixelMode mode );
    void fillcircle(int x, int y, int r, PixelMode mode );

    void fb_init(uint8_t x, uint8_t y);
    void fb_clear(void);

  #endif                    // fb_enable

#endif

