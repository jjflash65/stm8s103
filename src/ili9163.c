/* -------------------------------------------------------
                         ili9163.h

     Header Softwaremodul fuer ili9163 Graphic-LCD

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     25.10.2016  R. Seelig
   ------------------------------------------------------ */
/* -----------------------------------------------------------------------------------
      Displays aus China werden haeufig mit unterschiedlichen
      Bezeichnungen der Pins ausgeliefert. Moegliche
      Pinzuordnungen sind:

      Controller STM32F030          Display
      --------------------------------------------------------------------------
         SPI-SCK  / PC5    ----    SCK / CLK    (clock)
         SPI-MOSI / PC6    ----    SDA / DIN    (data in display)
                                   CS  / CE     (chip select display) (auf Masse zu legen)
                    PC4    ----    A0  / D/C    (selector data or command write)
                    PC3    ----    Reset / RST  (reset)

   ------------------------------------------------------------------------------------ */


   #include "ili9163.h"

  //-------------------------------------------------------------
  //  Initialisierungssequenz
  //-------------------------------------------------------------



int      aktxp;                    // Beinhaltet die aktuelle Position des Textcursors in X-Achse
int      aktyp;                    // dto. fuer die Y-Achse
uint16_t textcolor;                // Beinhaltet die Farbwahl fuer die Vordergrundfarbe
uint16_t bkcolor;                  // dto. fuer die Hintergrundfarbe
uint8_t  outmode;                  // Variable zum "Drehen" der Displayausgabe
uint8_t  textsize  = 0;            // Skalierung der Ausgabeschriftgroesse


const uint16_t egapalette [] =
    { 0x0000, 0x0015, 0x0540, 0x0555,
      0xa800, 0xa815, 0xaaa0, 0xad55,
      0x52aa, 0x52bf, 0x57ea, 0x57ff,
      0xfaaa, 0xfabf, 0xffea, 0xffff };

int abs(int value)
{
  if (value< 0) { return (value * (-1)); } else { return value; }
}
// --------------------------------------------------------------
// SPI - Funktionen
// --------------------------------------------------------------


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
  spi_delay();
  spi_out(cmd);                                      // senden
  spi_delay();
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
   WRDATA16

   sendet ein 16 Bit Integer via SPI an das Display
   ---------------------------------------------------------- */

void wrdata16(int data)
{
  int data1 = data>>8;
  int data2 = data&0xff;

  wrdata(data1);
  wrdata(data2);
}


/* ----------------------------------------------------------
   LCD_INIT

   initialisiert das Display fuer den Betrieb
   ---------------------------------------------------------- */

void lcd_init(void)
{
  volatile uint8_t  cmd_anz;
  volatile uint8_t  arg_anz;
  volatile uint16_t ms;
  uint16_t i;

  const uint8_t *tabseq;

  LCD_DDR |= ((1 << LCD_RST_PIN) | (1 << LCD_DC_PIN));
  LCD_CR1 |= ((1 << LCD_RST_PIN) | (1 << LCD_DC_PIN));
  spi_init(0,0,0);                                       // Taktteiler fuer SPI/2, keine Taktinvertierung, Phase 0

  LCD_PORT &= ~(1 << LCD_RST_PIN);                       // Resets LCD controler
  delay_ms(10);
  LCD_PORT |= (1 << LCD_RST_PIN);                        // Set LCD CE = 1 (Disabled)

  outmode= 0;

  tabseq= &lcdinit_seq[0];

  spi_init(0,0,0);                                       // Taktteiler fuer SPI/2, keine Taktinvertierung, Phase 0

  LCD_DDR |= (1 << LCD_RST_PIN) | (1 << LCD_DC_PIN);     // Set LCD Output pins

  LCD_PORT &= ~(1 << LCD_RST_PIN);                       // Resets LCD controler
  delay_ms(10);
  LCD_PORT |= (1 << LCD_RST_PIN);                        // Set LCD CE = 1 (Disabled)


  // ein einzelnes Kommando besteht aus mehreren Datenbytes. Zuerst wird ein Kommandobyte
  // auf dem SPI geschickt, anschliessend die zu diesem Kommandobytes dazugehoerigen Datenbytes
  // abschliessend wird evtl. ein Timingwait eingefuegt. Dieses wird fuer alle vorhandenen
  // Kommandos durchgefuehrt

  cmd_anz = *tabseq++;               // Anzahl Gesamtkommandos

  while(cmd_anz--)                                 // alle Kommandos auf SPI schicken
  {
    wrcmd(*tabseq++);                              // Kommando lesen
    arg_anz= *tabseq++;                            // Anzahl zugehoeriger Datenbytes lesen
    ms= arg_anz & delay_flag;                      // bei gesetztem Flag folgt ein Timingbyte
    arg_anz &= ~delay_flag;                        // delay_flag aus Anzahl Argumenten loeschen
    while(arg_anz--)                               // jedes Datenbyte des Kommandos
    {
      wrdata(*tabseq++);                           // senden
    }
    if(ms)                                         // wenn eine Timingangabe vorhanden ist
    {
      ms= *tabseq++;                              // Timingzeit lesen
      if(ms == 255) ms = 500;
      for (i= 0; i< ms; i++) delay_ms(1);         // und entsprechend "nichts" tun
    }
  }
}

/* ----------------------------------------------------------
   SET_RAM_ADDRESS

   legt den Zeichenbereich des Displays fest
   ---------------------------------------------------------- */

void set_ram_address (uint16_t x1, uint16_t y1, uint16_t x2, uint16_t y2)
{
  wrcmd(coladdr);
  wrdata(x1 >> 8);
  wrdata(x1);
  wrdata(x2 >> 8);
  wrdata(x2);

  wrcmd(rowaddr);
  #if (_yres == 128)
     wrdata(0x00);
     wrdata(y1+32+_lcyofs);
//     wrdata(0x00);
//     wrdata(y2+32);
     y2 += 32;					// Dummy um Warning85 zu verhindern
  #else
    wrdata(y1 >> 8);
    wrdata(y1);
    wrdata(y2 >> 8);
    wrdata(y2);
  #endif

  wrcmd(writereg);
}

/* ----------------------------------------------------------
   SETCOL
   ---------------------------------------------------------- */

void setcol(int startcol)
{
  wrcmd(coladdr);

  #if (ili9225 == 1)                            // andere Adressierung ILI9225
    wrdata16(_xres - startcol);
  #else
    wrdata16(startcol);
  #endif
}

void setpage(int startpage)
{
  wrcmd(rowaddr);
  wrdata16(startpage);
}

void setxypos(int x, int y)
{
  setcol(x);

  #if ( _yres==128 )
    setpage(y+32+_lcyofs);
  #else
    setpage(y);
  #endif

  wrcmd(writereg);
}

/* ----------------------------------------------------------
   PUTPIXEL

   zeichnet einen einzelnen Punkt auf dem Display an der
   Koordinate x,y mit der Farbe color.

   Putpixel beruecksichtigt die globale Variable "outmode"
   mithilfe derer es moeglich ist, eine Ausgabe auf dem
   Display zu "drehen"
   ---------------------------------------------------------- */

void putpixel(int x, int y,uint16_t color)
{
  switch (outmode)
  {
    case 0  :  setxypos(x,y); break;
    case 1  :  setxypos(y,_yres-1-x); break;
    case 2  :  setxypos(_xres-1-y,x); break;
    case 3  :  setxypos(_xres-1-x, _yres-1-y); break;

    default : break;

  }

  wrdata16(color);
}

/* ----------------------------------------------------------
   CLRSCR

   loescht den Displayinhalt mit der in der Variable
   "bkcolor" angegebenen Farbe
   ---------------------------------------------------------- */

void clrscr()
{
  int      x,y;
  uint8_t  colouthi, coloutlo;

  set_ram_address(0,0,_xres-1,_yres-1);

  colouthi = bkcolor >> 8;
  coloutlo = bkcolor & 0xff;

  LCD_PORT |= (1<<LCD_DC_PIN);

  for (y= 0; y< _yres; y++)
  {
    for (x= 0; x< _xres; x++)
    {
      wrdata(colouthi);
      wrdata(coloutlo);
    }
  }

}

/* ----------------------------------------------------------
   RGBFROMVALUE

     Setzt einen 16-Bitfarbwert aus 3 einzelnen Farbwerten
     fuer (r)ot, (g)ruen und (b)lau zusammen.
   ---------------------------------------------------------- */
uint16_t rgbfromvalue(uint8_t r, uint8_t g, uint8_t b)
{
  uint16_t value;

  r= r >> 3;
  g= g >> 2;
  b= b >> 3;
  value= b;
  value |= (g << 5);
  value |= (r << 11);
  return value;
}

/* ----------------------------------------------------------
   RGBFROMEGA

     liefert den 16-Bit Farbwert, der in der Ega-Farbpalette
     definiert ist.
   ---------------------------------------------------------- */
uint16_t rgbfromega(uint8_t entry)
{
  return egapalette[entry];
}

/* --------------------------------------------------
   GOTOXY
     Setzt den Textcursor (NICHT Pixelkoordinate) an
     die angegebene Textkoordinate.

     Parameter:
        x = X-Koordinate
        y = Y-Koordinate
   -------------------------------------------------- */
void gotoxy(unsigned char x, unsigned char y)
{
  aktxp= x*(fontsizex+(textsize*fontsizex));
  aktyp= y*(fontsizey+(textsize*fontsizey));
}

/* --------------------------------------------------
   LCD_PUTCHAR
     gibt das in ch angegebene Zeichen auf dem
     Display aus
   -------------------------------------------------- */
void lcd_putchar(unsigned char ch)
{
  uint8_t   i,i2;
  uint8_t   b;
  int       oldx,oldy;
  uint16_t  fontint;
  uint16_t  fmask;

  if (ch== 13)                                          // Fuer <printf> "/r" Implementation
  {
    aktxp= 0;
    return;
  }
  if (ch== 10)                                          // fuer <printf> "/n" Implementation
  {
    aktyp= aktyp+fontsizey+(fontsizey*textsize);
    return;
  }

  fmask= 1<<(fontsizex-1);

  oldx= aktxp;
  oldy= aktyp;
  for (i=0; i<fontsizey; i++)
  {
    b= font8x8[(ch-32)][i];
    fontint= b;

    for (i2= 0; i2<fontsizex; i2++)
    {
      if (fmask & fontint)
      {
        putpixel(oldx,oldy,textcolor);
        if ((textsize==1))
        {
          putpixel(oldx+1,oldy,textcolor);
          putpixel(oldx,oldy+1,textcolor);
          putpixel(oldx+1,oldy+1,textcolor);
        }
      }
      else
      {
        putpixel(oldx,oldy,bkcolor);
        if ((textsize==1))
        {
          putpixel(oldx+1,oldy,bkcolor);
          putpixel(oldx,oldy+1,bkcolor);
          putpixel(oldx+1,oldy+1,bkcolor);
        }
      }
      fontint= fontint<<1;
      oldx= oldx+1+textsize;
    }
    oldy++;
    if ((textsize==1)) {oldy++; }
    oldx= aktxp;
  }
  aktxp= aktxp+fontsizex+(fontsizex*textsize);
}

/* ----------------------------------------------------------
   PUTSTRING

   gibt einen Text an der aktuellen Position aus
   ----------------------------------------------------------*/
void putramstring(char *c)                              // Uebergabe eines Zeigers (auf einen String)
{
  while (*c)
  {
    lcd_putchar(*c++);
  }
}

/* ----------------------------------------------------------
   FASTXLINE

     zeichnet eine Linie in X-Achse mit den X Punkten
     x1 und x2 auf der Y-Achse y1
   ---------------------------------------------------------- */

void fastxline(uint8_t x1, uint8_t y1, uint8_t x2, uint16_t color)
{
  uint8_t x;

  if (x2< x1) { x= x1; x1= x2; x= x2= x; }

  for (x= x1; x< (x2+1); x++)
  {
    putpixel(x,y1, color);
  }

}

/* ----------------------------------------------------------
   FILLRECT

     zeichnet ein ausgefuelltes Rechteck mit den
     Koordinatenpaaren x1/y1 (linke obere Ecke) und
     x2/y2 (rechte untere Ecke);
   ---------------------------------------------------------- */

void fillrect(int x1, int y1, int x2, int y2, uint16_t color)
{
  uint8_t  colouthi, coloutlo;
  int x, y;

  #if (fastfillmode == 1)
    set_ram_address(x1, y1, x2, y2);

    colouthi = color >> 8;
    coloutlo = color & 0xff;

    LCD_PORT |= (1<<LCD_DC_PIN);

    for (y= y1; y< y2+1; y++)
    {
      for (x= x1; x< x2+1; x++)
      {
        wrdata(colouthi);
        wrdata(coloutlo);
      }
    }

    set_ram_address(0,0,_xres-1,_yres-1);
  #else
    if (y1> y2)
    {
      y= y1;
      y1= y2;
      y2= y;
    }

    for (y= y1; y< y2+1; y++)
    {
      fastxline(x1,y,x2,color);
    }
  #endif
}

/* ----------------------------------------------------------
   LCD_PUTCHARXY

   gibt ein einzelnes Zeichen an der GrafikKoordinate
   oldx, oldy aus.

   Der Hintergrund auf dem das Zeichen ausgegeben wird,
   wird NICHT ueberschrieben, es wird lediglich das Zeichen
   platziert.
   ---------------------------------------------------------- */

void lcd_putcharxy(int oldx, int oldy, unsigned char ch)
{
  uint8_t   i,i2;
  uint8_t   b;
  uint16_t  fontint;
  uint16_t  fmask;
  int       orgx;

  if (ch== 13)                                          // Fuer <printf> "/r" Implementation
  {
    aktxp= 0;
    return;
  }
  if (ch== 10)                                          // fuer <printf> "/n" Implementation
  {
    aktyp= aktyp+fontsizey+(fontsizey*textsize);
    return;
  }

  fmask= 1<<(fontsizex-1);

  orgx= oldx;
  for (i=0; i<fontsizey; i++)
  {
    b= font8x8[(ch-32)][i];
    fontint= b;

    for (i2= 0; i2<fontsizex; i2++)
    {
      if (fmask & fontint)
      {
        putpixel(oldx,oldy,textcolor);
        if ((textsize==1))
        {
          putpixel(oldx+1,oldy,textcolor);
          putpixel(oldx,oldy+1,textcolor);
          putpixel(oldx+1,oldy+1,textcolor);
        }
      }
      fontint= fontint<<1;
      oldx= oldx+1+textsize;
    }
    oldy++;
    if ((textsize==1)) {oldy++; }
    oldx= orgx;;
  }
}

/* ----------------------------------------------------------
   OUTTEXTXY

   gibt einen String an der Grafikkoordinate x,y aus.
   Verwendung:

        outtextxy(10,40,PSTR("Hallo Welt"));
   ---------------------------------------------------------- */

void outtextxy(int x, int y, const unsigned char *dataPtr)
{
  unsigned char c;

  for (c= *dataPtr; c; ++dataPtr, c= *dataPtr)
  {
    lcd_putcharxy(x,y,c);
    x += fontsizex;
  }
}

/* -------------------------------------------------------------
   LINE

     Zeichnet eine Linie von den Koordinaten x0,y0 zu x1,y1
     mit der angegebenen Farbe

     Parameter:
        x0,y0 = Koordinate linke obere Ecke
        x1,y1 = Koordinate rechte untere Ecke
        color = Zeichenfarbe
     Linienalgorithmus nach Bresenham (www.wikipedia.org)

   ------------------------------------------------------------- */
void line(int x0, int y0, int x1, int y1, uint16_t color)
{

  //    Linienalgorithmus nach Bresenham (www.wikipedia.org)

  int dx =  abs(x1-x0), sx = x0<x1 ? 1 : -1;
  int dy = -abs(y1-y0), sy = y0<y1 ? 1 : -1;
  int err = dx+dy, e2;                                     /* error value e_xy */

  for(;;)
  {

    putpixel(x0,y0,color);
    if (x0==x1 && y0==y1) break;
    e2 = 2*err;
    if (e2 > dy) { err += dy; x0 += sx; }                  /* e_xy+e_x > 0 */
    if (e2 < dx) { err += dx; y0 += sy; }                  /* e_xy+e_y < 0 */
  }
}

/* -------------------------------------------------------------
   RECTANGLE

   Zeichnet ein Rechteck von den Koordinaten x0,y0 zu x1,y1
   mit der angegebenen Farbe

   Parameter:
      x0,y0 = Koordinate linke obere Ecke
      x1,y1 = Koordinate rechte untere Ecke
      color = Zeichenfarbe
   ------------------------------------------------------------- */
void rectangle(int x1, int y1, int x2, int y2, uint16_t color)
{
  line(x1,y1,x2,y1, color);
  line(x2,y1,x2,y2, color);
  line(x1,y2,x2,y2, color);
  line(x1,y1,x1,y2, color);
}

/* -------------------------------------------------------------
   ELLIPSE

   Zeichnet eine Ellipse mit Mittelpunt an der Koordinate
   xm,ym mit den Hoehen- Breitenverhaeltnis a:b
   mit der angegebenen Farbe

   Parameter:
      xm,ym = Koordinate des Mittelpunktes der Ellipse
      a,b   = Hoehen- Breitenverhaeltnis
      color = Zeichenfarbe

   Ellipsenalgorithmus nach Bresenham (www.wikipedia.org)
   ------------------------------------------------------------- */
void ellipse(int xm, int ym, int a, int b, uint16_t color )
{
  // Algorithmus nach Bresenham (www.wikipedia.org)

  int dx = 0, dy = b;                       // im I. Quadranten von links oben nach rechts unten

  long a2 = a*a, b2 = b*b;
  long err = b2-(2*b-1)*a2, e2;             // Fehler im 1. Schritt */

  do
  {
    putpixel(xm+dx, ym+dy,color);            // I.   Quadrant
    putpixel(xm-dx, ym+dy,color);            // II.  Quadrant
    putpixel(xm-dx, ym-dy,color);            // III. Quadrant
    putpixel(xm+dx, ym-dy,color);            // IV.  Quadrant

    e2 = 2*err;
    if (e2 <  (2*dx+1)*b2) { dx++; err += (2*dx+1)*b2; }
    if (e2 > -(2*dy-1)*a2) { dy--; err -= (2*dy-1)*a2; }
  } while (dy >= 0);

  while (dx++ < a)                        // fehlerhafter Abbruch bei flachen Ellipsen (b=1)
  {
    putpixel(xm+dx, ym,color);             // -> Spitze der Ellipse vollenden
    putpixel(xm-dx, ym,color);
  }
}

/* -------------------------------------------------------------
   CIRCLE

   Zeichnet einen Kreis mit Mittelpunt an der Koordinate xm,ym
   und dem Radius r mit der angegebenen Farbe

   Parameter:
      xm,ym = Koordinate des Mittelpunktes der Ellipse
      r     = Radius des Kreises
      color = Zeichenfarbe
   ------------------------------------------------------------- */
void circle(int x, int y, int r, uint16_t color )
{
  ellipse(x,y,r,r,color);
}

/* -------------------------------------------------------------
   FILLELLIPSE

   Zeichnet eine ausgefuellte Ellipse mit Mittelpunt an der
   Koordinate xm,ym mit den Hoehen- Breitenverhaeltnis a:b
   mit der angegebenen Farbe

   Parameter:
      xm,ym = Koordinate des Mittelpunktes der Ellipse
      a,b   = Hoehen- Breitenverhaeltnis
      color = Zeichenfarbe

   Ellipsenalgorithmus nach Bresenham (www.wikipedia.org)
   ------------------------------------------------------------- */
void fillellipse(int xm, int ym, int a, int b, uint16_t color )
{
  // Algorithmus nach Bresenham (www.wikipedia.org)

  int dx = 0, dy = b;                       // im I. Quadranten von links oben nach rechts unten
  long a2 = a*a, b2 = b*b;
  long err = b2-(2*b-1)*a2, e2;             // Fehler im 1. Schritt */

  do
  {
    fastxline(xm+dx, ym+dy,xm-dx, color);            // I. und II.   Quadrant
    fastxline(xm-dx, ym-dy,xm+dx, color);            // III. und IV. Quadrant

    e2 = 2*err;
    if (e2 <  (2*dx+1)*b2) { dx++; err += (2*dx+1)*b2; }
    if (e2 > -(2*dy-1)*a2) { dy--; err -= (2*dy-1)*a2; }
  } while (dy >= 0);

  while (dx++ < a)                        // fehlerhafter Abbruch bei flachen Ellipsen (b=1)
  {
    putpixel(xm+dx, ym,color);             // -> Spitze der Ellipse vollenden
    putpixel(xm-dx, ym,color);
  }
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
   fwert        => Farbwert mit der das Pixel gezeichnet wird

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


   ---------------------------------------------------------- */

void showimage(int ox, int oy, const unsigned char* const image, uint16_t fwert)
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
        if (b& 1<<bp-1) {putpixel(ox+(x*8)+8-bp,oy+y,fwert);}
      }
    }
  }
}


/* -------------------------------------------------------------
   FILLCIRCLE

   Zeichnet einen ausgefuellten Kreis mit Mittelpunt an der
   Koordinate xm,ym und dem Radius r mit der angegebenen Farbe

   Parameter:
      xm,ym = Koordinate des Mittelpunktes der Ellipse
      r     = Radius des Kreises
      color = Zeichenfarbe
   ------------------------------------------------------------- */
void fillcircle(int x, int y, int r, uint16_t color )
{
  fillellipse(x,y,r,r,color);
}

