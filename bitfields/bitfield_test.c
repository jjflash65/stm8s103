/* -------------------------------------------------------
                        bitfield_test.c

     Demo, um einzelne Bits eines Bytes mit Namen zu
     versehen und diese hiermit ansprechen.

     Beispiel: in einem Byte vier 4-Farbenpixel speichern

     MCU      :  STM8S103F3
     Compiler :  SDCC 3.50
     Takt     :  interner Takt 16 MHz

     15.12.2016  R. Seelig
   ------------------------------------------------------ */

#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "uart.h"
#include "my_printf.h"

void putchar(char ch);
#define printf   my_printf


// in einem CGA Modus gibt es 4 Farben die hiernach
// per Pixel 2 Bits benoetigen. Von daher passen in ein
// einzelnes Byte 4 Pixel
struct cgacolors
{
  uint8_t px0 : 2;
  uint8_t px1 : 2;
  uint8_t px2 : 2;
  uint8_t px3 : 2;
};
#define px0    pixbyte.px0
#define px1    pixbyte.px1
#define px2    pixbyte.px2
#define px3    pixbyte.px3

struct cgacolors pixbyte;

#define cgabyte  *(uint8_t*)&pixbyte

int main(void)
{

  sysclock_init(0);                    // interner Taktgeber, 16MHz
  delay_ms(2);

  uart_init(19200);

  printf("\n\r--------------------------------------");
  printf("\n\rSTM8S103F3P6 - Bitfield - Demo\n\r");
  printf("15.12.2016  R. Seelig\n\r");
  printf("--------------------------------------\n\r");


  cgabyte= 0;
  px0= 03;
  px1= 10;
  px2= 01;
  px3= 01;


  printf("Wert von pixbyte nach dem Setzen von px3: %xh\n\r",cgabyte);
  printf("Speichergroesse von pixbyte: %d\n\r",sizeof(pixbyte));


  while(1);

}

// ######################################################################################

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
