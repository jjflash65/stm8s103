/* -------------------------------------------------------
                        dht11b_test.c
     DHT11 Temperatur- und Feuchtesensor auslesen mit
     Anzeige auf einem OLED SSD1306 Display

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     23.06.2016  R. Seelig
   ------------------------------------------------------ */

#include <stdint.h>
#include <string.h>
#include "stm8s.h"
#include "stm8_init.h"
#include "my_printf.h"
#include "dht11.h"
#include "ssd1306.h"

#define printf      my_printf


/* --------------------------------------------------------
   putchar

   wird von my-printf / printf aufgerufen und hier muss
   eine Zeichenausgabefunktion angegeben sein, auf das
   printf dann schreibt !
   -------------------------------------------------------- */
void putchar(char ch)
{
  oled_putchar(ch);
}


int main(void)
{
  int8_t   temperature = 0;
  int8_t   humidity = 0;
  uint8_t   errcode = 0;


  printfkomma= 1;

  sysclock_init(0);
  oled_init();
  clrscr();

  printf("\n\r");
  gotoxy(0,0); printf("DHT11 - Test");
  gotoxy(0,1); printf("----------------");

  gotoxy(1,3); printf("Temp.: ");
  gotoxy(1,4); printf("Humi.: ");

  while(1)
  {

    errcode= dht_getdata(&temperature, &humidity);
    if(!errcode)
    {
      gotoxy(8,3); printf("%d%cC  ", temperature, 131);
      gotoxy(8,4); printf("%d %%RH  ", humidity);
    }
  }

}
