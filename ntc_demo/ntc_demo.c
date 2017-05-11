/* -------------------------------------------------------
                         ntc_demo.c

     - Widerstandsmessung mittels des internen ADC

     Hardware :
       - 10 kOhm Widerstand
       - ein zu messender Widerstand
           ( fuer Temperaturbestimmung bspw. NTC_10k (Vishay 2381 640 66103) )

     MCU      :  STM8S103F3
     Takt     :  interner Takt 16 MHz

     24.06.2016  R. Seelig
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
         | |   Rx
         | |
         +-+
          |
          |
         ---
*/



#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "my_printf.h"
#include "uart.h"

#define printf           my_printf

#define intv_time        300            // Verzoegerungszeit der Wiederholungsschleife

#define u_ref  331                      // Referenzspg. des ADC = 3,31 Volt


#define tempstep         5
#define  ntc_firstval   -20


// Widerstandstabelle fuer Vishay NTC 2381-640-66472 4,7k NTC,
// Reichelt Nr.: NTC-0,2 4,7k
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


/* ---------------------------------------------------------
                           get_spg
     ermittelt die am angegebenen Analogeingang (AIN3 oder
     AIN4) anliegende Spannung.

     Diese Funktion benoetigte ein globales

                      #define u_ref

     das vorgibt, welcher Spannungswert (Betriebsspannung
     des MCU) einem  ADC-Wert von 1023 entspricht.
   --------------------------------------------------------- */

uint16_t get_spg(char channel)
{
  long l;

  adc_init(channel);
  l= adc_read();

  l= u_ref * l;
  l= l / 1023;                        // 10 Bit Aufloesung
  return (uint16_t) l;
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

/* --------------------------------------------------------
   putchar

   wird von my-printf / printf aufgerufen und hier muss
   eine Zeichenausgabefunktion angegeben sein, auf das
   printf dann schreibt !
   -------------------------------------------------------- */
void putchar(char ch)
{
  uart_putchar(ch);
}

/* ---------------------------------------------------------------------
                                  M A I N
   --------------------------------------------------------------------- */

int main(void)
{
  int  wid_wert, spg_wert, ntc_temp;

  sysclock_init(0);
  uart_init(19200);

  printf("\n\n\r--------------------");
  printf("\n\rWiderstandserfassung");
  printf("\n\rUART 19200 bd 8N1");
  printf("\n\r--------------------\n\n\r");
  while(1)
  {

    spg_wert= get_spg(4);
    wid_wert= get_widerstand(4);
    ntc_temp= ntc_calc(wid_wert, ntc_firstval, tempstep, &ntc_tab[0]);

    printfkomma= 2;                               // zwei Kommastelle bei printf-formater k
    printf("  U_in= %k V   ", spg_wert);

    printfkomma= 1;
    printf("  R= %k kOhm  T= %k oC   \r", wid_wert, ntc_temp);

    delay_ms(500);

  }
}
