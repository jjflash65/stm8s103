/* vim: set sw=8 ts=8 si et: */
/*********************************************
* Author: Guido Socher, Copyright: GPL 
* Copyright: GPL
**********************************************/
#include <inttypes.h>
#include <avr/interrupt.h>
#include <stdlib.h> 
#include <string.h>
#include <avr/io.h>
#include "uart.h"
#include "led.h"
#include "avr_compat.h"

int main(void)
{
        char ch;
	char str[10];
        uart_init();
        LED_INIT;
        LED_OFF;
        sei();
        while(1){
                ch=uart_getchar(1);
		// echo any input as hex value back (for testing
		// of the connection):
		itoa((int)ch,str,16);
		uart_sendstr_P("0x");
		uart_sendstr(str);
                if (ch == '\n' || ch == '\r' || ch ==' '){
                        continue;
                }
                if (ch == '0'){
                        LED_OFF;
                        uart_sendstr_P("\noff OK\n");
                }else if (ch == '1'){
                        LED_ON;
                        uart_sendstr_P("\non OK\n");
                }else{
                        uart_sendstr_P("\nUSAGE: 1 switch led on\n       0 switch led off\n");
                }
        }
	return(0);
}

