/* vim: set sw=8 ts=8 si et: */
/*********************************************
* Serial Peripheral Interface
* Author: Guido Socher, Copyright: GPL
* Copyright: GPL
**********************************************/
#include <avr/io.h>
#include "avr_compat.h"
#include "timeout.h"
// timing for software spi:
// #define F_CPU 3686400UL  // 3.6864 MHz
#include <util/delay.h>
static unsigned char sck_dur=1;
static unsigned char spi_in_sw=0;
//static unsigned char sck_dur=12;
//static unsigned char spi_in_sw=1;

// set the speed (used by PARAM_SCK_DURATION, page 31 in AVR068)
// For a clock of 3.6864MHz this is:
// SPI2X SPR1 SPR0 divider result_spi_Freq   avrisp dur
//  0     0    0     f/4      921KHz :        sckdur =0
//  0     0    1     f/16     230KHz :        sckdur =1
//  0     1    0     f/64     57KHz  :        sckdur =2
//  0     1    1     f/128    28KHz  :        sckdur =3
//
//SPI2X=SPSR bit 0
//SPR0 and SPR1 =SPCR bit 0 and 1
unsigned char  spi_set_sck_duration(unsigned char dur)
{
        spi_in_sw=0;
        if (dur >= 4){
        	// sofware spi very slow
                spi_in_sw=1;
                sck_dur=12;
        	return(sck_dur);
        }
        if (dur >= 3){
        	// 28KHz
        	cbi(SPSR,SPI2X);
        	sbi(SPCR,SPR1);
        	sbi(SPCR,SPR0);
                sck_dur=3;
        	return(sck_dur);
        }
        if (dur >= 2){
        	// 57KHz
        	cbi(SPSR,SPI2X);
        	sbi(SPCR,SPR1);
        	cbi(SPCR,SPR0);
                sck_dur=2;
        	return(sck_dur);
        }
        if (dur == 1){
        	// 230KHz
        	cbi(SPSR,SPI2X);
        	cbi(SPCR,SPR1);
        	sbi(SPCR,SPR0);
                sck_dur=1;
        	return(sck_dur);
        }
        if (dur == 0){
                // 921KHz
                cbi(SPSR,SPI2X);
                cbi(SPCR,SPR0);
                cbi(SPCR,SPR1);
                sck_dur=0;
                return(sck_dur);
        }
        return(1); // we should never come here
}

unsigned char spi_get_sck_duration(void)
{
        return(sck_dur);
}

void spi_sck_pulse(void)
{
        uint8_t spcrval;
        spcrval=SPCR; // store old value
        SPCR=0x00;     // SPI off
        cbi(PORTB,PB5); // SCK low
        _delay_ms(0.10);
        sbi(PORTB,PB5); // SCK high
        _delay_ms(0.10);
        cbi(PORTB,PB5); // SCK low
        SPCR=spcrval;
}

void spi_reset_pulse(void)
{
        /* give a positive RESET pulse, we can't guarantee
         * that SCK was low during power up (see Atmel's
         * data sheets, search for "Serial Downloading in e.g atmega8
         * data sheet):
         * the programmer can not guarantee that SCK is held low during
         * Power-up. In this case, RESET must be given a positive pulse of at least two
         * CPU clock cycles duration after SCK has been set to 0."*/
        PORTB|= (1<<PB2); // reset = high = not active
        _delay_ms(0.10);
        PORTB &= ~(1<<PB2); // reset = low, stay active
        delay_ms(20); // min stab delay
}

void spi_init(void)
{
        sbi(DDRB,PB2); // pb2 as reset pin is output, this is also the ss pin which
                       // must be output for master to work.
        sbi(PORTB,PB2); // reset = high = not active
        //
	// now output pins low in case somebody used it as output in his/her circuit
        sbi(DDRB,PB3); // MOSI is output
        cbi(PORTB,PB3); // MOSI low
        sbi(DDRB,PB5); // SCK is output
        cbi(PORTB,PB5); // SCK low
        delay_ms(20); // discharge MOSI/SCK
        if (spi_in_sw==0){
                /* Enable SPI, Master, set clock rate fck/16 */
                SPCR = (1<<SPE)|(1<<MSTR)|(1<<SPR0);
                spi_set_sck_duration(sck_dur);
                // now SCK and MOSI are under control of SPI
        }
        cbi(PORTB,PB2); // reset = low, stay active
        delay_ms(20); // stab delay
        spi_reset_pulse();
}

// send 8 bit, return received byte
unsigned char spi_mastertransmit(unsigned char data)
{
        unsigned char i=128;
        unsigned char rval=0;
        if (spi_in_sw==0){
                /* Start transmission in hardware*/
                SPDR = data;
                /* Wait for transmission complete */
                while(!(SPSR & (1<<SPIF)));
                return(SPDR);
        }
        // software spi, slow
        cbi(PORTB,PB5); // SCK low
        while(i){
                // MOSI
                if (data&i){
                        sbi(PORTB,PB3);
                }else{
                        cbi(PORTB,PB3);
                }
                _delay_ms(0.10);
                // read MISO
                if( bit_is_set(PINB,PINB4)){
                        rval|= i;
                }
                sbi(PORTB,PB5); // SCK high
                _delay_ms(0.10);
                cbi(PORTB,PB5); // SCK low
                i=i>>1;
        }
        return(rval);
}

// send 16 bit, return last rec byte
unsigned char spi_mastertransmit_16(unsigned int data)
{
        spi_mastertransmit((data>>8)&0xFF);
        return(spi_mastertransmit(data&0xFF));
}

// send 32 bit, return last rec byte
unsigned char spi_mastertransmit_32(unsigned long data)
{
        spi_mastertransmit((data>>24)&0xFF);
        spi_mastertransmit((data>>16)&0xFF);
        spi_mastertransmit((data>>8)&0xFF);
        return(spi_mastertransmit(data&0xFF));
}


void spi_disable(void)
{
        SPCR=0x00;     // SPI off
        sbi(PORTB,PB2);// reset = high, off
        cbi(DDRB,PB3); // MOSI high impedance, input
        cbi(PORTB,PINB3);// pullup off
        cbi(DDRB,PB5); // SCK high impedance, input
        cbi(PORTB,PINB5);// pullup off
        //
        cbi(DDRB,PINB2); // reset pin as input, high impedance
        cbi(PORTB,PINB2);// pullup off
}

