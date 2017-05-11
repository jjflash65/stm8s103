/* -------------------------------------------------------
                        serial_demo.c
     Test der seriellen Schnittstelle

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     23.06.2016  R. Seelig
   ------------------------------------------------------ */

#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "uart.h"
#include "my_printf.h"


#define led_output_init()   PB5_output_init()       // Onboard LED
#define led_set()           PB5_set()
#define led_clr()           PB5_clr()

#define blinkspeed   497

#define printf   my_printf

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
  long          li;
  uint16_t      cnt;
  uint16_t      baudrate;
  char          ch;
  uint8_t       running;

  sysclock_init(0);
  delay_ms(2);
//  sysclock_init(1);                  // externer Quarz
//  delay_ms(2);
  baudrate= 57600;
  uart_init(baudrate);

  led_output_init();

  li= F_CPU / 1000000;
  cnt= li;

  printf("\n\r--------------------------------------");
  printf("\n\rSTM8 running at %d MHz\n\r", cnt);
  printf("8 kByte Flash;  1 KByte RAM\n\n\r");
  printf("Baudrate: %d0\n\n\r",baudrate/10);
  printf("23.06.2016  R. Seelig\n\r");
  printf("--------------------------------------\n\r");
  printf("Taste um Counter anzuhalten bzw. neu zu starten\n\n\r");

  cnt= 0;
  running= 1;
  while(1)
  {
    if (running)
    {
      led_set();
      printf(" Counter: %d  \r",cnt);
      delay_ms(blinkspeed);
      led_clr();
      delay_ms(blinkspeed);
      cnt++;
    }
    else
    {
      cnt= 0;
      delay_ms(50);
    }
    if (uart_ischar())
    {
      ch= uart_getchar();
      delay_ms(10);
      if (running)
      {
        led_set();
        printf("\n\n\rCounter gestoppt, Taste fuer Neustart\n\n\r");
        running= 0;
      } else {running= 1;}
    }
  }
}
