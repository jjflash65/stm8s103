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
#include "my_printf.h"
#include "spi.h"
#include "stm8_glcd_nokia.h"

#define bildshow     1

#include "boeserjoke.h"

#if (bildshow == 1)
  #include "girl84_a.h"
  #include "girl84_b.h"
  #include "girl84_c.h"
  #include "venus.h"
#endif

#define countspeed   350

#define printf       my_printf


#define bled_output_init()   PB5_output_init()
#define bled_set()           PB5_set()
#define bled_clr()           PB5_clr()

#define exled_output_init()  PD4_output_init()
#define exled_set()          PD4_set()
#define exled_clr()          PD4_clr()

#define button_input_init()  PD5_input_init()
#define is_button()          is_PD5()


void putchar(char ch)
//   wird von my_printf benoetigt (aufruf innerhalb der Funktion my_printf) und
//   leitet die Ausgabe von my_printf zum LCD
{
  lcd_putchar(ch);
}

int main(void)
{
  int   cnt;

  sysclock_init(0);

  bled_output_init();
  exled_output_init();
  button_input_init();
  lcd_init();
  directwrite= 0;

  printfkomma= 2;

  while(1)
  {
    bled_set();
    exled_clr();
    clrscr();
    rectangle(0,0,82,47,1);
    rectangle(3,3,79,44,1);
    gotoxy(1,1); lcd_putstring("STM8S103F3");
    gotoxy(1,2); printf("Grafikmode");
    circle(40,34,9,1);
    line(3,24,80,44,1);
    scr_update();
    delay_ms(2000);

    bled_clr();
    exled_set();
    clrscr();
    showimage(0,0,&bmppic[0],1);
    scr_update();
    delay_ms(2000);

  #if (bildshow == 1)

      clrscr();
      showimage(0,0,&girla[0],1);
      scr_update();
      delay_ms(2000);

      clrscr();
      showimage(0,0,&girlb[0],1);
      scr_update();
      delay_ms(2000);

      clrscr();
      showimage(0,0,&girlc[0],1);
      scr_update();
      delay_ms(2000);

      clrscr();
      showimage(0,0,&venus[0],1);
      scr_update();
      delay_ms(2000);

  #endif
  }
}
