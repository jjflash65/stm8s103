/* ------------------------ spi.c ------------------

     stellt einfacheFunktionen fuer SPI
     Datentransfer zur Verfuegung.

     15.04.2016   R. Seelig
  -------------------------------------------------- */

#include "spi.h"


/* -------------------------------------------------------------
   SPI_INIT

   SPI-Interface der STM8 MCU konfigurieren

     spi_clk:
       Taktteiler, zulaessige Werte 0 .. 7
       0: freq / 2
       1: freq / 4
       .
       .
       7: freq / 256

     cpol = 0   SCK to 0 wenn idle
          = 1   SCK to 1 wenn idle
                ( Takt invertiert)
     cpha = 0   first clock transition is first data capture edge
          = 1   second clock transition is first data capture edge

   ------------------------------------------------------------- */
void spi_init(uint8_t spi_clk, char cpol, char cpha)
// Pins der SPI Funktionen als Ausgang setzen
{

  SPI_DDR  |= ( (1 << SPI_MOSI_PIN) | (1 << SPI_CLK_PIN));
  SPI_CR1  |= ( (1 << SPI_MOSI_PIN) | (1 << SPI_CLK_PIN));

  SPI_DDR  &= ~(1 << SPI_MISO_PIN);                             // Miso ist Eingang
  SPI_CR1S |= (1 << SPI_MISO_PIN);                              // Pop-Up Widerstand


  /* ---------------------------------------------
      // CPOL und CPHA
     --------------------------------------------- */

  if  (cpha)  SPI_CR1  |= SPI_CR1_CPHA; else SPI_CR1 &= ~(SPI_CR1_CPHA);
  if  (cpol)  SPI_CR1  |= SPI_CR1_CPOL; else SPI_CR1 &= ~(SPI_CR1_CPOL);

  //  SPI_CR1  |= SPI_CR1_LSBFIRST;            // hoeherwertiges Datenbit zu erst auf die Reise schicken


  SPI_CR1  |= SPI_CR1_MSTR;
  SPI_CR1  |= SPI_CR1_SPE;

  SPI_CR1  &= ~(0x07 << SPI_CR1_BR);
  SPI_CR1  |= (spi_clk << SPI_CR1_BR);    // Baudratendevisor enthaellt 3 Bits
                                          // 0x00 entspricht Teiler / 2, 0x07 = Teiler durch 256

}

/* -------------------------------------------------------------
   SPI_OUT

      Byte ueber SPI senden / empfangen
      data ==> zu sendendes Datum
   ------------------------------------------------------------- */
uint8_t spi_out(uint8_t data)
{

// Hardware SPI - Interface

  while (SPI_SR & SPI_SR_BSY);                   // warten bis SPI Hardware nicht beschaeftigt
  while (!(SPI_SR & SPI_SR_TXE));                // warten bis das letzte Datum geschickt wurde
  SPI_DR= data;

  return SPI_DR;

}

uint8_t spi_read(void)
{
  return SPI_DR;
}
