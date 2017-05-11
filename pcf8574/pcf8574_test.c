/* -------------------------------------------------------
                         pcf8574_test.c

     Test des I/O Expanders PCF8574 mittels Software im-
     plementiertem I2C Interface.

     Demo      :  Knightrider Lauflicht

     Hardware  :  I/O Expander  PCF8574
                  Leuchtdioden am Expander ueber Wider-
                  stand gegen +Vcc geschaltet
                  ( 0 = LED leuchtet)

     MCU       :  STM8S103F3
     Takt      :  interner Takt 16 MHz

     18.10.2016  R. Seelig
   ------------------------------------------------------ */

#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "sw_i2c.h"

/*
##################################################################
                   I2C  Portexpander PCF8574P
##################################################################

                            +---------+
                         A0 | 1    16 | Vcc
                         A1 | 2    15 | SDA
                         A2 | 3    14 | SCL
                         P0 | 4    13 | /INT
                         P1 | 5    12 | P7
                         P2 | 6    11 | P6
                         P3 | 7    10 | P5
                        GND | 8     9 | P4
                            +---------+
*/

/* ---------------------------------------------------------------
                                MAIN
   ---------------------------------------------------------------- */

#define laufspeed     50

int main(void)
{
  uint8_t outby;
  uint8_t dir;

  sysclock_init(0);
  outby= 1; dir = 1;

  i2c_master_init();
  while(1)
  {
    i2c_start(0x40);
    i2c_write(~(outby));
    i2c_stop();
    delay_ms(laufspeed);

    if (dir)
    {
      outby= outby << 1;
      if (outby== 0x80) dir= 0;      // Laufrichtung umschalten
    }
    else
    {
      outby= outby >> 1;
      if (outby== 0x01) dir= 1;
    }
  }
}
