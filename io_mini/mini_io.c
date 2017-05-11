/* -------------------------------------------------------
                         mini_io.c

     Versuche, die I/O Ports mit so wenig wie moeglich
     Speicherbedarf zu realisieren (notwendig geworden
     weil fuer ein einzelnes Projekt der Flash-Speicher
     ca. 500 Byte zu klein war !!! )

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     17.11.2016  R. Seelig
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

/*
  Die "Standard-Initialisierung"

  stm8_init.h

  wird entfernt weil hier die Fallunterscheidung ob mit oder der
  Controller mit oder ohne Quarz laufen soll entfernt wird und
  somit Speicherplatz eingespart werden kann.

  Daher werden die Initialisierungssequenzen eben hier eingefuegt

*/

#include "stdint.h"
#include "stm8s.h"
#include "stm8_gpio.h"

#define countspeed1   200
#define countspeed2   100

#define P_ODR   0   //   ( Output Register )
#define P_IDR   1   //   ( Input Register )
#define P_DDR   2   //   ( Direction Register )
#define P_CR1   3   //   ( Controll Register 1 )
#define P_CR2   4   //   ( Controll Register 2 )


/* ------------------------------------------------------
                        delay_ms
     grobe Zeitverzoegerung in Millisekunden. Der
     Wert 1435 in cnt2 ist "ausgemessen" und stimmt nur
     fuer eine Taktfrequenz von 16Mhz so "halbwegs". Fuer
     eine genauere Zeit ist besser eine Interruptroutine
     mittels Timer zu verwenden.
  ------------------------------------------------------ */
void delay_ms(uint16_t cnt)
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

/* ------------------------------------------------------
                     sysclock_init
      stellt den Taktgeber fuer den Controller fuer
      internen RC-Oszilator ein.

      Ersatz fuer die Init aus stm8_init.h
      Bringt 70 Byte Speicherplatz Einsparung
   ------------------------------------------------------ */
void sysclock_init(void)
{
  CLK_ICKR = 0;                                  //  Reset Register interner clock
  CLK_ECKR = 0;                                  //  Reset Register externer clock (ext. clock disable)

  CLK_ICKR =  HSIEN;                             //  Interner clock enable
  while ((CLK_ICKR & (HSIRDY)) == 0);            //  warten bis int. Takt eingeschwungen ist


  CLK_CKDIVR = 0;                                //  Taktteiler auf volle Geschwindigkeit
  CLK_PCKENR1 = 0xff;                            //  alle Peripherietakte an
  CLK_PCKENR2 = 0xff;                            //  dto.

  CLK_CCOR = 0;                                  //  CCO aus
  CLK_HSITRIMR = 0;                              //  keine Taktjustierung
  CLK_SWIMCCR = 0;                               //  SWIM = clock / 2.
  CLK_SWR = 0xe1;                                //  int. Generator als Taktquelle
  CLK_SWCR = 0;                                  //  Reset clock switch control register.
  CLK_SWCR = SWEN;                               //  Enable switching.
  while ((CLK_SWCR &  SWBSY) != 0);              //  warten bis Peripherietakt stabil

  delay_ms(50);
}

#define led1_init()     PB5_output_init()
#define led1_set()      PB5_set()
#define led1_clr()      PB5_clr()

/* ----------------------------------------------------
                   io_outputinit
   initialisiert einen einzelnen GPIO-Pin als Ausgang.
   Verbraucht bei nur einem verwendeten I/O Port
   MEHR Speicher als in stm8_init.h, jedoch wenn
   mehrere oder gar alle I/Os benoetigt werden weniger

   Hierbei gilt:

              ioport == 0  =>  PortA
                        1  =>  PortB
                        2  =>  PortC
                        3  =>  PortD

              iono   => Bitposition im Port

   I/O Adressen der Ports fangen bei Adresse 0x5000 an
   und belegen jeweils 4 Bytes Speicher Adressraum

   PortA = 0x5000, PortB = 0x5005 etc.

   Offset 0   = ODR      ( Output Register )
          1   = IDR      ( Input Register )
          2   = DDR      ( Direction Register )
          3   = CR1      ( Controll Register 1 )
          4   = CR2      ( Controll Register 2 )
   ---------------------------------------------------- */
void io_outputinit(uint8_t ioport, uint8_t iono)
{
  uint8_t   *ioadr = (uint8_t*)0x5000;     // gloabal weil mehrfach verwendet und deshalb
  uint8_t   b;

  ioadr+= (ioport*5);

  b= 1 << iono;
  *(ioadr + P_DDR) |=  b;        // Output Register
  *(ioadr + P_CR1) |=  b;        // Controll Register 1
  *(ioadr + P_CR2) &= ~(b);      // Controll Register 2
}

/* ----------------------------------------------------
                       io_set

   setzt oder loescht ein Bit im angegebenen Port

   Bsp.:  io_set(1,5,1);

        1 = PB
        5 = Bit 5
        1 = auf 1 setzen
   ---------------------------------------------------- */
void io_set(uint8_t ioport, uint8_t iono, uint8_t value)
{
  uint8_t   *ioadr = (uint8_t*)0x5000;
  uint8_t   b;

  ioadr+= (ioport*5);

  b= 1 << iono;
  if (value) *(ioadr + P_ODR) |= b; else *(ioadr + P_ODR) &= ~(b);
}


/* ----------------------------------------------------
                   io_inputinit
   initialisiert einen einzelnen GPIO-Pin als Eingang.
   ---------------------------------------------------- */
void io_inputinit(uint8_t ioport, uint8_t iono)
{
  uint8_t   *ioadr = (uint8_t*)0x5000;     // gloabal weil mehrfach verwendet und deshalb
  uint8_t   b;

  ioadr+= (ioport*5);

  b= 1 << iono;
  *(ioadr + P_DDR) &= ~(b);        // Output Register
  *(ioadr + P_CR1) |= b;           // Controll Register 1
}

/* ----------------------------------------------------
                       io_bitset
            liest einen Eingangspin ein
   ---------------------------------------------------- */
uint8_t io_bitset(uint8_t ioport, uint8_t iono)
{
  uint8_t   *ioadr = (uint8_t*)0x5000;     // gloabal weil mehrfach verwendet und deshalb
  uint8_t   b;

  ioadr+= (ioport*5);

  b=  ( *(ioadr + P_IDR) & (1 << iono) ) >> iono;

  return  b;

}

int main(void)
{
  sysclock_init();
  io_outputinit(1,5);                   // PB5 = Ausgang
  io_inputinit(1,4);                    // PB4 = Eingang
  while(1)
  {
    io_set(1,5,1);                      // PB5
    if (io_bitset(1,4))
      delay_ms(countspeed1);
    else
      delay_ms(countspeed2);
    io_set(1,5,0);
    if (io_bitset(1,4))
      delay_ms(countspeed1);
    else
      delay_ms(countspeed2);
  }
}

