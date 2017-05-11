/* -------------------------------------------------------
                         toene.h

     erzeugt Toene der C-Dur Tonleiter mittels Timer1-
     Overflow Interrupt, Lautsprecher an PD4 (ueber
     PNP-Transistor)

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     28.06.2016  R. Seelig
   ------------------------------------------------------ */
#ifndef in_toene
  #define in_toene

  #include "stm8s.h"
  #include "stm8_init.h"
  #include "stm8_gpio.h"

  // Lautsprecher an PD4 angeschlossen
  #define spk_init()      PD4_output_init()
  #define spk_set()       PD4_set()
  #define spk_clr()       PD4_clr()

  // Grundspielgeschwindigkeit
  #define                 playtempo 5       // Spieltempo, in dem die Noten abgespielt werden

  extern volatile char    sound;

  // Prototypen
  void tim1_ovf(void) __interrupt(11);
  void tim1_init(void);
  void setfreq(uint16_t freq);
  void tonlen(int w);
  void playnote(char note);
  void playstring(const uint8_t* const s);

#endif