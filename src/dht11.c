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

#include "dht11.h"


/* ------------------------------------------------------
                        dht_delay
     grobe Zeitverzoegerung in Mikrosekunden. Die Zeit-
     verzoegerung stimmt nur fuer eine Betriebsfrequenz
     von 16 MHz
  ------------------------------------------------------ */
void dht_delay(uint16_t anz)
{
  volatile uint16_t count;

  for (count= 0; count< anz; count++)
  {
    __asm
      nop
    __endasm;
  }
}

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
   ---------------------------------------------------------- */
int8_t dht_getdata(int8_t *temperature, int8_t *humidity)
{

  uint8_t   bits[5];
  uint8_t   i,j = 0;
  uint16_t  timeoutcounter = 0;

  memset(bits, 0, sizeof(bits));



  memset(bits, 0, sizeof(bits));

  // Reset Anschlusspin Sensor
  dht11_out();                                          // Anschluss als Output
  dht11_set();                                          // Pin = 1
  delay_ms(100);

  // Sendeaufforderung
  dht11_clr();
  delay_ms(15);
  dht11_in();

  timeoutcounter= 0;
  while(is_dht11())                                     // warten bis Bestaetigung = 0
  {
    timeoutcounter++;
    if (timeoutcounter > DHT_TIMEOUT) return 1;
  }

  timeoutcounter= 0;
  while(!(is_dht11()))                                   // warten bis Datenleitung = 1;
  {
    timeoutcounter++;
    dht_delay(2);
    if (timeoutcounter > DHT_TIMEOUT) return 2;
  }

  while(is_dht11())                                      // warten bis Datenleitung = 0;
  {
    timeoutcounter++;
    dht_delay(2);
    if (timeoutcounter > DHT_TIMEOUT) return 3;
  }

  while(!(is_dht11()))                                   // warten bis Datenleitung = 1;
  {
    timeoutcounter++;
    dht_delay(2);
    if (timeoutcounter > DHT_TIMEOUT) return 4;
  }

  // Ab jetzt kommen die Daten


  // Sensordaten lesen

  for (j= 0; j < 5; j++)                                // Sensor liefert 5 Datenbytes
  {
    uint8_t result=0;

    for(i= 0; i < 8; i++)
    {
      dht_delay(35);

      if (is_dht11())                                  // 1-Signal laenger als 35 us wird als 1 gelesen
      {
        result |= (1<<(7-i));

        timeoutcounter = 0;
        while(is_dht11())                              // warten bis Signal wieder 0 ist
        {
          dht_delay(2);
          timeoutcounter++;
          if(timeoutcounter > DHT_TIMEOUT)
          {
            return 5;                                   // Timeout
          }
        }

      }

      timeoutcounter = 0;
      while(!(is_dht11()))                             // auf 1 Signal Sensor warten
      {
        dht_delay(2);
        timeoutcounter++;
        if(timeoutcounter > DHT_TIMEOUT)
        {
          return 6;                                    // Timeout
        }
      }

      timeoutcounter = 0;
      // auf naechsten Framestart warten
      while(!(is_dht11()))
      {
        dht_delay(2);
        timeoutcounter++;
        if(timeoutcounter > DHT_TIMEOUT)
        {
          return 7;                                    // Timeout
        }

      }

    }
    bits[j] = result;
  }

  // Anschlusspin zuruecksetzen

  delay_ms(50);
  dht11_out();
  dht11_set();
  delay_ms(50);

  //Checksummenvergleich
  if ((uint8_t)(bits[0] + bits[1] + bits[2] + bits[3]) == bits[4])
  {
    *temperature = bits[2];
    *humidity = bits[0];
    return 0;
  }
  return 0x08;
}
