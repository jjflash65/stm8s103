/* -------------------------------------------------------
                         wdt_demo.c

     Verwendung des Watchdog-Timers

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     19.05.2016  R. Seelig
   ------------------------------------------------------ */

/*
##################################################################
                      STM8S103F3P6 Pinout
##################################################################


                            ------------
UART1_CK / TIM2_CH1 / PD4  |  1     20  |  PD3 / AIN4 / TIM2_CH2 / ADC_ETR
    UART1_TX / AIN5 / PD5  |  2     19  |  PD2 / AIN3
    UART1_RX / AIN6 / PD6  |  3     18  |  PD1 / SWIM
                     NRST  |  4     17  |  PC7 / SPI_MISO
              OSCIN / PA1  |  5     16  |  PC6 / SPI_MOSI
             OSCOUT / PA2  |  6     15  |  PC5 / SPI_CLK
                Vss (GND)  |  7     14  |  PC4 / TIM1_CH4 / CLK_CCO / AIN2
                VCAP (*1)  |  8     13  |  PC3 / TIM1_CH3 /
                Vdd (+Ub)  |  9     12  |  PB4 / I2C_SCL
           TIM2_CH3 / PA3  | 10     11  |  PB5 / I2C_SDA
                            -----------

*1 :  Ist mit min. 1uF gegen GND zu verschalten


                   Pinmapping STM8S103F3P6  auf R3 Board

                     STLINK v2            USB
                                        +----+
                      +----+            |    |
                  +---|    |------------|    |--------+
                  |   |    |            |    |        |
                  |   +----+            +----+        |
                  |                                   |
                  |                            SCA  o |
                  |                            SDA  o |
                  |                         | Aref  o |
                  |                         |  GND  o |
                  |                         |   13  o |  PC5  /  SPI.CLK
                  |                         |   12  o |  PC7  /  SPI.MISO
                  | o  res  |             d |   11  o |  PC6  /  SPI.MOSI
                  | o  3.3V |             i |   10  o |  PA3  /  SPI.SS
                  | o  5V   |             g |    9  o |
                  | o  GND  | a           i |    8  o |
                  | o  GND  | n           t |         |
                  | o  Uin  | a           a |    7  o |  PD4
                  |         | l           l |    6  o |  PD3
                  | o  A0   | o             |    5  o |  PD2
                  | o  A1   | g             |    4  o |  PD1
            PA1   | o  A2   |               |    3  o |  PC3
            PA2   | o  A3   |               |    2  o |  PC4
 I2C.SDA  / PB5   | o  A4   |               |    1  o |
 I2C.SCL  / PB4   | o  A5   |               |    0  o |
                  |                                   |
                  +-----------------------------------+


*/


#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"

#include "math.h"

#define countspeed   200

#define led1_init()     PB5_output_init()
#define led1_set()      PB5_set()
#define led1_clr()      PB5_clr()

void iwdg_init(void)
{
  // Watchdogtimer-Takt betraegt 128 kHz (im Datenblat LSI bezeichnet)

  IWDG_KR= 0xcc;                        // Start des Watchdogs
  IWDG_KR= 0x55;                        // Schreiberlaubnis auf IWDG Register
  IWDG_PR= 0x06;                        // Prescaler:
                                        // 0 : LSI / 4  ; 1 : LSI / 8  ; 2 : LSI / 16
                                        // 3 : LSI / 32 ; 4 : LSI / 64 ; 5 : LSI / 128
                                        // 6 : LSI / 256

  IWDG_RLR= 0xff;                       // Reload Zaehler, wird mit dem WDT-Takt heruntergezaehlt
                                        // WDT-Kickout nach ca. 1 Sekunde
  IWDG_KR= 0xaa;                        // Zaehler-Reset
}

iwdg_reset(void)
{
  IWDG_KR= 0xaa;
}


int main(void)
{

  sysclock_init(0);                     // erst Initialisieren mit internem RC
  iwdg_init();
  int_enable();

  led1_init();

  led1_clr();
  delay_ms(100);
  led1_set();
  while(1);                             // normalerweise wuerde die LED einmal auf-
                                        // leuchten und in der Endlosschleife verharren.
                                        // Nach ca. 1 Sekunde loest der WDT einen Reset aus
                                        // (hierdurch blinkt die LED, weil zu beginn des
                                        // Programms die LED ein und wieder ausgeschaltet wird

}

