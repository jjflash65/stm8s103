/* -------------------------------------------------------
                         ds1307_demo

     Liest DS1307 (Realtime-Clock-Chip) aus und zeigt
     diese auf einer 7 Segmentanzeige im Wechsel mit
     der Temperatur an.

     Benoetigte Hardware;

              DS1307   RTC-Modul
              4-stellige 7-Segmentanzeige (Tube Module)
              47k NTC-Widerstand
              3 Taster zum Stellen der Uhr

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     31.05.2016  R. Seelig
   ------------------------------------------------------ */

#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "i2c.h"
#include "seg7anz_v2.h"


#define ds1307_addr             0xd0

volatile uint8_t   std,min,sek;
volatile uint8_t   dow, day, month;
volatile uint8_t   year;


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


#define u_ref          326            // gemessene Betriebsspg.: 3.26 V ( * 100 )
#define intv_time      300            // Verzoegerungszeit der Wiederholungsschleife

#define d4char_C       0xc6           // Bitmuster fuer grosses C
#define d4char_L       0xc7           // Bitmuster fuer grosses L
#define d4char_oo      0x9c           // Bitmuster fuer hochgestelltes o

#define tempstep       5              // Temperaturdifferenz 2er Werte in Temperatur Lookup-Table
#define  ntc_firstval  -20            // erster Wert der Temperatur-Widerstands Tabelle

#define no_komma       1              // 1: Anzeige ohne Kommastelle
                                      // 0. Anzeige mit Kommastelle


// Widerstandstabelle fuer Vishay NTC 2381-640-66472 47k NTC,
// Reichelt Nr.: NTC-0,2 47k
// Erster Wert: 464,1 kOhm entspricht -20 Grad, Temperaturabstand der einzelnen
// Werte betraegt 5 Grad, somit entspricht der letzte Eintrag +65 Grad, ein
// 0 Byte signalisiertdas Ende der Tabelle

const int ntc_tab[] =
          { 4641, 3490, 2646, 2023, 1558, 1209,  945,  744,  589,
             470,  377,  304,  247,  201,  165,  136,  113,   94,
             0 };



/* --------------------------------------------------
      ds1307_READ

      liest eine Speicherzelle des DS1307 Uhrenbau-
      steins aus
   -------------------------------------------------- */
uint8_t ds1307_read(uint8_t addr)
{

  uint8_t value;

  i2c_start();
  delay_ms(1);
  i2c_write(ds1307_addr);
  delay_ms(1);
  i2c_write(addr);

  i2c_start();
  delay_ms(1);
  i2c_write(ds1307_addr | 1);
  delay_ms(1);
  value= i2c_read_nack();
  delay_ms(1);
  i2c_stop();
  delay_ms(10);

  return value;
}

/* --------------------------------------------------
      ds1307_WRITE

      beschreibt eine Speicherzelle des DS1307
      Uhrenbausteins

      addr  =>  Registeradresse
      value =>  zu setzender Wert
   -------------------------------------------------- */
void ds1307_write(uint8_t addr, uint8_t value)
{

  i2c_start();
  delay_ms(1);
  i2c_write(ds1307_addr);

  delay_ms(1);
  i2c_write(addr);
  delay_ms(1);

  i2c_write(value);
  delay_ms(1);
  i2c_stop;
  delay_ms(10);

}

/* --------------------------------------------------
      BCD2DEZ

      wandelt eine BCD kodierte Zahle in eine dezimale
      Bsp: value = 0x23
      Rueckgabe    23 (dezimal)
   -------------------------------------------------- */
uint8_t bcd2dez(uint8_t value)
{
  return (((value >> 4) * 10) + (value & 0x0f)) ;
}

/* --------------------------------------------------
      DEZ2BCD

      wandelt eine dezimale Zahl in eine BCD
      Bsp: value = 45
      Rueckgabe    0x45
   -------------------------------------------------- */
uint8_t dez2bcd(uint8_t value)
{
  uint8_t hiz,loz,c;

  hiz= value / 10;
  loz= (value -(hiz*10));
  c= (hiz << 4) | loz;
  return c;
}

/* --------------------------------------------------
      ds1307_readtime

      liest die Uhrzeit des DS1307 in globale
      Variable ein (year, month, day, std, min, sek)

   -------------------------------------------------- */
void ds1307_readtime(void)
{

  sek= ds1307_read(0) & 0x7f;
  delay_ms(1);

  min= ds1307_read(1) & 0x7f;
  delay_ms(1);

  std= ds1307_read(2) & 0x3f;
  delay_ms(1);

  day= ds1307_read(4) & 0x3f;
  delay_ms(1);

  month= ds1307_read(5) & 0x1f;
  delay_ms(1);

  year= ds1307_read(6);
  delay_ms(1);
}

/* --------------------------------------------------
      ds1307_settime

      setzt die Uhrzeit des DS1307
   -------------------------------------------------- */
void ds1307_settime(uint8_t year, uint8_t month, uint8_t day, uint8_t std, uint8_t min, uint8_t sek)
{
  ds1307_write(2,std);                    // Stunde
  delay_ms(10);
  ds1307_write(1,min);                    // Minute
  delay_ms(10);
  ds1307_write(0,sek);                    // Sekunde
  delay_ms(10);
  ds1307_write(4,day);                    // Tag
  delay_ms(10);
  ds1307_write(5,month);                  // Monat
  delay_ms(10);
  ds1307_write(6,year);                   // Jahr
  delay_ms(10);

}

/* --------------------------------------------------
      ds1307_settime

      initialisiert den DS1307, hierfuer wird zuvor
      I2C - Bus gestartet.

      Rueckgabewert= 0 wenn DS1307 nicht gefunden
   -------------------------------------------------- */

int ds1307_init(void)
{
  uint8_t ack, cx;


  i2c_init(2);
  delay_ms(10);

  ack= 0;
  i2c_start();
  delay_ms(1);
  ack= i2c_write(ds1307_addr);
  delay_ms(1);
  i2c_stop();
  if (!ack) return 0;


  cx= ds1307_read(0x00);
  cx &= 0x7f;                  // CH Bit loeschen
  ds1307_write(0x00,cx);
  delay_ms(1);
  cx= ds1307_read(0x02);       // lese Stunde (die das 12 / 24 Std. Format Flag enthaellt)
  delay_ms(1);
  cx &= 0xbf;                  // Bit 6= 0 => 24 Std. Format
  ds1307_write(0x02,cx);

  return 1;
}


/* ---------------------------------------------------------
                           adc_init
     Makro (weil als Funktion deklariert  mehr Flash-
     speicher benoetigt.

     Initialisiert den Analog-Digitalwandler. In < ch >
     wird der Kanal selektiert auf dem gemessen werden
     soll.

     STM8 Minimumboard hat nur 2 Kanaele fuer den ADC
     (andere Kanaele sind nicht herausgefuehrt):

     Kanal 3 (Pin PD2) und Kanal 4 (Pin PD3)
   --------------------------------------------------------- */
#define adc_init(ch)         {  ADC_CSR =  (ch);                  \
                                ADC_CR1 |= ADC_CR1_ADON; }


/* ---------------------------------------------------------
                           adc_read
     liest den 10-ADC und gibt den Messwert als Argument
     zurueck (Werte 0..1023)
   --------------------------------------------------------- */
uint16_t adc_read(void)
{
  uint16_t  adcvalue;

  ADC_CR1 |= ADC_CR1_ADON;            // AD-Wandlung starten
  while (!(ADC_CSR & ADC_CSR_EOX));   // warten bis Conversion beendet
  delay_us(5);                        // Warten bis Wert gelesen werden kann

  adcvalue = (ADC_DRH << 2);          // die unteren 2 Bit
  adcvalue += ADC_DRL;                // die oberen 8 Bit

  return adcvalue;
}


/* --------------------------------------------------------
                        get_widerstand

   ermittelt einen Widerstandswert, der am angegebenen
   Channel angeschlossen ist. An diesem Anschlusspin
   (AIN3 oder AIN4) muss ein Pop-Up Widerstand von 10 kOhm
   gegen Betriebsspannung geschaltet sein.

   Rueckgabewert:
     - gemessener Widerstand / 100
       Bsp.: Widerstand ist 47000 Ohm so ist Rueckgabewert
             470.
       Dies bedeutet, dass der kleinste Widerstand, der
       erfasst werden kann 100 Ohm betraegt.

    ==> fuer viele Anwendungen sind "falsche" Winderstands-
        werte im Bereich bis 2% tolerierbar. Vorteil hier
        ist es, dass float-Variablen vermieden wurden,
        speziell im Hinblick auf den limitierten Speicher
        eines STM8S103F3
   -------------------------------------------------------- */

uint16_t get_widerstand(char channel)
{
  long rx;
  uint16_t     i;

  adc_init(channel);
  delay_ms(5);

  rx= adc_read();
  rx= 0;
  for (i= 0; i<  10; i++)                 // Spg. am Widerstand 10 mal messen
  {
    rx += adc_read();
    delay_ms(30);
  }

//  rx= (rx) / (1023-(rx/100));
  rx= (rx*100) / (10210-(rx/1));         // 10230 "waere" der richtige Wert, durch
                                         // eine andere Angabe hier werden Systemfehler
                                         // wie Widerstandstoleranz, Leitungen, Messgehler
                                         // "wegkalibriert"
  return rx;
}

/* --------------------------------------------------------
                           ntc_calc

   kalkuliert aus einem gegebenen Wert mittels einer
   Wertetabelle den zu diesem Wert gehoehrende Temperatur

   wid_wert : Widerstandswert / 100
              (470 bedeutet somit 47000 = 47kOhm)
   firstval : der Temperaturwert, der dem ersten Eintrag
              in der Tabelle entspricht
   stepwidth: Temperaturdifferenz zwischen 2 Werten in der
              Tabelle
   *temp_tab: Die Tabelle selbst.

   Bsp.:

   Erster Wert in der Tabelle entspricht -20 Grad, die
   Differenz zwischen 2 Tabellenwerten sind 5 Grad, Werte
   sind in - tabelle - angegeben:

   temp= ntc_calc(185, -20, -5, &tabelle);

   Berechnet hiermit die Temperatur fuer einen Widerstands-
   wert von 18.5 kOhm.
   -------------------------------------------------------- */

int ntc_calc(int wid_wert, int firstval, int stepwidth, int *temp_tab)
{

  int   t, t2, tadd;
  char  b;

  // suche Position in der ntc_tab

    b= 0; t= firstval;

  while (wid_wert < temp_tab[b])
  {
    b++;
    t= t + stepwidth;
    if (temp_tab[b]== 0) { return 9999; }    // Fehler oder Temp. zu hoch
  }

  t = t * 10;                                // Pseudokomma

  if (wid_wert != temp_tab[b])
  {

    t= t - (stepwidth * 10);                   // Gradschritte in der Tabelle, 10 = Pseudokomma

    tadd= temp_tab[b-1]-temp_tab[b];           // Diff. zwischen 2 Tabellenwerte = 5 Grad

    t2= temp_tab[b-1]- wid_wert;

    t2= t2 * stepwidth * 10;

    t2= (t2 / tadd);
    t= t+t2;

  }
  return t;
}


/* ----------------------------------------------------------------------------------
                                           MAIN
   ---------------------------------------------------------------------------------- */

int main(void)
{

  uint8_t   oldsek;
  char      i2c_present;
  int       wid_wert, ntc_temp;


  sysclock_init(0);
  adc_init(4);                          // Spannung an Pin PD3 !!! messe entspr. Channel 4

  delay_ms(400);

  digit4_init();

  retast_init();
  midtast_init();
  litast_init();
  i2c_present= ds1307_init();

  if (!i2c_present)                     // I2C Adresse 0xD0 antwortet nicht
  {
    while(1)
    {
      digit4_sethex(ds1307_addr);       // fehlende I2C-Adresse blinken lassen
      delay_ms(300);
      digit4_setall(0xff, 0xff, 0xff, 0xff);
      delay_ms(300);
    }
  }

  ds1307_settime(0x16, 0x01, 0x01, 0x10, 0x11 , 0x00);    // 01.01.2016  10.11:00

  oldsek= sek;

  digit4_sethex(std << 8 | min);

  while(1)
  {
    do
    {
      ds1307_readtime();

      if ( is_midtast() )                                 // Stundentaste
      {
        std= ds1307_read(2) & 0x3f;
        delay_ms(50);
        while( is_midtast() )
        {
          std= bcd2dez(std);
          delay_ms(250);
          if (is_litast() )                               // Taste fuer runterzaehlen
          {
            if (std> 0) { std--; } else { std= 23; }
          }
          else
          {
            std++;
            std= std % 24;
          }
          std= dez2bcd(std);
          digit4_sethex(std << 8 | min);
          ds1307_write(2,std);                            // neu gestellte Stunde setzen
          delay_ms(10);
        }
        ds1307_write(0,0);
      }

      delay_ms(5);

      if ( is_retast() )                                 // Minutentaste
      {
        min= ds1307_read(1) & 0x3f;
        delay_ms(50);
        while( is_retast() )                             // Taste fuer runterzaehlen
        {
          min= bcd2dez(min);
          delay_ms(250);
          if (is_litast() )
          {
            if (min> 0) { min--; } else { min= 59; }
          }
          else
          {
            min++;
            min= min % 60;
          }
          min= dez2bcd(min);
          digit4_sethex(std << 8 | min);
          ds1307_write(1,min);                          // neu gesetzte Minute setzen
          delay_ms(10);
        }
        ds1307_write(0,0);
      }

    } while(sek == oldsek);
    oldsek= sek;
    sek= bcd2dez(sek);

    if ((sek % 15)>= 9)
    {
      do
      {
        wid_wert= get_widerstand(4);
        ntc_temp= ntc_calc(wid_wert, ntc_firstval, tempstep, &ntc_tab[0]);

        digit4_setall(0xff, 0xff, d4char_oo, d4char_C);
        digit4_setdez8bit(ntc_temp / 10, 2);

        ds1307_readtime();
        delay_ms(10);
        sek= bcd2dez(sek);
      } while( (sek % 15) != 0);
    }
    else
    {
      if (sek & 0x01) { digit4_setdp(2); } else { digit4_clrdp(2); }
      digit4_sethex(std << 8 | min);
    }
  }

}

