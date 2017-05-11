/* ------------------------------------------------
                ssd1306_softspi.c

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

#include "ssd1306_softspi.h"


/*  ---------------------------------------------------------
                       globale Variable
    --------------------------------------------------------- */

uint8_t aktxp= 0;
uint8_t aktyp= 0;
uint8_t doublechar;
uint8_t bkcolor= 0;
uint8_t textcolor= 1;

#if (fb_enable == 1)
  uint8_t vram[fb_size];
#endif

const uint8_t font8x8h[][8] = {
  {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00},       // Ascii 32 = ' '
  {0x00,0x00,0x00,0xfa,0xfa,0x00,0x00,0x00},       // Ascii 33 = '!'
  {0x00,0xe0,0xe0,0x00,0xe0,0xe0,0x00,0x00},       // Ascii 34 = '"'
  {0x28,0xfe,0xfe,0x28,0xfe,0xfe,0x28,0x00},       // Ascii 35 = '#'
  {0x00,0x24,0x54,0xfe,0xfe,0x54,0x48,0x00},       // Ascii 36 = '$'
  {0x00,0x62,0x66,0x0c,0x18,0x30,0x66,0x46},       // Ascii 37 = '%'
  {0x00,0x0c,0x5e,0xf2,0xba,0xec,0x5e,0x12},       // Ascii 38 = '&'
  {0x00,0x00,0x20,0xe0,0xc0,0x00,0x00,0x00},       // Ascii 39 = '''
  {0x00,0x00,0x38,0x7c,0xc6,0x82,0x00,0x00},       // Ascii 40 = '('
  {0x00,0x00,0x82,0xc6,0x7c,0x38,0x00,0x00},       // Ascii 41 = ')'
  {0x10,0x54,0x7c,0x38,0x38,0x7c,0x54,0x10},       // Ascii 42 = '*'
  {0x00,0x10,0x10,0x7c,0x7c,0x10,0x10,0x00},       // Ascii 43 = '+'
  {0x00,0x00,0x00,0x06,0x06,0x00,0x00,0x00},       // Ascii 44 = ','
  {0x00,0x10,0x10,0x10,0x10,0x10,0x10,0x00},       // Ascii 45 = '-'
  {0x00,0x00,0x00,0x06,0x06,0x00,0x00,0x00},       // Ascii 46 = '.'
  {0x06,0x0c,0x18,0x30,0x60,0xc0,0x80,0x00},       // Ascii 47 = '/'
  {0x7c,0xfe,0x8a,0x92,0xa2,0xfe,0x7c,0x00},       // Ascii 48 = '0'
  {0x00,0x00,0x40,0xfe,0xfe,0x00,0x00,0x00},       // Ascii 49 = '1'
  {0x00,0x42,0xc6,0x8e,0x9a,0xf2,0x62,0x00},       // Ascii 50 = '2'
  {0x00,0x44,0xc6,0x92,0x92,0xfe,0x6c,0x00},       // Ascii 51 = '3'
  {0x18,0x38,0x68,0xc8,0xfe,0xfe,0x08,0x00},       // Ascii 52 = '4'
  {0x00,0xe4,0xe6,0xa2,0xa2,0xbe,0x9c,0x00},       // Ascii 53 = '5'
  {0x00,0x7c,0xfe,0x92,0x92,0xde,0x4c,0x00},       // Ascii 54 = '6'
  {0x00,0x80,0x80,0x8e,0x9e,0xf0,0xe0,0x00},       // Ascii 55 = '7'
  {0x00,0x6c,0xfe,0x92,0x92,0xfe,0x6c,0x00},       // Ascii 56 = '8'
  {0x00,0x60,0xf2,0x96,0x9c,0xf8,0x70,0x00},       // Ascii 57 = '9'
  {0x00,0x00,0x00,0x36,0x36,0x00,0x00,0x00},       // Ascii 58 = ':'
  {0x00,0x00,0x80,0xb6,0x36,0x00,0x00,0x00},       // Ascii 59 = ';'
  {0x00,0x10,0x38,0x6c,0xc6,0x82,0x00,0x00},       // Ascii 60 = '<'
  {0x00,0x24,0x24,0x24,0x24,0x24,0x24,0x00},       // Ascii 61 = '='
  {0x00,0x82,0xc6,0x6c,0x38,0x10,0x00,0x00},       // Ascii 62 = '>'
  {0x00,0x40,0xc0,0x8a,0x9a,0xf0,0x60,0x00},       // Ascii 63 = '?'
  {0x7c,0xfe,0x82,0xba,0xba,0xfa,0x78,0x00},       // Ascii 64 = '@'
  {0x3e,0x7e,0xc8,0x88,0xc8,0x7e,0x3e,0x00},       // Ascii 65 = 'A'
  {0xfe,0xfe,0x92,0x92,0x92,0xfe,0x6c,0x00},       // Ascii 66 = 'B'
  {0x38,0x7c,0xc6,0x82,0x82,0xc6,0x44,0x00},       // Ascii 67 = 'C'
  {0xfe,0xfe,0x82,0x82,0xc6,0x7c,0x38,0x00},       // Ascii 68 = 'D'
  {0xfe,0xfe,0x92,0x92,0x92,0x82,0x82,0x00},       // Ascii 69 = 'E'
  {0xfe,0xfe,0x90,0x90,0x90,0x80,0x80,0x00},       // Ascii 70 = 'F'
  {0x38,0x7c,0xc6,0x82,0x8a,0xce,0x4e,0x00},       // Ascii 71 = 'G'
  {0xfe,0xfe,0x10,0x10,0x10,0xfe,0xfe,0x00},       // Ascii 72 = 'H'
  {0x00,0x82,0xfe,0xfe,0x82,0x00,0x00,0x00},       // Ascii 73 = 'I'
  {0x0c,0x0e,0x02,0x02,0x02,0xfe,0xfc,0x00},       // Ascii 74 = 'J'
  {0xfe,0xfe,0x90,0xb8,0x6c,0xc6,0x82,0x00},       // Ascii 75 = 'K'
  {0xfe,0xfe,0x02,0x02,0x02,0x02,0x02,0x00},       // Ascii 76 = 'L'
  {0xfe,0xfe,0x60,0x30,0x60,0xfe,0xfe,0x00},       // Ascii 77 = 'M'
  {0xfe,0xfe,0x60,0x30,0x18,0xfe,0xfe,0x00},       // Ascii 78 = 'N'
  {0x38,0x7c,0xc6,0x82,0xc6,0x7c,0x38,0x00},       // Ascii 79 = 'O'
  {0xfe,0xfe,0x90,0x90,0x90,0xf0,0x60,0x00},       // Ascii 80 = 'P'
  {0x38,0x7c,0xc6,0x8a,0xcc,0x76,0x3a,0x00},       // Ascii 81 = 'Q'
  {0xfe,0xfe,0x90,0x90,0x98,0xfe,0x66,0x00},       // Ascii 82 = 'R'
  {0x64,0xf6,0x92,0x92,0x92,0xde,0x4c,0x00},       // Ascii 83 = 'S'
  {0x80,0x80,0xfe,0xfe,0x80,0x80,0x00,0x00},       // Ascii 84 = 'T'
  {0xfc,0xfe,0x02,0x02,0x02,0xfe,0xfc,0x00},       // Ascii 85 = 'U'
  {0xf8,0xfc,0x06,0x02,0x06,0xfc,0xf8,0x00},       // Ascii 86 = 'V'
  {0xfe,0xfe,0x0c,0x18,0x0c,0xfe,0xfe,0x00},       // Ascii 87 = 'W'
  {0xc6,0xee,0x38,0x10,0x38,0xee,0xc6,0x00},       // Ascii 88 = 'X'
  {0x00,0xe0,0xf0,0x1e,0x1e,0xf0,0xe0,0x00},       // Ascii 89 = 'Y'
  {0x82,0x86,0x8e,0x9a,0xb2,0xe2,0xc2,0x00},       // Ascii 90 = 'Z'
  {0x00,0x00,0xfe,0xfe,0x82,0x82,0x00,0x00},       // Ascii 91 = '['
  {0x80,0xc0,0x60,0x30,0x18,0x0c,0x06,0x00},       // Ascii 92 = '\'
  {0x00,0x00,0x82,0x82,0xfe,0xfe,0x00,0x00},       // Ascii 93 = ']'
  {0x00,0x10,0x30,0x60,0xc0,0x60,0x30,0x10},       // Ascii 94 = '^'
  {0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01},       // Ascii 95 = '_'
  {0x00,0x00,0x80,0xc0,0x60,0x20,0x00,0x00},       // Ascii 96 = '`'
  {0x04,0x2e,0x2a,0x2a,0x2a,0x3e,0x1e,0x00},       // Ascii 97 = 'a'
  {0xfe,0xfe,0x22,0x22,0x22,0x3e,0x1c,0x00},       // Ascii 98 = 'b'
  {0x1c,0x3e,0x22,0x22,0x22,0x36,0x14,0x00},       // Ascii 99 = 'c'
  {0x1c,0x3e,0x22,0x22,0x22,0xfe,0xfe,0x00},       // Ascii 100 = 'd'
  {0x1c,0x3e,0x2a,0x2a,0x2a,0x3a,0x18,0x00},       // Ascii 101 = 'e'
  {0x10,0x7e,0xfe,0x90,0x90,0xc0,0x40,0x00},       // Ascii 102 = 'f'
  {0x19,0x3d,0x25,0x25,0x25,0x3f,0x3e,0x00},       // Ascii 103 = 'g'
  {0xfe,0xfe,0x20,0x20,0x20,0x3e,0x1e,0x00},       // Ascii 104 = 'h'
  {0x00,0x00,0x00,0xbe,0xbe,0x00,0x00,0x00},       // Ascii 105 = 'i'
  {0x02,0x03,0x01,0x01,0xbf,0xbe,0x00,0x00},       // Ascii 106 = 'j'
  {0xfe,0xfe,0x08,0x08,0x1c,0x36,0x22,0x00},       // Ascii 107 = 'k'
  {0x00,0x00,0x00,0xfe,0xfe,0x00,0x00,0x00},       // Ascii 108 = 'l'
  {0x1e,0x3e,0x30,0x18,0x30,0x3e,0x1e,0x00},       // Ascii 109 = 'm'
  {0x3e,0x3e,0x20,0x20,0x20,0x3e,0x1e,0x00},       // Ascii 110 = 'n'
  {0x1c,0x3e,0x22,0x22,0x22,0x3e,0x1c,0x00},       // Ascii 111 = 'o'
  {0x3f,0x3f,0x24,0x24,0x24,0x3c,0x18,0x00},       // Ascii 112 = 'p'
  {0x18,0x3c,0x24,0x24,0x24,0x3f,0x3f,0x00},       // Ascii 113 = 'q'
  {0x3e,0x3e,0x20,0x20,0x20,0x30,0x10,0x00},       // Ascii 114 = 'r'
  {0x12,0x3a,0x2a,0x2a,0x2a,0x2e,0x04,0x00},       // Ascii 115 = 's'
  {0x20,0xfc,0xfe,0x22,0x22,0x26,0x04,0x00},       // Ascii 116 = 't'
  {0x3c,0x3e,0x02,0x02,0x02,0x3e,0x3e,0x00},       // Ascii 117 = 'u'
  {0x38,0x3c,0x06,0x02,0x06,0x3c,0x38,0x00},       // Ascii 118 = 'v'
  {0x3c,0x3e,0x06,0x0c,0x06,0x3e,0x3c,0x00},       // Ascii 119 = 'w'
  {0x22,0x36,0x1c,0x08,0x1c,0x36,0x22,0x00},       // Ascii 120 = 'x'
  {0x39,0x3d,0x05,0x05,0x05,0x3f,0x3e,0x00},       // Ascii 121 = 'y'
  {0x00,0x22,0x26,0x2e,0x3a,0x32,0x22,0x00},       // Ascii 122 = 'z'
  {0x00,0x10,0x10,0x7c,0xee,0x82,0x82,0x00},       // Ascii 123 = '{'
  {0x00,0x00,0x00,0xee,0xee,0x00,0x00,0x00},       // Ascii 124 = '|'
  {0x00,0x82,0x82,0xee,0x7c,0x10,0x10,0x00},       // Ascii 125 = '}'
  {0x00,0x40,0x80,0x80,0x40,0x40,0x80,0x00},       // Ascii 126 = '~'
  {0x0e,0x1e,0x32,0x62,0x62,0x32,0x1e,0x0e},       // Ascii 127 = ' '

  {0x3c,0x42,0x81,0x81,0x81,0x42,0x3c,0x00},       // Ascii 128 = rundes O
  {0x3c,0x42,0xbd,0xbd,0xbd,0x42,0x3c,0x00},       // Ascii 129 = ausgefuelltes =
  {0x00,0x00,0x70,0x88,0x88,0x88,0x70,0x00}        // Ascii 130 = hochgestelltes o
};


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

#if (showimage_enable == 1)
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
#endif

#if (fb_enable == 1)

  /* ----------------------------------------------------------
     fb_putixel

     setzt einen Pixel im Framebufferspeicher an Position
     x,y.

     PixelMode 0 = loeschen
               1 = setzen
               2 = Pixelpositon im XOR-Modus verknuepfen
     ---------------------------------------------------------- */

  void fb_putpixel(uint8_t x, uint8_t y, uint8_t f)
  {
    uint16_t fbi;
    uint8_t  xr, yr, pixpos;

    xr= vram[0]; yr= vram[1];
    fbi= ((y >> 3) * xr) + 2 + x;
    pixpos= 7- (y & 0x07);

    switch (f)
    {
      case 0  : vram[fbi] &= ~(1 << pixpos); break;
      case 1  : vram[fbi] |= 1 << pixpos; break;
      case 2  : vram[fbi] ^= 1 << pixpos; break;

      default : break;
    }
  }

  /* ----------------------------------------------------------
     fb_show

     zeigt den Framebufferspeicher ab der Koordinate x,y
     (links oben) auf dem Display an
     ---------------------------------------------------------- */

  void fb_show(uint8_t x, uint8_t y)
  {
    uint8_t   xp, yp;
    uint16_t  fb_ind;

    fb_ind= 2;
    for (yp= y; yp< vram[1]+y; yp++)
    {
      for (xp= x; xp< vram[0]+x; xp++)
      {
        oled_setxybyte(xp, yp, vram[fb_ind]);
        fb_ind++;
      }
    }
  }

  #if (line_enable == 1) || (rectangle_enable == 1)

    /* ----------------------------------------------------------
       line

       Zeichnet eine Linie von den Koordinaten x0,y0 zu x1,y1
       im Screenspeicher.

       Linienalgorithmus nach Bresenham (www.wikipedia.org)

       PixelMode 0 = loeschen
                 1 = setzen
                 2 = Pixelpositon im XOR-Modus verknuepfen

       ---------------------------------------------------------- */

    void line(int x0, int y0, int x1, int y1, PixelMode mode)
    {


      //    Linienalgorithmus nach Bresenham (www.wikipedia.org)

      int dx =  abs(x1-x0), sx = x0<x1 ? 1 : -1;
      int dy = -abs(y1-y0), sy = y0<y1 ? 1 : -1;
      int err = dx+dy, e2;

      for(;;)
      {
        fb_putpixel(x0,y0,mode);
        if (x0==x1 && y0==y1) break;
        e2 = 2*err;
        if (e2 > dy) { err += dy; x0 += sx; }
        if (e2 < dx) { err += dx; y0 += sy; }
      }
    }

  #endif

  #if (rectangle_enable == 1)

    /* ----------------------------------------------------------
       RECTANGLE

       Zeichnet ein Rechteck von den Koordinaten x0,y0 zu x1,y1
       im Screenspeicher.

       Linienalgorithmus nach Bresenham (www.wikipedia.org)

       PixelMode 0 = loeschen
                 1 = setzen
                 2 = Pixelpositon im XOR-Modus verknuepfen

       ---------------------------------------------------------- */

    void rectangle(uint8_t x1, uint8_t y1, uint8_t x2, uint8_t y2, PixelMode mode)
    {
      line(x1,y1,x2,y1, mode);
      line(x2,y1,x2,y2, mode);
      line(x1,y2,x2,y2, mode);
      line(x1,y1,x1,y2, mode);
    }

  #endif

  #if (circle_enable == 1)

    /* ----------------------------------------------------------
       ELLIPSE

       Zeichnet eine Ellipse mit Mittelpunt an der Koordinate xm,ym
       mit den Hoehen- Breitenverhaeltnis a:b
       im Screenspeicher.

       Ellipsenalgorithmus nach Bresenham (www.wikipedia.org)

       PixelMode 0 = loeschen
                 1 = setzen
                 2 = Pixelpositon im XOR-Modus verknuepfen

       ---------------------------------------------------------- */

    void ellipse(int xm, int ym, int a, int b, PixelMode mode )
    {
      // Algorithmus nach Bresenham (www.wikipedia.org)

      int dx = 0, dy = b;                       // im I. Quadranten von links oben nach rechts unten
      long a2 = a*a, b2 = b*b;
      long err = b2-(2*b-1)*a2, e2;             // Fehler im 1. Schritt */

      do
      {
        fb_putpixel(xm+dx, ym+dy,mode);            // I.   Quadrant
        fb_putpixel(xm-dx, ym+dy,mode);            // II.  Quadrant
        fb_putpixel(xm-dx, ym-dy,mode);            // III. Quadrant
        fb_putpixel(xm+dx, ym-dy,mode);            // IV.  Quadrant

        e2 = 2*err;
        if (e2 <  (2*dx+1)*b2) { dx++; err += (2*dx+1)*b2; }
        if (e2 > -(2*dy-1)*a2) { dy--; err -= (2*dy-1)*a2; }
      } while (dy >= 0);

      while (dx++ < a)                         // fehlerhafter Abbruch bei flachen Ellipsen (b=1)
      {
        fb_putpixel(xm+dx, ym,mode);              // -> Spitze der Ellipse vollenden
        fb_putpixel(xm-dx, ym,mode);
      }
    }

    /* ----------------------------------------------------------
       CIRCLE

       Zeichnet einen Kreis mit Mittelpunt an der Koordinate xm,ym
       und dem Radius r im Screenspeicher.

       PixelMode 0 = loeschen
                 1 = setzen
                 2 = Pixelpositon im XOR-Modus verknuepfen

       ---------------------------------------------------------- */

    void circle(int x, int y, int r, PixelMode mode )
    {
      ellipse(x,y,r,r,mode);
    }

  #endif

  /* ----------------------------------------------------------
     fastxline

     zeichnet eine Linie in X-Achse mit den X Punkten
     x1 und x2 auf der Y-Achse y1

     PixelMode 0 = loeschen
               1 = setzen
               2 = Pixelpositon im XOR-Modus verknuepfen

     ---------------------------------------------------------- */

  void fastxline(uint8_t x1, uint8_t y1, uint8_t x2, PixelMode mode)
  {
    uint8_t x;

    if (x2< x1) { x= x1; x1= x2; x= x2= x; }

    for (x= x1; x< (x2+1); x++)
    {
      fb_putpixel(x,y1, mode);
    }
  }

  #if (fillrect_enable == 1)
    /* ----------------------------------------------------------
       fillrect

       zeichnet ein ausgefuelltes Rechteck mit den
       Koordinatenpaaren x1/y1 (linke obere Ecke) und
       x2/y2 (rechte untere Ecke);

       PixelMode 0 = loeschen
                 1 = setzen
                 2 = Pixelpositon im XOR-Modus verknuepfen

       ---------------------------------------------------------- */

    void fillrect(int x1, int y1, int x2, int y2, PixelMode mode)
    {
      int y;

      if (y1> y2)
      {
        y= y1;
        y1= y2;
        y2= y;
      }

      for (y= y1; y< y2+1; y++)
      {
        fastxline(x1,y,x2, mode);
      }
    }
  #endif

  #if (fillellipse_enable == 1)
    /* -------------------------------------------------------------
       fillellipse

       Zeichnet eine ausgefuellte Ellipse mit Mittelpunt an der
       Koordinate xm,ym mit den Hoehen- Breitenverhaeltnis a:b
       mit der angegebenen Farbe

       Parameter:
          xm,ym = Koordinate des Mittelpunktes der Ellipse
          a,b   = Hoehen- Breitenverhaeltnis

          PixelMode 0 = loeschen
                    1 = setzen
                    2 = Pixelpositon im XOR-Modus verknuepfen


       Ellipsenalgorithmus nach Bresenham (www.wikipedia.org)
       ------------------------------------------------------------- */
    void fillellipse(int xm, int ym, int a, int b, PixelMode mode )
    {
      // Algorithmus nach Bresenham (www.wikipedia.org)

      int dx = 0, dy = b;                       // im I. Quadranten von links oben nach rechts unten
      long a2 = a*a, b2 = b*b;
      long err = b2-(2*b-1)*a2, e2;             // Fehler im 1. Schritt */

      do
      {
        fastxline(xm+dx, ym+dy,xm-dx, mode);            // I. und II.   Quadrant
        fastxline(xm-dx, ym-dy,xm+dx, mode);            // III. und IV. Quadrant

        e2 = 2*err;
        if (e2 <  (2*dx+1)*b2) { dx++; err += (2*dx+1)*b2; }
        if (e2 > -(2*dy-1)*a2) { dy--; err -= (2*dy-1)*a2; }
      } while (dy >= 0);

      while (dx++ < a)                        // fehlerhafter Abbruch bei flachen Ellipsen (b=1)
      {
        fb_putpixel(xm+dx, ym,mode);             // -> Spitze der Ellipse vollenden
        fb_putpixel(xm-dx, ym,mode);
      }
    }

    /* -------------------------------------------------------------
       fillcircle

       Zeichnet einen ausgefuellten Kreis mit Mittelpunt an der
       Koordinate xm,ym und dem Radius r mit der angegebenen Farbe

       Parameter:
          xm,ym = Koordinate des Mittelpunktes der Ellipse
          r     = Radius des Kreises

          PixelMode 0 = loeschen
                    1 = setzen
                    2 = Pixelpositon im XOR-Modus verknuepfen
       ------------------------------------------------------------- */
    void fillcircle(int x, int y, int r, PixelMode mode )
    {
      fillellipse(x,y,r,r,mode);
    }
  #endif

/* --------------------------------------------------------
   fb_init

   initalisiert einen Framebufferspeicher.

   x = Framebuffergroesse in x Richtung
   y = Framebuffergroesse in y Richtung * 8
   -------------------------------------------------------- */
void fb_init(uint8_t x, uint8_t y)
{
  vram[0]= x;
  vram[1]= y;
}

/* --------------------------------------------------------
   fb_clear

   loescht den Framebufferspeicher
   -------------------------------------------------------- */
void fb_clear(void)
{
  uint16_t i;

  for (i= 2; i< fb_size; i++) vram[i]= 0x0;
}


#endif
