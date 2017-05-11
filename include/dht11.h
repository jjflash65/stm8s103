/* -------------------------------------------------------
                           dht11.h

     Header zur DHT11 Software (Temperatur und Luft-
     feuchtigkeitssensor)

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     28.04.2017  R. Seelig
   ------------------------------------------------------ */

/*  ------------------------------------------------------------
    Anschlusspins Sensor

    +----------------+
    |                |
    |                |
    |     DHT-11     |
    |                |
    |                |
    |                |
    +----------------+
     |    |    |    |
     o    o    o    o
    Vcc  Sig  Vcc  Gnd

    ------------------------------------------------------------ */


#ifndef in_dht11
  #define in_dht11

  #include <stdint.h>
  #include <string.h>
  #include "stm8s.h"
  #include "stm8_init.h"
  #include "stm8_gpio.h"

  // Anschluss des Datenpins des Sensors an den STM8S103

  #define dht11_out()        PB4_output_init()
  #define dht11_in()         PB4_input_init()

  #define dht11_set()        PB4_set()
  #define dht11_clr()        PB4_clr()
  #define is_dht11()         is_PB4()


  // Anzahl Versuche den Sensor zu lesen bis Timeout erfolgt
  #define DHT_TIMEOUT 5000

/* ----------------------------------------------------------
     dht_getdata

     liest per Bitbanging die Daten des DHT11 Sensors aus.

     Uebergabe:
       *temperature   : Zeiger auf eine unsigned Variable,
                        die die Temperatur aufnimmt
       *humidity      : dto. fuer die Luftfeuchtigkeit

     Rueckgabe:
                      0 : fehlerfrei gelesen
                    > 0 : Fehler, Fehlercodenummer zeigt an,
                          in welchem Bereich der Fehler
                          stattgefunden hat.

     Usage:

        uint8_t errcode, temp, humi;

        errcode= dht_getdata(&temp, &umi)
   ---------------------------------------------------------- */
int8_t dht_getdata(int8_t *temperature, int8_t *humidity);

#endif
