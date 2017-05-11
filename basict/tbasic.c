/* --------------------------------------------------------------------
                                 tbasic.c

    Basicinterpreter fuer STM8S103F3P6 Controller.

    Ausgangsdateien von T. Suzuki

    Modifikationen und Anpassungen an STM8S103
    von R. Seelig

    "Wettstreit um den billigsten Basic-Computer"

    Hardware  : STM8S103F3P6
    IDE       : keine (Editor / make)
    Toolchain : SDCC

    15.11.2016   R. seelig


    GNU General Public License ( macht also was ihr wollt damit! )
   -------------------------------------------------------------------- */
#include <stdint.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>

#include "stm8s.h"



#define SIZE_LINE    50                   // Eingabespeicher einer Zeile + NULL-Byte
#define SIZE_IBUF    SIZE_LINE
#define SIZE_LIST    512                  // Basic-Listing Speicher (Programmspeicher)
#define SIZE_ARRY    32                   // max. Array-Groesse
#define SIZE_GSTK    6                    // GOSUB stack size (2/ nest)
#define SIZE_LSTK    15                   // FOR stack size (5 / nest)
#define IO_MAX       17                   // max. Anzahl I/O Pins

#define return_key 0x0d
#define return_alt 0x0a

// Basic - Prototypen
int16_t iexp(void);
void sysfunc(int16_t v1, int16_t v2);

char *kwtbl[] =
{
  "GOTO", "GOSUB", "RETURN",
  "FOR", "TO", "STEP", "NEXT",
  "IF", "REM", "STOP",
  "INPUT", "PRINT", "LET",

  ",", ";",
  "-", "+", "*", "/", "(", ")",
  ">=", "#", ">", "=", "<=", "<",
  "@", "RND", "ABS", "SIZE",
  "OUT", "IN", "SCALL", "LIST", 
  "RUN", "NEW", "SAVE", "LOAD"
};

// Interpreterzwischencode
enum
{
  I_GOTO, I_GOSUB, I_RETURN,
  I_FOR, I_TO, I_STEP, I_NEXT,
  I_IF, I_REM, I_STOP,
  I_INPUT, I_PRINT, I_LET,

  I_COMMA, I_SEMI,
  I_MINUS, I_PLUS, I_MUL, I_DIV, I_OPEN, I_CLOSE,
  I_GTE, I_SHARP, I_GT, I_EQ, I_LTE, I_LT,
  I_ARRAY, I_RND, I_ABS, I_SIZE,
  I_OUT, I_IN, I_SCALL, I_LIST, I_RUN, I_NEW,
  I_SAVE, I_LOAD,
  I_NUM, I_VAR, I_STR,
  I_EOL
};

// Schluesselwort zaehlen
#define SIZE_KWTBL (sizeof(kwtbl) / sizeof(const char*))

// Textformatierung (kein Leerzeichen nach Funktion)
const uint8_t i_nsa[] =
{
  I_RETURN, I_STOP, I_COMMA,
  I_MINUS, I_PLUS, I_MUL, I_DIV, I_OPEN, I_CLOSE,
  I_GTE, I_SHARP, I_GT, I_EQ, I_LTE, I_LT,
  I_ARRAY, I_RND, I_ABS, I_SIZE, I_OUT, I_IN
};

// (und auch keines davor)
const uint8_t i_nsb[] =
{
  I_MINUS, I_PLUS, I_MUL, I_DIV, I_OPEN, I_CLOSE,
  I_GTE, I_SHARP, I_GT, I_EQ, I_LTE, I_LT,
  I_COMMA, I_SEMI, I_EOL
};

// Macrosuchfunktionen
#define nospacea(c) sstyle(c, i_nsa, sizeof(i_nsa))
#define nospaceb(c) sstyle(c, i_nsb, sizeof(i_nsb))

// Fehlermeldungen
char* errmsg[] =
{
  // Aufgrund akuten Speichermangels nur Fehlernummern anstelle
  // von Klartextmeldungen vergeben werden

/*
  "OK",
  "Err1",
  "Err2",
  "Err3",
  "Err4",
  "Err5",
  "Err6",
  "Err7",
  "Err8",
  "Err9",
  "Err10",
  "Err11",
  "Err12",
  "Err13",
  "Err14",
  "Err15",
  "Err16",
  "Err17",
  "Err18",
  "Err19",
  "Err20",
  "Break",
  "ESC-Break",
  "Err23",
  "Err24"
*/

  "OK",
  "Div by zero",
  "O-flow",
  "Out of range",
  "Buffer full",
  "List full",
  "GOSUB too deep",
  "Stack underflow",
  "FOR too deep",
  "NEXT no FOR",
  "NEXT no counter",
  "NEXT mismatch FOR",
  "FOR no var",
  "FOR no TO",
  "LET no var",
  "IF no condition",
  "Undef line no.",
  "\'(\' or \')\' expected",
  "\'=\' expected",
  "Illegal command",
  "Syntax error",
  "Break",
  "ESC-Break",
  "No I/O number",
  "Value expected"

};

// Fehlercodes
enum
{
  ERR_OK,
  ERR_DIVBY0,
  ERR_VOF,
  ERR_SOR,
  ERR_IBUFOF, ERR_LBUFOF,
  ERR_GSTKOF, ERR_GSTKUF,
  ERR_LSTKOF, ERR_LSTKUF,
  ERR_NEXTWOV, ERR_NEXTUM, ERR_FORWOV, ERR_FORWOTO,
  ERR_LETWOV, ERR_IFWOC,
  ERR_ULN,
  ERR_PAREN, ERR_VWOEQ,
  ERR_COM,
  ERR_SYNTAX,
  ERR_SYS,
  ERR_ESC,
  ERR_NOIO,
  ERR_NOVAL
};

// RAM mapping
char      lbuf[SIZE_LINE];                 // Buffer Eingabezeile
uint8_t   ibuf[SIZE_IBUF];                 // i-code Konvertierungsspeicher
int16_t   var[26];                         // max. 26 Variable
int16_t   arr[SIZE_ARRY];                  // Speichergroesse Array
uint8_t   listbuf[SIZE_LIST];              // Programmspeicher
uint8_t*  clp;                             // Zeiger auf aktuelle Zeile
uint8_t*  cip;                             // Zeiger auf aktuellen i-Code
uint8_t*  gstk[SIZE_GSTK];                 // GOSUB stack
uint8_t   gstki;                           // GOSUB stack index
uint8_t*  lstk[SIZE_LSTK];                 // FOR stack
uint8_t   lstki;                           // FOR stack index

uint8_t   err;                             // index Fehlermeldung

uint16_t  portddr= 0;                      // dient als Flagregister wie die Ausgangspins
                                           // initalisiert sind

//  PA3, PB4, PB5, PC3 .. PC7, PD3, PD4
const uint8_t  pinmap[10] ={ 3, 4, 5, 3, 4, 5, 6, 7, 3, 4 };

#define   bitset16(reg, nr)     ( reg |= 1 << nr )
#define   bitclr16(reg, nr)     ( reg &= ~(1 << nr) )
#define   testbit16(reg, nr)    ( (reg & (1 << nr)) >> nr )

// Register der GPIO Ports

#define P_ODR   0   //   ( Output Register )
#define P_IDR   1   //   ( Input Register )
#define P_DDR   2   //   ( Direction Register )
#define P_CR1   3   //   ( Controll Register 1 )
#define P_CR2   4   //   ( Controll Register 2 )


// Suchfunktion Exceptions
char sstyle(uint8_t code, const uint8_t *table, uint8_t count)
{
  while (count--)
    if (code == table[count])
    return 1;
  return 0;
}


/* ------------------------------------------------------
                        delay_ms
     grobe Zeitverzoegerung in Millisekunden. Der
     Wert 1435 in cnt2 ist "ausgemessen" und stimmt nur
     fuer eine Taktfrequenz von 16Mhz so "halbwegs". Fuer
     eine genauere Zeit ist besser eine Interruptroutine
     mittels Timer zu verwenden.
  ------------------------------------------------------ */
void delay_ms(uint16_t cnt)
{
  volatile uint16_t cnt2;

  while (cnt)
  {
    cnt2= 1435;
    while(cnt2)
    {
      cnt2--;
    }
    cnt--;
  }
}

/* ------------------------------------------------------
                     sysclock_init
      stellt den Taktgeber fuer den Controller fuer
      internen RC-Oszilator ein.

      Ersatz fuer die Init aus stm8_init.h
      Bringt 70 Byte Speicherplatz Einsparung
   ------------------------------------------------------ */
void sysclock_init(void)
{
  CLK_ICKR = 0;                                  //  Reset Register interner clock
  CLK_ECKR = 0;                                  //  Reset Register externer clock (ext. clock disable)

  CLK_ICKR =  HSIEN;                             //  Interner clock enable
  while ((CLK_ICKR & (HSIRDY)) == 0);            //  warten bis int. Takt eingeschwungen ist


  CLK_CKDIVR = 0;                                //  Taktteiler auf volle Geschwindigkeit
  CLK_PCKENR1 = 0xff;                            //  alle Peripherietakte an
  CLK_PCKENR2 = 0xff;                            //  dto.

  CLK_CCOR = 0;                                  //  CCO aus
  CLK_HSITRIMR = 0;                              //  keine Taktjustierung
  CLK_SWIMCCR = 0;                               //  SWIM = clock / 2.
  CLK_SWR = 0xe1;                                //  int. Generator als Taktquelle
  CLK_SWCR = 0;                                  //  Reset clock switch control register.
  CLK_SWCR = SWEN;                               //  Enable switching.
  while ((CLK_SWCR &  SWBSY) != 0);              //  warten bis Peripherietakt stabil

  delay_ms(50);
}


void uart_putchar(char ch)
{
  while(!(USART1_SR & USART_SR_TXE));   // warten bis letztes Zeichen gesendet ist
  USART1_DR = ch;                       // Zeichen senden
}

void uart_putstring(char *p)
{
  do
  {
    uart_putchar( *p );
  } while( *p++);
}

/* ------------------------------------------------------------
                         UART_GETCHAR
     wartet so lange, bis auf der seriellen Schnittstelle
     ein Zeichen eintrifft und liest dieses ein
   ------------------------------------------------------------ */
char uart_getchar(void)
{
  while(!(USART1_SR & USART_SR_RXNE));    // solange warten bis ein Zeichen eingetroffen ist
  return USART1_DR;
}

/* ------------------------------------------------------------
                         UART_ISCHAR
      testet, ob auf der seriellen Schnittstelle ein Zeichen
      zum Lesen ansteht (liest dieses aber nicht und wartet
      auch nicht darauf)
   ------------------------------------------------------------ */
char uart_ischar(void)
{
  return (USART1_SR & USART_SR_RXNE);
}


/* ------------------------------------------------------------
                            UART_INIT
      Initialisieren der seriellen Schnittstelle. Mit internem
      Taktgeber funktioniert die Schnittstelle nur bis
      57600 Baud
   ------------------------------------------------------------ */

void uart_init(void)
{
  USART1_CR2 |= USART_CR2_TEN;                          // TxD enabled
  USART1_CR2 |= USART_CR2_REN;                          // RxD enable
  USART1_CR3 &= ~(USART_CR3_STOP1);                     // Stopbit

  // Baudratendivisor:
  //   Divisior = F_CPU / Baudrate
  //   Nibbles des Divisors N3 N2 N1 N0
  //   Bsp.:   16 MHz / 9600 bd = 1667d = 0683h
  //      Hier waere dann:
  //        N3 = 0   / N2 = 6  / N1 = 8  / N0 = 3

  //      BRR1 bekaeme N2 und N1 => 0x68
  //      BRR2 bekaeme N3 und N0 => 0x03

  //  USART1_BRR1 = 0x68; // 9600 Baud
  //  USART1_BRR2 = 0x03;

  USART1_BRR1 = 0x11;
  USART1_BRR2 = 0x06;
}


void newline(void)
{
  uart_putchar(0x0d);
  uart_putchar(0x0a);
}


int16_t getrnd(int16_t value)
{
  return (rand() % value) + 1;
}


void eeprom_unlock(void)
{
  if (!(FLASH_IAPSR & FLASH_IAPSR_DUL))
  FLASH_DUKR= 0xae;
  FLASH_DUKR= 0x56;
}

#define eeprom_lock()    (FLASH_IAPSR &= ~(FLASH_IAPSR_DUL))


/* --------------------------------------------------
                      eeprom_write
     schreibt den Wert value an die Adresse addr
     im internen EEPROM
   -------------------------------------------------- */
uint8_t eeprom_write(uint16_t addr, uint8_t value)
{
  uint8_t *address = (char *) EEPROM_BASE_ADDR + addr;

  if (addr > 0x027f) return 0;                  // 0x27f = 639 = hoechste verfuegbare
                                                // Speicherzelle
  *address = (uint8_t) value;
  return 1;
}

/* --------------------------------------------------
                      eeprom_read
     liest den Inhalt der Speicheradresse addr
     des internen EEPROM aus und gibt dieses als
     Argument zurueck
   -------------------------------------------------- */
uint8_t eeprom_read(uint16_t addr)
{
  uint8_t value;
  uint8_t *address = (char *) EEPROM_BASE_ADDR + addr;

  if (addr > 0x027f) return 0xff;               // 0x27f = 639 = hoechste verfuegbare
                                                // Speicherzelle
  value= *address;
  return value;
}


void saveprog(void)
{
  uint16_t adr;

  eeprom_unlock();

  for (adr= 0; adr< SIZE_LIST; adr++)
  {
    eeprom_write(adr, listbuf[adr]);
  }
  eeprom_lock();
  uart_putstring("\n\rDone...");
}

void loadprog(void)
{
  uint16_t adr;

  eeprom_unlock();

  for (adr= 0; adr< SIZE_LIST; adr++)
  {
    listbuf[adr]= eeprom_read(adr);
  }
  eeprom_lock();
  uart_putstring("\n\rLoading done...");
}

char c_toupper(char c)
// gleiche Funktion wie C - Bibliothek
{
  return(c <= 'z' && c >= 'a' ? c - 32 : c);
}

char c_isprint(char c)
{
  return(c >= 32 && c <= 126);
}

char c_isspace(char c)
{
  return(c == ' ' || (c <= 13 && c >= 9));
}

char c_isdigit(char c)
{
  return(c <= '9' && c >= '0');
}

char c_isalpha(char c)
{
  return ((c <= 'z' && c >= 'a') || (c <= 'Z' && c >= 'A'));
}

char uart_readkey()
{
  char c;

  c= uart_getchar();
  if (c== return_alt) return return_key;
  return c;
}

/*
void uart_putstring(const char *s)
{
  while (*s) uart_putchar(*s++);
}
*/

void uart_getstring(void)
{
  char     c;
  uint8_t  len;

  len = 0;
  while  ((c = uart_readkey()) != return_key)
  {
    if (c == 9) c = ' ';                                // TAB durch Leerzeichen ersetzen
    if (((c == 8) || (c == 127)) && (len > 0))          // letztes Zeichen loeschen
    {
      len--;
      uart_putchar(8);
      uart_putchar(' ');
      uart_putchar(8);
    }
    else
    {
      if (c_isprint(c) && (len < (SIZE_LINE - 1)))
      {
        lbuf[len++] = c;
        uart_putchar(c);
      }
    }
  }
  newline();
  lbuf[len] = 0;
  if (len > 0)
  {
     while (c_isspace(lbuf[--len]));                    // Leerzeichen uebergehen
     lbuf[++len] = 0;
  }
}

void putnum(int16_t value, int16_t d)
{
  uint8_t dig;
  uint8_t sign;

  if (value < 0)
  {
    sign = 1;
    value = -value;
  }
  else
  {
    sign = 0;
  }

  lbuf[6] = 0;
  dig = 6;
  do
  {
    lbuf[--dig] = (value % 10) + '0';
    value /= 10;
  }while (value > 0);

  if (sign) lbuf[--dig] = '-';

  while (6 - dig < d)
  {
     uart_putchar(' ');
     d--;
  }
  uart_putstring(&lbuf[dig]);
}

int16_t getnum(void)
{
  int16_t value, tmp;
  char c;
  uint8_t len;
  uint8_t sign;

  len = 0;
  while ((c = uart_readkey()) != return_key)
  {
    if (((c == 8) || (c == 127)) && (len > 0))               // Del-Taste
    {
      len--;
      uart_putchar(8);
      uart_putchar(' ');
      uart_putchar(8);
    }
    else
    {
      if ((len == 0 && (c == '+' || c == '-')) || (len < 6 && c_isdigit(c)))
      {
        lbuf[len++] = c;
        uart_putchar(c);
      }
    }
  }
  newline();
  lbuf[len] = 0;

  switch (lbuf[0])
  {
    case '-':
        sign = 1;
        len = 1;
        break;
    case '+':
        sign = 0;
        len = 1;
        break;
    default:
        sign = 0;
        len = 0;
        break;
  }

  value = 0;
  tmp = 0;

  while (lbuf[len])
  {
    tmp = 10 * value + lbuf[len++] - '0';
    if (value > tmp)                            // Werteueberlauf
    {
        err = ERR_VOF;
    }
    value = tmp;
  }

  if (sign) return -value;
  return value;
}


uint8_t toktoi()
// Konvertierung Token zu I-Code, Rueckgabe Laenge oder 0

{
  uint8_t   i;
  uint8_t   len = 0;
  char      *pkw = 0;
  char      *ptok;
  char      *s = lbuf;
  char      c;
  int16_t   value;
  int16_t   tmp;

  while (*s)
  {
    while (c_isspace(*s)) s++;                // Leerzeichen ueberlesen

   // Schluesselwortuebersetzung
   for (i = 0; i < SIZE_KWTBL; i++)
   {
     pkw = (char *)kwtbl[i];                  // Schluesselworttabelle
     ptok = s;

     // Schluesselwortvergleich
     while ((*pkw != 0) && (*pkw == c_toupper(*ptok)))
     {
        pkw++;
        ptok++;
     }

     if (*pkw == 0)                           // gefunden
     {
       if (len >= SIZE_IBUF - 1)
       {
         err = ERR_IBUFOF;
         return 0;
       }

       // I-Code gefunden
       ibuf[len++] = i;
       s = ptok;
       break;
     }
   }

   // Case statement benoetigt Argument fuer Nummern, Variable oder strings
   if (i == I_REM)
   {
      while (c_isspace(*s)) s++;               // Leerzeichen
      ptok = s;
      for (i = 0; *ptok++; i++);               // Laenge ermitteln
      if (len >= SIZE_IBUF - 2 - i)
      {
        err = ERR_IBUFOF;
        return 0;
      }
      ibuf[len++] = i;                         // Laenge setzen
      while (i--)                              // String kopieren
      {
        ibuf[len++] = *s++;
      }
      break;
    }

    if (*pkw == 0) continue;

    ptok = s;

    // Zahlenkonvertierung
    if (c_isdigit(*ptok))
    {
      value = 0;
      tmp = 0;
      do
      {
        tmp = 10 * value + *ptok++ - '0';
        if (value > tmp)
        {
          err = ERR_VOF;
          return 0;
        }
        value = tmp;
      } while (c_isdigit(*ptok));

      if (len >= SIZE_IBUF - 3)
      {
        err = ERR_IBUFOF;
        return 0;
      }
      s = ptok;
      ibuf[len++] = I_NUM;
      ibuf[len++] = value & 255;
      ibuf[len++] = value >> 8;
    }
    else
    {
      if (*s == '\"' || *s == '\'')
      {
        c = *s++;
        ptok = s;
        for (i = 0; (*ptok != c) && c_isprint(*ptok); i++) ptok++;

        if (len >= SIZE_IBUF - 1 - i)
        {
          err = ERR_IBUFOF;
          return 0;
        }

        ibuf[len++] = I_STR;
        ibuf[len++] = i;

        while (i--)
        {
          ibuf[len++] = *s++;
        }
        if (*s == c) s++;
      }
      else
      {
        if (c_isalpha(*ptok))
        {
          if (len >= SIZE_IBUF - 2)
          {
            err = ERR_IBUFOF;
            return 0;
          }
          if (len >= 4 && ibuf[len - 2] == I_VAR && ibuf[len - 4] == I_VAR)
          {
            err = ERR_SYNTAX;
            return 0;
          }
          ibuf[len++] = I_VAR;
          ibuf[len++] = c_toupper(*ptok) - 'A';
          s++;
        }
        else
        {
          err = ERR_SYNTAX;
          return 0;
        }
      }
    }
  }
  ibuf[len++] = I_EOL;
  return len;
}

int16_t getlineno(uint8_t *lp)
{
  if (*lp == 0) return 32767;                      // hoechste Zeilennummer
  return *(lp + 1) | *(lp + 2) << 8;
}

uint8_t* getlp(int16_t lineno)
// Zeilennummer suchen
{
  uint8_t *lp;

  for (lp = listbuf; *lp; lp += *lp)
  {
    if (getlineno(lp) >= lineno) break;
  }
  return lp;
}

int16_t getsize(void)
// freien Speicher ermitteln
{
  uint8_t* lp;

  for (lp = listbuf; *lp; lp += *lp);
  return (int16_t)(listbuf + SIZE_LIST - lp - 1);
}

void inslist(void)
// I-Code zum Programmlisting hinzufuegen
{
  uint8_t *insp;
  uint8_t *p1, *p2;
  int16_t len;

  if (getsize() < *ibuf)
  {
     err = ERR_LBUFOF;                       // List Speicher overflow
     return;
  }

  insp = getlp(getlineno(ibuf));

  if (getlineno(insp) == getlineno(ibuf))    // Zeilennummer
  {
    p1 = insp;
    p2 = p1 + *p1;
    while ((len = *p2) != 0)
    {
       while (len--) *p1++ = *p2++;
    }
   *p1 = 0;
  }

  if (*ibuf == 4) return;

  // Platz schaffen
  for (p1 = insp; *p1; p1 += *p1);
  len = p1 - insp + 1;
  p2 = p1 + *ibuf;
  while (len--) *p2-- = *p1--;

  // und einfuegen
  len = *ibuf;
  p1 = insp;
  p2 = ibuf;
  while (len--) *p1++ = *p2++;
}

void putlist(uint8_t* ip)
{
  uint8_t i;

  while (*ip != I_EOL)
  {
    // Schluesselwort
    if (*ip < SIZE_KWTBL)
    {
      uart_putstring(kwtbl[*ip]);
      if (!nospacea(*ip))  uart_putchar(' ');
      if (*ip == I_REM)
      {
        ip++;
        i = *ip++;
        while (i--)
        {
          uart_putchar(*ip++);
        }
        return;
      }
      ip++;
    }
    else
    {
      // Zahl
      if (*ip == I_NUM)
      {
        ip++;
        putnum(*ip | *(ip + 1) << 8, 0);
        ip += 2;
        if (!nospaceb(*ip)) uart_putchar(' ');
      }
      else
      {
        // Variable
        if (*ip == I_VAR)
        {
          ip++;
          uart_putchar(*ip++ + 'A');
          if (!nospaceb(*ip)) uart_putchar(' ');
        }
        else
        {
          // String
          if (*ip == I_STR)
          {
            char c;

            c = '\"';
            ip++;
            for (i = *ip; i; i--)
            {
              if (*(ip + i) == '\"')
              {
                c = '\'';
                break;
              }
            }

            uart_putchar(c);
            i = *ip++;
            while (i--)
            {
              uart_putchar(*ip++);
            }
            uart_putchar(c);
            if (*ip == I_VAR) uart_putchar(' ');
          }

          // nichts gefunden, eigentlich darf hierher nicht gelangt werden
          else
          {
            err = ERR_SYS;
            return;
          }
        }
      }
    }
  }
}

int16_t getparam(void)
// extrahiere Parameter
{
  int16_t value;

  if (*cip != I_OPEN)
  {
    err = ERR_PAREN;
   return 0;
  }
  cip++;
  value = iexp();
  if (err) return 0;

  if (*cip != I_CLOSE)
  {
    err = ERR_PAREN;
    return 0;
  }
  cip++;

  return value;
}

/* ----------------------------------------------------
                   io_inputinit
   initialisiert einen einzelnen GPIO-Pin als Eingang.
   ---------------------------------------------------- */
void io_inputinit(uint8_t ioport, uint8_t iono)
{
  uint8_t   *ioadr = (uint8_t*)0x5000;     // gloabal weil mehrfach verwendet und deshalb
  uint8_t   b;

  ioadr+= (ioport*5);

  b= 1 << iono;
  *(ioadr + P_DDR) &= ~(b);        // Output Register
  *(ioadr + P_CR1) |= b;           // Controll Register 1
}

/* ----------------------------------------------------
                       io_bitset
            liest einen Eingangspin ein
   ---------------------------------------------------- */
uint8_t io_bitset(uint8_t ioport, uint8_t iono)
{
  uint8_t   *ioadr = (uint8_t*)0x5000;     // gloabal weil mehrfach verwendet und deshalb
  uint8_t   b;

  ioadr+= (ioport*5);

  b=  ( *(ioadr + P_IDR) & (1 << iono) ) >> iono;

  return  b;

}

/* ----------------------------------------------------
                   io_outputinit
   initialisiert einen einzelnen GPIO-Pin als Ausgang.
   Verbraucht bei nur einem verwendeten I/O Port
   MEHR Speicher als in stm8_init.h, jedoch wenn
   mehrere oder gar alle I/Os benoetigt werden weniger

   Hierbei gilt:

              ioport == 0  =>  PortA
                        1  =>  PortB
                        2  =>  PortC
                        3  =>  PortD

              iono   => Bitposition im Port

   I/O Adressen der Ports fangen bei Adresse 0x5000 an
   und belegen jeweils 4 Bytes Speicher Adressraum

   PortA = 0x5000, PortB = 0x5005 etc.

   Offset 0   = ODR      ( Output Register )
          1   = IDR      ( Input Register )
          2   = DDR      ( Direction Register )
          3   = CR1      ( Controll Register 1 )
          4   = CR2      ( Controll Register 2 )
   ---------------------------------------------------- */
void io_outputinit(uint8_t ioport, uint8_t iono)
{
  uint8_t   *ioadr = (uint8_t*)0x5000;     // gloabal weil mehrfach verwendet und deshalb
  uint8_t   b;

  ioadr+= (ioport*5);

  b= 1 << iono;
  *(ioadr + P_DDR) |=  b;        // Output Register
  *(ioadr + P_CR1) |=  b;        // Controll Register 1
  *(ioadr + P_CR2) &= ~(b);      // Controll Register 2
}

/* ----------------------------------------------------
                       io_set

   setzt oder loescht ein Bit im angegebenen Port

   Bsp.:  io_set(1,5,1);

        1 = PB
        5 = Bit 5
        1 = auf 1 setzen
   ---------------------------------------------------- */
void io_set(uint8_t ioport, uint8_t iono, uint8_t value)
{
  uint8_t   *ioadr = (uint8_t*)0x5000;
  uint8_t   b;

  ioadr+= (ioport*5);

  b= 1 << iono;
  if (value) *(ioadr + P_ODR) |= b; else *(ioadr + P_ODR) &= ~(b);
}

/* --------------------------------------------------------
                         iioin

     Eingangportpins lesen. Ist ein Portportpin nicht als
     Eingang definiert, geschieht es hier und bleibt so-
     lange ein Eingang, bis er ueber ioutput als Ausgang
     definiert wird.
   -------------------------------------------------------- */
int16_t iioin(int16_t index)
{
  uint8_t gp, bitnr;

  gp= 0;
  // wenn index > 0 ist es min. PB, Portnummer erhoehen
  if (index>1) gp++;
  // wenn index > 2 ist es min PC, Portnummer erhoehen
  if (index>2) gp++;
  // wenn index > 3 ist es PD, Portnummer erhoehen
  if (index>7) gp++;

  bitnr= pinmap[index];


// Portbelegung siehe ioutput

  if (testbit16(portddr, index))
  {
    bitclr16(portddr, index);
    io_inputinit(gp, bitnr);
  }

  return io_bitset(gp, bitnr);
}

/* --------------------------------------------------------
                         ioutput

     Ausgangspins schalten. Ist ein Portpin nicht als
     Ausgang definiert, geschieht es hier und bleibt so-
     lange ein Ausgang, bis er ueber iioin als Eingang
     definiert wird.
   -------------------------------------------------------- */
void ioutput()
// I/O Funktion : Output
{

  int16_t value;
  int16_t index;

  uint8_t gp, bitnr;

  index = getparam();
  if (err) return;
  if (index >= IO_MAX)
  {
    err = ERR_NOIO;
    return;
  }
  if (*cip != I_EQ)
  {
    err = ERR_NOIO;
    return;
  }
  cip++;

  value = iexp();
  if (err) return;


//   index ist die Portnummer, value der Wert
//   Registerbits:

//    mapping I/O BitNr  0     PA3
//    mapping I/O BitNr  1     PB4
//    mapping I/O BitNr  2     PB5
//    mapping I/O BitNr  3     PC3
//    mapping I/O BitNr  4     PC4
//    mapping I/O BitNr  5     PC5
//    mapping I/O BitNr  6     PC6
//    mapping I/O BitNr  7     PC7
//    mapping I/O BitNr  8     PD3
//    mapping I/O BitNr  9     PD4

  gp= 0;
  // wenn index > 0 ist es min. PB, Portnummer erhoehen
  if (index>0) gp++;
  // wenn index > 2 ist es min PC, Portnummer erhoehen
  if (index>2) gp++;
  // wenn index > 3 ist es PD, Portnummer erhoehen
  if (index>7) gp++;

  bitnr= pinmap[index];

  if (!(testbit16(portddr, index)))
  {
    bitset16(portddr, index);
    io_outputinit(gp, bitnr);
  }
  if (value) io_set(gp, bitnr, 1); else io_set(gp, bitnr, 0);
}

int16_t ivalue(void)
{
  int16_t value;

  switch (*cip)
  {
    case I_NUM:
    {
      cip++;
      value = *cip | *(cip + 1) << 8;
      cip += 2;
      break;
    }
    case I_PLUS:
    {
      cip++;
      value = ivalue();
      break;
    }
    case I_MINUS:
    {
      cip++;
      value = 0 - ivalue();
      break;
    }
    case I_VAR:
    {
      cip++;
      value = var[*cip++];
      break;
    }
    case I_OPEN:
    {
      value = getparam();
      break;
    }
    case I_ARRAY:
    {
      cip++;
      value = getparam();
      if (err) break;
      if (value >= SIZE_ARRY)
      {
        err = ERR_SOR;
        break;
      }
      value = arr[value];
      break;
    }
    case I_IN:
    {
      cip++;
      value = getparam();
      if (err) break;
      if (value >= IO_MAX)
      {
        err = ERR_NOIO;
        break;
      }
      value= iioin(value);
      break;
    }
    case I_RND:
    {
      cip++;
      value = getparam();
      if (err) break;
      value = getrnd(value);
      break;
    }
    case I_ABS:
    {
      cip++;
      value = getparam();
      if (err) break;
      if (value < 0) value *= -1;
      break;
    }
    case I_SIZE:
    {
      cip++;
      if ((*cip != I_OPEN) || (*(cip + 1) != I_CLOSE))
      {
        err = ERR_PAREN;
        break;
      }
      cip += 2;
      value = getsize();
      break;
    }
    default:
    {
      err = ERR_SYNTAX;
      break;
    }
  }
  return value;
}

int16_t imul()
// Multiplikation und Division
{
  int16_t value, tmp;

  value = ivalue();
  if (err) return -1;

  while (1)
  {
    switch (*cip)
    {
      case I_MUL:
      {
        cip++;
        tmp = ivalue();
        value *= tmp;
        break;
      }
      case I_DIV:
      {
        cip++;
        tmp = ivalue();
        if (tmp == 0)
        {
          err = ERR_DIVBY0;
          return -1;
        }
        value /= tmp;
        break;
      }
      default: return value;
    }
  }
}

int16_t iplus()
// Addition und Subtraktion
{
  int16_t value, tmp;

  value = imul();
  if (err) return -1;

  while (1)
  {
    switch (*cip)
    {
      case I_PLUS:
      {
        cip++;
        tmp = imul();
        value += tmp;
        break;
      }
      case I_MINUS:
      {
        cip++;
        tmp = imul();
        value -= tmp;
        break;
      }
      default: return value;
    }
  }
}

/* ----------------------------------------------------------------
                                  iexp

                               Der Parser
   ---------------------------------------------------------------- */
int16_t iexp(void)
{
  int16_t value, tmp;

  value = iplus();
  if (err) return -1;

  while (1)
  {
    switch (*cip)
    {
      case I_EQ:
      {
        cip++;
        tmp = iplus();
        value = (value == tmp);
        break;
      }
      case I_SHARP:
      {
        cip++;
        tmp = iplus();
        value = (value != tmp);
        break;
      }
      case I_LT:
      {
        cip++;
        tmp = iplus();
        value = (value < tmp);
        break;
      }
      case I_LTE:
      {
        cip++;
        tmp = iplus();
        value = (value <= tmp);
        break;
      }
      case I_GT:
      {
        cip++;
        tmp = iplus();
        value = (value > tmp);
        break;
      }
      case I_GTE:
      {
        cip++;
        tmp = iplus();
        value = (value >= tmp);
        break;
      }
      default: return value;
    }
  }
}

void iprint(void)
{
  int16_t value;
  int16_t len;
  uint8_t i;

  len = 0;
  while (*cip != I_SEMI && *cip != I_EOL)
  {
    switch (*cip)
    {
      case I_STR:
      {
        cip++;
        i = *cip++;
        while (i--) uart_putchar(*cip++);
        break;
      }
      case I_SHARP:
      {
        cip++;
        len = iexp();
        if (err) return;
        break;
      }
      default:
      {
        value = iexp();
        if (err) return;
        putnum(value, len);
        break;
      }
    }

    if (*cip == I_COMMA)
    {
      cip++;
      if (*cip == I_SEMI || *cip == I_EOL) return;
    }
    else
    {
      if (*cip != I_SEMI && *cip != I_EOL)
      {
        err = ERR_SYNTAX;
        return;
      }
    }
  }
  newline();
}

void iinput(void)
{
  int16_t value;
  int16_t index;
  uint8_t i;
  uint8_t prompt;

  while (1)
  {
    prompt = 1;

    if (*cip == I_STR)
    {
      cip++;
      i = *cip++;
      while (i--) uart_putchar(*cip++);
      prompt = 0;
    }

    switch (*cip)
    {
      case I_VAR:                         // Variablenwert einlesen
      {
        cip++;
        if (prompt)
        {
//           uart_putchar(*cip + 'A');    // hier wird die einzulesende Variable angezeigt
//           uart_putchar(':');
          uart_putstring(": ");
        }
        value = getnum();
        if (err) return;
        var[*cip++] = value;
        break;
      }
      case I_ARRAY:
      {
        cip++;
        index = getparam();
        if (err) return;
        if (index >= SIZE_ARRY)
        {
          err = ERR_SOR;
          return;
        }
        if (prompt)
        {
          uart_putstring("@(");
          putnum(index, 0);
          uart_putstring("):");
        }
        value = getnum();
        if (err) return;
        arr[index] = value;
        break;
      }
      default:
      {
        err = ERR_SYNTAX;
        return;
      }
    }

    switch (*cip)
    {
      case I_COMMA:
      {
        cip++;
        break;
      }
      case I_SEMI:
      case I_EOL:  return;
      default:
      {
        err = ERR_SYNTAX;
        return;
      }
    }
  }
}

// Variable assignment handler
void ivar(void)
{
  int16_t value;
  int16_t index;

  index = *cip++;
  if (*cip != I_EQ)
  {
    err = ERR_VWOEQ;
    return;
  }
  cip++;

  value = iexp();
  if (err) return;

  var[index] = value;
}

void iarray()
{
  int16_t value;
  int16_t index;

  index = getparam();
  if (err) return;

  if (index >= SIZE_ARRY)
  {
    err = ERR_SOR;
    return;
  }

  if (*cip != I_EQ)
  {
    err = ERR_VWOEQ;
    return;
  }
  cip++;

  value = iexp();
  if (err) return;

  arr[index] = value;
}

void ilet(void)
{
  switch (*cip)
  {
    case I_VAR:
    {
      cip++;
      ivar();                 // Variable assignment
      break;
    }
    case I_ARRAY:
    {
      cip++;
      iarray();               // Array assignment
      break;
    }
    default:
    {
      err = ERR_LETWOV;
      break;
    }
  }
}

uint8_t *iexe(void)
// I-Code ausfuehren
{
  int16_t lineno;                // Zeilennummer
  uint8_t* lp;                   // Zeiger auf Zeile
  int16_t index, vto, vstep;     // FOR-NEXT items
  int16_t condition;             // IF condition

  uint16_t arg1, arg2;           // Parameter fuer SCALL

  while (*cip != I_EOL)
  {
    if (uart_ischar())
    {
      if (uart_readkey() == 27)               // ESC
      {
        err = ERR_ESC;
        return NULL;
      }
    }

    switch (*cip)
    {
      case I_SCALL:
      {
        cip++;
        if (*cip != I_NUM)
        {
          err= ERR_NOVAL;
          break;
        }

        cip++;
        arg1 = *cip;
        cip++;
        arg1 += (*cip << 8);

        cip++;                      // Komma abfragen
        if (*cip != I_COMMA)
        {
          err= ERR_NOVAL;
          break;
        }

        cip++;

        if ((*cip != I_NUM) && (*cip != I_VAR))
        {
          err= ERR_NOVAL;
          break;
        }

        if (*cip == I_NUM)
        {
            cip++;
            arg2= *cip;
            cip++;
            arg2 += (*cip << 8);
         }
         else
         {
             cip++;
             arg2= var[*cip];
         }
//        printf("\n\rParameter sind: %d , %d\n\r",arg1, arg2 );
        cip++;
        sysfunc(arg1, arg2);
        break;
      }
      case I_GOTO:
      {
        cip++;
        lineno = iexp();
        if (err) break;
        lp = getlp(lineno);                   // Zeilennummer suchen
        if (lineno != getlineno(lp))          // wenn nicht gefunden
        {
          err = ERR_ULN;
          break;
        }

        clp = lp;
        cip = clp + 3;
        break;
      }
      case I_GOSUB:
      {
        cip++;
        lineno = iexp();
        if (err) break;
        lp = getlp(lineno);
        if (lineno != getlineno(lp))
        {
          err = ERR_ULN;
          break;
        }

        // push pointers
        if (gstki > SIZE_GSTK - 2)             // stack overflow ?
        {
           err = ERR_GSTKOF;
           break;
        }
        gstk[gstki++] = clp;
        gstk[gstki++] = cip;

        clp = lp;
        cip = clp + 3;
        break;
      }
      case I_RETURN:
      {
        if (gstki < 2)                         // stack underflow ?
        {
          err = ERR_GSTKUF;
          break;
        }
        cip = gstk[--gstki];
        clp = gstk[--gstki];
        break;
      }
      case I_FOR:
      {
        cip++;

        if (*cip++ != I_VAR)
        {
           err = ERR_FORWOV;
           break;
        }

        index = *cip;
        ivar();
        if (err) break;

        if (*cip == I_TO)
        {
          cip++;
          vto = iexp();
        }
        else
        {
          err = ERR_FORWOTO;
          break;
        }

        if (*cip == I_STEP)
        {
           cip++;
           vstep = iexp();
        }
        else
        {
           vstep = 1;
        }

        // overflow check

        if (((vstep < 0) && (-32767 - vstep > vto)) ||
                            ((vstep > 0) && (32767 - vstep < vto)))
        {
          err = ERR_VOF;
          break;
        }

        // push pointers
        if (lstki > SIZE_LSTK - 5)                   // stack overflow ?
        {
          err = ERR_LSTKOF;
          break;
        }
        lstk[lstki++] = clp;
        lstk[lstki++] = cip;

        lstk[lstki++] = (uint8_t*)(uintptr_t)vto;
        lstk[lstki++] = (uint8_t*)(uintptr_t)vstep;
        lstk[lstki++] = (uint8_t*)(uintptr_t)index;
        break;
      }
      case I_NEXT:
      {
        cip++;

        if (lstki < 5)                              // leerer Stack
        {
           err = ERR_LSTKUF;
           break;
        }

        index = (int16_t)(uintptr_t)lstk[lstki - 1];
        if (*cip++ != I_VAR)
        {
          err = ERR_NEXTWOV;
          break;
        }
        if (*cip++ != index)
        {
          err = ERR_NEXTUM;
          break;
        }

        vstep = (int16_t)(uintptr_t)lstk[lstki - 2];
        var[index] += vstep;
        vto = (int16_t)(uintptr_t)lstk[lstki - 3];

        // loop end
        if (((vstep < 0) && (var[index] < vto)) ||
                            ((vstep > 0) && (var[index] > vto)))
        {
          lstki -= 5;
          break;
        }

        // loop
        cip = lstk[lstki - 4];
        clp = lstk[lstki - 5];
        break;
      }

      case I_IF:
      {
        cip++;
        condition = iexp();
        if (err)
        {
          err = ERR_IFWOC;
          break;
        }
        if (condition) break;
      }
      case I_REM:
      {
        while (*cip != I_EOL) cip++;
        break;
      }
      case I_STOP:
      {
        while (*clp) clp += *clp;
        return clp;
      }
      case I_VAR:
      {
        cip++;
        ivar();
        break;
      }
      case I_ARRAY:
      {
        cip++;
        iarray();
        break;
      }
      case I_OUT:
      {
        cip++;
        ioutput();
        break;
      }
      case I_LET:
      {
        cip++;
        ilet();
        break;
      }
      case I_PRINT:
      {
        cip++;
        iprint();
        break;
      }
      case I_INPUT:
      {
        cip++;
        iinput();
        break;
      }
      case I_LIST:
      case I_NEW:
      case I_RUN:
      {
        err = ERR_COM;
        break;
      }
      case I_SEMI:
      {
        cip++;
        break;
      }

      default:
      {
        err = ERR_SYNTAX;
        break;
      }
    }

    if (err) return NULL;
  }
  return clp + *clp;
}

void irun(void)
{
  uint8_t* lp;

  gstki = 0;
  lstki = 0;
  clp = listbuf;

  while (*clp)
  {
    cip = clp + 3;
    lp = iexe();
    if (err) return;
    clp = lp;
  }
}

void ilist(void)
{
  int16_t lineno;

  lineno = (*cip == I_NUM) ? getlineno(cip) : 0;

  for (clp = listbuf;
             *clp && (getlineno(clp) < lineno);
              clp += *clp);
  {
    while (*clp)
    {
      putnum(getlineno(clp), 0);
      uart_putchar(' ');
      putlist(clp + 3);
      if (err) break;
      newline();
      clp += *clp;
    }
  }
}

void inew(void)
{
  uint8_t i;

  for (i = 0; i < 26; i++) var[i] = 0;
  for (i = 0; i < SIZE_ARRY; i++) arr[i] = 0;
  gstki = 0;
  lstki = 0;
  *listbuf = 0;
  clp = listbuf;
}

void icom(void)
// Kommandoprozessor
{

  cip = ibuf;
  switch (*cip)
  {
    case I_SAVE:
    {
      saveprog();
      break;
    }
    case I_LOAD:
    {
      loadprog();
      break;
    }

    case I_NEW:
    {
      cip++;
      if (*cip == I_EOL)
        inew();
      else
        err = ERR_SYNTAX;
      break;
    }
    case I_LIST:
    {
      cip++;
      if (*cip == I_EOL || *(cip + 3) == I_EOL)
         ilist();
      else
         err = ERR_SYNTAX;
      break;
    }
    case I_RUN:
    {
      cip++;
      irun();
      break;
    }
    default:
    {
      iexe();
      break;
    }
  }
}

void error()
// gibt OK oder Fehlermeldung aus
{
  if (err)
  {
    if (cip >= listbuf && cip < listbuf + SIZE_LIST && *clp)
    {
      newline();
      uart_putstring("LINE:");
      putnum(getlineno(clp), 0);
      uart_putchar(' ');
      putlist(clp + 3);
    }
    else
    {
      newline();
      uart_putstring("YOU TYPE: ");
      uart_putstring(lbuf);
    }
  }
  newline();
  uart_putstring(errmsg[err]);
  newline();
  err = 0;
}


/* -----------------------------------------------------------------------
                                    basic
    Hauptprogramm und USER-Interface zur Interaktion
   ----------------------------------------------------------------------- */

void basic()
{
  uint8_t len;
  uint16_t z;

//  inew();                             // loescht den Programmbuffer

  uart_putstring("\n\STM8S103F3P6 -- TBasic -- 57600Bd 8n1\n\r");
  strcpy(lbuf,"print \"  \",size(),\" Bytes free\"");
  len = toktoi();  
  icom();

  error();                              // Fehlerflag loeschen, OK als Prompt

  // Input 1 line and execute
  // sequentiell eine Zeile einlesen und ausfuehren
  while (1)
  {
    uart_putstring("> ");
    uart_getstring();

    len = toktoi();
    if (err)
    {
       error();
       continue;
    }

    if (*ibuf == I_NUM)
    {
      *ibuf = len;
      inslist();
      if (err)  error();
      continue;
    }

    icom();                     // direkte Kommandoausfuehrung
    error();                    // Fehler loeschen, OK ausgeben
  }
}

/* --------------------------------------------------------
                         outputbyte
   -------------------------------------------------------- */
/*
void outputbyte(uint16_t value)
// I/O Funktion : Output
{
  uint8_t b, gp, bitnr;

//   index ist die Portnummer, value der Wert
//   Registerbits:

//    mapping I/O BitNr  0     PA3
//    mapping I/O BitNr  1     PB4
//    mapping I/O BitNr  2     PB5
//    mapping I/O BitNr  3     PC3
//    mapping I/O BitNr  4     PC4
//    mapping I/O BitNr  5     PC5
//    mapping I/O BitNr  6     PC6
//    mapping I/O BitNr  7     PC7
//    mapping I/O BitNr  8     PD3
//    mapping I/O BitNr  9     PD4


  for (b= 0; b< 10; b++)
  {
    gp= 0;
      
    // wenn index > 0 ist es min. PB, Portnummer erhoehen
    if (b>0) gp++;
    // wenn index > 2 ist es min PC, Portnummer erhoehen
    if (b>2) gp++;
    // wenn index > 3 ist es PD, Portnummer erhoehen
    if (b>7) gp++;
  
    bitnr= pinmap[b];
      
      
    if (!(testbit16(portddr, b)))
    {
      bitset16(portddr, b);
      io_outputinit(gp, b);
    }
    if (value & (1 << b)) io_set(gp, bitnr, 1); else io_set(gp, bitnr, 0);
  }  
}
*/

/* --------------------------------------------------------
                         sysfunc
   hier koennen (System)funktionen implementiert werden,
   die vom BASIC aus mittels

                SCALL Funktion, Funktionsargument

   gerufen werden koennen.

   Funktionen
             1 : Gebe Ascii-Zeichen aus
                 Argument: auszugebendes Zeichen
                 SCALL 1, 65       // gibt grosses A aus
             
             2 : Gebe Zahlenwert auf I/O Pins aus
                 Argument: auszugebender Wert
                 SCALL 2, 129      // Ausgangspin 0 (PA3) und
                                   // Pin 7 (PD3) werden eingeschaltet
             3 : Gebe Zahlenwert auf I/O Pins invertiert aus
                 Argument: auszugebender Wert
                 SCALL 2, 129      // Ausgangspin 0 (PA3) und
                                   // Pin 7 (PD3) sind ausgeschaltet, alle
                                   // anderen an
   -------------------------------------------------------- */
void sysfunc(int16_t v1, int16_t v2)
{
  switch (v1)
  {
    case 1 :
    {
      uart_putchar(v2 & 0xff);
      break;
    }   
/*    
    case 2 :
    {
      outputbyte(v2 & 0x3ff);
      break;
    }
    case 3 :
    {
      outputbyte(~(v2) & 0x3ff);
      break;
    }
*/ 
    default : break;
  }
}

/* ---------------------------------------------------------------------
                                M-A-I-N
   --------------------------------------------------------------------- */

int main(void)
{

  sysclock_init();
  uart_init();

  inew();

  basic();
  return 0;
}
