/* -------------------------------------------------------
                         txlcd_demo.c

     Demoprogramm fuer erstes Lebenszeichen des Displays

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     23.06.2016  R. Seelig
   ------------------------------------------------------ */

#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "txlcd.h"
#include "my_printf.h"

#define printf       my_printf                  // my_printf auf printf umleiten

#define lcdrow       2                          // Anzahl Zeilen des Displays, 2 oder 4
/*
      Anschluss am Bsp. Pollin-Display C0802-04
      -------------------------------------------------------------------------
         o +5V
         |                            Display            STM8S103F3P6 Controller
         _                        Funktion   PIN            PIN    Funktion
        | |
        |_| 1,8k                     GND      1 ------------
         |                          +5V       2 ------------
         o----o Kontrast   ---    Kontrast    3 ------------
         |                            RS      4 ------------   12    PB4
         _                           GND      5 ------------
        | |                    (Takt) E       6 ------------   13    PC3
        |_| 150                      D4       7 ------------   14    PC4
         |                           D5       8 ------------   15    PC5
        ---  GND                     D6       9 ------------   16    PC6
                                     D7      10 ------------   11    PB5



      Anschluss am Bsp. Standarddisplay mit 14 Anschluessen (ohne LED)
      --------------------------------------------------------------------------
         o +5V
         |                            Display            STM8S103F3P6 Controller
         _                        Funktion   PIN            PIN    Funktion
        | |
        |_| 1,8k                     GND      1 ------------
         |                          +5V       2 ------------
         o----o Kontrast   ---    Kontrast    3 ------------
         |                            RS      4 ------------   12    PB4
         _                           GND      5 ------------
        | |                    (Takt) E       6 ------------   13    PC3
        |_| 150                      D0       7 ------------   n.c.
         |                           D1       8 ------------   n.c.
        ---  GND                     D2       9 ------------   n.c.
                                     D3      10 ------------   n.c.
                                     D4      11 ------------   14    PC4
                                     D5      12 ------------   15    PC5
                                     D6      13 ------------   16    PC6
                                     D7      14 ------------   11    PB5


         Portpins des Controllers MUESSEN Pop-Up Widerstaende 10 kOhm an
         +5V angeschlossen haben !!!
*/

static const unsigned char hoch2bmp[8] =                  // Math. Quadratzeichen
  { 0x06, 0x01, 0x06, 0x08, 0x0f, 0x00, 0x00, 0x00};


/* --------------------------------------------------------
   putchar

   wird von my-printf / printf aufgerufen und hier muss
   eine Zeichenausgabefunktion angegeben sein, auf das
   printf dann schreibt !
   -------------------------------------------------------- */
void putchar(char ch)
{
  txlcd_putchar(ch);
}


int main(void)
{
  uint16_t  cnt;

  sysclock_init(0);                     // erst Initialisieren mit internem RC
//  sysclock_init(1);                     // .. und dann auf externen Quarz umschalten

  txlcd_init();
  delay_ms(500);
  txlcd_setuserchar(0,&hoch2bmp[0]);

  cnt= 0;

  gotoxy(1,1); printf(" STM8 S103 F3P6");
  gotoxy(1,2); printf(" TX-LCD ");

  #if (lcdrow == 4)
    gotoxy(1,4); printf("10.2016-R.Seelig");
  #endif

  delay_ms(2000);
  gotoxy(1,2); printf("        ");
  while(1)
  {
    gotoxy(4,2);
    printf("%d%c= %d ",cnt,0,cnt*cnt);
    cnt++;
    cnt= cnt % 31;
    if (!cnt)
    {
      gotoxy(4,2); printf("        ");
    }
    delay_ms(1000);
  }
}
