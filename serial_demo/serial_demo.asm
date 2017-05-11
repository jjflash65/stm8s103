;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Aug 12 2015) (Linux)
; This file was generated Thu Apr 20 06:55:54 2017
;--------------------------------------------------------
	.module serial_demo
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _my_printf
	.globl _uart_init
	.globl _uart_ischar
	.globl _uart_getchar
	.globl _uart_putchar
	.globl _delay_ms
	.globl _sysclock_init
	.globl _putchar
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
;--------------------------------------------------------
; Stack segment in internal ram 
;--------------------------------------------------------
	.area	SSEG
__start__stack:
	.ds	1

;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area DABS (ABS)
;--------------------------------------------------------
; interrupt vector 
;--------------------------------------------------------
	.area HOME
__interrupt_vect:
	int s_GSINIT ;reset
	int 0x0000 ;trap
	int 0x0000 ;int0
	int 0x0000 ;int1
	int 0x0000 ;int2
	int 0x0000 ;int3
	int 0x0000 ;int4
	int 0x0000 ;int5
	int 0x0000 ;int6
	int 0x0000 ;int7
	int 0x0000 ;int8
	int 0x0000 ;int9
	int 0x0000 ;int10
	int 0x0000 ;int11
	int 0x0000 ;int12
	int 0x0000 ;int13
	int 0x0000 ;int14
	int 0x0000 ;int15
	int 0x0000 ;int16
	int 0x0000 ;int17
	int 0x0000 ;int18
	int 0x0000 ;int19
	int 0x0000 ;int20
	int 0x0000 ;int21
	int 0x0000 ;int22
	int 0x0000 ;int23
	int 0x0000 ;int24
	int 0x0000 ;int25
	int 0x0000 ;int26
	int 0x0000 ;int27
	int 0x0000 ;int28
	int 0x0000 ;int29
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area HOME
	.area GSINIT
	.area GSFINAL
	.area GSINIT
__sdcc_gs_init_startup:
__sdcc_init_data:
; stm8_genXINIT() start
	ldw x, #l_DATA
	jreq	00002$
00001$:
	clr (s_DATA - 1, x)
	decw x
	jrne	00001$
00002$:
	ldw	x, #l_INITIALIZER
	jreq	00004$
00003$:
	ld	a, (s_INITIALIZER - 1, x)
	ld	(s_INITIALIZED - 1, x), a
	decw	x
	jrne	00003$
00004$:
; stm8_genXINIT() end
	.area GSFINAL
	jp	__sdcc_program_startup
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area HOME
	.area HOME
__sdcc_program_startup:
	jp	_main
;	return from main will return to caller
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area CODE
;	serial_demo.c: 33: void putchar(char ch)
;	-----------------------------------------
;	 function putchar
;	-----------------------------------------
_putchar:
;	serial_demo.c: 35: uart_putchar(ch);
	ld	a, (0x03, sp)
	push	a
	call	_uart_putchar
	pop	a
	ret
;	serial_demo.c: 39: int main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #3
;	serial_demo.c: 47: sysclock_init(0);
	push	#0x00
	call	_sysclock_init
	pop	a
;	serial_demo.c: 48: delay_ms(2);
	push	#0x02
	push	#0x00
	call	_delay_ms
	popw	x
;	serial_demo.c: 52: uart_init(baudrate);
	push	#0x00
	push	#0xe1
	call	_uart_init
	popw	x
;	serial_demo.c: 54: led_output_init();
	ldw	x, #0x5007
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
	ldw	x, #0x5008
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
	ldw	x, #0x5009
	ld	a, (x)
	and	a, #0xdf
	ld	(x), a
;	serial_demo.c: 59: printf("\n\r--------------------------------------");
	ldw	x, #___str_0+0
	pushw	x
	call	_my_printf
	popw	x
;	serial_demo.c: 60: printf("\n\rSTM8 running at %d MHz\n\r", cnt);
	ldw	x, #___str_1+0
	push	#0x10
	push	#0x00
	pushw	x
	call	_my_printf
	addw	sp, #4
;	serial_demo.c: 61: printf("8 kByte Flash;  1 KByte RAM\n\n\r");
	ldw	x, #___str_2+0
	pushw	x
	call	_my_printf
	popw	x
;	serial_demo.c: 62: printf("Baudrate: %d0\n\n\r",baudrate/10);
	ldw	x, #___str_3+0
	push	#0x80
	push	#0x16
	pushw	x
	call	_my_printf
	addw	sp, #4
;	serial_demo.c: 63: printf("23.06.2016  R. Seelig\n\r");
	ldw	x, #___str_4+0
	pushw	x
	call	_my_printf
	popw	x
;	serial_demo.c: 64: printf("--------------------------------------\n\r");
	ldw	x, #___str_5+0
	pushw	x
	call	_my_printf
	popw	x
;	serial_demo.c: 65: printf("Taste um Counter anzuhalten bzw. neu zu starten\n\n\r");
	ldw	x, #___str_6+0
	pushw	x
	call	_my_printf
	popw	x
;	serial_demo.c: 67: cnt= 0;
	clrw	x
	ldw	(0x02, sp), x
;	serial_demo.c: 68: running= 1;
	ld	a, #0x01
	ld	(0x01, sp), a
;	serial_demo.c: 69: while(1)
00110$:
;	serial_demo.c: 71: if (running)
	tnz	(0x01, sp)
	jreq	00102$
;	serial_demo.c: 73: led_set();
	ldw	x, #0x5005
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
;	serial_demo.c: 74: printf(" Counter: %d  \r",cnt);
	ldw	x, #___str_7+0
	ldw	y, (0x02, sp)
	pushw	y
	pushw	x
	call	_my_printf
	addw	sp, #4
;	serial_demo.c: 75: delay_ms(blinkspeed);
	push	#0xf1
	push	#0x01
	call	_delay_ms
	popw	x
;	serial_demo.c: 76: led_clr();
	ldw	x, #0x5005
	ld	a, (x)
	and	a, #0xdf
	ld	(x), a
;	serial_demo.c: 77: delay_ms(blinkspeed);
	push	#0xf1
	push	#0x01
	call	_delay_ms
	popw	x
;	serial_demo.c: 78: cnt++;
	ldw	x, (0x02, sp)
	incw	x
	ldw	(0x02, sp), x
	jra	00103$
00102$:
;	serial_demo.c: 82: cnt= 0;
	clrw	x
	ldw	(0x02, sp), x
;	serial_demo.c: 83: delay_ms(50);
	push	#0x32
	push	#0x00
	call	_delay_ms
	popw	x
00103$:
;	serial_demo.c: 85: if (uart_ischar())
	call	_uart_ischar
	tnz	a
	jreq	00110$
;	serial_demo.c: 87: ch= uart_getchar();
	call	_uart_getchar
;	serial_demo.c: 88: delay_ms(10);
	push	#0x0a
	push	#0x00
	call	_delay_ms
	popw	x
;	serial_demo.c: 89: if (running)
	tnz	(0x01, sp)
	jreq	00105$
;	serial_demo.c: 91: led_set();
	ldw	x, #0x5005
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
;	serial_demo.c: 92: printf("\n\n\rCounter gestoppt, Taste fuer Neustart\n\n\r");
	ldw	x, #___str_8+0
	pushw	x
	call	_my_printf
	popw	x
;	serial_demo.c: 93: running= 0;
	clr	(0x01, sp)
	jra	00110$
00105$:
;	serial_demo.c: 94: } else {running= 1;}
	ld	a, #0x01
	ld	(0x01, sp), a
	jra	00110$
	addw	sp, #3
	ret
	.area CODE
___str_0:
	.db 0x0A
	.db 0x0D
	.ascii "--------------------------------------"
	.db 0x00
___str_1:
	.db 0x0A
	.db 0x0D
	.ascii "STM8 running at %d MHz"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_2:
	.ascii "8 kByte Flash;  1 KByte RAM"
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_3:
	.ascii "Baudrate: %d0"
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_4:
	.ascii "23.06.2016  R. Seelig"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_5:
	.ascii "--------------------------------------"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_6:
	.ascii "Taste um Counter anzuhalten bzw. neu zu starten"
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_7:
	.ascii " Counter: %d  "
	.db 0x0D
	.db 0x00
___str_8:
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.ascii "Counter gestoppt, Taste fuer Neustart"
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.db 0x00
	.area INITIALIZER
	.area CABS (ABS)
