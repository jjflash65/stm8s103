/* -------------------------------------------------------
                          txlcd_sr.c

     Ansteuerung eines HD44780 kompatibles Textdisplay
     welches ueber ein Schieberegister SN74HC595
     angesprochen wird.

     Betrieb des Displays im 4-Bit Modus

     Anmerkung: ein HCT - Typ kann hier NICHT verwendet
                werden, da diese eine mindest UB von
                4,5V benoetigt und der STM8 3,3V Betriebs-
                spannung besitzt.

                Ausgaenge des Schieberegisters sind ueber
                1 kOhm Pullup-Widerstaende nach 5V zu
                schalten um 5V Textdisplays in Betrieb
                nehmen zu koennen.

     Hardware : 74HC595
              : HD44780 komp. Display (hier 0802 Pollin
                Display)

     MCU      : STM8S103F3
     Takt     : interner Takt 16 MHz

     26.10.2016  R. Seelig
   ------------------------------------------------------ */

#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "txlcd_595.h"
#include "my_printf.h"


/* --------------------------------------------------------

 Pinbelegung:

 STM8S103F3      74HC595
                Pin  Funktion
  ----------------------------------------------------------
   PD3 -------- (14)   data
   PD2 -------- (12)   STCP ( Strobe, Uebernahme in Ausgangslatch )
   PD1 -------- (11)   SHCP ( Shift-clock, Takt )

                ( 8)   GND
                (10)   /MR  (Master Reset, auf +UB zu legen)
                (13)   /OE  (Output enable, fuer permanente Ausgabe
                             auf GND zu legen)
                (16)   +UB

                (15)   O0   Ausgang Datenbit 0
                ( 1)   O1   Ausgang Datenbit 1
                ( 2)   O2   Ausgang Datenbit 2
                ( 3)   O3   Ausgang Datenbit 3
                ( 4)   O4   Ausgang Datenbit 4
                ( 5)   O5   Ausgang Datenbit 5
                ( 6)   O6   Ausgang Datenbit 6
                ( 7)   O7   Ausgang Datenbit 7

*/

/* --------------------------------------------------------
     Anschlussbelegung Textdisplay an das Schieberegister


         SN74HC595        Display              SR_GPIO

            O0      ---     D4
            O1      ---     D5
            O2      ---     D6
            O3      ---     D7
            O4      ---     RS
            O5      ---     E    ( Clk )
            06      --------------------------    0
            07      --------------------------    1
*/


#define printf     my_printf
#define lcdrow       2                          // Anzahl Zeilen des Displays, 2 oder 4


void putchar(char ch)
{
  txlcd_putchar(ch);
}

static const unsigned char hoch2bmp[8] =                  // Math. Quadratzeichen
  { 0x06, 0x01, 0x06, 0x08, 0x0f, 0x00, 0x00, 0x00};




/* ---------------------------------------------------------------------------------
                                      M-A-I-N
   ---------------------------------------------------------------------------------*/

int main(void)
{
  int cnt= 0;

  sysclock_init(0);
  sr595_init();

  txlcd_init();
  txlcd_setuserchar(0,&hoch2bmp[0]);

  cnt= 0;

  gotoxy(2,1);printf(" STM8 ");
  gotoxy(1,2); printf(" TX-LCD ");

  #if (lcdrow == 4)
    gotoxy(1,4); printf("10.2016-R.Seelig");
  #endif

  delay_ms(2000);
  gotoxy(1,2); printf("        ");
  while(1)
  {
    gotoxy(1,2);
    printf("%d%c= %d ",cnt,0,cnt*cnt);
    cnt++;
    cnt= cnt % 31;
    if (!cnt)
    {
      gotoxy(1,2); printf("        ");
    }
    delay_ms(1000);
  }
}
