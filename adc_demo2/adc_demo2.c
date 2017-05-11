/* -------------------------------------------------------
                         adc_demo2.c

     misst die Spannung an Pin PD3 und zeigt diese auf
     dem 4 stelligen 7-Segmentmodul (mit 74HC595 Schiebe-
     registern) an.

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     19.05.2016  R. Seelig
   ------------------------------------------------------ */

#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "seg7anz_v2.h"


#define u_ref                326            // gemessene Betriebsspg.: 3.26 V ( * 100 )

#define intv_time            300            // Verzoegerungszeit der Wiederholungsschleife

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
  uint16_t  adcvalue, spg_wert;
  char      ledflag = 0;

  sysclock_init(0);
  digit4_init();                        // Modul initialisieren
  tim2_init();
  digit4_setdp(2);

  while(1)
  {
    adc_init(4);                        // Spannung an Pin PD3 !!! messe entspr. Channel 4
    adcvalue= adc_read();
    spg_wert= value2spg(adcvalue);
    digit4_setdez(spg_wert);

    delay_ms(intv_time);

  }
}
