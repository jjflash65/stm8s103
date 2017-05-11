/* -------------------------------------------------------
                         txlcd.c

     Library fuer HD44780 kompatible Displays

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     23.06.2016  R. Seelig
   ------------------------------------------------------ */

/*
      Anschluss am Bsp. Pollin-Display C0802-04

      ---------------------------------------------------
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

#include "txlcd.h"

char wherex, wherey;

/* -------------------------------------------------------
     NIBBLEOUT

     sendet ein Halbbyte an das LC-Display an die in
     den Defines angegebenen Pins

         WERT= gesamtes Byte
         HILO= 1 => oberen 4 Bits werden gesendet
         HILO= 0 => untere 4 Bits werden gesendet
   ------------------------------------------------------- */

void nibbleout(unsigned char wert, unsigned char hilo)
{
  if (hilo)
  {
     if (testbit(wert,7)) { txlcd_d7_set(); }
                    else  { txlcd_d7_clr(); }
     if (testbit(wert,6)) { txlcd_d6_set(); }
                    else  { txlcd_d6_clr(); }
     if (testbit(wert,5)) { txlcd_d5_set(); }
                    else  { txlcd_d5_clr(); }
     if (testbit(wert,4)) { txlcd_d4_set(); }
                    else  { txlcd_d4_clr(); }
  }

  else
  {
     if (testbit(wert,3)) { txlcd_d7_set(); }
                    else  { txlcd_d7_clr(); }
     if (testbit(wert,2)) { txlcd_d6_set(); }
                    else  { txlcd_d6_clr(); }
     if (testbit(wert,1)) { txlcd_d5_set(); }
                    else  { txlcd_d5_clr(); }
     if (testbit(wert,0)) { txlcd_d4_set(); }
                    else  { txlcd_d4_clr(); }

  }
}

/* -------------------------------------------------------
      txlcd_takt

      gibt einen Clockimpuls an das Display
   ------------------------------------------------------- */

void txlcd_takt(void)
{
  txlcd_e_set();
  delay_us(60);
  txlcd_e_clr();
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
     txlcd_pininit

     setzt die zur Verwendung benoetigten Anschlusspins
     als Ausgaenge
   ------------------------------------------------------- */

void txlcd_pininit(void)
{
  txlcd_rs_init();
  txlcd_e_init();
  txlcd_d4_init();
  txlcd_d5_init();
  txlcd_d6_init();
  txlcd_d7_init();
}

/* -------------------------------------------------------
     txlcd_init

     bereitet das Display fuer den Betrieb vor. Die in
     den Defines gegebenen Anschluesse des Displays
     werden auf Ausgang geschaltet.
     Es wird 4-Bit Datenuebertragung verwendet.

   ------------------------------------------------------- */

void txlcd_init(void)
{
  char i;

  txlcd_pininit();
  txlcd_rs_clr();
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

  txlcd_rs_clr();
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

  txlcd_rs_clr();
  txlcd_io(0x40+(nr << 3));                         // CG-Ram Adresse fuer eigenes Zeichen
  txlcd_rs_set();
  for (b= 0; b< 8; b++) txlcd_io(*userchar++);
  txlcd_rs_clr();
}


/* -------------------------------------------------------
     txlcd_putchar

     platziert ein Zeichen auf dem Display.

               CH = auszugebendes Zeichen
   ------------------------------------------------------- */

void txlcd_putchar(char ch)
{
  txlcd_rs_set();
  txlcd_io(ch);
  wherex++;
}
