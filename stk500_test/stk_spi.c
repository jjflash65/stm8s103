/*********************************************
* SPI Interface fuer STK Programmer
**********************************************/

#include "spi.h"
#include "stk_spi.h"
static unsigned char sck_dur = 1;

//    921KHz :        sckdur =0
//    230KHz :        sckdur =1
//    57KHz  :        sckdur =2
//    28KHz  :        sckdur =3
//
//SPI2X=SPSR bit 0
//SPR0 and SPR1 =SPCR bit 0 and 1

unsigned char  stkspi_set_sck_duration(unsigned char dur)
{
  if (dur >= 3)
  {
    sck_dur=4;
    spi_init(7,0,0);
    return(sck_dur);
  }
  if (dur >= 3)
  {
    sck_dur= 3;
    spi_init(3,0,0);
    return(sck_dur);
  }
  if (dur >= 2)
  {
    sck_dur=2;
    spi_init(2,0,0);
    return(sck_dur);
  }
  if (dur == 1)
  {
    sck_dur=1;
    spi_init(1,0,0);
    return(sck_dur);
  }

  if (dur == 0)
  {
    sck_dur=1;
    spi_init(1,0,0);
    return(sck_dur);
  }

  return(1); // we should never come here
}

unsigned char stkspi_get_sck_duration(void)
{
  return(sck_dur);
}


void stkspi_reset_pulse(void)
{
  stkspi_reshi();
  delay_us(100);
  stkspi_reslo();
  delay_ms(20);
}

void stkspi_init(void)
{
  stkspi_res_init();
  stkspi_set_sck_duration(sck_dur);
  stkspi_reset_pulse();
}

// send 8 bit, return received byte
unsigned char stkspi_mastertransmit(unsigned char data)
{
  return spi_out(data);
}

// send 16 bit, return last rec byte
unsigned char stkspi_mastertransmit_16(unsigned int data)
{
  stkspi_mastertransmit((data>>8)&0xFF);
  return(stkspi_mastertransmit(data&0xFF));
}

// send 32 bit, return last rec byte
unsigned char stkspi_mastertransmit_32(unsigned long data)
{
  stkspi_mastertransmit((data>>24)&0xFF);
  stkspi_mastertransmit((data>>16)&0xFF);
  stkspi_mastertransmit((data>>8)&0xFF);
  return(stkspi_mastertransmit(data&0xFF));
}

void stkspi_disable(void)
{
}

