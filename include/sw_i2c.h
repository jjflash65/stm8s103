/* -----------------------------------------------------
                        sw_i2c.h

    Softwareimplementierung  I2C-Bus (Bitbanging)

    MCU   :  STM8S103F3
    Takt  :  interner Takt 16 MHz

    IDE       : keine (Editor / make)
    Toolchain : SDCC

    16.10.2016   R. seelig
  ------------------------------------------------------ */

#ifndef in_sw_i2c
  #define in_sw_i2c

  #include "stm8s.h"
  #include "stm8_init.h"
  #include "stm8_gpio.h"

  #define short_puls     0            // Einheiten fuer einen langen Taktimpuls
  #define long_puls      0            // Einheiten fuer einen kurzen Taktimpuls
  #define del_wait       0            // Wartezeit fuer garantierten 0 Pegel SCL-Leitung

  #define i2c_sda_inp()   PB5_input_init()
  #define i2c_sda_out()   PB5_output_init()
  #define i2c_sda_hi()    PB5_set()
  #define i2c_sda_lo()    PB5_clr()
  #define i2c_is_sda()    is_PB5()

  #define i2c_scl_out()   PB4_output_init()
  #define i2c_scl_hi()    PB4_set()
  #define i2c_scl_lo()    PB4_clr()

  #define short_del()     i2c_delay(short_puls)
  #define long_del()      i2c_delay(long_puls)
  #define wait_del()      i2c_delay(del_wait)

  // --------------------------------------------------------------------
  //                      Prototypen aus sw_i2c.h
  // --------------------------------------------------------------------

  /* -------------------------------------------------------

      ############### i2c_master_init ##############

      setzt die Pins die fuer den I2C Bus verwendet werden
      als Ausgaenge


      ############## i2c_sendstart(void) ###############

      erzeugt die Startcondition auf dem I2C Bus


      ############## i2c_start(uint8_t addr) ##############

      erzeugt die Startcondition auf dem I2C Bus und
      schreibt eine Deviceadresse auf den Bus


      ############## i2c_stop(void) ##############

      erzeugt die Stopcondition auf dem I2C Bus


      ############## i2c_write_nack(uint8_t data) ##############

      schreibt einen Wert auf dem I2C Bus OHNE ein Ack-
      nowledge einzulesen


      ############## i2c_write(uint8_t data) ##############

      schreibt einen Wert auf dem I2C Bus.

      Rueckgabe:
                 > 0 wenn Slave ein Acknowledge gegeben hat
                 == 0 wenn kein Acknowledge vom Slave


      ############## i2c_write16(uint16_t data) ##############

      schreibt einen 16 Bit Wert (2Bytes) auf dem I2C Bus.

      Rueckgabe:
                 > 0 wenn Slave ein Acknowledge gegeben hat
                 == 0 wenn kein Acknowledge vom Slave


      ############## i2c_read(uint8_t ack) ##############

      liest ein Byte vom I2c Bus.

      Uebergabe:
                 1 : nach dem Lesen wird dem Slave ein
                     Acknowledge gesendet
                 0 : es wird kein Acknowledge gesendet

      Rueckgabe:
                  gelesenes Byte
     ------------------------------------------------------- */

  void i2c_master_init(void);
  void i2c_sendstart(void);
  uint8_t i2c_start(uint8_t addr);
  void i2c_stop();
  void i2c_write_nack(uint8_t data);
  uint8_t i2c_write(uint8_t data);
  uint8_t i2c_write16(uint16_t data);
  uint8_t i2c_read(uint8_t ack);

  #define i2c_read_ack()    i2c_read(1)
  #define i2c_read_nack()   i2c_read(0)

#endif
