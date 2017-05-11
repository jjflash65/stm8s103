/* -------------------- stm8_nokia.c -------------------------

   Library fuer die Anbindung eines s/w Nokia LCD an
   einen STM8. Abgespeckte LCD-Bibliothek, keine Grafik-
   routinen

   20.05.2016 R. Seelig
   ------------------------------------------------------------ */

#include "stm8_nokia.h"

/*

  Die Prototypen aus stm8_nokia.h

  void spi_init(void);
  unsigned char spi_out(uint8_t data);
  void wrcmd(uint8_t command);                            // sende ein Kommando
  void lcd_init();                                        // initialisiere das Display
  void wrdata(uint8_t dat);                               // sende ein Datum
  void clrscr();                                          // loesche das Display
  void gotoxy(char x,char y);                             // positioniere Ausgabeposition
  void lcd_putchar_d(char ch);                            // setze Zeichen auf das Display
  void putstring(char *c);                                // schreibe String aus dem RAM

*/

char wherex= 0;
char wherey= 0;
char invchar= 0;               // = 1 fuer inversive Textausgabe


/* -------------------------------------------------------------
   WRCMD

   sendet Kommando via SPI an das LCD
   ------------------------------------------------------------- */
void wrcmd(uint8_t cmd)
{
  LCD_PORT &= ~(1 << LCD_DC_PIN);                    // C/D = 0 Kommandomodus
  spi_out(cmd);                                      // senden
  delay_us(20);
}

/* -------------------------------------------------------------
   WRDATA

   sendet Datum via SPI an das LCD
   ------------------------------------------------------------- */
void wrdata(uint8_t data)
{
  LCD_PORT |= (1 << LCD_DC_PIN);                     // C/D = 1 Kommandomodus
  spi_out(data);                                     // senden
}

/* -------------------------------------------------------------
   LCD_INIT

   initialisiert das Display
   ------------------------------------------------------------- */
void lcd_init()
{

  LCD_DDR |= ((1 << LCD_RST_PIN) | (1 << LCD_DC_PIN));
  LCD_CR1 |= ((1 << LCD_RST_PIN) | (1 << LCD_DC_PIN));
  spi_init(1,0,0);                                       // Taktteiler fuer SPI/4, keine Taktinvertierung, Phase 0

  LCD_PORT &= ~(1 << LCD_RST_PIN);                       // Resets LCD controler
  delay_ms(10);
  LCD_PORT |= (1 << LCD_RST_PIN);                        // Set LCD CE = 1 (Disabled)

  // LCD Controller Kommandos  (eigentliches initialisieren)

  // diese Initialisierung funktioniert mit N5510 aelterer Herstellungsdatum
/*
  wrcmd(0x21);                            // Erweiterter Kommandomodus
  wrcmd(0x09);                            // Set int. HV Generator (ca. 7V an Pin7)
  wrcmd(0xff);                            // VOP max
  wrcmd(0x16);                            // BIAS = 2
  wrcmd(0x06);                            // Temp. Koeffizient = 2
  wrcmd(0x20);                            // Standart Kommandomodus
  wrcmd(0x0c);                            // normale Ausgabe (normal = 0Ch, invertiert = 0Dh)
*/

  // Initialisierung fuer neuere N5510
  wrcmd(0x21);                            // Erweiterter Kommandomodus
  delay_ms(2);
  wrcmd(0x09);                            // Set int. HV Generator (ca. 7V an Pin7)
  delay_ms(2);
  wrcmd(0xc8);                            // VOP max
  delay_ms(2);
  wrcmd(0x10);                            // BIAS = 2
  delay_ms(2);
  wrcmd(0x04);                            // Temp. Koeffizient = 2
  delay_ms(2);
  wrcmd(0x20);                            // Standart Kommandomodus
  delay_ms(2);
  wrcmd(0x0c);                            // normale Ausgabe (normal = 0Ch, invertiert = 0Dh)
  delay_ms(20);

  clrscr();
}

/* -----------------------------------------------------
   CLRSCR

   loescht den Displayinhalt
   ----------------------------------------------------- */
void clrscr()
{
  int  i;

  wrcmd(0x80);             // Anfangsadresse des Displays
  wrcmd(0x40);
  for(i= 1;i <(LCD_REAL_X_RES * LCD_REAL_Y_RES/8);i++) { wrdata(0x00); }
  gotoxy(0,0);
}

/* -----------------------------------------------------
   GOTOXY

   positioniert die Textausgabeposition auf X/Y
   ----------------------------------------------------- */
void gotoxy(char x,char y)
{
 wrcmd(0x80+(x*6));
 wrcmd(0x40+y);
 wherex= x; wherey= y;
}

/* -----------------------------------------------------
   PUTCHAR_D

   gibt ein Zeichen auf dem Display aus
   (die Steuerkommandos \n und \r fuer <printf> sind
   implementiert)
   ----------------------------------------------------- */
void lcd_putchar_d(char ch)
{
  int b,rb;

  if (ch== 13)
  {
    gotoxy(0,wherey);
    return;
  }
  if (ch== 10)
  {
    wherey++;
    gotoxy(wherex,wherey);
    return;
  }

  if (ch== 8)
  {
    if ((wherex> 0))
    {
      wherex--;
      gotoxy(wherex,wherey);
      for (b= 0;b<6;b++)
      {
        if (invchar) {wrdata(0xff);} else {wrdata(0);}
      }
      gotoxy(wherex,wherey);
    }
    return;
  }

  if ((ch<0x20)||(ch>lastascii)) ch = 92;               // ASCII Zeichen umrechnen

  // Kopiere Daten eines Zeichens aus dem Zeichenarray in den LCD-Screenspeicher

  for (b= 0;b<5;b++)
  {
    rb= fonttab[ch-32][b];
    if (invchar) {rb= ~rb;}
    wrdata(rb);
  }
  if (invchar) {wrdata(0xff);} else {wrdata(0);}
  wherex++;
  if (wherex> 15)
  {
    wherex= 0;
    wherey++;
  }
  gotoxy(wherex,wherey);
}

/* ---------------------------------------------------
   LCD_PUTSTRING
   gibt einen Text aus dem RAM an der aktuellen Position aus
   ---------------------------------------------------*/
void lcd_putstring(char *c)                              // Uebergabe eines Zeigers (auf einen String)
{
  while (*c)
  {
    lcd_putchar_d(*c++);
  }
}
