/* -------------------------------------------------------
                         n5510_demo.c

     Demoprogramm fuer erstes Lebenszeichen des Displays

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     19.05.2016  R. Seelig
   ------------------------------------------------------ */

#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "my_printf.h"
#include "stm8_nokia.h"

#define countspeed   350

#define printf       my_printf


#define bled_output_init()   PB5_output_init()
#define bled_set()           PB5_set()
#define bled_clr()           PB5_clr()

#define exled_output_init()  PD4_output_init()
#define exled_set()          PD4_set()
#define exled_clr()          PD4_clr()

#define button_input_init()  PD2_input_init()
#define is_button()          is_PD2()


char doublechar = 0;

/* ----------------------------------------------------------
   LCD_PUTDOUBLECHAR

   setzt ein Zeichen direkt auf das Display und setzt den
   Cursor auf die naechste Position

   ch ==> zu setzenes Zeichen
   ---------------------------------------------------------- */

void lcd_putdoublechar(uint8_t ch)
{
  int b,rb;
  uint8_t d,dbch;
  char x,y;

  x= wherex; y= wherey;
  if ((ch<0x20)||(ch>lastascii)) ch = 92;               // nicht anzeigbares Zeichen durch Ascii 92 ersetzen

  // Kopiere Daten eines Zeichens aus dem Zeichenarray in den LCD-Screenspeicher

  for (b= 0;b<5;b++)
  {
    rb= fonttab[ch-32][b];
    dbch= 0;
    for (d= 0; d< 4; d++)
    {
      if (rb & (1 << d))
      {
        dbch |= (1 << (d*2)) | (1 << ((d*2)+1));
      }
    }
    rb= dbch;
    if (invchar) {rb= ~rb;}
    wrdata(rb);
    wrdata(rb);
  }
  gotoxy(x,y+1);
  for (b= 0;b<5;b++)
  {
    rb= fonttab[ch-32][b];
    dbch= 0;
    for (d= 4; d< 8; d++)
    {
      if (rb & (1 << d))
      {
        dbch |= (1 << ((d-4)*2)) | (1 << (((d-4)*2)+1));
      }
    }
    rb= dbch;
    if (invchar) {rb= ~rb;}
    wrdata(rb);
    wrdata(rb);
  }
  gotoxy(x+2,y);
}


/* --------------------------------------------------------
   putchar

   wird von my-printf / printf aufgerufen und hier muss
   eine Zeichenausgabefunktion angegeben sein, auf das
   printf dann schreibt !
   -------------------------------------------------------- */
void putchar(char ch)
{
  if (doublechar)
  {
    lcd_putdoublechar(ch);
  }
  else
  {
    lcd_putchar_d(ch);
  }
}

int main(void)
{
  int   cnt;

  sysclock_init(0);

  bled_output_init();
  exled_output_init();
  button_input_init();

  printfkomma= 2;

  lcd_init();
  clrscr();
  gotoxy(0,0);
  printf(" STM8S103F3P6\n\r");
  printf(" doppelt gross\n\r");
  printf("--------------\n\r");
  printf("88  93  98 103 108");

  gotoxy(0,4);
  doublechar=1;
  printf("STM8S");
  doublechar=0;

  while(is_button());
  delay_ms(100);

  clrscr();
  gotoxy(0,0);

  printf(" STM8S103F3P6\n\r");
  printf("    16MHz\n\r");
  printf("--------------\n\r");
  printf("by R.Seelig");

  cnt= 0;
  while(1)
  {

    gotoxy(0,5);
    printf("%d^%d= %d",cnt,cnt,cnt*cnt);

    bled_set();
    delay_ms(countspeed);
    bled_clr();
    delay_ms(countspeed);

    if (cnt & 1) { exled_set(); } else { exled_clr(); }

//    if (cnt & 2) { led_set(led2); } else { led_clr(led2); }
//    if (cnt & 4) { led_set(led3); } else { led_clr(led3); }

    gotoxy(0,4);

    if (is_button() ) printf("Button: - 1 -");
              else printf("Button: - 0 -");

    cnt++;
    cnt= cnt % 101;
    if (!(cnt))
    {
      gotoxy(0,5);
      printf("              ");
    }
  }
}
