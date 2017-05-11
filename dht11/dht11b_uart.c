/* -------------------------------------------------------
                        dht11b_test.c
     DHT11 Temperatur- und Feuchtesensor auslesen mit
     Anzeige auf einem OLED SSD1306 Display

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     10.05.2017  R. Seelig
   ------------------------------------------------------ */

#include <stdint.h>
#include <string.h>
#include "stm8s.h"
#include "stm8_init.h"
#include "my_printf.h"
#include "uart.h"
#include "dht11.h"

#define printf      my_printf


/* --------------------------------------------------------
   putchar

   wird von my-printf / printf aufgerufen und hier muss
   eine Zeichenausgabefunktion angegeben sein, auf das
   printf dann schreibt !
   -------------------------------------------------------- */
void putchar(char ch)
{
  uart_putchar(ch);
}


int main(void)
{
  int8_t   temperature = 0;
  int8_t   humidity = 0;
  uint8_t   errcode = 0;


  printfkomma= 1;

  sysclock_init(0);
  uart_init(57600);

  printf("\n\r");
  printf("DHT11 - Test");
  printf("\n\r------------------------\n\n\r");

  while(1)
  {

    errcode= dht_getdata(&temperature, &humidity);
    if(!errcode)
    {
      printf("\r  Temp.: %d oC  Humidity: %d %%RH  ", temperature, humidity);
    }
  }

}
