/* -------------------- stm8_glcd_nokia.c ---------------------

   Anbindung eines Nokia s/w Displays an einen STM8 MCU
   Verwendbare Displays:

      5110
      3310
      3410

   (c) 22.05.2016 R. Seelig
   ------------------------------------------------------------ */

#include <string.h>
#include <stdlib.h>
#include "stm8_glcd_nokia.h"
#include "spi.h"

// LCD Variable

unsigned int Lcd_FrameIdx;
char    directwrite= 0;
char    wherex=0;
char    wherey=0;
char    invchar= 0;               // = 1 fuer inversive Textausgabe  (nur im Directwrite-Modus)
uint8_t outmode= 0;                  // Variable zum "Drehen" der Displayausgabe


unsigned char signal[LCD_VISIBLE_X_RES];
unsigned char LcdFrameBuffer[LCD_FB_SIZE];

void spi_delay(void)
{

  __asm;
    nop
    nop
    nop
    nop
  __endasm;
}


/* -------------------------------------------------------------
   WRCMD

   sendet Kommando via SPI an das LCD
   ------------------------------------------------------------- */
void wrcmd(uint8_t cmd)
{
  LCD_PORT &= ~(1 << LCD_DC_PIN);                    // C/D = 0 Kommandomodus
  spi_out(cmd);                                      // senden
  delay_us(10);
}

/* -------------------------------------------------------------
   WRDATA

   sendet Datum via SPI an das LCD
   ------------------------------------------------------------- */
void wrdata(uint8_t data)
{
  LCD_PORT |= (1 << LCD_DC_PIN);                     // C/D = 1 Kommandomodus
  spi_delay();
  spi_out(data);                                     // senden
  spi_delay();
}



/* ----------------------------------------------------------
   LCD Interface
   ---------------------------------------------------------- */

/* ----------------------------------------------------------
   INIT_LCD

   initialisert LCD
   ---------------------------------------------------------- */

void lcd_init(void)
{
  int n;

  LCD_DDR |= ((1 << LCD_RST_PIN) | (1 << LCD_DC_PIN));
  LCD_CR1 |= ((1 << LCD_RST_PIN) | (1 << LCD_DC_PIN));
  spi_init(1,0,0);                                       // Taktteiler fuer SPI/4, keine Taktinvertierung, Phase 0

  LCD_PORT &= ~(1 << LCD_RST_PIN);                       // Resets LCD controler
  delay_ms(10);
  LCD_PORT |= (1 << LCD_RST_PIN);                        // Set LCD CE = 1 (Disabled)

  // LCD Controller Kommandos  (eigentliches initialisieren)

  // diese Initialisierung funktioniert mit N5510 aelterer Herstellung

/*
  wrcmd(0x21);                            // Erweiterter Kommandomodus
  wrcmd(0x09);                            // Set int. HV Generator (ca. 7V an Pin7)
  wrcmd(0xff);                            // VOP max
  wrcmd(0x16);                            // BIAS = 2
  wrcmd(0x06);                            // Temp. Koeffizient = 2
  wrcmd(0x20);                            // Standart Kommandomodus
  wrcmd(0x0c);                            // normale Ausgabe (normal = 0Ch, invertiert = 0Dh)
*/

  // Initialisierung fuer neuere N5510

  wrcmd(0x21);                            // Erweiterter Kommandomodus
  delay_ms(1);
  wrcmd(0x09);                            // Set int. HV Generator (ca. 7V an Pin7)
  delay_ms(1);
  wrcmd(0xc8);                            // VOP max
  delay_ms(1);
  wrcmd(0x10);                            // BIAS = 2
  delay_ms(1);
  wrcmd(0x04);                            // Temp. Koeffizient = 2
  delay_ms(1);
  wrcmd(0x20);                            // Standart Kommandomodus
  delay_ms(1);
  wrcmd(0x0c);                            // normale Ausgabe (normal = 0Ch, invertiert = 0Dh)



// Alternative fuer "merkwuerdige" Displays
/*
  wrcmd(0x21);                            // Erweiterter Kommandomodus
  wrcmd(0xb1);                            // interne Ladungspumpe (ca. 7V an Pin7)
  wrcmd(0x04);                            // Temp Koefficent
  wrcmd(0x14);                            // BIAS = 0x14
  wrcmd(0x0c);                            // normale Ausgabe
  wrcmd(0x20);                            // Standart Kommandomodus
  wrcmd(0x0c);                            // normale Ausgabe (normal = 0Ch, invertiert = 0Dh)
*/

  memset(LcdFrameBuffer,0x00,LCD_FB_SIZE);              // LCD Cache loeschen

  // LCD loeschen

  wrcmd( 0x80);
  wrcmd( 0x40);
  for(n=0; n<(LCD_REAL_X_RES*LCD_REAL_Y_RES); n++) wrdata(0x00);
}

/* -----------------------------------------------------
   CLRSCR_D

   loescht den Displayinhalt
   ----------------------------------------------------- */
void clrscr_d()
{
  int  i=0;

  wrcmd(0x80);             // Anfangsadresse des Displays
  wrcmd(0x40);
  for(i=1;i<(LCD_REAL_X_RES*LCD_REAL_Y_RES/8);i++) { wrdata(0x00); }
  gotoxy_d(0,0);
}

/* ----------------------------------------------------------
   CLRSCR

   loescht den Screenspeicher
   ---------------------------------------------------------- */

void clrscr(void)
{
  int n;

  if (directwrite==1)
  {
    clrscr_d();
    return;
  }

  memset(LcdFrameBuffer,0x00,LCD_FB_SIZE);              // LCD Cache loeschen
  wrcmd( 0x80);
  wrcmd( 0x40);
  for(n=0; n<(LCD_REAL_X_RES*LCD_REAL_Y_RES); n++) wrdata(0x00);
  gotoxy(0,0);
}

/* --------------------------------------------------------
   GOTOXY_D

   positioniert den Textcursor direkt im Displayspeicher.
   Nachfolgende Textausgaben werden an diese Stelle ge-
   schrieben.

   Position x,y (Textkoordinaten x= 0..15 / y= 0..7 )
   -------------------------------------------------------- */

void gotoxy_d(unsigned char x, unsigned char y)
{
  wrcmd(0x80+(x*6));
  wrcmd(0x40+y);
  wherex= x; wherey= y;
}

/* --------------------------------------------------------
   GOTOXY

   positioniert den Textcursor im Screenspeicher an

   Position x,y (Textkoordinaten x= 0..15 / y= 0..7 )
   -------------------------------------------------------- */

void gotoxy(unsigned char x, unsigned char y)
{

  if (directwrite==1)
  {
    gotoxy_d(x,y);
    return;
  }
  if(x>((LCD_VISIBLE_X_RES/6)-1)) return;               // Funktion verlassen wenn X-Koordinate ausserhalb des Displays
  if(y>((LCD_VISIBLE_Y_RES/8)-1)) return;               // dto. Y Koordinate

  Lcd_FrameIdx = ( x * 6) + ( y * LCD_VISIBLE_X_RES);    // Adresse im LCD-Cache berechnen
  wherex= x;
  wherey= y;
}

/* ----------------------------------------------------------
   LCD_PUTCHAR_D

   setzt ein Zeichen direkt auf das Display und setzt den
   Cursor auf die naechste Position

   (die Steuerkommandos \n , \r  und Backspace fuer <printf>
   sind implementiert)

   ch ==> zu setzenes Zeichen
   ---------------------------------------------------------- */


void lcd_putchar_d(uint8_t ch)
{
  int b,rb;

  if (ch== 13)
  {
    gotoxy_d(0,wherey);
    return;
  }
  if (ch== 10)
  {
    wherey++;
    gotoxy_d(wherex,wherey);
    return;
  }

  if (ch== 8)
  {
    if ((wherex> 0))
    {
      wherex--;
      gotoxy_d(wherex,wherey);
      for (b= 0;b<6;b++)
      {
        if (invchar) {wrdata(0xff);} else {wrdata(0);}
      }
      gotoxy_d(wherex,wherey);
    }
    return;
  }

  if ((ch<0x20)||(ch>lastascii)) ch = 92;               // ASCII Zeichen umrechnen

  // Kopiere Daten eines Zeichens aus dem Zeichenarray in den LCD-Screenspeicher

  for (b= 0;b<5;b++)
  {
    rb= fonttab[ch-32][b];
    if (invchar) {rb= ~rb;}
    wrdata(rb);
  }
  if (invchar) {wrdata(0xff);} else {wrdata(0);}
  wherex++;
  if (wherex> 15)
  {
    wherex= 0;
    wherey++;
  }
  gotoxy_d(wherex,wherey);
}


/* ----------------------------------------------------------
   LCD_PUTCHAR

   setzt ein Zeichen im Screenspeicher und postioniert den
   Cursor auf die naechste Position

   ch ==> zu setzenes Zeichen
   ---------------------------------------------------------- */

void lcd_putchar (uint8_t ch)
{
  unsigned char i;

    if (ch== 13)                                          // Fuer <printf> "/r" Implementation
    {
      gotoxy(0,wherey);
      return;
    }
    if (ch== 10)                                          // fuer <printf> "/n" Implementation
    {
      wherey++;
      gotoxy(wherex,wherey);
      return;
    }
    if ((ch<0x20)||(ch>lastascii)) ch = 92;               // ASCII Zeichen umrechnen

    // Kopiere Daten eines Zeichens aus dem Zeichenarray in den LCD-Cache

    for (i=0; i<5; i++) LcdFrameBuffer[Lcd_FrameIdx++]= fonttab[ch-32][i] << 1;

    LcdFrameBuffer[Lcd_FrameIdx]=0x00;

    if(Lcd_FrameIdx==(LCD_FB_SIZE-1))
    {
      Lcd_FrameIdx = 0;
      wherex= 0;
      wherey++;
    }
    else
    {
      Lcd_FrameIdx++;
      wherex++;
    }

}

/* ---------------------------------------------------
   LCD_PUTSTRING
   gibt einen Text aus dem RAM an der aktuellen Position aus
   ---------------------------------------------------*/
void lcd_putstring(char *c)                              // Uebergabe eines Zeigers (auf einen String)
{
  while (*c)
  {
    if (directwrite) lcd_putchar_d(*c++); else lcd_putchar(*c++);
  }
}


/* ----------------------------------------------------------
   PUTPIXEL

   Setzt Pixel an Position X,Y im Screenspeicher
   PixelMode 0 = loeschen
             1 = setzen
             2 = Pixelpositon im XOR-Modus verknuepfen

   ---------------------------------------------------------- */

void putpixel(unsigned char x, unsigned char y, PixelMode mode )
{
  uint16_t index;
  uint8_t offset;
  uint8_t data;
  uint8_t x2,y2;

    switch (outmode)
    {
      case 0  :  x2= x; y2= y; break;
      case 1  :  x2=y; y2= _yres-1-x; break;
      case 2  :  x2= _xres-1-y; y2= x; break;
      case 3  :  x2= _xres-1-x; y2= _yres-1-y; break;

      default : break;

    }


  index=((y2/8)*LCD_VISIBLE_X_RES)+x2;
  offset=y2-((y2/8)*8);

 // Pixel im entsprechenden PixelMode setzen

  data=LcdFrameBuffer[index];
  if (mode==PIXEL_ON) data |= (0x01<<offset);                          // Pixel setzen
  else if (mode==PIXEL_OFF) data &= (~(0x01<<offset));                 // Pixel loeschen
  else if (mode==PIXEL_XOR) data ^= (0x01<<offset);                    // Pixel im XOR-Mode setzen
  LcdFrameBuffer[index]=data;
}


/* ----------------------------------------------------------
   LINE

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
    putpixel(x0,y0,mode);
    if (x0==x1 && y0==y1) break;
    e2 = 2*err;
    if (e2 > dy) { err += dy; x0 += sx; }
    if (e2 < dx) { err += dx; y0 += sy; }
  }
}

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
    putpixel(xm+dx, ym+dy,mode);            // I.   Quadrant
    putpixel(xm-dx, ym+dy,mode);            // II.  Quadrant
    putpixel(xm-dx, ym-dy,mode);            // III. Quadrant
    putpixel(xm+dx, ym-dy,mode);            // IV.  Quadrant

    e2 = 2*err;
    if (e2 <  (2*dx+1)*b2) { dx++; err += (2*dx+1)*b2; }
    if (e2 > -(2*dy-1)*a2) { dy--; err -= (2*dy-1)*a2; }
  } while (dy >= 0);

  while (dx++ < a)                         // fehlerhafter Abbruch bei flachen Ellipsen (b=1)
  {
    putpixel(xm+dx, ym,mode);              // -> Spitze der Ellipse vollenden
    putpixel(xm-dx, ym,mode);
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



/* ----------------------------------------------------------
   SHOWIMAGE

   Kopiert ein im Flash abgelegtes Bitmap in den Screens-
   peicher. Bitmap muss byteweise in Zeilen gespeichert
   vorliegen Hierbei entspricht 1 Byte 8 Pixel.
   Bsp.: eine Reihe mit 6 Bytes entsprechen 48 Pixel
         in X-Achse

   ox,oy        => linke obere Ecke an der das Bitmap
                   angezeigt wird
   image        => das anzuzeigende Bitmap
   resX         => Anzahl der Bytes in X-Achse
   LcdPixelMode => Ausgabemode
      0 = Bitmappixel loeschen
      1 = Bitmappixel setzen
      2 = Bitmappixel im XOR-Mode mit Hintergrund verknuepfen

   ---------------------------------------------------------- */

void showimage(char ox, char oy, const unsigned char* const image, PixelMode mode)
{

  int x,y;
  uint8_t b,bp;
  uint8_t resX, resY;

  resX= image[0];
  resY= image[1];
  if ((resX % 8) == 0) { resX= resX / 8; }
                 else  { resX= (resX / 8)+1; }

  for (y=0;y< resY;y++)
  {
    for (x= 0;x<resX;x++)
    {
      b= image[y *resX +x+2];
      for (bp=8;bp>0;bp--)
      {
        if (b& 1<<bp-1) {putpixel(ox+(x*8)+8-bp,oy+y,mode);}
      }
    }
  }
}


void yline(char x, char y1, char y2)
{
  unsigned char y,yd1,yd2,i,b,b2,b3;

  if (y2< y1)
  {
     y= y2; y2= y1; y1= y;
  }
  yd1= y1>>3; yd2= y2>>3;
  b= y1 % 8;
  b2= 1<< b;
  for (i=b; i<7; i++)
  {
    b2+= 1<<(i+1);
  }
  wrcmd(0x80+x);
  wrcmd(0x40+yd1);
  wrdata(b2);
  if (yd1 == yd2)
  {
    b= y2%8;
    b3=0;
    for (i=8; i> b+1;i--)
    {
      b3= 0x80+(b3>>1);
    }
    b3=~b3;
    b2 &= b3;
    wrcmd(0x80+x);
    wrcmd(0x40+yd1);
    wrdata(b2);
  }
  else
  {
    for (y= (yd1+1); y< yd2; y++)
    {
      wrcmd(0x80+x);
      wrcmd(0x40+y);
      wrdata(0xff);
    }
    b= y2%8;
    b2=0;
    for (i= 0; i< b+1;i++)
    {
      b2 = b2+(1<<i);
    }
    wrcmd(0x80+x);
    wrcmd(0x40+yd2);
    wrdata(b2);
  }
  wrcmd(0);
}


/* ----------------------------------------------------------
   SCR_UPDATE

   bringt den Screenspeicher (abgelegt im ATmega) zur Anzeige
   auf dem LCD

   ---------------------------------------------------------- */
void scr_update(void)
{

  unsigned int i=0;
  unsigned char row;
  unsigned char col;

  for (row=0; row<(LCD_VISIBLE_Y_RES / 8); row++)
  {
    wrcmd( 0x80);
    wrcmd( 0x40 | row);
    for (col=0; col<LCD_VISIBLE_X_RES; col++) wrdata(LcdFrameBuffer[i++]);
  }

}
