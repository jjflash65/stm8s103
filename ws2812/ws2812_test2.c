/* -------------------------------------------------------
                        ws2812_test.c

     Programm zum Ansprechen von WS2812 LED's

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     28.04.2017  R. Seelig
   ------------------------------------------------------ */

/*
##################################################################
                      STM8S103F3P6 Pinout
##################################################################


                            ------------
UART1_CK / TIM2_CH1 / PD4  |  1     20  |  PD3 / AIN4 / TIM2_CH2 / ADC_ETR
    UART1_TX / AIN5 / PD5  |  2     19  |  PD2 / AIN3
    UART1_RX / AIN6 / PD6  |  3     18  |  PD1 / SWIM
                     NRST  |  4     17  |  PC7 / SPI_MISO
              OSCIN / PA1  |  5     16  |  PC6 / SPI_MOSI
             OSCOUT / PA2  |  6     15  |  PC5 / SPI_CLK
                Vss (GND)  |  7     14  |  PC4 / TIM1_CH4 / CLK_CCO / AIN2
                VCAP (*1)  |  8     13  |  PC3 / TIM1_CH3 /
                Vdd (+Ub)  |  9     12  |  PB4 / I2C_SCL
           TIM2_CH3 / PA3  | 10     11  |  PB5 / I2C_SDA
                            -----------

*1 :  Ist mit min. 1uF gegen GND zu verschalten

*/

#include <stdint.h>
#include "stm8s.h"
#include "stm8_init.h"

#define printf    my_printf

#define countspeed   100

/* -------------------------------------------------------------
     hier angeben, an welchem Portpin der WS2812 Strang
     angeschlossen ist (benutzten Port "entkommentieren"
   ------------------------------------------------------------- */

// Port, an dem die LED angeschlossen ist
// #define ws_porta
// #define ws_portb
// #define ws_portc
 #define ws_portc

#define gpio_pin      5                         // Portpin an dem die LED angeschlossen ist
                                                // hier dann PD4

/* -------------------------------------------------------------
     Makros zur die die Registeradressen den oben gemachten
     Angaben zuordnen
   ------------------------------------------------------------- */

#define port_mask        ( 1 << gpio_pin )
#if defined ws_porta

  #define ws_init()      {  PA_DDR |=   port_mask;    \
                            PA_CR1 |=   port_mask;    \
                            PA_CR2 &= ~(port_mask); }
  #define gpio_asm    0x5000                              // I/O Portadresse fuer Port A

#elif defined ws_portb
  #define ws_init()      {  PB_DDR |=   port_mask;    \
                            PB_CR1 |=   port_mask;    \
                            PB_CR2 &= ~(port_mask); }
  #define gpio_asm    0x5005                              // I/O Portadresse fuer Port C

#elif defined ws_portc
  #define ws_init()      {  PC_DDR |=   port_mask;    \
                            PC_CR1 |=   port_mask;    \
                            PC_CR2 &= ~(port_mask); }
  #define gpio_asm    0x500a                              // I/O Portadresse fuer Port C

#elif defined ws_portd
  #define ws_init()      {  PD_DDR |=   port_mask;    \
                            PD_CR1 |=   port_mask;    \
                            PD_CR2 &= ~(port_mask); }
  #define gpio_asm    0x500f                              // I/O Portadresse fuer Port B

#else
  #error "kein vorhandener Port des STM8S gewaehlt..."

#endif


#define ledanz        7                         // Anzahl der Leuchtdioden im Strang
volatile uint8_t ledbuffer[ledanz * 3];

typedef struct colvalue
{
  uint8_t r;
  uint8_t g;
  uint8_t b;
}colvalue;


colvalue rgbcolor;      // weil SDCC keine struct als Funktionsparameter kann (weder als
                        // Ueber- noch als Rueckgabe) gibt es eine globale Variable rgbcolor


const uint8_t egapalette[] =
{
/* -------------------------------------------------------------
      Farbpalette fuer dunklere EGA Farben (siehe EGA-
      Farbzuweisungen
   ------------------------------------------------------------- */
  0x00,0x00,0x00, 0x00,0x00,0x03, 0x00,0x03,0x00, 0x00,0x03,0x03,
  0x03,0x00,0x00, 0x03,0x00,0x03, 0x03,0x01,0x00, 0x03,0x03,0x03,
  0x01,0x01,0x01, 0x01,0x01,0x06, 0x01,0x06,0x01, 0x01,0x06,0x06,
  0x06,0x01,0x01, 0x06,0x01,0x06, 0x06,0x06,0x01, 0x06,0x06,0x06,
/* -------------------------------------------------------------
      Farbpalette fuer helle EGA Farben
   ------------------------------------------------------------- */
  0x00,0x00,0x00, 0x00,0x00,0xaa, 0x00,0xaa,0x00, 0x00,0xaa,0xaa,
  0xaa,0x00,0x00, 0xaa,0x00,0xaa, 0xaa,0x55,0x00, 0xaa,0xaa,0xaa,
  0x55,0x55,0x55, 0x55,0x55,0xff, 0x55,0xff,0x55, 0x55,0xff,0xff,
  0xff,0x55,0x55, 0xff,0x55,0xff, 0xff,0xff,0x55, 0xff,0xff,0xff
};

void setrgbcolor(uint8_t r, uint8_t g, uint8_t b, struct colvalue *f)
{
  (*f).r= r;
  (*f).g= g;
  (*f).b= b;
}

void setrgbfromega(uint8_t eganr, struct colvalue *f)
{
  (*f).g= egapalette[(eganr*3)+1];        // gruen
  (*f).r= egapalette[(eganr*3)];          // rot
  (*f).b= egapalette[(eganr*3)+2];        // blau
}

/* ----------------------------------------------------------
                          ws_reset

     setzt die Leuchtdiodenreihe (fuer einen folgenden
     Datentransfer zu den Leuchtdioden) zurueck
   ---------------------------------------------------------- */
void ws_reset(void)
{
  __asm
    bres gpio_asm, #gpio_pin            // Datenpin des LED-Strangs auf 0 setzen
  __endasm;

  delay_us(100);
}


/* -------------------------------------------------------------
      ws_showarray

      (leider) in Maschinensprache, weil ich keinen anderen
      Weg gefunden habe, mittels SDCC 350 Nanosekundenimpulse
      zu erzeugen.

      Der SDCC legt seine Parameter auf den Stack in der
      Reihenfolge von hinten nach vorne ab, hier also:

      anz (2 Byte), *ptr (2 Byte), Ruecksprungadresse (2 Byte)

      In wiefern andere Compiler den Stack belegen weiss ich in
      Ermangelung eines anderen Compilers nicht und von daher
      wird diese Funktion wohl nur mit SDCC (Version 3.5)
      funktionieren.

      Uebergabe:
                *ptr  : Zeiger auf ein Array, das angezeigt
                        werden soll
                anz   : Anzahl der anzuzeigenden LED's
   ------------------------------------------------------------- */
void ws_showarray(uint8_t *ptr, int anz)
{
  __asm

    push a
    pushw x
    pushw y                   // auf dem Stack liegt (in dieser Reihenfolge)
                              // int anz                         ( 2 Byte )
                              // Zeiger ptr                      ( 2 Byte )
                              // Ruecksprungadresse              ( 2 Byte )
                              // a                               ( 1 Byte )
                              // x                               ( 2 Byte )
                              // y                               ( 2 Byte )

    ldw y,(0x0a, sp)          // 10. Position auf dem Stack = int anz

    // anz= (anz*3)-1         => jede LED 3 Byte Speicherbedarf erfordert n*3
    //                           Sendevorgaenge;
    addw y,(0x0a, sp)
    addw y,(0x0a, sp)
    decw y

    ldw x,(0x08, sp)          //  8. Position = *ptr

    array_loop:

      pushw y                 // Anzahl der noch zu sendenden Bytes auf den Stack

      ld a,(x)                // a enthaellt den ersten Wert, auf den PTR zeigt
      ldw y,#0x0007           // 8 Shifts fuer 1 Byte

      loop0:

        rlc a                 // ist hoechstwertigstes gesetzt
        jrc sendhi            // dann eine 1 senden
      sendlo:
        // 0 - senden
        bset gpio_asm, #gpio_pin
        nop
        nop
        bres gpio_asm, #gpio_pin
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop

        jra loop0_end

      sendhi:
        // 1 - senden
        bset gpio_asm, #gpio_pin
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        bres gpio_asm, #gpio_pin
        nop
        nop

      loop0_end:
        decw y
      jrpl loop0

      incw x
      popw y
      decw y
    jrpl array_loop

    popw y
    popw x
    pop a

  __endasm;
}

/* ----------------------------------------------------------
                          ws_clrarray
     loescht ein LED Anzeigearray

     Parameter:
                   *ptr : Zeiger auf ein Array, das
                          geloescht werden soll
                    anz : Anzahl der LEDs, die angezeigt
                          werden sollen
   ---------------------------------------------------------- */
void ws_clrarray(uint8_t *ptr, int anz)
{
  int i;

  for (i= 0; i< (anz*3); i++)
  {
    *ptr = 0x00;
    ptr++;
  }
}

/* ----------------------------------------------------------
                        ws_setrgbcol

      setzt den Farbwert der in der in

                    struct colvalue f

      angegeben ist, in einem Array, das mittels
      ws_showarray auf einen LED-Strang ausgegeben
      werden kann.

      Parameter:
                    *ptr : Zeiger auf ein Array, das die
                           RGB Farbwerte aufnehmen soll
                      nr : LED-Nummer im Array, welche die
                           Position im Leuchtdiodenstrang
                           repraesentiert
   ---------------------------------------------------------- */
void ws_setrgbcol(uint8_t *ptr, uint16_t nr, struct colvalue *f)
{
  ptr+= (nr*3);
  *ptr= (*f).g;
  ptr++;
  *ptr= (*f).r;
  ptr++;
  *ptr= (*f).b;
}

/* ----------------------------------------------------------
                        ws_setegacol

      setzt einen Farbwert aus der EGA-Palette in einem
      Array, das mittels showarray auf einem LED-Strang
      ausgegeben werden kann.

      Parameter:
                    *ptr : Zeiger auf ein Array, das die
                           RGB Farbwerte aufnehmen soll
                      nr : LED-Nummer im Array, welche die
                           Position im Leuchtdiodenstrang
                           repraesentiert
                   eganr : Farbwert, der EGA-Palette

                           0..15 dunkle Farben
                          16..31 helle  Farben

   ---------------------------------------------------------- */
void ws_setegacol(uint8_t *ptr, uint16_t nr, uint8_t eganr)
{
  ptr+= (nr*3);
  *ptr= egapalette[(eganr*3)+1];        // gruen
  ptr++;
  *ptr= egapalette[(eganr*3)];          // rot
  ptr++;
  *ptr= egapalette[(eganr*3)+2];        // blau
}

/* ----------------------------------------------------------
                          ws_blendup_left

      blendet eine LED-Anzahl anz mit dem Farbwert, der in


                      struct colvalue f

      angegeben ist, links schiebend auf.

      Verzoegerungszeit dtime bestimmt die Dauer eines
      Einzelschrittes beim Aufbau
   ---------------------------------------------------------- */
void ws_blendup_left(uint8_t *ptr, uint8_t anz, struct colvalue *f, int dtime)
{
  int8_t i;

  ws_reset();
  for (i= 2; i< anz+1; i++)
  {
    ws_setrgbcol(ptr, i-1, f);
    ws_showarray(ptr, anz);
    delay_ms(dtime);
  }
}

/* ----------------------------------------------------------
                          ws_blendup_right

      blendet eine LED-Anzahl anz mit dem Farbwert, der in


                       struct colvalue f

      angegeben ist, rechts schiebend auf.

      Verzoegerungszeit dtime bestimmt die Dauer eines
      Einzelschrittes beim Aufbau
   ---------------------------------------------------------- */
void ws_blendup_right(uint8_t *ptr, uint8_t anz, struct colvalue *f, int dtime)
{
  int8_t i;

  ws_reset();
  for (i= anz; i> -1; i--)
  {
    ws_setrgbcol(ptr, i-1, f);
    ws_showarray(ptr, ledanz);
    delay_ms(dtime);
  }
}


/* ----------------------------------------------------------
                          ws_buffer_rl

      rotiert einen Pufferspeicher der die Leuchtdiodenmatrix
      enthaelt um eine LED-Position nach links (also 3 Bytes)
      und fuegt hierbei die am Ende anstehende LED am Anfang
      wieder ein.
   ---------------------------------------------------------- */
void ws_buffer_rl(uint8_t *ptr, uint8_t lanz)
{
  uint8_t b, b2, j;
  int     i;
  uint8_t *hptr1, *hptr2;

  for (j= 0; j< 3; j++)
  {
    hptr1 = ptr;
    hptr1 += (lanz*3)-1;
    b= *hptr1;
    for (i= (lanz*3)-1; i> 0; i--)
    {
      hptr2= ptr;
      hptr2 += (i-1);
      b2= *hptr2;
      hptr2++;
      *hptr2= b2;
    }
    *ptr= b;
  }
}

/* ----------------------------------------------------------
                          ws_buffer_rr

      rotiert einen Pufferspeicher der die Leuchtdiodenmatrix
      enthaelt um eine LED-Position nach rechts (also 3 Bytes)
      und fuegt hierbei die am Anfang anstehende LED am Ende
      wieder ein.
   ---------------------------------------------------------- */
void ws_buffer_rr(uint8_t *ptr, uint8_t lanz)
{
  uint8_t b, b2, j;
  int     i;
  uint8_t *hptr1, *hptr2;


  for (j= 0; j< 3; j++)
  {
    b= *ptr;
    for (i= 0; i < (lanz*3)-1;  i++)
    {
      hptr2= ptr;
      hptr2 += i+1;
      b2= *hptr2;
      hptr2--;
      *hptr2= b2;
    }
    hptr1 = ptr;
    hptr1 += (lanz*3)-1;
    *hptr1= b;
  }
}


/* -------------------------------------------------------------------------------------------
                                              M-A-I-N
   ------------------------------------------------------------------------------------------- */

int main(void)
{
  int8_t    i;

  struct colvalue rgbcol;

  sysclock_init(0);                     //  initialisieren mit internem RC-Taktgeber
  ws_init();
  ws_reset();


  while(1)
  {

    ws_clrarray(&ledbuffer[0],ledanz);
    ws_showarray(&ledbuffer[0], ledanz);   // leeren LED-Strang anzeigen
    delay_ms(1);

    // fuegt eine blaue Leuchtdiode an Position 0 in den LED-Matrixpuffer
    // an Position 1 ein
    setrgbcolor(0,0,5, &rgbcol);
    ws_setrgbcol(&ledbuffer[0], 1, &rgbcol);

    // und laesst die Matrix 2 Durchlaeufe nach rechts, dann nach links rotieren
    // (Lauflicht)
    for (i= 0; i< (ledanz * 4)-1; i++)
    {
      ws_showarray(&ledbuffer[0], ledanz);
      delay_ms(100);
      ws_buffer_rl(&ledbuffer[0], ledanz);
    }
    for (i= 0; i< (ledanz * 4)-1; i++)
    {
      ws_showarray(&ledbuffer[0], ledanz);
      delay_ms(100);
      ws_buffer_rr(&ledbuffer[0], ledanz);
    }
    delay_ms(1500);


    // laesst 4 mal hintereinander 4 verschiedene Farben aufblenden
    ws_clrarray(&ledbuffer[0],ledanz);
    for (i= 1; i< 4; i++)
    {
      setrgbcolor(0,2,0, &rgbcol);
      ws_blendup_left(&ledbuffer[0], ledanz, &rgbcol, 35);
      setrgbcolor(2,0,0, &rgbcol);
      ws_blendup_left(&ledbuffer[0], ledanz, &rgbcol, 35);
      setrgbcolor(0,0,2, &rgbcol);
      ws_blendup_left(&ledbuffer[0], ledanz, &rgbcol, 35);
      setrgbcolor(2,0,2, &rgbcol);
      ws_blendup_left(&ledbuffer[0], ledanz, &rgbcol, 35);
    }

    delay_ms(1000);

    // zeigt die ersten 7-EGA-Farben an
    for (i= 1; i< ledanz+1; i++)
    {
      ws_setegacol(&ledbuffer[0], i-1, i);
    }

    ws_reset();
    ws_showarray(&ledbuffer[0], ledanz);

    delay_ms(3000);
  }
}

