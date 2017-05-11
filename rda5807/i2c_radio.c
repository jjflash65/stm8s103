/* -----------     I2C_RADIO.AVC    ------------------

     MCU:          ATmega8   / ATmega48  / ATmega88 /
                   ATmega168 / ATmega328

     Quarz:            16 MZz

     Compiler:         AVR-GCC
     IDE:              Context

     16.06.2013        R. Seelig

   ------------------------------------------------------- */

#ifndef F_CPU
#define F_CPU 1000000
#endif

// ------------------------------------------------------------------------------------------

#include <util/delay.h>
#include <avr/io.h>
#include <avr/pgmspace.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>

#include "i2c_master_mega.h"
#include "atm168_rs232_c.h"

#define chbit(wert,nr)      ((wert) & (1<<nr))               // testet auf einer Bitposition <nr> im Port <wert> auf 1 oder 0

#define fbands 87.005

uint16_t i;

float    aktfreq = 101.80;      // Startfrequenz

uint8_t  rda5807_adrs = 0x10;   // I2C-addr. sequential access
uint8_t  rda5807_adrr = 0x11;   // I2C-addr. random access
uint8_t  rda5807_adrt = 0x60;   // I2C-addr. for TEA5767like access

uint16_t rda5807_regdef[10] ={
            0x0758,             // 00 defaultid
            0x0000,             // 01 not used
            0xD009,             // 02 DHIZ,DMUTE,BASS, POWERUPENABLE,RDS
            0x0000,             // 03
            0x1400,             // 04 DE ? SOFTMUTE
            0x84DF,             // 05 INT_MODE,SEEKTH=0110,????, Volume=15
            0x4000,             // 06 OPENMODE=01
            0x0000,             // 07 unused ?
            0x0000,             // 08 unused ?
            0x0000 };           // 09 unused ?

uint16_t rda5807_reg[32];

void delay(char wert)
{
   char i;
   for (i=0;i< wert;i++)
   {
     _delay_ms(100);
   }
}

/*
void printint(int wert)
{
  char str16[16];

  itoa(wert,str16,10);
  putramstring(str16);
}
*/

//----------------------------------------
// RDA5807 Set one Configuration Registers
//----------------------------------------
void rda5807_writereg(char reg)
{
  i2c_start(rda5807_adrr,0);
  i2c_write(reg);
  i2c_write16(rda5807_reg[reg]);
  i2c_stop();
}

//----------------------------------------
// Set all Configuration Registers
//----------------------------------------
void rda5807_write(void)
{
  uint8_t b;

  i2c_start(rda5807_adrs,0);
  for (int i=2; i<7; i++)
  {
    i2c_write16(rda5807_reg[i]);
  }
  i2c_stop();
}


void rda5807_reset(void)
{
  for (int i=0; i<7; i++)
  {
    rda5807_reg[i]= rda5807_regdef[i];
  }
  rda5807_reg[2]= rda5807_reg[2] | 0x0002;    // Enable SoftReset
  rda5807_write();
  rda5807_reg[2]= rda5807_reg[2] & 0xFFFB;   // Disable SoftReset
}

//----------------------------------------
// RDA5807 Power On
//----------------------------------------
int rda5807_poweron()
{
  rda5807_reg[3]= rda5807_reg[3] | 0x010;   // Enable Tuning
  rda5807_reg[2]= rda5807_reg[2] | 0x001;   // Enable PowerOn

  rda5807_write();

  rda5807_reg[3]= rda5807_reg[3] & 0xFFEF;  // Disable Tuning
}

//----------------------------------------
// RDA5807 Tune Radio to defined Frequency
//----------------------------------------
int rda5807_setfreq(float f_mhz)
{
  uint16_t channel;

  f_mhz= f_mhz+0.1;
  channel=(f_mhz-fbands) / 0.1;
  channel&= 0x03FF;
  rda5807_reg[3]= channel * 64 + 0x10;  // Channel + TUNE-Bit + Band=00(87-108) + Space=00(100kHz)

  i2c_start(rda5807_adrs,0);
  i2c_write16(0xD009);
  i2c_write16(rda5807_reg[3]);
  i2c_stop();

  _delay_ms(100);
//  RDA5807_Status();
  return 0;
}

//----------------------------------------
// RDA5807 Set Volume
//----------------------------------------
void rda5807_setvol(int setvol)
{
  rda5807_reg[5]=(rda5807_reg[5] & 0xFFF0)| setvol;
  rda5807_writereg(5);
}

int main()
{
  i2c_master_init();
  rs232_init(38400);
  stdout= &usartout;

  prints_232("I2C Radio => Reset \n\r");
  rda5807_reset();
  prints_232("I2C Radio => Power On \n\r");
  rda5807_poweron();
  prints_232("I2C Radio => Set Frequenz 97.8 MHz\n\r");
  rda5807_setfreq(101.8);
  prints_232("I2C Radio => Set Volume: 0......x........\n\r");
  rda5807_setvol(4);

  while(1);
}
