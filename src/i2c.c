/* -------------------------------------------------------
                           i2c.c

     grundlegende Library zum Ansprechen des I2C Busses
     OHNE Interruptbenutzung

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     31.05.2016  R. Seelig
   ------------------------------------------------------ */

#include "i2c.h"


uint8_t speedsel;
uint8_t i2c_first;

/* ---------------------------------------------------------
                           i2c_delay
       an die "Reaktionszeiten" der Register des STM8 an-
       gepasste Warteschleife
   --------------------------------------------------------- */
void i2c_delay(uint16_t anz)
{
  volatile uint16_t count;

  for (count= 0; count< anz; count++)
  {
    __asm
      nop
      nop
    __endasm;
  }
}

/* ---------------------------------------------------------
                           i2c_init

      initialisiert den I2C-Bus

      freq= 0    I2C Busfrequenz ca. 100 kHz
          = 1    I2C Busfrequenz ca.  50 kHz
          = 2    I2C Busfrequenz ca.  15 kHz
   --------------------------------------------------------- */
void i2c_init(char freq)
{
  I2C_CR1 = 0;                 // Power disable, clock stretching enable

  I2C_FREQR = 16;              // 16 MHZ F_CPU
  speedsel= freq;
  switch (freq)
  {
    case 0  :
    {
      I2C_CCRL = 0x45;
      I2C_CCRH = 0x00;         // I2C Busfrequenz ca. 100KHz /  Standardmode
      break;
    }
    case 1  :
    {
      I2C_CCRL = 0x98;
      I2C_CCRH = 0x00;         // I2C Busfrequenz ca.  50KHz /  Standardmode
      break;
    }
    case 2  :
    {
      I2C_CCRL = 0x00;
      I2C_CCRH = 0x02;         // I2C Busfrequenz ca.  15KHz /  Standardmode
      break;
    }
    default : break;
  }

  I2C_TRISER = 2;
  I2C_CR1 |= I2C_CR1_ENGC;
//  I2C_CR2 |= I2C_CR2_POS;
  I2C_CR2 &= ~(I2C_CR2_POS);
  I2C_CR1 |= I2C_CR1_NOSTRETCH;
  I2C_OARH = I2C_OARH_ADDCONF;
  I2C_CR1 |= I2C_CR1_PE;       // I2C Power On
  I2C_CR2 |= I2C_CR2_ACK;              // nach lesen ACK senden
}

/* ---------------------------------------------------------
                           i2c_start

      sendet das Startsignal auf dem I2C Bus (SDA= SCL = 1,
      dann SDA= 0, SCL= 1, dann SDA= SCL = 0)
   --------------------------------------------------------- */
void i2c_start(void)
{
  char dummy;

  I2C_CR2 |= I2C_CR2_START;            // I2C Bus - Startkondition
  I2C_CR2 |= I2C_CR2_ACK;              // nach lesen ACK senden

//  I2C_CR2 |= I2C_CR2_START | I2C_CR2_ACK;
  while (!(I2C_SR1 & I2C_SR1_SB));     // warten bis STM8 Startbefehl verarbeitet hat
  dummy= I2C_SR1;
  i2c_first= 1;
}
/* ---------------------------------------------------------
                           i2c_stop

      sendet das Stopsignal auf dem I2C Bus
   --------------------------------------------------------- */
void i2c_stop(void)
{
  I2C_CR2 |= I2C_CR2_STOP;          // I2C Bus - Stop
}

/* ---------------------------------------------------------
                           i2c_write

      sendet den Wert in < value > auf dem I2C Bus.
      Rueckgabewert:
                     1 : ACK vom Slave gemeldet
                     0 : es wurde kein ACK eines Slaves
                         gesendet
   --------------------------------------------------------- */
uint8_t i2c_write(uint8_t value)
{
  uint8_t  retvalue;
  volatile uint8_t  dummy;
  uint8_t timcx, timcmp;


  switch (speedsel)
  {
    case 0 : timcmp= 13; break;
    case 1 : timcmp= 30; break;
    case 2 : timcmp= 90; break;
//    case 2 : timcmp= 120; break;
  }
  I2C_DR = value;                                    // zu schickende I2C-Bus Adresse
  timcx= 0;                                          // Timeoutcounter um acknowledge abzufragen
  while (((I2C_SR1 & I2C_SR1_ADDR)== 0) && (timcx< timcmp))
  {
    i2c_delay(5);
    timcx++;
  }
  dummy= I2C_SR3;                                    // damit neues Zeichen geschickt werden kann

  if (I2C_SR2 & I2C_SR2_AF) retvalue= 0; else retvalue= 1;
  I2C_SR2 &= ~(I2C_SR2_AF);                          // ACK-Flag loeschen

  return retvalue;
}


/* ---------------------------------------------------------
                           i2c_read

      liest I2C Bus und gibt ACK
      Rueckgabewert:
                     gelesener Wert
   --------------------------------------------------------- */
uint8_t i2c_read(void)
{
  static uint8_t value;
  static uint8_t dummy;

  I2C_CR2 &= ~(I2C_CR2_POS);


  if (!(i2c_first))
  {
    I2C_CR2 |= I2C_CR2_ACK;                          // nach lesen ACK senden
    value= I2C_DR;
    I2C_SR1 &=  ~(I2C_SR1_RXNE);
  }

  I2C_CR2 &= ~(I2C_CR2_POS);
  I2C_CR2 |= I2C_CR2_ACK;                          // nach lesen ACK senden
  value= I2C_DR;

  i2c_first= 0;
  return value;
}

/* ---------------------------------------------------------
                           i2c_read_nack

      liest I2C Bus und gibt keinen ACK nach lesen
      Rueckgabewert:
                     gelesener Wert
   --------------------------------------------------------- */
uint8_t i2c_read_nack(void)
{
  static uint8_t value;
  static uint8_t dummy;

  if (!(i2c_first))
  {
    I2C_CR2 &= ~(I2C_CR2_ACK);                    // kein ACK senden
    value= I2C_DR;
    I2C_SR1 &=  ~(I2C_SR1_RXNE);
    I2C_CR2 &= ~(I2C_CR2_ACK);                      // kein ACK senden
  }

  I2C_CR2 &= ~(I2C_CR2_ACK);                      // kein ACK senden
  value= I2C_DR;
  I2C_SR1 &=  ~(I2C_SR1_RXNE);
  dummy= I2C_SR1;
  dummy= I2C_SR2;
  dummy= I2C_SR3;


  return value;
}

