/* -------------------------------------------------------
                         buttontest.c

     Funktionstest von 4 angeschlossenen Tastern mit
     Anzeige auf einem s/w Nokiadisplay im Grafikmodus

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     19.05.2016  R. Seelig
   ------------------------------------------------------ */

#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "spi.h"
#include "n5510_b.h"
#include <string.h>

/* ---------------------------------------------------------
     um Speicherplatz zu sparen werden Tasten nicht ueber
     die komfortableren Pxn_input_init und is_Pxn gehandelt,
   --------------------------------------------------------- */

// Tasten an PB4, PB5, PD2, PD3
#define PB_tastmask    (( 1<<4 ) | ( 1<<5 ))           // PB4 und PB5
#define PD_tastmask    (( 1<<2 ) | ( 1<<3 ))

#define tastl     0x04
#define tastr     0x02
#define tastu     0x01
#define tastd     0x08


void strrev(unsigned char *str)                        // fehlt leider in SDCC
// aus einem "Ralph" wird ein "hplaR"
{
  int     i,j;
  uint8_t a;
  uint8_t len;

  len = strlen((const char *)str);
  for (i = 0, j = len - 1; i < j; i++, j--)
  {
    a = str[i];
    str[i] = str[j];
    str[j] = a;
  }
}


int utoa(uint16_t num, unsigned char* str, int base)   // fehlt leider auch in SDCC
{
  int sum;
  int i = 0;
  int digit;

  sum= num;
  do
  {
    digit = sum % base;
    if (digit < 0xA) { str[i++] = '0' + digit; }
		else { str[i++] = 'A' + digit - 0x0a; }
    sum /= base;
  }while (sum && (i < 6));                        // max. 6 Zeichen
  if (i == 6 && sum) { return -1; }
  str[i] = '\0';
  strrev(str);
  return 0;
}


void tast_init(void)
{
  // 2 Tasten des PortB als Input
  PB_DDR |= PB_tastmask;
  PB_CR1 |= PB_tastmask;
  PB_CR2 &= ~(PB_tastmask);

  // 2 Tasten des PortD als Input
  PD_DDR |= PD_tastmask;
  PD_CR1 |= PD_tastmask;
  PD_CR2 &= ~(PD_tastmask);
}

uint8_t readkey(void)
{
  uint8_t k2;

  // PortB und PortB lesen und ueber Verknuepfungen so
  // bearbeiten, dass die Tasten die Bitpositionen
  // D0..D3 einnehmen

  k2= ((PD_IDR & PD_tastmask) | (PB_IDR & PB_tastmask));
  return (~( k2 >> 2 ) & 0x0f);
}

void putchar(char ch)
//   wird von my_printf benoetigt (aufruf innerhalb der Funktion my_printf) und
//   leitet die Ausgabe von my_printf zum LCD
{
  lcd_putchar(ch);
}

void prints(char *c)
{
  while (*c)
  {
    lcd_putchar(*c++);
  }
}


int main(void)
{
  uint8_t ch;
  char    zstring[7];


  sysclock_init(0);

  lcd_init();
  outmode= 1;
  textsize= 0;
  clrscr();
  gotoxy(0,0); prints("Taste: ");
  scr_update();

  while(1)
  {
    ch= readkey();
//    utoa(ch,zstring,16);
    gotoxy(2,2);
    if (ch & tastl) prints("left ");
    if (ch & tastr) prints("right");
    if (ch & tastu) prints("  up ");
    if (ch & tastd) prints("down ");
    if (!ch) prints("none ");
//    gotoxy(4,2); prints(zstring);

    scr_update();
    delay_ms(100);
  }

}
