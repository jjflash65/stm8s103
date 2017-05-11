/* -------------------------------------------------------
                         ili9163_demo.c

     Demoprogramm fuer erstes Lebenszeichen des Displays

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     19.05.2016  R. Seelig
   ------------------------------------------------------ */
/* -----------------------------------------------------------------------------------
      Displays aus China werden haeufig mit unterschiedlichen
      Bezeichnungen der Pins ausgeliefert. Moegliche
      Pinzuordnungen sind (wobei PC5 und PC6 festgelegt sind, Deklaration
      fuer A0 / DC und Reset in  tftdisplay.h):

      Controller STM32F030          Display
      --------------------------------------------------------------------------
         SPI-SCK  / PC5    ----    SCK / CLK    (clock)
         SPI-MOSI / PC6    ----    SDA / DIN    (data in display)
                                   CS  / CE     (chip select display) (auf Masse zu legen)
                    PC4    ----    A0  / D/C    (selector data or command write)
                    PC3    ----    Reset / RST  (reset)

   ------------------------------------------------------------------------------------ */

#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "spi.h"
#include "tftdisplay.h"

#include "hase.h"


/* ------------------------------------------------------------
                            PUTINT
     gibt einen Integer dezimal aus. Ist Uebergabe
     "komma" != 0 wird ein "Kommapunkt" mit ausgegeben.

     Bsp.: 12345 wird als 123.45 ausgegeben.
     (ermoeglicht Pseudofloatausgaben im Bereich)
   ------------------------------------------------------------ */
void putint(int i, char komma)
{
  typedef enum boolean { FALSE, TRUE }bool_t;

  static int zz[]      = { 10000, 1000, 100, 10 };
  bool_t     not_first = FALSE;

  uint8_t       zi;
  int        z, b;

  komma= 5-komma;

  if (!i)
  {
    lcd_putchar('0');
  }
  else
  {
    if(i < 0)
    {
      lcd_putchar('-');
      i = -i;
    }
    for(zi = 0; zi < 4; zi++)
    {
      z = 0;
      b = 0;

      if  ((zi==komma) && komma)
      {
        if (!not_first) lcd_putchar('0');
        lcd_putchar('.');
        not_first= TRUE;
      }

      while(z + zz[zi] <= i)
      {
        b++;
        z += zz[zi];
      }
      if(b || not_first)
      {
        lcd_putchar('0' + b);
        not_first = TRUE;
      }
      i -= z;
    }
    if (komma== 4) lcd_putchar('.');
    lcd_putchar('0' + i);
  }
}


void prints(unsigned char *p)
{
  do
  {
    lcd_putchar( *p );
    p++;
  } while( *p);}


int main(void)
{
  char  b;
  int   x;

  sysclock_init(0);
//  sysclock_init(1);

  lcd_init();

  outmode= 3;

  while(1)
  {
  bkcolor= rgbfromega(15);
  clrscr();
//  fillrect(0,0,127,119,rgbfromvalue(0x60,0xff,0x60));
  fillrect(0,0,127,119,rgbfromega(14));
  showimage(5,0,&bmppic[0],rgbfromega(0));
  textcolor= rgbfromega(blue);
  for (b= 3; b > -1; b--)
  {
    gotoxy(1,15);
    prints(" Countdown: ");
    putint(b,0);
    delay_ms(1000);
  }
  showimage(5,0,&bmppic[0],rgbfromega(14));
  delay_ms(1000);

  textcolor= rgbfromega(14);
  bkcolor= rgbfromvalue(0x00,0x00,0x66);
  clrscr();
  bkcolor= rgbfromvalue(0x20,0x20,0xff);
  fillrect(6,6,122,122,rgbfromvalue(0x20,0x20,0xff));

  gotoxy(2,1); prints("STM8S103F3P6");
  gotoxy(2,2); prints("    16MHz");
  gotoxy(2,3); prints("------------");
  gotoxy(2,4); prints("by R.Seelig");

  fillcircle(64,85,25, rgbfromvalue(0x66,0x00,0x00));
  for (x= 51; x< 121; x++)
  {
    putpixel(x,x,rgbfromvalue(0x00,0x80,0x00));
  }
  line(30,51,97,121,rgbfromega(yellow));

  delay_ms(2500);
  }
}
