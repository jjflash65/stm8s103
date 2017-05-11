/* -------------------------------------------------------
                         n5510_mandelmann.c

     Demoprogramm fuer s/w Nokiadisplay im Grafikmodus

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     19.05.2016  R. Seelig
   ------------------------------------------------------ */

#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "my_printf.h"
#include "spi.h"
#include "stm8_glcd_nokia.h"


#define printf       my_printf

#define graphwidth     84
#define graphheight    48


void putchar(char ch)
//   wird von my_printf benoetigt (aufruf innerhalb der Funktion my_printf) und
//   leitet die Ausgabe von my_printf zum LCD
{
  lcd_putchar(ch);
}

void mandelbrot(void)
{
  uint16_t k, kt, x, y;
  float    dx, dy, xmin, xmax, ymin, ymax;
  float    jx, jy, wx, wy, tx, ty, r, m;

  kt= 100; m= 4.0;

  xmin= 1.5; xmax= -1.0; ymin= -1.0; ymax= 1.0;

//  alternative Zahlenwerte

//  xmin= -0.5328; xmax= -0.2078; ymin= 0.3742; ymax= 0.892;

  dx= (float)(xmax-xmin) / graphwidth;
  dy= (float) (ymax-ymin) / graphheight;

  for (x= 0; x< graphwidth; x++)
  {
    jx= xmin + ((float)x*dx);

    for (y= 0; y< graphheight; y++)
    {
      jy= ymin+((float)y*dy);

      k= 0; wx= 0.0; wy= 0.0;
      do
      {
        tx= wx*wx-(wy*wy+jx);
        ty= 2.0*wx*wy+jy;
        wx= tx;
        wy= ty;
        r= wx*wx+wy+wy;

        k++;
      } while ((r < m) && (k < kt) && (k < 91));

      if (k> 90)
      {
        putpixel(x,y, 1);
      }
    }
    scr_update();
  }
}


int main(void)
{

  sysclock_init(0);

  lcd_init();
  directwrite= 0;

  clrscr();
  gotoxy(0,0); printf("Mandelbrot");
  scr_update();
  mandelbrot();

  while(1);

}
