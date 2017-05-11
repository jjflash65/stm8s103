/* -------------------------------------------------------
                         i2c_explore.c

     Demo zum "Spielen" auf dem I2C Bus. I2C Geraete
     koennen ueber deren Kommandos mittels write und
     read angesteuert werden.

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     31.05.2016  R. Seelig
   ------------------------------------------------------ */

#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "my_printf.h"
#include "uart.h"
#include "i2c.h"

#define rtc_addr            0xD0
#define lm75_addr           0x90

#define extled_init( )      PD4_output_init()           // Makro fuer GPIO PD4 als Ausgang
#define extled_clr()        PD4_set()                   // Makro fuer GPIO PD4 = 1
#define extled_set()        PD4_clr()                   //            dto. PD4 = 0


#define printf              my_printf

// -------------------------------------------------------------------------------------

#define cmdanz   10
static const char cmds [cmdanz][9] =
{
//     1        2       3        4       5        6      7       8         9
    "start", "stop", "write", "read", "rnack", "lm75", "scan", "time", "settime", "test"
};

/* --------------------------------------------------
     PUTCHAR

     Diese Funktion wird von < my_printf > zur Ausgabe
     von Zeichen aufgerufen. Hier ist eine Hardware-
     zeichenausgabefunktion anzugeben, mit der
     my_printf zusammen arbeiten soll.
   -------------------------------------------------- */
void putchar(char ch)
{
  uart_putchar(ch);
}

/* --------------------------------------------------
     READSTR
     liest einen String von der seriellen Schnitt-
     stelle in den Puffer *string ein.

     < anz > gibt die maximale Anzahl der Zeichen an,
     die eingelesen werden duerfen.
   -------------------------------------------------- */
void readstr(char *string, char anz)
{
  char cnt, ch;

  cnt= 0;

  *string= 0;
  do
  {
    ch= uart_getchar();
    if (ch!= 0x0d)
    {
      if (ch!= 0x08)
      {
        if (cnt< anz)
        {
          uart_putchar(ch);
          *string= ch;
          string++;
          *string= 0;
          cnt++;
        }
      }
      else
      {
        if (cnt)
        {
          uart_putchar(0x08);
          string--;
          *string= 0;
          cnt--;
        }
      }
    }
  } while (ch != 0x0d);
}

/* --------------------------------------------------
     CHECKCMD

     vergleicht den in < string > uebergebenen Text
     mit dem gloabalen Textarray < cmds >.

     Gibt es eine Uebereinstimmung des Strings mit
     eine Element des Arrays "cmds" ,wird die
     Elementposition als Argument zurueck gegeben.
   -------------------------------------------------- */
char checkcmd(char *string)
{
  char  i,cp, ch;
  char  match;
  char  *s;

  i= 0;
  do
  {
    s= string;
    match= 1;
    cp= 0;
    do
    {
      ch= cmds[i][cp];
      if (ch!= *s) match= 0;
//      nur fuer Fehlersuchzwecke
//      printf("%d: %.2x = %c  %.2x = %c\n\r",cp,ch,ch,*s,*s);
      cp++; s++;
    }while(ch && match);
    if (match) return i+1;
    i++;
  } while (i < cmdanz);
  return 0;
}

void crlf(void)
{
  uart_putchar(0x0d);
  uart_putchar(0x0a);
}

/* --------------------------------------------------
     PRINTHEX
     gibt einen unsigned char als Hex-Wert auf der
     seriellen Schnittstelle aus
   -------------------------------------------------- */
void printhex(uint8_t value)
{
  uint8_t b;

  b= (value >> 4);
  if (b< 10) b += '0'; else b += 'A'-10;
  uart_putchar(b);
  b= value & 0x0f;
  if (b< 10) b += '0'; else b += 'A'-10;
  uart_putchar(b);
}

/* --------------------------------------------------
     GETHEX
     liest einen Hex-Wert von der seriellen Schnitt-
     stelle ein

     echo => 1 : gelesener Wert wird zurueckgesendet
             0 : nicht zuruecksenden
   -------------------------------------------------- */
uint8_t gethex(char echo)
{
  uint8_t ch;
  uint8_t value;


  do
  {
    ch= uart_getchar();
  } while (!( ((ch>= '0') && (ch<= '9')) || ((ch>= 'a') && (ch<= 'f')) ));
  if (echo) uart_putchar(ch);

  if (ch > 'F')
  {
    ch= (ch-'a')+10;
  }
  else
  {
    if (ch> '9') ch= (ch-'A')+10; else ch -= '0';
  }
  value= (ch<< 4);

  do
  {
    ch= uart_getchar();
  } while (!( ((ch>= '0') && (ch<= '9')) || ((ch>= 'a') && (ch<= 'f')) ));
  if (echo) uart_putchar(ch);

  if (ch > 'F')
  {
    ch= (ch-'a')+10;
  }
  else
  {
    if (ch> '9') ch= (ch-'A')+10; else ch -= '0';
  }
  value |= ch;
  return value;
}

/* --------------------------------------------------
     LM75_READ

     "Extra". Liest einen eventuell angeschlossenen
     LM75 - Sensor aus und gibt die Temperatur multi-
     pliziert mit 10 als Argument zurueck.

     Ist kein LM75 am I2C Bus angeschlossen, wird als
     Wert -127 zurueck gegeben.
   -------------------------------------------------- */
int lm75_read(void)
{
  char       ack;
  char       t1;
  uint8_t    t2;
  int        lm75temp;

  i2c_start();

  ack= i2c_write(lm75_addr);                // LM75 Basisadresse
  if (ack)
  {

    i2c_write(0x00);                        // LM75 Registerselect: Temp. auslesen
    i2c_write(0x00);

    i2c_stop();
    delay_us(200);
    i2c_start();

    i2c_write(lm75_addr | 1);               // LM75 zum Lesen anwaehlen
    delay_ms(1);                            // Reaktionszeit LM75
    t1= 0;
    t1= i2c_read();                         // hoeherwertigen 8 Bit
    delay_ms(1);
    t2= i2c_read_nack();                    // niederwertiges Bit (repraesentiert 0.5 Grad)
    i2c_stop();

  }
  else
  {
    i2c_stop();
    return -127;                            // Abbruch, Chip nicht gefunden
  }

  lm75temp= t1;
  lm75temp = lm75temp*10;
  if (t2 & 0x80) lm75temp += 5;             // wenn niederwertiges Bit gesetzt, sind das 0.5 Grad
  return lm75temp;
}

/* --------------------------------------------------
     I2C_SCAN

     scannt den I2C-Bus auf angeschlossene Devices
     und gibt deren Adressen auf der ser. Schnitt-
     stelle aus
   -------------------------------------------------- */
void i2c_scan(void)
{
  uint8_t  i2c_devices[127];
  uint8_t  i2c_anz, ack;
  uint8_t  i;

  i2c_anz= 0;
  for (i= 0x00; i< 0xfe; i +=2)
  {
    printf(" Bus-Scan: %xh \r",i);
    i2c_start();
    delay_ms(1);
    ack= i2c_write(i);
    delay_ms(1);
    i2c_stop();
    if (ack)
    {
      printf(" Bus-Scan: %xh found\r",i);
      delay_ms(1000);
      i2c_devices[i2c_anz]= i;
      i2c_anz++;
      printf("                      \r");
    }
    delay_ms(5);
  }
  printf("\n\n\rScan complete...\n\r");
  if (i2c_anz)
  {
    printf("\n\rI2C-devices found at:\n\r");
    for (i= 0; i< i2c_anz; i++)
    {
      printf(" %xh \n\r",i2c_devices[i]);
    }
  }
  else
    printf("\n\rNo I2C-devices found \n\r");
}

/* --------------------------------------------------
      DEZ2BCD

      wandelt eine dezimale Zahl in eine BCD
      Bsp: value = 45
      Rueckgabe    0x45
   -------------------------------------------------- */
uint8_t dez2bcd(uint8_t value)
{
  uint8_t hiz,loz,c;

  hiz= value / 10;
  loz= (value -(hiz*10));
  c= (hiz << 4) | loz;
  return c;
}


/* --------------------------------------------------
      RTC_READ

      liest eine Speicherzelle des DS1307 Uhrenbau-
      steins aus
   -------------------------------------------------- */
uint8_t rtc_read(uint8_t addr)
{

  uint8_t value;

  i2c_start();
  i2c_write(rtc_addr);
  delay_ms(1);
  i2c_write(addr);
  delay_ms(1);
  i2c_stop();
  delay_ms(1);
  i2c_start();
  i2c_write(rtc_addr | 1);
  delay_ms(1);
  value= i2c_read_nack();
  delay_ms(1);
  i2c_stop();

  return value;
}

/* --------------------------------------------------
      RTC_WRITE

      beschreibt eine Speicherzelle des DS1307
      Uhrenbausteins

      addr  =>  Registeradresse
      value =>  zu setzender Wert
   -------------------------------------------------- */
void rtc_write(uint8_t addr, uint8_t value)
{

  i2c_start();
  i2c_write(rtc_addr);
  delay_ms(1);
  i2c_write(addr);
  delay_ms(1);
  i2c_write(value);
  delay_ms(1);
  i2c_stop;

}

/* --------------------------------------------------
      RTC_SHOWTIME

      liest das DS1307 Uhrenmodul aus und zeigt die
      Zeit an.
   -------------------------------------------------- */
void rtc_showtime(void)
{
  uint8_t sek,min,std;
  uint8_t day,month,year;

  sek= rtc_read(0) & 0x7f;
  min= rtc_read(1) & 0x7f;
  std= rtc_read(2) & 0x3f;
  day= rtc_read(4) & 0x3f;
  month= rtc_read(5) & 0x1f;
  year= rtc_read(6);

  printf("\n\r %x.%x.20%x  %x.%x:%x\n\r",day,month,year,std,min,sek);

}


/* ---------------------------------------------------------------------
                              MAIN
   --------------------------------------------------------------------- */

int main(void)
{
  char     inbuffer[13];
  char     ch;
  uint8_t  ack, hexv;
  int      b, i;

  {
   __asm
     ldw x, #0x0300
     ldw sp, x
   __endasm;
  }
  sysclock_init(0);

  printfkomma= 1;                       // my_printf verwendet mit Formatter %k eine Kommastelle
  i2c_init(2);                          // 2 = ca. 15kHz I2C Clock-Takt
  extled_init();

  extled_set();                         // externe LED an
  uart_init(19200);

  printf("\n\n\rI2C-Explorer mit STM8S103F3P6\n\r-----------------------------\n\n\r");
  printf("\n\rCommands are:  start   / stop    / write   / read");
  printf("\n\r               rnack   / scan    / lm75    / time");
  printf("\n\r               settime \n\n\r");

  while(1)
  {
    uart_prints("I2C:> ");
    readstr(&inbuffer[0],8);
    ch= checkcmd(&inbuffer[0]);
    switch(ch)
    {
      case 1 :                               // start - condition
      {
        i2c_start();
        printf("\n\r  start-condition done...\n\n\r");
        break;
      }
      case 2 :                               // stop - condition
      {
        i2c_stop();
        printf("\n\r  stop-condition done...\n\n\r");
        break;
      }
      case 3 :                               // write Data-Byte
      {
        printf("\n\r  byte to write: ");
        b= gethex(1);
        i2c_write(b);
        crlf();
        break;
      }
      case 4 :                               // read Data-Byte
      {
        printf("\n\r  readed byte: ");
        b= i2c_read();
        printf("0x%xh = %dd\n\r",b,b);
        break;
      }
      case 5 :                               // read Data-Byte, no acknowledge
      {
        printf("\n\r  readed byte: ");
        b= i2c_read_nack();
        printf("0x%xh = %dd\n\r",b,b);
        break;
      }
      case 6 :
      {
        b= lm75_read();
        if (b== -127)
        {
          printf("\n\r  LM75 not connected..\n\r");
        }
        else
        {
          printf("\n\r  Temp.= %k C\n\n\r",b);
        }
        break;
      }
      case 7 :                               // scan I2C Bus
      {
        extled_clr();                        // externe LED aus
        printf("\n\r");
        i2c_scan();
        printf("\n\r");
       extled_set();                         // externe LED an
        break;
      }
      case 8 :                               // Time
      {
        printf("\n\r");
        i2c_start();
        delay_ms(1);
        ack= i2c_write(rtc_addr);
        delay_ms(1);
        i2c_stop();
        if (ack)
        {
          rtc_showtime();
        }
        else
        {
          printf("\n\r RTC-device (DS1307) not connected..\n\r");
        }
        printf("\n\r");
        break;
      }
      case 9 :                               // Set time
      {
        i2c_start();
        delay_ms(1);
        ack= i2c_write(rtc_addr);
        delay_ms(1);
        i2c_stop();
        if (ack)
        {
          printf("\n\n\r");
          printf(" Hour    : ");
          hexv= gethex(1) & 0x3f;
          rtc_write(2,hexv);
          printf("\n\r");
          printf(" Minute  : ");
          hexv= gethex(1) & 0x7f;
          rtc_write(1,hexv);
          printf("\n\r");
          printf(" Secound : ");
          hexv= gethex(1) & 0x7f;
          rtc_write(0,hexv);
          printf("\n\r");
          printf(" Day     : ");
          hexv= gethex(1) & 0x3f;
          rtc_write(4,hexv);
          printf("\n\r");
          printf(" Month   : ");
          hexv= gethex(1) & 0x3f;
          rtc_write(5,hexv);
          printf("\n\r");
          printf(" Year    : ");
          hexv= gethex(1) & 0x3f;
          rtc_write(6,hexv);
          printf("\n\n\r");
        }
        else
        {
          printf("\n\r RTC-device (DS1307) not connected..\n\r");
        }
        break;
      }

      case 10 :
        {
          i2c_start();
          i2c_write(0xa0);
          i2c_write(0x10);
          i2c_stop();

          i2c_start();
          i2c_write(0xa1);
          for (i= 0; i< 5; i++)
          {
            printf("\n\r  readed byte: ");
            b= i2c_read();
            printf("0x%xh = %dd\n\r",b,b);
          }
          b= i2c_read_nack();
          printf("0x%xh = %dd\n\r",b,b);
          i2c_stop();
          break;
        }
      default :
      {
        uart_putchar(ch);
        uart_prints("\n\runkown command\n\n\r");
        break;
      }
    }
  }
}
