#ifndef in_stkspi
  #define in_stkspi

  #include "stm8s.h"
  #include "stm8_init.h"
  #include "stm8_gpio.h"


  #define stkspi_res_init()  PB4_output_init()
  #define stkspi_reshi()     PB4_set()
  #define stkspi_reslo()     PB4_clr()

  extern void stkspi_init(void);
  extern unsigned char stkspi_set_sck_duration(unsigned char dur);
  extern unsigned char stkspi_get_sck_duration(void);
  extern unsigned char stkspi_mastertransmit(unsigned char data);
  extern unsigned char stkspi_mastertransmit_16(unsigned int data);
  extern unsigned char stkspi_mastertransmit_32(unsigned long data);
  extern void stkspi_disable(void);
  extern void stkspi_reset_pulse(void);

#endif

