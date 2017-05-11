/* -------------------------------------------------------
                         buttons.c

     Demoprogramm fuer I/O Input mittels Taster

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     19.05.2016  R. Seelig
   ------------------------------------------------------ */

/*
##################################################################
   STM8S103F3P6 Minimal-Board (China)  alternative Pinfunktionen
##################################################################

Hinweis: VCAP ist NICHT auf dem Board aufgelegt !!!


Boardpin No. Minimum-Board  =====    Funktion

     1          d4          -----    PD4 / UART1_CK / TIM2_CH1 / BEEP(HS)
     2          d5          -----    PD5 / UART1_TX / AIN5 / HS
     3          d6          -----    PD6 / UART1_RX / AIN6 / HS
     4          rst         -----    NRST ( auch fuer ST-Link)
     5          a1          -----    PA1 / OSCIN (Quarz)
     6          a2          -----    PA2 / OSCOUT (Ouarz)
     7          gnd         -----    Vss
     8          5V          -----    Betriebsspannung
     9          3V3         -----    3,3V Ausgangsspannung AMS1117 3.3
     10         a3          -----    PA3 / SPI_NSS / TIM2_CH3(HS)

     11         b5          -----    PB5 / T / I2C_SDA / TIM1_BKIN
     12         b4          -----    PB4 / T / I2C_SCL / ADC_ETR
     13         c3          -----    PC3 / HS / TIM1_CH3 / TLI / TIM1_CH1N
     14         c4          -----    PC4 / HS / TIM1_CH4 / CLK_CC0 / AIN2 / TIM1_CH2N
     15         c5          -----    PC5 / HS / SPI_SCK
     16         c6          -----    PC6 / HS / SPI_MOSI / TIM1_CH1
     17         c7          -----    PC7 / HS / SPI_MISO / TIM1_CH2
     18         d1          -----    PD1 / HS / SWIM ( ST-Link )
     19         d2          -----    PD2 / HS / AIN3 / TIM2_CH3
     20         d3          -----    PD3 / HS / AIN4 / TIM2_CH2 / ADC_ETR

*/

#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "seg7anz_v2.h"

#define blinkspeed1    100
#define blinkspeed2    300
#define blinkspeed3    500

#define led1_init()         PB5_output_init()
#define led1_set()          PB5_set()
#define led1_clr()          PB5_clr()

// Taster beim Einlesen invertieren, da ein Taster gegen GND verschaltet ist
// und ein Betaetigen an den Eingangpins eine 0 liefert

// Taster rechts
#define retast_init()       PC3_input_init()
#define is_retast()         (!(is_PC3()))

// Taster Mitte
#define midtast_init()      PC4_input_init()
#define is_midtast()        (!(is_PC4()))

// Taster links
#define litast_init()       PC5_input_init()
#define is_litast()         (!(is_PC5()))

int getspeed(int inspeed)
{
  int tmpspeed;

  tmpspeed= inspeed;
  if (is_retast())
  {
    delay_ms(50);                    // Entprellzeit
    while(is_retast());              // Warten bis Taster losgelassen ist
    delay_ms(50);                    // Entprellzeit
    tmpspeed= blinkspeed1;
  }

  if (is_midtast())
  {
    delay_ms(50);                    // Entprellzeit
    while(is_midtast());              // Warten bis Taster losgelassen ist
    delay_ms(50);                    // Entprellzeit
    tmpspeed= blinkspeed2;
  }

  if (is_litast())
  {
    delay_ms(50);                    // Entprellzeit
    while(is_litast());              // Warten bis Taster losgelassen ist
    delay_ms(50);                    // Entprellzeit
    tmpspeed= blinkspeed3;
  }

  digit4_setdez(tmpspeed);
  return tmpspeed;
}


int main(void)
{
  uint16_t aktspeed;

  sysclock_init(0);                     // erst Initialisieren mit internem RC

  aktspeed= blinkspeed1;
  led1_init();

  retast_init();
  midtast_init();
  litast_init();

  digit4_init();                        // Modul initialisieren
  digit4_setdez(aktspeed);

  while(1)
  {


    led1_clr();
    aktspeed= getspeed(aktspeed);
    delay_ms(aktspeed);
    led1_set();
    aktspeed= getspeed(aktspeed);
    delay_ms(aktspeed);

  }
}

