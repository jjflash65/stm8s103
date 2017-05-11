/* -------------------------------------------------------
                         spiro.c

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     19.05.2016  R. Seelig
   ------------------------------------------------------ */

#include <stdint.h>
#include <string.h>
#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "my_printf.h"
#include "stm8_nokia.h"

#define countspeed   350

#define printf       my_printf


#define bled_output_init()   PB5_output_init()
#define bled_set()           PB5_set()
#define bled_clr()           PB5_clr()

#define exled_output_init()  PD4_output_init()
#define exled_set()          PD4_set()
#define exled_clr()          PD4_clr()

#define button_input_init()  PD3_input_init()
#define is_button()          is_PD3()

#define LCD_FRAME_SIZE       518
uint8_t  LcdFrame[LCD_FRAME_SIZE];
int t_lastx, t_lasty;


/* --------------------------------------------------------
   putchar

   wird von my-printf / printf aufgerufen und hier muss
   eine Zeichenausgabefunktion angegeben sein, auf das
   printf dann schreibt !
   -------------------------------------------------------- */
void putchar(char ch)
{
  lcd_putchar_d(ch);
}


float abs(float value)
{
  if (value< 0.0f) return (value * -(1.0f));
           else return value;
}

#define MY_PI     3.14159265359f

float tiny_pow(int n, float value)
{
  float tmp;
  int   i;

  tmp= value;
  for (i= 0; i < n-1; i++)
  {
    tmp= tmp*value;
  }
  return tmp;
}

float tiny_sin(float value)
{
  float degree;
  float p3;
  float p5;
  float p7;
  float sinx;

  int   mflag= 0;

  while (value > (2*MY_PI)) value -= (2*MY_PI);
  if (value > MY_PI)
  {
    mflag= - 1;
    value -= MY_PI;
  }

  if (value > (MY_PI /2)) value = MY_PI - value;

  degree= value;

  p3 = tiny_pow(3, degree);
  p5  = tiny_pow(5, degree);
  p7  = tiny_pow(7, degree);

  // Taylor-Reihenentwicklung
  // 6 = fak(3); 120 = fak(5); 5040= fak(7)
  sinx= (degree - (p3/6.0f) + (p5/120.0f) - (p7/5040.0f));

  if (mflag) sinx = sinx * (-1);

  return sinx;
}

float tiny_cos(float value)
{
  return tiny_sin(value - (MY_PI / 2.0f)) * -1.0f;
}

/* ----------------------------------------------------------
   PUTPIXEL

   Setzt Pixel an Position X,Y im Screenspeicher
   PixelMode 0 = loeschen
             1 = setzen
             2 = Pixelpositon im XOR-Modus verknuepfen

   ---------------------------------------------------------- */

void putpixel(unsigned char x, unsigned char y, uint8_t mode )
{
  unsigned int index;
  unsigned char offset;
  unsigned char data;

  index=((y/8)*LCD_VISIBLE_X_RES)+x;
  offset=y-((y/8)*8);

 // Pixel im entsprechenden PixelMode setzen

  data=LcdFrame[index];
  if (mode== 1) data |= (0x01<<offset);                          // Pixel setzen
  else if (mode== 0) data &= (~(0x01<<offset));                 // Pixel loeschen
  else if (mode== 2) data ^= (0x01<<offset);                    // Pixel im XOR-Mode setzen
  LcdFrame[index]=data;
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

void line(int x0, int y0, int x1, int y1, uint8_t mode)
{


  //    Linienalgorithmus nach Bresenham (www.wikipedia.org)

  int dx =  abs(x1-x0), sx = x0<x1 ? 1 : -1;
  int dy = -abs(y1-y0), sy = y0<y1 ? 1 : -1;
  int err = dx+dy, e2;

  for(;;)
  {
    putpixel(x0,y0, mode);
    if (x0==x1 && y0==y1) break;
    e2 = 2*err;
    if (e2 > dy) { err += dy; x0 += sx; }
    if (e2 < dx) { err += dx; y0 += sy; }
  }
}



void turtle_moveto(int x, int y)
{
 t_lastx= x; t_lasty= y;
}

void turtle_lineto(int x, int y, uint8_t col)
{
  line(x,y, t_lastx, t_lasty, col);
  turtle_moveto(x,y);
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
     for (col=0; col<LCD_VISIBLE_X_RES; col++) wrdata(LcdFrame[i++]);
   }
}

/* ----------------------------------------------------------
   CLRSCR_FRAME

   loescht den Screenspeicher
   ---------------------------------------------------------- */

void clrscr_frame(void)
{
  int n;

  memset(LcdFrame,0x00,LCD_FRAME_SIZE);              // LCD FRAME loeschen
}


void spiro_generate(int inner, int outer, int evol, int resol, uint16_t col)
{
  const int c_width  = 84;
  const int c_height = 48;
  float     inner_xpos, inner_ypos;
  float     outer_xpos, outer_ypos;
  float     j, k;
  int       i;

  inner_xpos = (c_width / 2.0f);
  inner_ypos = (c_height / 2.0f) + inner;

  outer_xpos= inner_xpos;
  outer_ypos= inner_ypos + outer;
  turtle_moveto(outer_xpos, outer_ypos);

  for (i= 0; i< resol + 1; i++)
  {
    j= ((float)i / resol) * (2.0f * MY_PI);
    inner_xpos = (c_width / 2.0f) + (inner * tiny_sin(j));
    inner_ypos = (c_height / 2.0f) + (inner * tiny_cos(j));

    k= j * ((float)evol / 10.0f);

    outer_xpos= inner_xpos + (outer * tiny_sin(k));
    outer_ypos= inner_ypos + (outer * tiny_cos(k));

    turtle_lineto(outer_xpos, outer_ypos, col);
    scr_update();
  }
}



int main(void)
{
  int   cnt;
  int   i;
  float r;

  uint32_t z;

  sysclock_init(0);

  bled_output_init();
  exled_output_init();
  button_input_init();

  printfkomma= 2;

  lcd_init();
  clrscr();
  while(1)
  {
    gotoxy(0,2);
    printf("  Spirograph\n\r");
    delay_ms(2000);
    spiro_generate(11, 12, 80, 200, 1);
    scr_update();
    delay_ms(2000);
    spiro_generate(11, 12, 80, 200, 0);
    scr_update();
  }
}
