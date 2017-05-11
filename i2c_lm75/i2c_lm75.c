/* -------------------------------------------------------
                         i2c_lm75.c

     Temperaturanzeige auf N5510 Display

     Hardware :

        - LM75 (I2C Temperatursensor)
        - N5510 S/W LCD-Display

     MCU      :  STM8S103F3
     Takt     :  interner Takt 16 MHz

     31.05.2016  R. Seelig
   ------------------------------------------------------ */

#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "my_printf.h"
#include "stm8_nokia.h"
#include "i2c.h"

#define printf               my_printf

#define bled_output_init()   PD4_output_init()
#define bled_set()           PD4_set()
#define bled_clr()           PD4_clr()

// -------------------------------------------------------------------------------------


int lm75_read(void)
{
  char       ack;
  char       t1;
  uint8_t    t2;
  int        lm75temp;

  i2c_start();

  ack= i2c_write(0x90);                     // LM75 Basisadresse
  if (ack)
  {

    i2c_write(0x00);                        // LM75 Registerselect: Temp. auslesen
    i2c_write(0x00);

    i2c_stop();
    delay_us(200);
    i2c_start();

    i2c_write(0x91);                        // LM75 zum Lesen anwaehlen
    delay_ms(1);                            // Reaktionszeit LM75
    t1= 0;
    t1= i2c_read();                         // hoeherwertigen 8 Bit
    delay_ms(1);
    t2= i2c_read_nack();                    // niederwertiges Bit (repraesentiert 0.5 Grad)
    i2c_stop();

  }
  else
  {
    i2c_stop();
    return -127;                            // Abbruch, Chip nicht gefunden
  }

  lm75temp= t1;
  lm75temp = lm75temp*10;
  if (t2 & 0x80) lm75temp += 5;             // wenn niederwertiges Bit gesetzt, sind das 0.5 Grad
  return lm75temp;
}


/* --------------------------------------------------
     PUTCHAR

     Diese Funktion wird von < my_printf > zur Ausgabe
     von Zeichen aufgerufen. Hier ist eine Hardware-
     zeichenausgabefunktion anzugeben, mit der
     my_printf zusammen arbeiten soll.
   -------------------------------------------------- */
void putchar(char ch)
{
  lcd_putchar_d(ch);
}


int main(void)
{
  int tempvalue;

  sysclock_init(0);

  printfkomma= 1;
  i2c_init(2);
  lcd_init();
  clrscr();

  bled_output_init();

  clrscr();
  gotoxy(0,0);
  printf("I2C-Demo");
  gotoxy(0,2);
  printf("--------------");


  while(1)
  {
    bled_clr();
    gotoxy(0,1); printf("I2C-LM75:");

    tempvalue= lm75_read();
    if ((tempvalue!= -127))
    {
      printf("found");
      gotoxy(0,4); printf("Temp.= %k%c  ",tempvalue,124);
    }
    else
    {
      printf("fail ");
      gotoxy(0,4); printf("Temp.= n.a.  ");
    }

    delay_ms(500);
    bled_set();
    delay_ms(500);
  }
}
