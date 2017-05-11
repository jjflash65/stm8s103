/* -------------------------------------------------------
                         ntc_7seg.c

    Temperaturmessung mittels NTC Widerstand

    Hardware :  10 kOhm Widerstand
                NTC_47K (Vishay 2381 640 66103) )
                      Reichelt Bestellnr.: NTC 0,2 47k
                4 Digit 7 Segmentmodul (Schieberegistervers.)


    MCU      :  STM8S103F3
    Takt     :  interner Takt 16 MHz

    26.08.2016  R. Seelig
   ------------------------------------------------------ */

/*
     +Ub (3.3V)

          ^
          |
         +-+
         | |   10k
         | |
         +-+
          |
          o----------o AIN4 / PD3  (Pin No. 20)
          |
         +-+
         | |   Rx   (NTC_47k)
         | |
         +-+
          |
          |
         ---

 ------------------------------------------------------
   Pinbelegung:

   4 Bit LED Digital Tube Module                 STM8S103F
   -------------------------------------------------------

       (shift-clock)   Sclk   -------------------- PD2
       (strobe-clock)  Rclk   -------------------- PD1
       (ser. data in)  Dio    -------------------- PA3
       (+Ub)           Vcc
                       Gnd


   Anzeigenposition 0 ist das rechte Segment des Moduls

            +-----------------------------+
            |  POS3   POS2   POS1   POS0  |
    Vcc  o--|   --     --     --     --   |
    Sclk o--|  |  |   |  |   |  |   |  |  |
    Rclk o--|  |  |   |  |   |  |   |  |  |
    Dio  o--|   -- o   -- o   -- o   -- o |
    GND  o--|                             |
            |   4-Bit LED Digital Tube    |
            +-----------------------------+

   Segmentbelegung der Anzeige:

       a
      ---
   f | g | b            Segment | dp |  g  |  f  |  e  |  d  |  c  |  b  |  a  |
      ---               --------------------------------------------------------
   e |   | c            Bit-Nr. |  7 |  6  |  5  |  4  |  3  |  2  |  1  |  0  |
      ---
       d

   Segmente leuchten bei einer logischen 0 (gemeinsame Kathode) !!!


*/

#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "seg7anz_v2.h"


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


// -------------------------------------------------------------------------------------

/* ---------------------------------------------------------
                           adc_init
     Makro (weil als Funktion deklariert eher mehr Flash-
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



/* ---------------------------------------------------------
                          value2spg
     Rechnet einen Zahlenwert von 0..1023 (10 Bit) in eine
     Spannung um, deren Maximum in der Konstante u_ref
     festgelegt ist.

     u_ref =  "Referenzspg." = 3,31V Betriebsspg. (gemessen)
     ergebnis = (ADC-Wert/Aufloesung) * u_ref

     Da bei Integerdivision (ADC-Wert / Aufloesung) IMMER 0 entsteht
     ( float-Ergebnisse waeren 0.55 bswp), ist die Reihenfolge der
     Rechnung eine andere: ergebnis = (ADC-Wert * u_ref) / Aufloesung)
   --------------------------------------------------------- */
uint16_t value2spg(uint16_t value)
{
  long     l;

  l= value;
  l= u_ref * l;
  l= l / 1023;                        // 10 Bit Aufloesung
  return (uint16_t) l;
}

/* ---------------------------------------------------------------------
                                  M A I N
   --------------------------------------------------------------------- */

int main(void)
{
  int  wid_wert, ntc_temp;

  sysclock_init(0);
  digit4_init();                        // Modul initialisieren
  adc_init(4);                          // Spannung an Pin PD3 !!! messe entspr. Channel 4


  #if(no_komma == 1)
    digit4_setall(0xff, 0xff, d4char_oo, d4char_C);
  #else
    digit4_setdp(1);
  #endif

  while(1)
  {
    wid_wert= get_widerstand(4);
    ntc_temp= ntc_calc(wid_wert, ntc_firstval, tempstep, &ntc_tab[0]);

    #if(no_komma == 1)
      digit4_setdez8bit(ntc_temp / 10, 2);
    #else
      digit4_setdez(ntc_temp);
      if (ntc_temp < 1000)
      {
        seg7_4digit[3]= 0xff;             // fuehrende
      }
      if (ntc_temp < 100)
      {
        seg7_4digit[2]= 0xff;             // fuehrende
      }
    #endif

    delay_ms(intv_time);

  }
}
