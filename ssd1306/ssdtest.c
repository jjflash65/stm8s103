/* ------------------------------------------------
                 ssd1306_demo.c

   Benoetigte Hardware;

            - SSD1306 OLED Display

   MCU   :  STM8S103F3
   Takt  :  externer Takt 16 MHz

   21.12.16 by R. Seelig

  -------------------------------------------------- */

#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "../include/my_printf.h"

#include "nemo.h"

#define printf   my_printf

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

*/

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


const uint8_t font8x8h[][8] = {
  {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00},       // Ascii 32 = ' '
  {0x00,0x00,0x00,0xfa,0xfa,0x00,0x00,0x00},       // Ascii 33 = ' '
  {0x00,0xe0,0xe0,0x00,0xe0,0xe0,0x00,0x00},       // Ascii 34 = ' '
  {0x28,0xfe,0xfe,0x28,0xfe,0xfe,0x28,0x00},       // Ascii 35 = ' '
  {0x00,0x24,0x54,0xfe,0xfe,0x54,0x48,0x00},       // Ascii 36 = ' '
  {0x00,0x62,0x66,0x0c,0x18,0x30,0x66,0x46},       // Ascii 37 = ' '
  {0x00,0x0c,0x5e,0xf2,0xba,0xec,0x5e,0x12},       // Ascii 38 = ' '
  {0x00,0x00,0x20,0xe0,0xc0,0x00,0x00,0x00},       // Ascii 39 = ' '
  {0x00,0x00,0x38,0x7c,0xc6,0x82,0x00,0x00},       // Ascii 40 = ' '
  {0x00,0x00,0x82,0xc6,0x7c,0x38,0x00,0x00},       // Ascii 41 = ' '
  {0x10,0x54,0x7c,0x38,0x38,0x7c,0x54,0x10},       // Ascii 42 = ' '
  {0x00,0x10,0x10,0x7c,0x7c,0x10,0x10,0x00},       // Ascii 43 = ' '
  {0x00,0x00,0x00,0x06,0x06,0x00,0x00,0x00},       // Ascii 44 = ' '
  {0x00,0x10,0x10,0x10,0x10,0x10,0x10,0x00},       // Ascii 45 = ' '
  {0x00,0x00,0x00,0x06,0x06,0x00,0x00,0x00},       // Ascii 46 = ' '
  {0x06,0x0c,0x18,0x30,0x60,0xc0,0x80,0x00},       // Ascii 47 = ' '
  {0x7c,0xfe,0x8a,0x92,0xa2,0xfe,0x7c,0x00},       // Ascii 48 = ' '
  {0x00,0x00,0x40,0xfe,0xfe,0x00,0x00,0x00},       // Ascii 49 = ' '
  {0x00,0x42,0xc6,0x8e,0x9a,0xf2,0x62,0x00},       // Ascii 50 = ' '
  {0x00,0x44,0xc6,0x92,0x92,0xfe,0x6c,0x00},       // Ascii 51 = ' '
  {0x18,0x38,0x68,0xc8,0xfe,0xfe,0x08,0x00},       // Ascii 52 = ' '
  {0x00,0xe4,0xe6,0xa2,0xa2,0xbe,0x9c,0x00},       // Ascii 53 = ' '
  {0x00,0x7c,0xfe,0x92,0x92,0xde,0x4c,0x00},       // Ascii 54 = ' '
  {0x00,0x80,0x80,0x8e,0x9e,0xf0,0xe0,0x00},       // Ascii 55 = ' '
  {0x00,0x6c,0xfe,0x92,0x92,0xfe,0x6c,0x00},       // Ascii 56 = ' '
  {0x00,0x60,0xf2,0x96,0x9c,0xf8,0x70,0x00},       // Ascii 57 = ' '
  {0x00,0x00,0x00,0x36,0x36,0x00,0x00,0x00},       // Ascii 58 = ' '
  {0x00,0x00,0x80,0xb6,0x36,0x00,0x00,0x00},       // Ascii 59 = ' '
  {0x00,0x10,0x38,0x6c,0xc6,0x82,0x00,0x00},       // Ascii 60 = ' '
  {0x00,0x24,0x24,0x24,0x24,0x24,0x24,0x00},       // Ascii 61 = ' '
  {0x00,0x82,0xc6,0x6c,0x38,0x10,0x00,0x00},       // Ascii 62 = ' '
  {0x00,0x40,0xc0,0x8a,0x9a,0xf0,0x60,0x00},       // Ascii 63 = ' '
  {0x7c,0xfe,0x82,0xba,0xba,0xfa,0x78,0x00},       // Ascii 64 = ' '
  {0x3e,0x7e,0xc8,0x88,0xc8,0x7e,0x3e,0x00},       // Ascii 65 = ' '
  {0xfe,0xfe,0x92,0x92,0x92,0xfe,0x6c,0x00},       // Ascii 66 = ' '
  {0x38,0x7c,0xc6,0x82,0x82,0xc6,0x44,0x00},       // Ascii 67 = ' '
  {0xfe,0xfe,0x82,0x82,0xc6,0x7c,0x38,0x00},       // Ascii 68 = ' '
  {0xfe,0xfe,0x92,0x92,0x92,0x82,0x82,0x00},       // Ascii 69 = ' '
  {0xfe,0xfe,0x90,0x90,0x90,0x80,0x80,0x00},       // Ascii 70 = ' '
  {0x38,0x7c,0xc6,0x82,0x8a,0xce,0x4e,0x00},       // Ascii 71 = ' '
  {0xfe,0xfe,0x10,0x10,0x10,0xfe,0xfe,0x00},       // Ascii 72 = ' '
  {0x00,0x82,0xfe,0xfe,0x82,0x00,0x00,0x00},       // Ascii 73 = ' '
  {0x0c,0x0e,0x02,0x02,0x02,0xfe,0xfc,0x00},       // Ascii 74 = ' '
  {0xfe,0xfe,0x90,0xb8,0x6c,0xc6,0x82,0x00},       // Ascii 75 = ' '
  {0xfe,0xfe,0x02,0x02,0x02,0x02,0x02,0x00},       // Ascii 76 = ' '
  {0xfe,0xfe,0x60,0x30,0x60,0xfe,0xfe,0x00},       // Ascii 77 = ' '
  {0xfe,0xfe,0x60,0x30,0x18,0xfe,0xfe,0x00},       // Ascii 78 = ' '
  {0x38,0x7c,0xc6,0x82,0xc6,0x7c,0x38,0x00},       // Ascii 79 = ' '
  {0xfe,0xfe,0x90,0x90,0x90,0xf0,0x60,0x00},       // Ascii 80 = ' '
  {0x38,0x7c,0xc6,0x8a,0xcc,0x76,0x3a,0x00},       // Ascii 81 = ' '
  {0xfe,0xfe,0x90,0x90,0x98,0xfe,0x66,0x00},       // Ascii 82 = ' '
  {0x64,0xf6,0x92,0x92,0x92,0xde,0x4c,0x00},       // Ascii 83 = ' '
  {0x80,0x80,0xfe,0xfe,0x80,0x80,0x00,0x00},       // Ascii 84 = ' '
  {0xfc,0xfe,0x02,0x02,0x02,0xfe,0xfc,0x00},       // Ascii 85 = ' '
  {0xf8,0xfc,0x06,0x02,0x06,0xfc,0xf8,0x00},       // Ascii 86 = ' '
  {0xfe,0xfe,0x0c,0x18,0x0c,0xfe,0xfe,0x00},       // Ascii 87 = ' '
  {0xc6,0xee,0x38,0x10,0x38,0xee,0xc6,0x00},       // Ascii 88 = ' '
  {0x00,0xe0,0xf0,0x1e,0x1e,0xf0,0xe0,0x00},       // Ascii 89 = ' '
  {0x82,0x86,0x8e,0x9a,0xb2,0xe2,0xc2,0x00},       // Ascii 90 = ' '
  {0x00,0x00,0xfe,0xfe,0x82,0x82,0x00,0x00},       // Ascii 91 = ' '
  {0x80,0xc0,0x60,0x30,0x18,0x0c,0x06,0x00},       // Ascii 92 = ' '
  {0x00,0x00,0x82,0x82,0xfe,0xfe,0x00,0x00},       // Ascii 93 = ' '
  {0x00,0x10,0x30,0x60,0xc0,0x60,0x30,0x10},       // Ascii 94 = ' '
  {0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01},       // Ascii 95 = ' '
  {0x00,0x00,0x80,0xc0,0x60,0x20,0x00,0x00},       // Ascii 96 = ' '
  {0x04,0x2e,0x2a,0x2a,0x2a,0x3e,0x1e,0x00},       // Ascii 97 = ' '
  {0xfe,0xfe,0x22,0x22,0x22,0x3e,0x1c,0x00},       // Ascii 98 = ' '
  {0x1c,0x3e,0x22,0x22,0x22,0x36,0x14,0x00},       // Ascii 99 = ' '
  {0x1c,0x3e,0x22,0x22,0x22,0xfe,0xfe,0x00},       // Ascii 100 = ' '
  {0x1c,0x3e,0x2a,0x2a,0x2a,0x3a,0x18,0x00},       // Ascii 101 = ' '
  {0x10,0x7e,0xfe,0x90,0x90,0xc0,0x40,0x00},       // Ascii 102 = ' '
  {0x19,0x3d,0x25,0x25,0x25,0x3f,0x3e,0x00},       // Ascii 103 = ' '
  {0xfe,0xfe,0x20,0x20,0x20,0x3e,0x1e,0x00},       // Ascii 104 = ' '
  {0x00,0x00,0x00,0xbe,0xbe,0x00,0x00,0x00},       // Ascii 105 = ' '
  {0x02,0x03,0x01,0x01,0xbf,0xbe,0x00,0x00},       // Ascii 106 = ' '
  {0xfe,0xfe,0x08,0x08,0x1c,0x36,0x22,0x00},       // Ascii 107 = ' '
  {0x00,0x00,0x00,0xfe,0xfe,0x00,0x00,0x00},       // Ascii 108 = ' '
  {0x1e,0x3e,0x30,0x18,0x30,0x3e,0x1e,0x00},       // Ascii 109 = ' '
  {0x3e,0x3e,0x20,0x20,0x20,0x3e,0x1e,0x00},       // Ascii 110 = ' '
  {0x1c,0x3e,0x22,0x22,0x22,0x3e,0x1c,0x00},       // Ascii 111 = ' '
  {0x3f,0x3f,0x24,0x24,0x24,0x3c,0x18,0x00},       // Ascii 112 = ' '
  {0x18,0x3c,0x24,0x24,0x24,0x3f,0x3f,0x00},       // Ascii 113 = ' '
  {0x3e,0x3e,0x20,0x20,0x20,0x30,0x10,0x00},       // Ascii 114 = ' '
  {0x12,0x3a,0x2a,0x2a,0x2a,0x2e,0x04,0x00},       // Ascii 115 = ' '
  {0x20,0xfc,0xfe,0x22,0x22,0x26,0x04,0x00},       // Ascii 116 = ' '
  {0x3c,0x3e,0x02,0x02,0x02,0x3e,0x3e,0x00},       // Ascii 117 = ' '
  {0x38,0x3c,0x06,0x02,0x06,0x3c,0x38,0x00},       // Ascii 118 = ' '
  {0x3c,0x3e,0x06,0x0c,0x06,0x3e,0x3c,0x00},       // Ascii 119 = ' '
  {0x22,0x36,0x1c,0x08,0x1c,0x36,0x22,0x00},       // Ascii 120 = ' '
  {0x39,0x3d,0x05,0x05,0x05,0x3f,0x3e,0x00},       // Ascii 121 = ' '
  {0x00,0x22,0x26,0x2e,0x3a,0x32,0x22,0x00},       // Ascii 122 = ' '
  {0x00,0x10,0x10,0x7c,0xee,0x82,0x82,0x00},       // Ascii 123 = ' '
  {0x00,0x00,0x00,0xee,0xee,0x00,0x00,0x00},       // Ascii 124 = ' '
  {0x00,0x82,0x82,0xee,0x7c,0x10,0x10,0x00},       // Ascii 125 = ' '
  {0x00,0x40,0x80,0x80,0x40,0x40,0x80,0x00},       // Ascii 126 = ' '
  {0x0e,0x1e,0x32,0x62,0x62,0x32,0x1e,0x0e},       // Ascii 127 = ' '

  {0x3c,0x42,0x81,0x81,0x81,0x42,0x3c,0x00},       // Ascii 128 = rundes O
  {0x3c,0x42,0xbd,0xbd,0xbd,0x42,0x3c,0x00}        // Ascii 129 = ausgefuelltes =

};




/*  ---------------------------------------------------------
                       globale Variable
    --------------------------------------------------------- */


uint8_t aktxp= 0;
uint8_t aktyp= 0;
uint8_t doublechar;
uint8_t bkcolor= 0;
uint8_t textcolor= 1;


/* -----------------------------------------------------
                      spi_out
   sendet ein Datum ueber Software-SPI (Bit-Banging)
   ----------------------------------------------------- */
void spi_out(uint8_t value)
{
  char a;

  for (a= 0; a< 8; a++)
  {
    if((value & 0x80)> 0) { mosi_set(); }
                     else { mosi_clr(); }
    // Taktimpuls erzeugen
    sck_set();
    sck_clr();
    value= value << 1;
  }
}

/*  ---------------------------------------------------------
                        oled_init
              initialisiert das OLED-Display
    --------------------------------------------------------- */
void oled_init(void)
{
  sw_mosiinit();
  sw_csinit();
  sw_resinit();
  sw_dcinit();
  sw_sckinit();

  oled_enable();
  delay_ms(10);

  rst_clr();                    // Display-reset
  delay_ms(10);
  rst_set();

  oled_cmdmode();               // nachfolgende Daten als Kommando

  spi_out(0x8d);                // Ladungspumpe an
  spi_out(0x14);

  spi_out(0xaf);                // Display on
  delay_ms(150);

  spi_out(0xa1);                // Segment Map
  spi_out(0xc0);                // Direction Map
  oled_datamode();
}

/*  ---------------------------------------------------------
                       oled_setxybyte

      setzt ein Byte an Koordinate x,y

      Anmerkung:
            da Display monochrom werden (leider) immer
            8 Pixel in Y Richtung geschrieben, daher ist
            Wertebereich fuer y = 0..7 !

            Bsp. Koordinate y== 6 beschreibt tatsaechliche
            y-Koordinaten 48-55 (inclusive)
    --------------------------------------------------------- */
void oled_setxybyte(uint8_t x, uint8_t y, uint8_t value)
{
    oled_cmdmode();
    y= 7-y;

    spi_out(0xb0 | (y & 0x0f));
    spi_out(0x10 | (x >> 4 & 0x0f));
    spi_out(x & 0x0f);

    oled_datamode();
    if ((!textcolor)) value= ~value;
    spi_out(value);
}

/*  ---------------------------------------------------------
                           clrscr

      loescht den Displayinhalt mit der in bkcolor ange-
      gebenen "Farbe" (0 = schwarz, 1 = hell)
    --------------------------------------------------------- */

void clrscr(void)
{
  uint8_t x,y;

  oled_enable();

  rst_clr();                    // Display-reset
  delay_ms(1);
  rst_set();

  oled_cmdmode();               // nachfolgende Daten als Kommando

  spi_out(0x8d);                // Ladungspumpe an
  spi_out(0x14);

  spi_out(0xaf);                // Display on

  spi_out(0xa1);                // Segment Map
  spi_out(0xc0);                // Direction Map
  oled_datamode();


  for (y= 0; y< 8; y++)         // ein Byte in Y-Achse = 8 Pixel...
                                // 8*8Pixel = 64 Y-Reihen
  {
    oled_cmdmode();

    spi_out(0xb0 | y);          // Pageadresse schreiben
    spi_out(0x00);              // MSB X-Adresse
    spi_out(0x00);              // LSB X-Adresse (+Offset)

    oled_datamode();
    for (x= 0; x< 128; x++)
    {
      if (bkcolor) spi_out(0xff); else spi_out(0x00);
    }
  }

}

/*  ---------------------------------------------------------
                     oled_setpageadr

      adressiert den Speicher des Displays (und gibt somit
      die Speicherstelle an, die als naechstes beschrieben
      wird)
    --------------------------------------------------------- */
void oled_setpageadr(uint8_t x, uint8_t y)
{
  oled_cmdmode();
  y= 7-y;

  spi_out(0xb0 | (y & 0x0f));
  spi_out(0x10 | (x >> 4 & 0x0f));
  spi_out(x & 0x0f);

  oled_datamode();
}

/*  ---------------------------------------------------------
                            gotoxy

       legt die naechste Textausgabeposition auf dem
       Display fest. Koordinaten 0,0 bezeichnet linke obere
       Position
    --------------------------------------------------------- */
void gotoxy(uint8_t x, uint8_t y)
{
  aktxp= x;
  aktyp= y;
  x *= 8;
  y= 7-y;
  oled_cmdmode();
  spi_out(0xb0 | (y & 0x0f));
  spi_out(0x10 | (x >> 4 & 0x0f));
  spi_out(x & 0x0f);
  oled_datamode();
}

/*  ---------------------------------------------------------
                         oled_putchar

       gibt ein Zeichen auf dem Display aus. Steuerzeichen
       (fuer bspw. printf) sind implementiert:

               13 = carriage return
               10 = line feed
                8 = delete last char
    --------------------------------------------------------- */
void oled_putchar(uint8_t ch)
{
  uint8_t  i, b;
  uint8_t  z1;
  uint16_t z2[8];
  uint16_t z;

  if (ch== 13)                                          // Fuer <printf> "/r" Implementation
  {
    aktxp= 0;
    gotoxy(aktxp, aktyp);
    return;
  }
  if (ch== 10)                                          // fuer <printf> "/n" Implementation
  {
    aktyp++;
    gotoxy(aktxp, aktyp);
    return;
  }

  if (ch== 8)
  {
    if ((aktxp> 0))
    {

      aktxp--;
      gotoxy(aktxp, aktyp);

      for (i= 0; i< 8; i++)
      {
       if ((!textcolor)) spi_out(0xff); else spi_out(0x00);
      }
      gotoxy(aktxp, aktyp);
    }
    return;

  }

  if (doublechar)
  {
    for (i= 0; i< 8; i++)
    {
      // Zeichen auf ein 16x16 Zeichen vergroessern
      z1= font8x8h[ch-' '][i];
      z2[i]= 0;
      for (b= 0; b< 8; b++)
      {
        if (z1 & (1 << b))
        {
          z2[i] |= (1 << (b*2));
          z2[i] |= (1 << ((b*2)+1));
        }
      }
    }

    for (i= 0; i< 8; i++)
    {
      z= z2[i];
      if ((!textcolor)) z= ~z;
      z= z >> 8;
      spi_out(z);
      spi_out(z);
    }
    gotoxy(aktxp, aktyp+1);
    for (i= 0; i< 8; i++)
    {
      z= z2[i];
      if ((!textcolor)) z= ~z;
      z= z & 0xff;
      spi_out(z);
      spi_out(z);
    }
    aktyp--;
    aktxp +=2;
    if (aktxp> 15)
    {
      aktxp= 0;
      aktyp +=2;
    }
    gotoxy(aktxp,aktyp);
  }
  else
  {
    for (i= 0; i< 8; i++)
    {
      if ((!textcolor)) spi_out(~(font8x8h[ch-' '][i]));
                   else spi_out(font8x8h[ch-' '][i]);
    }
    aktxp++;
    if (aktxp> 15)
    {
      aktxp= 0;
      aktyp++;
    }
    gotoxy(aktxp,aktyp);
  }
}

/*  ---------------------------------------------------------
                         reversebyte

       spiegelt die Bits eines Bytes. D0 tauscht mit D7
       die Position, D1 mit D6 etc.
    --------------------------------------------------------- */
uint8_t reversebyte(uint8_t value)
{
  uint8_t hb, b;

  hb= 0;
  for (b= 0; b< 8; b++)
  {
    if (value & (1 << b)) hb |= (1 << (7-b));
  }
  return hb;
}

/* ---------------------------------------------------------
                         SHOWIMAGE_D

   zeigt ein Bitmap an den Koordinaten x,y an

   Parameter

   mode: Zeichenmodus
            0 = Bitmap wird mit der in bkcolor angegebenen
                Farbe geloescht
            1 = Bitmap wird gezeichnet
            2 = Bitmap wird invertiert gezeichnet

   zeigt ein im ROM abgelegtes Bitmap an. Bitmap hat das-
   selbe Format wie in <showimage>.

   Speicherorganisation des Displays

         X-Koordinate
           0     1     2
         ----------------------------
   Y     Byte0 Byte1 Byte2 ...
   |
   K  0   D0    D0    D0
   o
   o  1   D1    D1    D1
   r
   d  2   D2    D2    D2
   i
   n  3   D3    D3    D3
   a
   t  4   D4    D4    D4
   e      .     .     .
          .     .     .

   Speicherorganisation des Bitmaps:

   Y       X-Koordinate
   |        0  1  2  3  4  5  6  7    8  9 10 11 12 13 14 15
   K               Byte 0                    Byte 1
   o  0     D7 D6 D5 D4 D3 D2 D1 D0   D7 D6 D5 D4 D3 D2 D1 D0
   o
   r         Byte (Y*XBytebreite)     Byte (Y*XBytebreite)+1
   d  1     D7 D6 D5 D4 D3 D2 D1 D0   D7 D6 D5 D4 D3 D2 D1 D0
   i
   n
   a
   t
   e
   --------------------------------------------------------- */
void showimage_d(uint8_t ox, uint8_t oy, const unsigned char* const image, char mode)
{
  uint8_t x,y,xp;
  uint8_t hb,b;
  char i;
  uint8_t resX, resY;


  resX= image[0];
  resY= image[1];

  if ((resX % 8) == 0) { resX= resX / 8; }
                 else  { resX= (resX / 8)+1; }

  for (y=0; y < (resY / 8); y++)
  {
    xp= 0;
    oled_setpageadr(ox, y + (oy / 8));

    for (x= 0; x < (resX * 8); x++)
    {

      if ((mode==1) || (mode==2))
      {

        b= 0xff;
        for (i= 0; i < 8; i++)
        {
          hb = image[(((y*8)+i) * resX) +(x / 8)+2];
          hb &= 1<<(7-xp);
          if (hb != 0)
          {
            b&= ~(1 << i);
          }
        }

        xp++;
        xp = xp % 8;
        b = reversebyte(b);
        if (mode==2) b= ~b;
        spi_out(b);
      }
      else
      {
        if (bkcolor) spi_out(0xff); else  spi_out(0x00);
      }
    }
  }
}

void show_vled(uint8_t value)
{
  char b;

  for (b= 7; b > -1; b--)
  {
    if (value & (1 << b)) oled_putchar(129); else oled_putchar(128);
  }
}

void putchar(char ch)
{
  oled_putchar(ch);
}

/* ------------------------------------------------------------------------
                                    MAIN
   ------------------------------------------------------------------------ */

int main(void)
{
  uint8_t b, i;

  sysclock_init(0);                     // zuerst System fuer internen Takt
  oled_init();

  while(1)
  {
    bkcolor= 0;
    textcolor= 1;
    clrscr();

    gotoxy(0,0);
    printf("STM8S103   16MHz\n\r");
    printf("----------------");

    doublechar= 1;
    gotoxy(3,3);
    printf("STM8S");
    doublechar= 0;
    gotoxy(3,5);
    printf("Hallo Welt");
    gotoxy(0,7);
    for (b= 5; b>0; b--)
    {
      printf("\r   Coundown: %d ",b);
      delay_ms(1000);
    }

    textcolor= 0;
    bkcolor= 0;
    clrscr();
    showimage_d(20,0,&bmppic[0],1);
    gotoxy(0,7);
    for (b= 5; b>0; b--)
    {
      delay_ms(1000);
    }

    textcolor= 1;
    bkcolor= 0;
    clrscr();

    gotoxy(0,0);
    printf("Virtuelle LED's\n\r");
    printf("----------------");

    doublechar= 1;

    for (i= 0; i< 2; i++)
    {
      b= 0x80;
      while(b> 0)
      {
        gotoxy(0,4);
        show_vled(b);
        delay_ms(100);
        b= b>> 1;
      }

      b= 0x02;
      while(b< 80)
      {
        gotoxy(0,4);
        show_vled(b);
        delay_ms(100);
        b= b<< 1;
      }
    }
    gotoxy(0,4);
    show_vled(b);
    delay_ms(300);

    doublechar= 0;
    gotoxy(2,2); printf("%d = 0x%x =", 0x4e, 0x4e);
    gotoxy(0,4);
    doublechar= 1;
    show_vled(0x4e);
    doublechar= 0;

    delay_ms(3000);
  }
}
