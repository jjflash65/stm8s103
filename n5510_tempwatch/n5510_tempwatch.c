/* -------------------------------------------------------
                       n5510_tempwatch.c

     - Widerstandsmessung mittels des internen ADC
     - Umrechnung Widerstand => Temperatur (NTC)
     - Einbindung der Softwareuhr in stm8_systimer
     - Anzeige auf N5510 GLCD (Nokia Display)
     - senden von Uhrzeit und Temperatur ueber RS232

     zusaetzliche Hardware :

       - 10 kOhm Widerstand
       - ein zu messender Widerstand
           ( fuer Temperaturbestimmung bspw. NTC_4,7k (Vishay 2381 640 66103) )

       - N5510 Display 84x48

       - 2 Taster + 2 Stck. 10 kOhm Widerstaende
       - RS232-Adapter

     MCU      :  STM8S103F3
     Takt     :  externer Quarz 16 MHz

     18.08.2016  R. Seelig
   ------------------------------------------------------ */

/*

------------------------------------------------------------------
                      STM8S103F3P6 Pinout
------------------------------------------------------------------

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


       ________________________________
      /                                \
      |   _________________________    |
      |  /                          \  |
      | |                            | |
      | |         N5510 GLCD         | |
      | |                            | |
      | |    (Nokia comp. Display)   | |
      | |                            | |
      |  \__________________________/  |
      \________________________________/
        |   |   |   |   |   |   |   |
        o   o   o   o   o   o   o   o
        1   2   3   4   5   6   7   8
       RST CE  DC  DIN CLK Vcc Lig GND


      Anschlussbelegung N5510 LCD
      Display                STM8S103F3P6
      ---------------------------------------------


      1  RST     .......     PC3  (      Pin.No.: 13)
      2  CE        GND
      3  DC      .......     PC4  (      Pin.No.: 14)
      4  DIN     .......     PC6  (MOSI, Pin.No.: 16)
      5  CLK     .......     PC5  (CLK,  Pin.No.: 15)
      6  Vcc      +3.3V
      7  LIGHT     GND
      8  GND       GND
*/


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
         | |   NTC 0.2 4,7K
         | |
         +-+
          |
          |
         ---
*/

/*
     2 Taster und LED:

     Set Taster angeschlossen an PB4
     Return Taster angeschlossen an PD2

     LED an PB5 ueber 560 Ohm nach +Ub geschalten
*/

#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "stm8_systimer.h"
#include "my_printf.h"
#include "stm8_glcd_nokia.h"
#include "uart.h"
#include "thermo84bmp.h"
#include "stm8watch2.h"


#define printf           my_printf
#define intv_time        300            // Verzoegerungszeit der Wiederholungsschleife
#define u_ref  331                      // Referenzspg. des ADC = 3,31 Volt
#define tem_xpos         3              // X-Offset der Ausgabeposition des Thermometerbitmaps
#define tempstep         5              // Schrittweite in Grad der NTC Look-up Tabelle von
                                        // einem Widerstandswert zum naechsten
#define ntc_firstval     -20            // Erster Temperaturwert in Grad der NTC Look-up Tabelle
#define stelldelay       250            // Verzoegerungszeit (ms) beim Uhrzeit stellen
#define tastdelay        180            // Entprellzeit fuer Tasten


// Widerstandstabelle fuer Vishay NTC 2381-640-66472 47k NTC,
// Reichelt Nr.: NTC-0,2 47k
// Erster Wert: 464,1 kOhm entspricht -20 Grad, Temperaturabstand der einzelnen
// Werte betraegt 5 Grad, somit entspricht der letzte Eintrag +65 Grad, ein
// 0 Byte signalisiertdas Ende der Tabelle

const int ntc_tab[] =
          { 4641, 3490, 2646, 2023, 1558, 1209,  945,  744,  589,
             470,  377,  304,  247,  201,  165,  136,  113,   94,
             0 };

char     outchannel = 1;                    // Ausgabekanal fuer putchar
                                            // 0 : LCD
                                            // 1 : RS232

#define sekled_init()     PB5_output_init()
#define sekled_set()      PB5_set()
#define sekled_clr()      PB5_clr()

#define sekled2_init()    PD1_output_init()
#define sekled2_set()     PD1_set()
#define sekled2_clr()     PD1_clr()

#define setbutton_init()  PB4_input_init()
#define is_setbutton()    ( !is_PB4() )

#define retbutton_init()  PD2_input_init()
#define is_retbutton()    ( !is_PD2() )


/* ---------------------------------------------------------
                 systimer_intervall

   wird zyklisch vom Timer1 Interrupt alle Millisekunde
   aufgerufen.
   --------------------------------------------------------- */
void systimer_intervall()
{
  if (millisek == 500) { sekled_clr(); sekled2_set(); }
  if (millisek == 0) { sekled_set(); sekled2_clr(); }
}


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
     liest den 10Bit-ADC und gibt den Messwert als Argument
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
                                         // wie Widerstandstoleranz, Leitungen, Messfehler
                                         // "wegkalibriert"
  return rx;
}

/* --------------------------------------------------------
                           ntc_calc

   kalkuliert aus einem gegebenen Wert mittels einer
   Wertetabelle die zu diesem Wert gehoehrende Temperatur

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

   Rueckgabewert ist die Temperatur * 10

   Bsp.: 233 entspricht 23,3 Grad
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
                           fillbar

   zeichnet ein ausgefuelltes Rechteck in der "Farbe" f

   mit den Koordinaten
   x1,y1 -> x2, y2 : linke obere Ecke zu rechte untere Ecke

   -------------------------------------------------------- */
void fillbar(char x1, char y1, char x2, char y2, char f)
{
  char x, y;
  for (y= y1; y< y2+1; y++)
    for (x= x1; x< x2+1; x++)
      putpixel(x,y,f);
}

/* ---------------------------------------------------------
                          show_tempbar

   zeichnet einen Temperaturbalken im Thermometer
   60 Grad entsprechen 30 Pixel auf der Anzeige
   Temperatur wird als Integer uebergeben und ist mit
   Faktor 10 multipliziert
   Bsp.: 286 entsprechen 28.6 Grad
   temp / 200 entspricht somit der Pixelaufloesung in Y-Achse

   y-Pixel 32 => -10 Grad
   y-Pixel 27 =>   0 Grad
   y-Pixel  2 => +50 Grad
 --------------------------------------------------------- */
void show_tempbar(int temp)

{
  char ypix;

  if (temp> 500) temp= 500;
  ypix= temp / 20;
  fillbar(tem_xpos+6, 2, tem_xpos+10, 32, 0);           // alte Anzeige loeschen
  fillbar(tem_xpos+6, 27- ypix, tem_xpos+10, 32, 1);
}

/* ---------------------------------------------------------
                          show_time

         zeigt die Variablen der Softwareuhr an
   --------------------------------------------------------- */
void show_time(void)
{
  if (std < 10) printf("0");
  printf("%d:",std);

  if (min < 10) printf("0");
  printf("%d.",min);

  if (sek < 10) printf("0");
  printf("%d",sek);
}

/* --------------------------------------------------------
   putchar

   wird von my-printf / printf aufgerufen und hier muss
   eine Zeichenausgabefunktion angegeben sein, auf das
   printf dann schreibt !
   -------------------------------------------------------- */
void putchar(char ch)
{
  switch(outchannel)
  {
    case 0  : { lcd_putchar(ch); break; }
    case 1  : { uart_putchar(ch); break; }
    default : break;
  }
}


/* ---------------------------------------------------------------------
                                  M A I N
   --------------------------------------------------------------------- */

int main(void)
{
  int  wid_wert, spg_wert, ntc_temp;
  char oldsek;

  sysclock_init(0);
  delay_ms(50);
  sysclock_init(1);                              // mit externem Quarz (auch als Zeitbasis)

  tim1_init();                                   // Timer1 - Interrupt = Uhr starten
  uart_init(19200);

  lcd_init();

  sekled_init();
  sekled2_init();
  setbutton_init();
  retbutton_init();

  std= 9; min= 9; sek= 57; year= 2016; month= 1; day= 1;
  directwrite= 0;
  printfkomma= 1;                               // Kommaausgaben mittels my_printf mit einer Kommastelle

  showimage(0, 0, &watchbmp[0],1);
  scr_update();
  delay_ms(2500);
  clrscr();
  showimage(tem_xpos, 0, &thermo84[0],1);
  rectangle(38, 14, 80, 26, 1);
  gotoxy(6,4);
  scr_update();
  outchannel= 1;

  printf("\n\n\r  --------------------");
  printf("\n\r  STM8S103F3P6");
  printf("\n\r  NTC 0,2 4,7K");
  printf("\n\r  --------------------\n\n\r");
  oldsek= sek + 1;
  while(1)
  {

    if (oldsek != sek)
    {
      oldsek= sek;
      spg_wert= get_spg(4);
      wid_wert= get_widerstand(4);
      ntc_temp= ntc_calc(wid_wert, ntc_firstval, tempstep, &ntc_tab[0]);

      outchannel= 1;                                // Ausgabe auf RS232

      printf("  ");
      show_time();
      printf(" T= %k oC   \r", ntc_temp);

      outchannel= 0;                                // Ausgabe auf LCD

      show_tempbar(ntc_temp);
      gotoxy(7,2);
      if (ntc_temp< 1000)                           // nur bis 99.9 Grad anzeigen
        printf("%k%cC",ntc_temp, 124);              // 124 = hochgestelltes kleines o
      else
        printf("------");

      gotoxy(6,5); show_time();

      scr_update();
    }

    if ( is_setbutton() )                           // wenn Set Button gedrueckt
    {                                               // Uhr stellen
      int_disable();
      delay_ms(tastdelay);
      outchannel= 0;                                // Ausgabe auf LCD

      gotoxy(7,4); putchar(126);
      scr_update();

      while ( !is_retbutton() )                     // solange keine Return Taste
      {                                             // Stunden stellen
        if ( is_setbutton() )
        {
          std++;
          std= std % 24;
          gotoxy(6,5); show_time();
          delay_ms(stelldelay);
          scr_update();
        }
      }
      delay_ms(tastdelay);
      gotoxy(7,4); putchar(' ');
      gotoxy(10,4); putchar(126);
      scr_update();

      while ( !is_retbutton() )                     // solange keine Return Taste
      {                                             // Minuten stellen
        if ( is_setbutton() )
        {
          min++;
          min= min % 60;
          gotoxy(6,5); show_time();
          delay_ms(stelldelay);
          scr_update();
        }
      }
      delay_ms(tastdelay);
      gotoxy(10,4); putchar(' ');
      gotoxy(13,4); putchar(126);
      scr_update();

      while ( !is_retbutton() )                     // solange keine Return Taste
      {                                             // Seknuden stellen
        if ( is_setbutton() )
        {
          sek++;
          sek= sek % 60;
          gotoxy(6,5); show_time();
          delay_ms(stelldelay);
          scr_update();
        }
      }
      delay_ms(tastdelay);
      gotoxy(13,4); putchar(' ');
      scr_update();
      millisek= 0;

      int_enable();
    }

  }
}
