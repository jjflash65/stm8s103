/* -------------------------------------------------------
                         spiro2.c

     Grafik-Demoprogramm
     Spirograph fuer ili9163 GLCD mit Aufloesung
     128 x 128 Pixel

     MCU   :  STM32F030F4P6
     Takt  :  interner Takt 48 MHz

     16.10.2016  R. Seelig
   ------------------------------------------------------ */

#include <stdint.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>

#include <libopencm3.h>

#include "sysf030_init.h"
#include "ili9163.h"
#include "my_printf.h"

#include "math_fixed.h"


#define printf       my_printf

/* --------------------------------------------------------
   my_putchar

   wird von my-printf / printf aufgerufen und hier muss
   eine Zeichenausgabefunktion angegeben sein, auf das
   printf dann schreibt !
   -------------------------------------------------------- */
void my_putchar(char ch)
{
  lcd_putchar(ch);
}

#define MY_PI     3.14159265359f

int t_lastx, t_lasty;


void turtle_moveto(int x, int y)
{
 t_lastx= x; t_lasty= y;
}

void turtle_lineto(int x, int y, uint16_t col)
{
  line(x,y, t_lastx, t_lasty,col);
  turtle_moveto(x,y);
}

void spiro_generate(int inner, int outer, int evol, int resol, uint16_t col)
{
  const int c_width  = 240;
  const int c_height = 320;
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
    inner_xpos = (c_width / 2.0f) + (inner * fk_sin(j));
    inner_ypos = (c_height / 2.0f) + (inner * fk_cos(j));

    k= j * ((float)evol / 10.0f);

    outer_xpos= inner_xpos + (outer * fk_sin(k));
    outer_ypos= inner_ypos + (outer * fk_cos(k));

    turtle_lineto(outer_xpos, outer_ypos, col);
    delay(15);
  }
}

int main(void)
{
  sys_init();

  lcd_init();
  lcd_enable();

  lcd_init();
  outmode= 0;

  bkcolor= rgbfromega(0);
  textcolor= rgbfromvalue(0xff,0x80,0x00);
  clrscr();

  while(1)
  {
//  spiro_generate(16, 16, 120, 80, rgbfromvalue(0xff,0xff,0xff));
  spiro_generate(31, 31, 80, 220, rgbfromvalue(0x80,0x80,0xff));
  spiro_generate(58, 58, 140,220, rgbfromega(1));
//  spiro_generate(61, 2, 1340, 420, rgbfromega(9));
//  spiro_generate(1, 4, 140,220, rgbfromega(5));
  delay(3000);
  spiro_generate(58, 58, 140,220, rgbfromvalue(0x00,0x20,0x00));;
  spiro_generate(31, 31, 80, 220, rgbfromvalue(0x00,0xcf,0x00));
  delay(3000);
  spiro_generate(58, 58, 140,220, rgbfromvalue(0x30,0x00,0x30));;
  spiro_generate(31, 31, 80, 220, rgbfromvalue(0xff,0x30,0xff));
  delay(3000);
  spiro_generate(58, 58, 140,220, rgbfromega(4));
  spiro_generate(31, 31, 80, 220, rgbfromvalue(0xff,0x80,0x00));
  delay(3000);
  spiro_generate(58, 58, 140,220, rgbfromega(0));
  spiro_generate(31, 31, 80, 220, rgbfromvalue(0x0,0x0,0x0));
//  delay(3000);
  }
  gotoxy(0,0);
  printf("Spirograph");

  while(1);

  spiro_generate(40, 20, 40, 120, rgbfromega(5));
  spiro_generate(140, 55, 360, 1200, rgbfromega(1));
  spiro_generate(170, 170, 500, 1200, rgbfromega(9));
}

