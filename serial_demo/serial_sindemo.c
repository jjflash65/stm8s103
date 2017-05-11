/* -------------------------------------------------------
                        serial_demo.c
     Test der seriellen Schnittstelle mit einfacher
     Berechnung einer Sinusfunktion

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

#define inp_init()          PD3_input_init()
#define is_inp()            is_PD3()

#define blinkspeed   497

#define printf   my_printf

float abs(float value)
{
  if (value< 0.0f) return (value * -(1.0f));
           else return value;
}

#define M_PI     3.14159265359f

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

  while (value > 360.0f) value -= 360.0f;
  if (value > 180.0f)
  {
    mflag= - 1;
    value -= 180.0f;
  }

  if (value > 90.0f) value = 180.0f - value;

  degree= (value * M_PI) / 180.0f;

  p3 = tiny_pow(3, degree);
  p5  = tiny_pow(5, degree);
  p7  = tiny_pow(7, degree);

  sinx= (degree - (p3/6.0f) + (p5/120.0f) - (p7/5040.0f));

  if (mflag) sinx = sinx * (-1);
  return sinx;

}

void draw_sincurve(void)
{
  int i, x, x2;
  for (i= 0; i< 361; i += 10)
  {
    x2 = (tiny_sin(i) * 24) + 25;
    for (x= 0; x < x2; x++) uart_putchar(' ');
    printf("o\n\r");
    delay_ms(40);
  }
}

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

  uint16_t counter = 0;
  uint16_t ch;
  float    wuwert;
  int      wuwerti;

  printfkomma= 3;

  sysclock_init(0);
  baudrate= 57600;
  uart_init(baudrate);

  led_output_init();
  inp_init();

  li= F_CPU / 1000000;
  cnt= li;

  printf("\n\r--------------------------------------");
  printf("\n\rSTM8 running at %d MHz\n\r", cnt);
  printf("8 kByte Flash;  1 KByte RAM\n\n\r");
  printf("Baudrate: %d0\n\n\r",baudrate/10);
  printf("20.04.2017  R. Seelig\n\r");
  printf("--------------------------------------\n\r");
  printf("Taste um Counter anzuhalten bzw. neu zu starten\n\n\r");

//  draw_sincurve();
  while(uart_ischar()) {ch= uart_getchar(); putchar(ch); }  // eventuell eingegangene Zeichen alle loeschen

  while (1)
  {
    led_set();
    delay_ms(500);
    led_clr();

    wuwert= tiny_sin(counter);
    wuwerti= wuwert*1000;

    printf("  Counter: %xh sin(%d)= %k PD3= ", counter, counter, wuwerti);

    if (is_inp()) printf("1     \r");
            else printf("0     \r");

    delay_ms(500);
    counter++;
    counter = counter % 3600;

    if (uart_ischar())
    {
      ch= uart_getchar();
      printf("\n\n\rGedrueckte Taste war: %c\n\r", ch );
      printf("Beliebige Taste fuer Counterstart...\n\n\r");
      ch= uart_getchar();
      draw_sincurve();

    }

  }
}
