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

#define sr04_trig_init()    PC4_output_init()               // D2 auf r3-Board
#define sr04_echo_init()    PC3_input_init()                // D3 auf r3-Board

#define trig_set()          PC4_set()
#define trig_clr()          PC4_clr()
#define is_echo()           is_PC3()


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
  int8_t    temperature = 0;
  int8_t    humidity = 0;
  uint8_t   errcode = 0;

  uint16_t  mess;
  uint32_t  dist;


  printfkomma= 1;

  sysclock_init(0);
  oled_init();
  sr04_trig_init();
  sr04_echo_init();

  clrscr();

  printf("\n\r");
  gotoxy(0,0); printf("DHT11 / U-schall");
  gotoxy(0,1); printf("----------------");

  gotoxy(1,3); printf("Temp.: ");
  gotoxy(1,4); printf("Humi.: ");
  gotoxy(1,6); printf("Dist.: ");

  while(1)
  {
    // Ultraschallimpuls aussenden
    trig_set();
    delay_us(5);
    trig_clr();
    delay_us(5);
    trig_set();

    mess= 0;
    while(!(is_echo()) );               // warten bis Sensor mit logisch 1 antwortet
    while(is_echo() && (mess< 2100))    // 2100 entspricht bei 300/42 Einheiten 150cm
    {
      delay_us(1);
      mess++;
    }
    dist= mess;
    dist= (dist * 300) / 42;            // impirisch ermittelter Wert bei 16 MHz Taktfrequenz
    mess= dist / 10;

    errcode= dht_getdata(&temperature, &humidity);
    if(!errcode)
    {
      gotoxy(8,3); printf("%d%cC  ", temperature, 131);
      gotoxy(8,4); printf("%d %%RH  ", humidity);
    }
    else
    {
      gotoxy(8,3); printf("n.a.     ");
      gotoxy(8,4); printf("n.a.     ");
    }
    gotoxy(8,6); printf("%k cm  ",mess);
  }

}
