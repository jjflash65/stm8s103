/* ------------------------------------------------
                   oled_uhr.c

   Analoge Uhrendarstellung auf einem OLED-
   Display

   Benoetigte Hardware;

            - SSD1306 OLED Display
            - 2 Taster
            - 47k NTC

   MCU   :  STM8S103F3
   Takt  :  externer Takt 16 MHz

   21.12.16 by R. Seelig

  -------------------------------------------------- */

#include <stdlib.h>                             // fuer abs()
#include <stdint.h>
#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "stm8_systimer.h"

#include "./ssd1306_softspi.h"

#define tast1_init()    PB4_input_init()
#define is_tast1()      (!is_PB4())
#define tast2_init()    PD2_input_init()
#define is_tast2()      (!is_PD2())

#define tasthispeed     70
#define tastlospeed     400

volatile uint16_t intv_ticker = 0;

char wtag[][3] = {"So", "Mo", "Di", "Mi", "Do", "Fr", "Sa"};


#define uhr_x           32                     // Mittelpunkt der Zeiger
#define uhr_y           32
#define std_zeigersize 21
#define min_zeigersize 25
#define uhr_ri          (min_zeigersize+2)    // innere Skalierung
#define uhr_ra          (uhr_ri+3)             // aeussere Skalierung


#define cos_0           0
#define sin_0           1
#define cos_6           0.10452
#define sin_6           0.99452
#define cos_12          0.20791
#define sin_12          0.97814
#define cos_18          0.30901
#define sin_18          0.95105
#define cos_24          0.40673
#define sin_24          0.91354
#define cos_30          0.5
#define sin_30          0.86602
#define cos_36          0.58778
#define sin_36          0.80901
#define cos_42          0.66913
#define sin_42          0.74314
#define cos_48          0.74314
#define sin_48          0.66913
#define cos_54          0.80901
#define sin_54          0.58778
#define cos_60          0.86602
#define sin_60          0.5
#define cos_66          0.91354
#define sin_66          0.40673
#define cos_72          0.95105
#define sin_72          0.30901
#define cos_78          0.97814
#define sin_78          0.20791
#define cos_84          0.99452
#define sin_84          0.10452
#define cos_90          1
#define sin_90          0



typedef const struct{
  int x1;
  int y1;
  int x2;
  int y2;
} line_typ;


const line_typ uhr[] =
{
  {+uhr_ri *  cos_0, -uhr_ri *  sin_0, +uhr_ra *  cos_0, -uhr_ra *  sin_0},
  {+uhr_ri * cos_30, -uhr_ri * sin_30, +uhr_ra * cos_30, -uhr_ra * sin_30},
  {+uhr_ri * cos_60, -uhr_ri * sin_60, +uhr_ra * cos_60, -uhr_ra * sin_60},
  {+uhr_ri * cos_90, -uhr_ri * sin_90, +uhr_ra * cos_90, -uhr_ra * sin_90},

  {+uhr_ri * cos_60, +uhr_ri * sin_60, +uhr_ra * cos_60, +uhr_ra * sin_60},
  {+uhr_ri * cos_30, +uhr_ri * sin_30, +uhr_ra * cos_30, +uhr_ra * sin_30},
  {+uhr_ri *  cos_0, +uhr_ri *  sin_0, +uhr_ra *  cos_0, +uhr_ra *  sin_0},

  {-uhr_ra * cos_30, -uhr_ra * sin_30, -uhr_ri * cos_30, -uhr_ri * sin_30},
  {-uhr_ra * cos_60, -uhr_ra * sin_60, -uhr_ri * cos_60, -uhr_ri * sin_60},
  {-uhr_ra * cos_90, -uhr_ra * sin_90, -uhr_ri * cos_90, -uhr_ri * sin_90},

  {-uhr_ra * cos_60, +uhr_ra * sin_60, -uhr_ri * cos_60, +uhr_ri * sin_60},
  {-uhr_ra * cos_30, +uhr_ra * sin_30, -uhr_ri * cos_30, +uhr_ri * sin_30}
};



const int  std_zeiger[] = {
  std_zeigersize * cos_0,
  std_zeigersize * cos_6,
  std_zeigersize * cos_12,
  std_zeigersize * cos_18,
  std_zeigersize * cos_24,
  std_zeigersize * cos_30,
  std_zeigersize * cos_36,
  std_zeigersize * cos_42,
  std_zeigersize * cos_48,
  std_zeigersize * cos_54,
  std_zeigersize * cos_60,
  std_zeigersize * cos_66,
  std_zeigersize * cos_72,
  std_zeigersize * cos_78,
  std_zeigersize * cos_84,
  std_zeigersize * cos_90
};

const int min_zeiger[] = {
  min_zeigersize * cos_0,      // 0
  min_zeigersize * cos_6,      // 1
  min_zeigersize * cos_12,     // 2
  min_zeigersize * cos_18,     // 3
  min_zeigersize * cos_24,     // 4
  min_zeigersize * cos_30,     // 5
  min_zeigersize * cos_36,     // 6
  min_zeigersize * cos_42,     // 7
  min_zeigersize * cos_48,     // 8
  min_zeigersize * cos_54,     // 9
  min_zeigersize * cos_60,     // 10
  min_zeigersize * cos_66,     // 11
  min_zeigersize * cos_72,     // 12
  min_zeigersize * cos_78,     // 13
  min_zeigersize * cos_84,     // 14
  min_zeigersize * cos_90      // 15
};


#define tempstep         5
#define  ntc_firstval   -20

// Widerstandstabelle fuer Vishay NTC 2381-640-66472 47k NTC,
// Reichelt Nr.: NTC-0,2 47k
// Erster Wert: 464,1 kOhm entspricht -20 Grad, Temperaturabstand der einzelnen
// Werte betraegt 5 Grad, somit entspricht der letzte Eintrag +65 Grad, ein
// 0 Byte signalisiertdas Ende der Tabelle

const int ntc_tab[] =
          { 4641, 3490, 2646, 2023, 1558, 1209,  945,  744,  589,
             470,  377,  304,  247,  201,  165,  136,  113,   94,
             0 };


/* -------------------------------------------------------
                 get_zeiger_value

   Berechnet ausgehend von einer 0,0 Koordinate die
   x,y Position fuer den Winkel w und gibt diese in
   x,y zurueck
   ------------------------------------------------------- */
void get_zeiger_value(int w, const int *tab_ptr, int *x, int *y)
{
  if (w < 15)
  {
    *x = tab_ptr[w];
    *y = -(tab_ptr[15-w]);
  }
  else
  {
    if (w < 30)
    {
      *x = tab_ptr[30-w];
      *y = tab_ptr[w-15];
    }
    else
    {
      if (w < 45)
      {
        *x = -(tab_ptr[w-30]);
        *y = tab_ptr[45-w];
      }
      else
      {
        *x = -(tab_ptr[60-w]);
        *y = -(tab_ptr[w-45]);
      }
    }
  }
}

/* -------------------------------------------------------
                        analoguhr
     zeichnet die Uhreinteilung und die Zeiger der Uhr
   ------------------------------------------------------- */
void analoguhr(int std, int min, int sek, char drawmode)
{
  int i;
  int x, y;

  while(std> 12) std -= 12;
  while(min > 60) min -= 60;
  while(sek > 60) sek -= 60;

  for(i=0; i<12; i++)
  {
    line( uhr_x + uhr[i].x1,
          uhr_y + uhr[i].y1,
          uhr_x + uhr[i].x2,
          uhr_y + uhr[i].y2,
          drawmode);
  }

  get_zeiger_value(min, min_zeiger, &x, &y);
  line(uhr_x, uhr_y, uhr_x+x, uhr_y+y, drawmode);

  if (abs(x) > abs(y))
  {
    line(uhr_x, uhr_y+1, uhr_x+x, uhr_y+y+1, drawmode);
  }
  else
  {
    line(uhr_x+1, uhr_y, uhr_x+x+1, uhr_y+y, drawmode);
  }

  std = std * 5;
  while(min >= 12)
  {
    min -= 12;
    std++;
  }

  get_zeiger_value(std, std_zeiger, &x, &y);
  line(uhr_x, uhr_y, uhr_x+x, uhr_y+y, drawmode);

  if (abs(x) > abs(y))
  {
    line(uhr_x, uhr_y+1, uhr_x+x, uhr_y+y+1, drawmode);
  }
  else
  {
    line(uhr_x+1, uhr_y, uhr_x+x+1, uhr_y+y, drawmode);
  }
  get_zeiger_value(sek, min_zeiger, &x, &y);
  line(uhr_x, uhr_y, uhr_x+x, uhr_y+y, drawmode);

}

void putchar(uint8_t ch)
{
  oled_putchar(ch);
}

/* -------------------------------------------------------
                          puts
     Zeigt einen AsciiZ String an, auf den der Zeiger
     zeigt.

     Bsp.:   puts("Hallo Welt);
   ------------------------------------------------------ */
void puts(char *p)
{
  do
  {
    putchar( *p );
    p++;
  }while(*p);

}

/* -------------------------------------------------------
                          putdez2
     zeigt die 2 stellige, vorzeichenbehaftete dezimale
     Zahl in val an.

     mode greift bei Zahlen kleiner 10:

     mode        0  : es wird eine fuehrende 0 ausgegeben
                 1  : es wird anstelle einer 0 ein Leer-
                      zeichen ausgegeben
                 2  : eine fuehrende 0 wird unterdrueckt
   ------------------------------------------------------- */

void putdez2(signed char val, uint8_t mode)
{
  char b;
  if (val < 0)
  {
    putchar('-');
    val= -val;
  }
  b= val / 10;
  if (b == 0)
  {
    switch(mode)
    {
      case 0 : putchar('0'); break;
      case 1 : putchar(' '); break;
      default : break;
    }
  }
  else
    putchar(b+'0');
  b= val % 10;
  putchar(b+'0');
}

/* -------------------------------------------------------
                      systimer_intervall
   wird jede ms vom Systemtimer-Interrupt aufgerufen
   ------------------------------------------------------ */
void systimer_intervall(void)
{
  intv_ticker++;
  intv_ticker = intv_ticker % 30000;
}

/* -------------------------------------------------------
                      tast2_counter

      Zaehlt Variable cnt hoch, wenn Taster 2 gedrueckt
      ist. Bleibt Taster 2 laengere Zeit gedrueckt, wird
      die Zaehlfrequenz erhoeht.
      Der Zaehlwert ist das Rueckgabeergebnis

      outx,outy    : Koordinaten auf dem Display an
                     der das Zaehlen angezeigt wird

      maxcnt       : Maximalwert-1, den die Variable cnt
                     erreichen kann.
      addtocnt     : Offsetwert, der zum Zaehlergebnis
                     hinzuaddiert wird
   ------------------------------------------------------ */
uint8_t tast2_counter(uint8_t outx, uint8_t outy, uint8_t maxcnt, uint8_t cnt, uint8_t addtocnt)
{
  uint16_t cntspeed;

  delay_ms(50);
  intv_ticker= 0;
  cntspeed= tastlospeed;
  while(is_tast2())
  {
    if (intv_ticker> 2000) cntspeed= tasthispeed;
    cnt++;
    cnt = cnt % maxcnt;
    gotoxy(outx,outy);
    putdez2(cnt+addtocnt,2);
    putchar(' ');
    delay_ms(cntspeed);
  }
  delay_ms(50);
  return (cnt+addtocnt);
}

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

   temp= ntc_calc(185, -20, -5, &ntc_tab[0]);

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


/* -------------------------------------------------------
                           getwtag
   Wochentagsberechnung nach Carl-Friedrich-Gauss

   liefert den Wochentag zu einem Datum zurueck:
   0 = Sonntag  .. 6 = Samstag
   ------------------------------------------------------- */

char getwtag(int tag, int monat, int jahr)
{
  int w_tag;

  if (monat < 3)
  {
     monat = monat + 12;
     jahr--;
  }
  w_tag = (tag+2*monat + (3*monat+3)/5 + jahr + jahr/4 - jahr/100 + jahr/400 + 1) % 7 ;
  return w_tag;
}


/* -------------------------------------------------------
                      stellen_screen
   ------------------------------------------------------ */
void stellen_screen(void)
{
  clrscr();
  gotoxy(0,0); puts("Uhr stellen\n\r----------------");
  puts("\n\rStunde :");
  puts("\n\rMinute :");
  puts("\n\rJahr   :");
  puts("\n\rMonat  :");
  puts("\n\rTag    :");
}

/* -------------------------------------------------------
                      uhr_show
   ------------------------------------------------------ */
void uhr_show(void)
{
  int8_t  temp;
  int16_t rval;

  analoguhr(std,min,sek, 1);
  fb_show(64,0);
  analoguhr(std,min,sek, 0);

  gotoxy(0,0);
  putdez2(std,1); putchar(':');
  putdez2(min,0); putchar('.');
  putdez2(sek,0);

  temp= getwtag(day, month, year);
  gotoxy(0,5); puts(wtag[temp]);
  gotoxy(0,6);
  putdez2(day,0); putchar('.');
  putdez2(month,0); putchar('.');
  putdez2(year,0);

  rval= get_widerstand(4);
  temp= (ntc_calc(rval, ntc_firstval, tempstep, &ntc_tab[0])) / 10;

  gotoxy(2,3);
  putdez2(temp,1);
  putchar(130);               // hochgestelltes kleines o = Gradzeichen
  putchar('C');
  putchar(' ');

}

/* ------------------------------------------------------------------------------------------------------------------
                                                    M-A-I-N
   ------------------------------------------------------------------------------------------------------------------ */
int main(void)
{
  uint8_t my_std, my_min, my_year, my_month, my_day;
  uint8_t z_year, e_year;
  uint8_t oldsek;

  sysclock_init(0);                     // zuerst System fuer internen Takt
  delay_ms(200);
  sysclock_init(1);                     // externer Quarz
  oled_init();
  clrscr();
  fb_init(64,8);
  fb_clear();
  tim1_init();

  year= 17; month= 7; day= 5; std= 0; min= 0; sek= 0;

  oldsek= 61;
  circle(uhr_x, uhr_y, 31, 1);

  while(1)
  {
    uhr_show();

    while(oldsek == sek)
    {
      if (is_tast1())
      {
        stellen_screen();
        my_std= std; my_min= min; my_year= year; my_month= month; my_day= day;
        gotoxy(10,3); putdez2(my_std,2); putchar(' ');

        delay_ms(50);
        while(is_tast1());
        delay_ms(50);

        while(!is_tast1())
        {
          if (is_tast2())
          {
            my_std= tast2_counter(10,3,24, my_std, 0);
          }
        }
        delay_ms(50);
        while(is_tast1());
        delay_ms(50);

        gotoxy(10,4); putdez2(my_min,2); putchar(' ');
        while(!is_tast1())
        {
          if (is_tast2())
          {
            my_min= tast2_counter(10,4,60, my_min, 0);
          }
        }
        delay_ms(50);
        while(is_tast1());
        delay_ms(50);

        z_year= (my_year % 100) / 10;
        gotoxy(10,5); puts("20");
        putdez2(z_year,2);
        while(!is_tast1())
        {
          if (is_tast2())
          {
            z_year= tast2_counter(12,5,10, z_year, 0);
          }
        }
        delay_ms(50);
        while(is_tast1());
        delay_ms(50);

        e_year= my_year % 10;
        gotoxy(10,5); puts("20");
        putdez2(z_year,2);
        putdez2(e_year,2);

        while(!is_tast1())
        {
          if (is_tast2())
          {
            e_year= tast2_counter(13,5,10, e_year, 0);
          }
        }
        my_year= (z_year*10)+e_year;
        delay_ms(50);
        while(is_tast1());
        delay_ms(50);

        gotoxy(10,6); putdez2(my_month,2); putchar(' ');
        while(!is_tast1())
        {
          if (is_tast2())
          {
            my_month= tast2_counter(10,6,12, my_month-1, 1);
          }
        }
        delay_ms(50);
        while(is_tast1());
        delay_ms(50);

        gotoxy(10,7); putdez2(my_day,2); putchar(' ');
        while(!is_tast1())
        {
          if (is_tast2())
          {
            if ((my_month == 2) && ((my_year % 4) == 0))           // Februar im Schaltjahr
              my_day= tast2_counter(10,7,29, my_day-1, 1);
            else
            if ((my_month == 2) && ((my_year % 4) > 0))           // Februar im Nichtschaltjahr
              my_day= tast2_counter(10,7,28, my_day-1, 1);
            else
            if ((my_month==4) || (my_month==6) || (my_month==9) || (my_month== 11))
              my_day= tast2_counter(10,7,30, my_day-1, 1);
            else
              my_day= tast2_counter(10,7,31, my_day-1, 1);
          }
        }
        delay_ms(50);
        while(is_tast1());
        delay_ms(50);


        std= my_std; min= my_min; sek= 0; oldsek= 61;
        year= (z_year * 10) + (e_year); month= my_month; day= my_day;
        clrscr();

        fb_clear();
        circle(uhr_x, uhr_y, 31, 1);
      }
    }
    oldsek= sek;
  }
}
