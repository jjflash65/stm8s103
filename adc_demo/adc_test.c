/* -------------------------------------------------------
                         adc_test.c

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     19.05.2016  R. Seelig
   ------------------------------------------------------ */

#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "my_printf.h"
#include "uart.h"

#define printf               my_printf

#define bled_output_init()   PB5_output_init()
#define bled_set()           PB5_set()
#define bled_clr()           PB5_clr()


#define u_ref                331            // gemessene Betriebsspg.: 3.31 V ( * 100 )

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
  uint16_t  adcvalue, spg_wert;
  char      ledflag = 0;

  sysclock_init(0);

  printfkomma= 2;

  uart_init(19200);
  bled_output_init();

  bled_clr();
  printf("\n\n\r-----------------");
  printf("\n\rADC-Demo");
  printf("\n\rUART 19200 bd 8N1");
  printf("\n\r-----------------\n\n\r");
  adc_init(3);
  while(1)
  {

    adcvalue= adc_read();
    spg_wert= value2spg(adcvalue);

    printf(" ADC : %d   ", adcvalue);
    printf(" Spg.: %k V     \r", spg_wert);
    ledflag = ~(ledflag);
    if (ledflag) bled_set(); else bled_clr();

    delay_ms(intv_time);

  }
}
