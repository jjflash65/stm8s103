/* -------------------------------------------------------
                        sn74hc595.h
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

#ifndef in_sr595
  #define in_sr595

  #include "stm8s.h"
  #include "stm8_init.h"
  #include "stm8_gpio.h"

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

  #define srdata_init()       PD3_output_init()
  #define srdata_set()        PD3_set()
  #define srdata_clr()        PD3_clr()

  #define srstrobe_init()     PD2_output_init()
  #define srstrobe_set()      PD2_set()
  #define srstrobe_clr()      PD2_clr()

  #define srclock_init()      PD1_output_init()
  #define srclock_set()       PD1_set()
  #define srclock_clr()       PD1_clr()


  extern uint8_t sr595_buffer;


  void sr595_delay(void);
  void sr595_ckpuls(void);
  void sr595_stpuls(void);
  void sr595_outbyte(uint8_t value);
  void sr595_outbit(char nr, char value);
  void sr595_init(void);

#endif
