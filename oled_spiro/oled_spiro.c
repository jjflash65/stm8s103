/* ------------------------------------------------
                   oled_spiro.c


   Benoetigte Hardware;

            - SSD1306 OLED Display

   MCU   :  STM8S103F3
   Takt  :  externer Takt 16 MHz

   21.12.16 by R. Seelig

  -------------------------------------------------- */

#include <stdint.h>
#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"

#include "./ssd1306_softspi.h"

int t_lastx, t_lasty;


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


void turtle_moveto(int x, int y)
{
 t_lastx= x; t_lasty= y;
}

void turtle_lineto(int x, int y, uint8_t col)
{
  line(x,y, t_lastx, t_lasty, col);
  turtle_moveto(x,y);
}



void spiro_generate(int inner, int outer, int evol, int resol, uint16_t col)
{
  const int c_width  = 64;
  const int c_height = 64;
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
//    fb_show(32,0);
  }
}

void oled_putstring(char *p)
{
  do
  {
    if (*p)
    {
      oled_putchar( *p );
    }
  } while( *p++);
}

/* ------------------------------------------------------------------------------------------------------------------
                                                    M-A-I-N
   ------------------------------------------------------------------------------------------------------------------ */
int main(void)
{
  uint8_t cnt;

  sysclock_init(0);                     // zuerst System fuer internen Takt

  oled_init();
  clrscr();
  fb_init(65,8);
  fb_clear();
  gotoxy(0,0);
  oled_putstring("Grafik erzeugen");
  spiro_generate(8, 16, 60, 100, 1);
/*
  clrscr();

  fb_show(58,0);
  gotoxy(0,0);
  oled_putstring("Spiro-");
  gotoxy(0,1);
  oled_putstring("graph");
*/
  cnt= 1;
  while(1)
  {
    fb_show(cnt, 0);
    delay_ms(1000);
    clrscr();
    cnt++;
  }
}
