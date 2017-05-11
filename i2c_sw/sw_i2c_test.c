/* -------------------------------------------------------
                         sw_i2c_test.c

     schreibt ggf. Werte in ein 24LC16 EEProm und liest
     diese wieder aus

     MCU       :  STM8S103F3

     Hardware  :  EEProm 24LC16
     Takt      :  interner Takt 16 MHz

     18.10.2016  R. Seelig
   ------------------------------------------------------ */

#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "my_printf.h"
#include "uart.h"
#include "sw_i2c.h"


#define printf              my_printf

#define writedummy          0           // 1 : Werte werden ins EEProm geschrieben
                                        // 0 : nicht schreiben


// -------------------------------------------------------------------------------------


/* --------------------------------------------------
     PUTCHAR

     Diese Funktion wird von < my_printf > zur Ausgabe
     von Zeichen aufgerufen. Hier ist eine Hardware-
     zeichenausgabefunktion anzugeben, mit der
     my_printf zusammen arbeiten soll.
   -------------------------------------------------- */
void putchar(char ch)
{
  uart_putchar(ch);
}


void crlf(void)
{
  uart_putchar(0x0d);
  uart_putchar(0x0a);
}


/* ---------------------------------------------------------------------
                              MAIN
   --------------------------------------------------------------------- */

int main(void)
{
  int inp;
  int cnt;
  uint8_t cx,anz;
  uint8_t ack;

  sysclock_init(0);

  printfkomma= 1;                       // my_printf verwendet mit Formatter %k eine Kommastelle
  i2c_master_init();
  uart_init(19200);

  i2c_master_init();
  printf("\n\rI2C Bus scanning\n\r--------------------------\n\n\r" \
         "Devices found at address:\n\n\r");
  anz= 0;

  for (cx= 1; cx< 127; cx++)
  {
    ack= i2c_start(cx << 1);
    delay_ms(1);
    i2c_stop();
    if (ack)
    {
      printf("%xh  ",(cx << 1));
      anz++;
      anz= anz % 5;
      if (!anz) printf("\n\r");
    }
    delay_ms(1);
  }
  printf("\n\n\rEnd of I2C-bus scanning... \n\n\r");
  i2c_stop();

  #if (writedummy == 1)

  printf("\n\rWerte schreiben Adresse 0x01b0:");
  for (cnt= 0; cnt< 8; cnt++)
  {
    i2c_start(0xa0);
    i2c_write(0x10 + cnt);
    i2c_write(0x0 | ((cnt*2)+0x30));
    i2c_stop();
    delay_ms(20);
  }

  printf("\n\rWerte schreiben Adresse 0x02b0:\n\r");
  for (cnt= 0; cnt< 8; cnt++)
  {
    i2c_start(0xa0);
    i2c_write(0x40+cnt);
    i2c_write(0x0 | ((cnt*4) + 0x50));
//    i2c_write(0x55);
    i2c_stop();
    delay_ms(20);
  }

  #endif


  printf("\n\n\rgelesene Werte: \n\r");

  for (cnt= 0; cnt< 8; cnt++)
  {
    i2c_start(0xa0);
    i2c_write(0x10+cnt);

    i2c_start(0xa1);
    inp= i2c_read_nack();
    i2c_stop();
    printf("%xh ",inp);
  }

  printf("\n\n\rPageread 1:\n\r");

  i2c_start(0xa0);
  i2c_write(0x10);
  i2c_start(0xa1);

  for (cnt= 0; cnt< 7; cnt++)
  {
    inp= i2c_read_ack();
    printf("%xh ",inp);
  }
  inp= i2c_read_nack();
  printf("%xh ",inp);
  i2c_stop();

  printf("\n\n\rPageread 2:\n\r");

  i2c_start(0xa0);
  i2c_write(0x40);
  i2c_start(0xa1);

  for (cnt= 0; cnt< 7; cnt++)
  {
    inp= i2c_read_ack();
    printf("%xh ",inp);
  }
  inp= i2c_read_nack();
  printf("%xh ",inp);
  i2c_stop();

  printf("\n\n\rend of test\n\r");

  while(1)
  {
  }

  while(1);
}
