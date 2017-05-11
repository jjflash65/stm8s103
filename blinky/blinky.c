/* -------------------------------------------------------
                         blinky.c

     Demoprogramm fuer erstes Lebenszeichen des MCU

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

##################################################################
   STM8S103F3P6 Minimal-Board (China)  alternative Pinfunktionen
##################################################################

Hinweis: VCAP ist NICHT auf dem Board aufgelegt !!!


Minimum-Board       =====    Funktion

d4                  -----    PD4 / UART1_CK / TIM2_CH1 / BEEP(HS)
d5                  -----    PD5 / UART1_TX / AIN5 / HS
d6                  -----    PD6 / UART1_RX / AIN6 / HS
rst                 -----    NRST ( auch fuer ST-Link)
a1                  -----    PA1 / OSCIN (Quarz)
a2                  -----    PA2 / OSCOUT (Ouarz)
gnd                 -----    Vss
5V                  -----    Betriebsspannung
3V3                 -----    3,3V Ausgangsspannung AMS1117 3.3
a3                  -----    PA3 / SPI_NSS / TIM2_CH3(HS)

b5                  -----    PB5 / T / I2C_SDA / TIM1_BKIN
b4                  -----    PB4 / T / I2C_SCL / ADC_ETR
c3                  -----    PC3 / HS / TIM1_CH3 / TLI / TIM1_CH1N
c4                  -----    PC4 / HS / TIM1_CH4 / CLK_CC0 / AIN2 / TIM1_CH2N
c5                  -----    PC5 / HS / SPI_SCK
c6                  -----    PC6 / HS / SPI_MOSI / TIM1_CH1
c7                  -----    PC7 / HS / SPI_MISO / TIM1_CH2
d1                  -----    PD1 / HS / SWIM ( ST-Link )
d2                  -----    PD2 / HS / AIN3 / TIM2_CH3
d3                  -----    PD3 / HS / AIN4 / TIM2_CH2 / ADC_ETR


*/


#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"

#include "math.h"

#define countspeed   200

#define led1_init()     PB5_output_init()
#define led1_set()      PB5_set()
#define led1_clr()      PB5_clr()

#define led2_init()     PD4_output_init()
#define led2_set()      PD4_set()
#define led2_clr()      PD4_clr()

#define button_init()   PB4_input_init()
#define is_button()     is_PB4()

void pol_delay(uint16_t cnt)
{
  volatile uint16_t cnt2;

  while (cnt)
  {
    cnt2= 1435;
    while(cnt2)
    {
      cnt2--;
    }
    cnt--;
  }
}

int main(void)
{
  sysclock_init(0);                     // erst Initialisieren mit internem RC
//  sysclock_init(1);                     // .. und dann auf externen Quarz umschalten

  led1_init();
  led2_init();
  button_init();

  while(1)
  {
    led1_set();

    if (is_button()) led2_clr();

    pol_delay(800);
    led1_clr();

    if (is_button()) led2_set();

    pol_delay(50);
  }
}

