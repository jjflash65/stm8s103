/* -------------------------------------------------------
                        eeprom_demo.c
     Test des EEPROMS

     MCU   :  STM8S103F3
     Takt  :  interner Takt 16 MHz

     18.05.2016  R. Seelig
   ------------------------------------------------------ */

#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"
#include "uart.h"
#include "my_printf.h"


#define led_output_init()   PB5_output_init()
#define led_set()           PB5_set()
#define led_clr()           PB5_clr()


#define printf   my_printf

void putchar(char ch)
// putchar wird von myprintf aufgerufen
{
  uart_putchar(ch);
}

void eeprom_unlock(void)
{
  if (!(FLASH_IAPSR & FLASH_IAPSR_DUL))
  FLASH_DUKR= 0xae;
  FLASH_DUKR= 0x56;
}

#define eeprom_lock()    (FLASH_IAPSR &= ~(FLASH_IAPSR_DUL))


/* --------------------------------------------------
                      eeprom_write
     schreibt den Wert value an die Adresse addr
     im internen EEPROM
   -------------------------------------------------- */
uint8_t eeprom_write(uint16_t addr, uint8_t value)
{
  uint8_t *address = (char *) EEPROM_BASE_ADDR + addr;

  if (addr > 0x027f) return 0;                  // 0x27f = 639 = hoechste verfuegbare
                                                // Speicherzelle
  *address = (uint8_t) value;
  return 1;
}

/* --------------------------------------------------
                      eeprom_read
     liest den Inhalt der Speicheradresse addr
     des internen EEPROM aus und gibt dieses als
     Argument zurueck
   -------------------------------------------------- */
uint8_t eeprom_read(uint16_t addr)
{
  uint8_t value;
  uint8_t *address = (char *) EEPROM_BASE_ADDR + addr;

  if (addr > 0x027f) return 0xff;               // 0x27f = 639 = hoechste verfuegbare
                                                // Speicherzelle
  value= *address;
  return value;
}


/* --------------------------------------------------
                          MAIN
   -------------------------------------------------- */
int main(void)
{
  uint8_t  eep_data;
  uint16_t eep_indata;

  sysclock_init(0);
  uart_init(19200);

  eeprom_unlock();

  led_output_init();

  printf("\n\r--------------------------------------");
  printf("\n\rSTM8 EEPROM - Test\n\n\r");
  printf("31.05.2016  R. Seelig\n\r");
  printf("--------------------------------------\n\r");


  eep_data= 0x3c;
  printf("\n\rWriting value 0x%x on memoryaddress 0x0020", eep_data);
  eeprom_write(0x0020, eep_data);

  eep_data= 0x7a;
  printf("\n\rWriting value 0x%x on memoryaddress 0x0024\n\r", eep_data);
  eeprom_write(0x0024, eep_data);

  eep_indata= eeprom_read(0x0020);
  printf("\n\r0x0020: 0x%x",eep_indata);
  eep_indata= eeprom_read(0x0024);
  printf("\n\r0x0024: 0x%x\n\r",eep_indata);

  eeprom_lock();

  while(1)
  {
  }
}
