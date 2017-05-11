/* -------------------------------------------------------
                        shiftreg.c
     Funktionen zum Umgang mit dem 74HC595 Schiebe-
     register.

     Anmerkung: ein HCT - Typ kann hier NICHT verwendet
                werden, da diese eine mindest UB von
                4,5V benoetigt

                Uebernahme Daten ins Schieberegister
                und von Schieberegister ins Latch bei
                positiver Taktflanke

     Hardware : 74HC595

     MCU      : STM8S103F3
     Takt     : interner Takt 16 MHz

     01.07.2016  R. Seelig
   ------------------------------------------------------ */

#include "sn74hc595.h"

/*
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

uint8_t sr595_buffer;           // Buffer, der den aktuellen Inhalt des Schieberegisters
                                // beinhalten soll

/* ----------------------------------------------------------
   sr595_delay

   Verzoegerungsfunktion zur Erzeugung von Takt und Strobe-
   impuls
   ---------------------------------------------------------- */
void sr595_delay(void)
{

  __asm;
    nop
    nop
  __endasm;
}

/* ----------------------------------------------------------
   sr595_ckpuls

   nach der Initialisierung besitzt die Taktleitung low-
   Signal. Hier wird ein Taktimpuls nach high und wieder
   low erzeugt
   ---------------------------------------------------------- */
void sr595_ckpuls(void)
// Schieberegister Taktimpuls
{
  sr595_delay();
  srclock_set();
  sr595_delay();
  srclock_clr();
}

/* ----------------------------------------------------------
   sr595_stpuls

   nach der Initialisierung besitzt die Strobeleitung low-
   Signal. Hier wird ein Taktimpuls nach high und wieder
   low erzeugt
   ---------------------------------------------------------- */
void sr595_stpuls(void)
// Strobe Taktimpuls
{
  sr595_delay();
  srstrobe_set();
  sr595_delay();
  srstrobe_clr();
}

/* ----------------------------------------------------------
   sr595_outbyte

   uebertraegt das Byte in - value - in das Schieberegister.
   Der Wert im Schieberegister wird in der globalen Variable
   - sr595_buffer - gespeichert (damit hiermit in Verbindung
   mit - sr595_outbit - einzelne Bits auf den Ausgaengen
   des Schieberegisters getaetigt werden koennen)
   ---------------------------------------------------------- */
void sr595_outbyte(uint8_t value)
{
  uint8_t mask, b;

  mask= 0x80;

  sr595_buffer= value;

  for (b= 0; b< 8; b++)
  {
    // Byte ins Schieberegister schieben, MSB zuerst
    if (mask & value) srdata_set();             // 1 oder 0 entsprechend Wert setzen
                 else srdata_clr();

    sr595_ckpuls();                             // ... Puls erzeugen und so ins SR schieben
    mask= mask >> 1;                            // naechstes Bit
  }
  sr595_stpuls();                               // komplett ausgegebenes Byte ins Ausgangslatch
}

/* ----------------------------------------------------------
   sr595_outbit

   setzt bzw. loescht ein einzelnes Bit am Ausgang des
   Schieberegisters. Globale Variable - sr595_buffer - wird
   entsprechend veraendert.

   Uebergabewerte:
                 nr => Bitnummer welches gesetzt, bzw.
                       geloescht werden soll

                 value => jeder Wert groesser 0 setzt ein
                          Bit, 0 loescht ein Bit
   ---------------------------------------------------------- */
void sr595_outbit(char nr, char value)
{
  if (value)
  {
    sr595_buffer |= (1 << nr);
    sr595_outbyte(sr595_buffer);
  }
  else
  {
    sr595_buffer &= ~(1 << nr);
    sr595_outbyte(sr595_buffer);
  }
}

/* ----------------------------------------------------------
   sr595_init

   initalisiert alle GPIO Pins die das Schieberegister
   benoetigt als Ausgaenge und setzt alle Ausgaenge des
   Schieberegisters auf 0
   ---------------------------------------------------------- */
void sr595_init(void)
// alle Pins an denen das Schieberegister angeschlossen ist als
// Ausgang schalten
{
  srdata_init();
  srstrobe_init();
  srclock_init();

  srdata_clr();
  srclock_clr();
  srstrobe_clr();

  sr595_outbyte(0);
}


