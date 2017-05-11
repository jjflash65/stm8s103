/* ----------------------- spi.h -------------------

     stellt einfache Funktionen fuer SPI
     Datentransfer zur Verfuegung.

     15.04.2016   R. Seelig
  -------------------------------------------------- */


#ifndef in_spiuart
  #define in_spiuart

  #include "stm8s.h"
  #include "stm8_gpio.h"


  /* --------------------------------------------------
        grundsaetzliche Funktionen und Macros des
        SPI - Interfaces
     -------------------------------------------------- */

  #define SPI_DDR               PC_DDR
  #define SPI_CR1S              PC_CR1
  #define SPI_MISO_PIN          PC7
  #define SPI_MOSI_PIN          PC6
  #define SPI_CLK_PIN           PC5


  void     spi_init(uint8_t spi_clk, char cpol, char cpha);
  uint8_t  spi_out(uint8_t data);
  uint8_t  spi_read(void);

#endif
