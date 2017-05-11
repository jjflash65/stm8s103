/* -------------------------------------------------------
                           i2c.c

     grundlegende Library zum Ansprechen des I2C Busses
     OHNE Interruptbenutzung

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     31.05.2016  R. Seelig
   ------------------------------------------------------ */

#include "tm1637.h"


/* -------------------------------------------------------
                         tm1637.c

     Library fuer 4-stellige 7-Segmentanzeigemodul
     mit TM1637 Chip

     MCU   :  STM8S103F3

     23.06.2016  R. Seelig
   ------------------------------------------------------ */

/*
     Anschlussbelegung: siehe tm1637.h

   ------------------------------------------------------
     Hinweis:
   ------------------------------------------------------

   Das Protokol des TM1637 Chip ist etwas "wunderlich", es arbeitet
   nach dem I2C Prinzip, jedoch hoert der Chip auf keine I2C-Adresse
   sondern ist grundsaetzlich aktiv. Aus diesem Grund wurde nicht das
   Hardware I2C des STM8S verwendet sondern der TM1637 wird mittels
   Bitbanging angesprochen.

   Ein Nebeneffekt hierbei ist, dass jeder beliebige I/O Pin verwendet
   werden kann.
*/

/* ----------------------------------------------------------
         verfuegbare Funktionen von tm1637.c :
   ----------------------------------------------------------

void tm1637_init(void);
void tm1637_start(void);
void tm1637_stop(void);
void tm1637_write (uint8_t value);
void tm1637_clear(void);
void tm1637_selectpos(char nr);
void tm1637_setbright(uint8_t value);
void tm1637_setbmp(uint8_t pos, uint8_t value);
void tm1637_setzif(uint8_t pos, uint8_t zif);
void tm1637_setseg(uint8_t pos, uint8_t seg);
void tm1637_setdez(int value);
void tm1637_setdez2(char pos, uint8_t value);
void tm1637_sethex(uint16_t value);
void tm1637_sethex2(char pos, uint8_t value);

*/

/* ----------------------------------------------------------
                      Globale Variable
   ---------------------------------------------------------- */

uint8_t    hellig    = 15;                // beinhaltet Wert fuer die Helligkeit (erlaubt: 0x00 .. 0x0f);
uint8_t    tm1637_dp = 0;                 // 0 : Doppelpunkt abgeschaltet
                                          // 1 : Doppelpunkt sichtbar
                                          //     tm1637_dp wird beim Setzen der Anzeigeposition 1 verwendet
                                          //     und hat erst mit setzen dieser Anzeige einen Effekt

uint8_t    led7sbmp[16] =                // Bitmapmuster fuer Ziffern von 0 .. F
                { 0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07,
                  0x7f, 0x6f, 0x77, 0x7c, 0x39, 0x5e, 0x79, 0x71 };


/* ----------------------------------------------------------
                   TM1637 - Definitionen
   ---------------------------------------------------------- */

/*  ------------------- Kommunikation -----------------------

    Der Treiberbaustein TM1637 wird etwas "merkwuerdig
    angesprochen. Er verwendet zur Kommunikation ein I2C
    Protokoll, jedoch OHNE eine Adressvergabe. Der Chip ist
    somit IMMER angesprochen. Aus diesem Grund wird die
    Kommunikation mittels Bitbanging vorgenommen. Hierfuer
    kann jeder freie I/O Anschluss des Controllers verwendet
    werden (siehe defines am Anfang).
   ---------------------------------------------------------- */

void tm1637_init(void)
{
  scl_init();
  sda_init();
}

void tm1637_start(void)              // I2C Bus-Start
{
  scl_set();
  sda_set();
  puls_len();
  sda_clr();
}

void tm1637_stop(void)               // I2C Bus-Stop
{
  scl_clr();
  puls_len();
  sda_clr();
  puls_len();
  scl_set();
  puls_len();
  sda_set();
}

void tm1637_write (uint8_t value)    // I2C Bus-Datentransfer
{
  uint8_t i;

  for (i = 0; i <8; i++)
  {
    scl_clr();
    if (value & 0x01) { sda_set(); }
                   else { sda_clr(); }
    puls_len();
    value = value >> 1;
    scl_set();
    puls_len();
  }
  scl_clr();
  puls_len();                        // der Einfachheit wegen wird ACK nicht abgefragt
  scl_set();
  puls_len();
  scl_clr();

}

/*  ----------------------------------------------------------
                      Benutzerfunktionen
    ---------------------------------------------------------- */


 /*  ------------------- SELECTPOS ---------------------------

        waehlt die zu beschreibende Anzeigeposition aus
     --------------------------------------------------------- */
void tm1637_selectpos(char nr)
{
  tm1637_start();
  tm1637_write(0x40);                // Auswahl LED-Register
  tm1637_stop();

  tm1637_start();
  tm1637_write(0xc0 | nr);           // Auswahl der 7-Segmentanzeige
}

/*  ----------------------- SETBRIGHT ------------------------

       setzt die Helligkeit der Anzeige
       erlaubte Werte fuer Value sind 0 .. 15
    ---------------------------------------------------------- */
void tm1637_setbright(uint8_t value)
{
  tm1637_start();
  tm1637_write(0x80 | value);        // unteres Nibble beinhaltet Helligkeitswert
  tm1637_stop();
}

/*  ------------------------- CLEAR -------------------------

       loescht die Anzeige auf dem Modul
    --------------------------------------------------------- */
void tm1637_clear(void)
{
  uint8_t i;

  tm1637_selectpos(0);
  for(i=0;i<6;i++) { tm1637_write(0x00); }
  tm1637_stop();

  tm1637_setbright(hellig);

}

/*  ---------------------- SETBMP ---------------------------
       gibt ein Bitmapmuster an einer Position aus
    --------------------------------------------------------- */
void tm1637_setbmp(uint8_t pos, uint8_t value)
{
  tm1637_selectpos(pos);             // zu beschreibende Anzeige waehlen

  if (pos== 1)
  {
    if (tm1637_dp) { value |= 0x80; }
  }
  tm1637_write(value);               // Bitmuster value auf 7-Segmentanzeige ausgeben
  tm1637_stop();

}

/*  ---------------------- SETZIF ---------------------------
       gibt ein Ziffer an einer Position aus
       Anmerkung: das Bitmuster der Ziffern ist in
                  led7sbmp definiert
    --------------------------------------------------------- */
void tm1637_setzif(uint8_t pos, uint8_t zif)
{
  tm1637_selectpos(pos);             // zu beschreibende Anzeige waehlen

  zif= led7sbmp[zif];
  if (pos== 1)
  {
    if (tm1637_dp) { zif |= 0x80; }
  }
  tm1637_write(zif);               // Bitmuster value auf 7-Segmentanzeige ausgeben
  tm1637_stop();

}
/*  ----------------------- SETSEG --------------------------
       setzt ein einzelnes Segment einer Anzeige

       pos: Anzeigeposition (0..3)
       seg: das einzelne Segment (0..7 siehe oben)
    --------------------------------------------------------- */
void tm1637_setseg(uint8_t pos, uint8_t seg)
{

  tm1637_selectpos(pos);             // zu beschreibende Anzeige waehlen
  tm1637_write(1 << seg);
  tm1637_stop();

}

/*  ----------------------- SETDEZ --------------------------
       gibt einen 4-stelligen dezimalen Wert auf der
       Anzeige aus
    --------------------------------------------------------- */
void tm1637_setdez(int value)
{
  uint8_t i,v;

  for (i= 4; i> 0; i--)
  {
    v= value % 10;
    tm1637_setbmp(i-1, led7sbmp[v]);
    value= value / 10;
  }
}

/*  ---------------------- SETDEZ2 --------------------------
       gibt einen 2-stelligen dezimalen Wert auf der
       Anzeige aus

       pos:     0 => Anzeige erfolgt auf den hinteren
                     beiden Digits
                1 => Anzeige erfolgt auf den vorderen
                     beiden Digits
                2 => Anzeige erfolgt in der Mitte
    --------------------------------------------------------- */
void tm1637_setdez2(char pos, uint8_t value)
{
  uint8_t v;

  if (pos== 2)
  {
    v= value % 10;
    tm1637_setbmp(2, led7sbmp[v]);
    value= value / 10;
    v= value % 10;
    tm1637_setbmp(1, led7sbmp[v]);
  }
  else
  {
    pos= pos % 2;
    pos= (1 - pos) * 2;
    v= value % 10;
    tm1637_setbmp(pos+1, led7sbmp[v]);
    value= value / 10;
    v= value % 10;
    tm1637_setbmp(pos, led7sbmp[v]);
  }
}

/*  ----------------------- SETHEX --------------------------
       gibt einen 4-stelligen hexadezimalen Wert auf der
       Anzeige aus
    --------------------------------------------------------- */
void tm1637_sethex(uint16_t value)
{
  uint8_t i,v;

  for (i= 4; i> 0; i--)
  {
    v= value % 0x10;
    tm1637_setbmp(i-1, led7sbmp[v]);
    value= value / 0x10;
  }
}

/*  ---------------------- SETHEX2 --------------------------
       gibt einen 2-stelligen hexadezimalen Wert auf der
       Anzeige aus

       pos:     0 => Anzeige erfolgt auf den hinteren
                     beiden Digits
                1 => Anzeige erfolgt auf den vorderen
                     beiden Digits
    --------------------------------------------------------- */
void tm1637_sethex2(char pos, uint8_t value)
{
  uint8_t v;

  pos= pos % 2;
  pos= (1 - pos) * 2;
  v= value & 0x0f;
  tm1637_setbmp(pos+1, led7sbmp[v]);
  v= (value >> 4) & 0x0f;
  tm1637_setbmp(pos, led7sbmp[v]);
}
