/* vim: set sw=8 ts=8 si et: */
/*********************************************
* Basic LED test software for the avrusb500 programmer.
* Author: Guido Socher, Copyright: GPL 
* Copyright: GPL
**********************************************/
#include <inttypes.h>
#include <string.h>
#include <avr/io.h>
#include "led.h"
#include "avr_compat.h"
#include "timeout.h"


int main(void)
{
        LED_INIT;
        LED_OFF;
        while(1){
                // 1 Hz:
                delay_ms(500);
                LED_ON;
                delay_ms(500);
                LED_OFF;
        }
	return(0);
}

