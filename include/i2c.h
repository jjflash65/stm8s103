/* -------------------------------------------------------
                           i2c.h

     Libraryheader zum Ansprechen des I2C Busses
     OHNE Interruptbenutzung

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     31.05.2016  R. Seelig
   ------------------------------------------------------ */

#ifndef in_stm8i2c
  #define in_stm8i2c

  #include "stm8s.h"
  #include "stm8_init.h"


  extern uint8_t speedsel;

  void i2c_init(char freq);
  void i2c_start(void);
  void i2c_stop(void);
  uint8_t i2c_write(uint8_t value);
  uint8_t i2c_read(void);
  uint8_t i2c_read_nack(void);

#endif
