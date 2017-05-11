/* -------------------------------------------------------
                        txlcd_595.h

     Header zur Ansteuerung eines HD44780 kompatibles
     Textdisplay welches ueber ein Schieberegister
     SN74HC595 angesprochen wird.

     Betrieb des Displays im 4-Bit Modus

     Anmerkung: ein HCT - Typ kann hier NICHT verwendet
                werden, da diese eine mindest UB von
                4,5V benoetigt

     Hardware : 74HC595
              : HD44780 komp. Display (hier 0802 Pollin
                Display)

     MCU      : STM8S103F3
     Takt     : interner Takt 16 MHz

     26.10.2016  R. Seelig
   ------------------------------------------------------ */

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


   --------------------------------------------------------
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

#include "txlcd_595.h"

uint8_t sr_value;                       // beinhaltet immer das zuletzt ausgegebene
                                        // Byte des Schieberegisters. Dieses Byte
                                        // wird per Bitoperationen manipuliert
                                        // um jeweils ein einzelnes Bit des
                                        // Schieberegisterausgangs setzen / loeschen
                                        // zu koennen !

char wherex, wherey;


/* -------------------------------------------------------
     NIBBLEOUT

     sendet ein Halbbyte am Ausgang des Schieberegsters

         WERT= gesamtes Byte
         HILO= 1 => oberen 4 Bits werden ausgegeben
         HILO= 0 => untere 4 Bits werden ausgegeben
   ------------------------------------------------------- */
void nibbleout(unsigned char wert, unsigned char hilo)
{

  sr_value &= 0xf0;
  if (hilo)
  {
    sr_value |= ((wert >> 4) & 0x0f);
  }
  else
  {
    sr_value |= (wert & 0x0f);
  }
  sr595_outbyte(sr_value);
}

/* -------------------------------------------------------
      txlcd_takt

      gibt einen Clockimpuls an das Display
   ------------------------------------------------------- */

void txlcd_takt(void)
{
  clk_set();
  delay_us(60);
  clk_clr();
  delay_us(60);
}

/* -------------------------------------------------------
      txlcd_io

      sendet ein Byte an das Display an die in den
      Defines angegebenen Pins
              Wert = zu sendendes Byte
   ------------------------------------------------------- */

void txlcd_io(char wert)
{
  nibbleout(wert,1);
  txlcd_takt();
  nibbleout(wert,0);
  txlcd_takt();
}

/* -------------------------------------------------------
     txlcd_init

     bereitet das Display fuer den Betrieb vor.
     Es wird 4-Bit Datenuebertragung verwendet.

   ------------------------------------------------------- */

void txlcd_init(void)
{
  char i;
  sr_value= 0x00;
  sr595_outbyte(sr_value);

  rs_clr();
  for (i= 0; i< 3; i++)
  {
    txlcd_io(0x20);
    delay_ms(6);
  }
  txlcd_io(0x28);
  delay_ms(6);
  txlcd_io(0x0c);
  delay_ms(6);
  txlcd_io(0x01);
  delay_ms(6);
  wherex= 0; wherey= 0;
}

/* -------------------------------------------------------
     gotoxy

     setzt den Textcursor an eine Stelle im Display. Die
     obere linke Ecke hat die Koordinate (1,1)
   ------------------------------------------------------- */

void gotoxy(char x, char y)
{
  unsigned char txlcd_adr, b;

  y--;
  x--;
  txlcd_adr= 0x80 + (( (y & 0x01) * 0x40)  + x);

  // fuer 4 zeilige Displays
  b= (y & 0x02);                     // 3. oder 4 Zeile angewaehlt
  txlcd_adr |= b << 3;               // ... und Zeichenadressoffset berechnen

  rs_clr();
  txlcd_io(txlcd_adr);
  wherex= x+1;
  wherey= y+1;
}

/* -------------------------------------------------------
     txlcd_setuserchar

     kopiert die Bitmap eines benutzerdefiniertes Zeichen
     in den Charactergenerator des Displaycontrollers

               nr : Position im Ram des Displays, an
                    der die Bitmap hinterlegt werden
                    soll.
        *userchar : Zeiger auf die Bitmap des Zeichens

   Bsp.:  txlcd_setuserchar(3,&meinezeichen[0]);
          txlcd_putchar(3);

   ------------------------------------------------------- */


void txlcd_setuserchar(char nr, const char *userchar)
{
  char b;

  rs_clr();
  txlcd_io(0x40+(nr << 3));                         // CG-Ram Adresse fuer eigenes Zeichen
  rs_set();
  for (b= 0; b< 8; b++) txlcd_io(*userchar++);
  rs_clr();
}


/* -------------------------------------------------------
     txlcd_putchar

     platziert ein Zeichen auf dem Display.

               CH = auszugebendes Zeichen
   ------------------------------------------------------- */

void txlcd_putchar(char ch)
{
  rs_set();
  txlcd_io(ch);
  wherex++;
}
