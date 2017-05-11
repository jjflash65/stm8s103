/* -------------------------------------------------------
                         math2_tiny.c

     Demoprogramm fuer Benutzung der math.h

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     19.05.2016  R. Seelig
   ------------------------------------------------------ */

#include <stdint.h>
#include <math.h>
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

#define DECIMALPLACES        1


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


#define MAX16BIT    0x7FFF

int hollyConstant = MAX16BIT*0.017453292519943295769236907684886; // =Pi/2/90°
//First of all sine and cosine tables

int sinTable[] = {
MAX16BIT*0.0,                                    //sin(0)
MAX16BIT*0.17364817766693034885171662676931 ,    //sin(10)
MAX16BIT*0.34202014332566873304409961468226 ,    //sin(20)
MAX16BIT*0.5 ,                                   //sin(30)
MAX16BIT*0.64278760968653932632264340990726 ,    //sin(40)
MAX16BIT*0.76604444311897803520239265055542 ,    //sin(50)
MAX16BIT*0.86602540378443864676372317075294 ,    //sin(60)
MAX16BIT*0.93969262078590838405410927732473 ,    //sin(70)
MAX16BIT*0.98480775301220805936674302458952 ,    //sin(80)
MAX16BIT*1.0                                     //sin(90)
};

int cosTable[] = {
MAX16BIT*1.0 ,                                   //cos(0)
MAX16BIT*0.99984769515639123915701155881391 ,    //cos(1)
MAX16BIT*0.99939082701909573000624344004393 ,    //cos(2)
MAX16BIT*0.99862953475457387378449205843944 ,    //cos(3)
MAX16BIT*0.99756405025982424761316268064426 ,    //cos(4)
MAX16BIT*0.99619469809174553229501040247389 ,    //cos(5)
MAX16BIT*0.99452189536827333692269194498057 ,    //cos(6)
MAX16BIT*0.99254615164132203498006158933058 ,    //cos(7)
MAX16BIT*0.99026806874157031508377486734485 ,    //cos(8)
MAX16BIT*0.98768834059513772619004024769344      //cos(9)
};

/* Integer Sinus-Funktion
--------------------------------------
Prototype: int Sinus ( int angle );

Syntax:	i = Sinus (30);
Result:	INT16_MAX
*/
uint32_t sinus (uint32_t angle )
{
   uint32_t a,quadrant;
   uint32_t b,ret;

   quadrant = (angle % (360*DECIMALPLACES))/(90*DECIMALPLACES); // = 0,1,2,3
   angle = (angle % (90*DECIMALPLACES));                        // modulo 90
   if ((quadrant%2)!=0) angle = (90*DECIMALPLACES - angle);

   a = angle /(10*DECIMALPLACES);     // = 0, 10, 20, 30...80
   b = angle - 10*DECIMALPLACES * a;  // = 1.56 2.77 ...9.89
   ret = sinTable[a] * cosTable[b/DECIMALPLACES] +
        (b * hollyConstant * sinTable[9-a]) / DECIMALPLACES;
   ret = ret>>15; //int16 resolution is sufficient

   if (quadrant>=2) ret=-ret;
   return ret;
}


int main(void)
{
  int   cnt;
  int   i;

  sysclock_init(0);

  bled_output_init();
  exled_output_init();
  button_input_init();

  printfkomma= 2;

  lcd_init();
  clrscr();
  gotoxy(0,0);
  printf(" STM8S103F3P6\n\r");
  printf("  math_tiny\n\r");
  printf("--------------\n\r");

    cnt= 31415;
    gotoxy(0,3); printf("              ");
    i= sinus(31415);
    gotoxy(0,3); printf("SIN(%d)=%k",cnt, i);

    while(1);

  cnt= 0;
  while(1)
  {

    bled_set();
    delay_ms(countspeed);
    bled_clr();
    delay_ms(countspeed);

    if (cnt & 1) { exled_set(); } else { exled_clr(); }

    cnt++;
    cnt= cnt % 360;
    gotoxy(0,3); printf("              ");
    i= sinus(cnt);
    gotoxy(0,3); printf("SIN(%d)=%k",cnt, i);
  }
}
