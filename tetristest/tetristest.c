/* -------------------------------------------------------
                         n5510_glcd_demo

     Demoprogramm fuer s/w Nokiadisplay im Grafikmodus

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     19.05.2016  R. Seelig
   ------------------------------------------------------ */

#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "spi.h"
#include "n5510_b.h"
#include <string.h>

#define drofsx  2
#define drofsy  10
#define figanz  7

const uint16_t tfig01 [figanz][4] =
{                                          //   o
   { 0xe400, 0x4c40, 0x4e00, 0x4640 },    //  ooo     Figur 0

                                          //  o
   { 0xe200, 0x44c0, 0x8e00, 0x6440 },    //  ooo     Figur 1

                                          //    o
   { 0xe800, 0xc440, 0x2e00, 0x4460 },    //  ooo     Figur 2

                                          //   oo
   { 0x6c00, 0x8c40, 0x6c00, 0x8c40 },    //  oo      Figur 3

                                          //  oo
   { 0xc600, 0x4c80, 0xc600, 0x4c80 },    //   oo     Figur 4

                                          //  oo
   { 0xcc00, 0xcc00, 0xcc00, 0xcc00 },    //  oo      Figur 5

                                          //
   { 0xf000, 0x4444, 0xf000, 0x4444 }     //  oooo    Figur 6
};

void strrev(unsigned char *str)                             // fehlt leider in SDCC
// aus einem "Ralph" wird ein "hplaR"
{
  int     i,j;
  uint8_t a;
  uint8_t len;

  len = strlen((const char *)str);
  for (i = 0, j = len - 1; i < j; i++, j--)
  {
    a = str[i];
    str[i] = str[j];
    str[j] = a;
  }
}

int utoa(uint16_t num, unsigned char* str, int base)   // fehlt leider auch in SDCC
{
  int sum;
  int i = 0;
  int digit;

  sum= num;
  do
  {
    digit = sum % base;
    if (digit < 0xA) { str[i++] = '0' + digit; }
		else { str[i++] = 'A' + digit - 0x0a; }
    sum /= base;
  }while (sum && (i < 6));                        // max. 6 Zeichen
  if (i == 6 && sum) { return -1; }
  str[i] = '\0';
  strrev(str);
  return 0;
}


void putchar(char ch)
//   wird von my_printf benoetigt (aufruf innerhalb der Funktion my_printf) und
//   leitet die Ausgabe von my_printf zum LCD
{
  lcd_putchar(ch);
}

void prints(char *c)
{
  while (*c)
  {
    lcd_putchar(*c++);
  }
}

void drawklotz(uint8_t x, uint8_t y, uint8_t mode)
// ein Klotz ist 4x4 Pixel gross. Da rechts und links je ein Rand
// gezeichnet wird, stehen (hochkant) von 48 Pixel 46 fuer die
// Kloetze zur Verfuegung. somit koennen 11 Kloetze gezeichnet
// werden. In Y-Achse stehen 73 Pixel zur Verfuegung. Somit
// koennen hier 18 Kloetze gezeichnet werden
{
  rectangle(drofsx+(x*4), drofsy+(y*4), drofsx+(x*4)+3, drofsy+(y*4)+3, mode);
}

void drawfig(uint8_t x, uint8_t y, uint8_t mode, uint8_t nr, uint8_t pos)
{
  uint8_t  i, x2, y2;
  uint16_t b;


  b= 0x8000;
  for (i= 0; i< 16; i++)
  {
    if ((tfig01[nr][pos] & b))
    {
      drawklotz(x+(i % 4), y+(i / 4), mode);
    }
    b= b >> 1;
  }
}

void box(uint8_t x1, uint8_t y1, uint8_t x2, uint8_t y2, uint8_t mode)
{
  uint8_t x, y;

  for (y= y1; y<= y2; y++)
  {
    for (x= x1; x<= x2; x++)
    {
      putpixel(x,y, mode);
    }
  }
}

void intro(void)
{
  uint8_t x,y;

  for (y= 0; y < 18; y++)
  {
    for (x= 0; x < 11; x++)
    {
      drawklotz(x,y,1);
      scr_update();
      delay_ms(5);
    }
  }

  box(3,38,44,49, 0);
  gotoxy(1,5); prints("TETRIS");
  scr_update();
  delay_ms(4000);
  scr_update();
  for (y= 10; y < 82; y++)
  {
    for (x= 2; x < 47; x++)
    {
      putpixel(x,y, 0);
    }
    scr_update();
    delay_ms(15);
  }
  delay_ms(1000);
}

int main(void)
{
  uint8_t i;
  uint8_t x,y;
  char    fig;

  int  score;
  char zstring[7];

  sysclock_init(0);

  lcd_init();
  outmode= 1;
  textsize= 0;

  score= 0;
  rectangle(0,8,47,83,1);
  intro();
  gotoxy(0,0); prints("Sc:");

  i= 0; fig= 0;
  while(1)
  {
    utoa(score,zstring,10);
    gotoxy(4,0); prints(zstring);
    drawfig(3+i, 0+i, 1, fig, i);
    scr_update();
    delay_ms(500);
    drawfig(3+i, 0+i, 0, fig, i);
    i++;
    i= i % 4;
    if (!i)
    {
      fig++;
      fig= fig % (figanz);
    }
    score++;
  }

  while(1);

}
