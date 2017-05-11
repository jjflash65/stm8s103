;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Aug 12 2015) (Linux)
; This file was generated Mon Apr 24 07:33:18 2017
;--------------------------------------------------------
	.module bitfield_test
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _my_printf
	.globl _uart_init
	.globl _uart_putchar
	.globl _delay_ms
	.globl _sysclock_init
	.globl _pixbyte
	.globl _putchar
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
_pixbyte::
	.ds 1
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
;	bitfield_test.c: 45: int main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	pushw	x
;	bitfield_test.c: 48: sysclock_init(0);                    // interner Taktgeber, 16MHz
	push	#0x00
	call	_sysclock_init
	pop	a
;	bitfield_test.c: 49: delay_ms(2);
	push	#0x02
	push	#0x00
	call	_delay_ms
	popw	x
;	bitfield_test.c: 51: uart_init(19200);
	push	#0x00
	push	#0x4b
	call	_uart_init
	popw	x
;	bitfield_test.c: 53: printf("\n\r--------------------------------------");
	ldw	x, #___str_0+0
	pushw	x
	call	_my_printf
	popw	x
;	bitfield_test.c: 54: printf("\n\rSTM8S103F3P6 - Bitfield - Demo\n\r");
	ldw	x, #___str_1+0
	pushw	x
	call	_my_printf
	popw	x
;	bitfield_test.c: 55: printf("15.12.2016  R. Seelig\n\r");
	ldw	x, #___str_2+0
	pushw	x
	call	_my_printf
	popw	x
;	bitfield_test.c: 56: printf("--------------------------------------\n\r");
	ldw	x, #___str_3+0
	pushw	x
	call	_my_printf
	popw	x
;	bitfield_test.c: 59: cgabyte= 0;
	ldw	x, #_pixbyte+0
	ldw	(0x01, sp), x
	ldw	x, (0x01, sp)
	clr	(x)
;	bitfield_test.c: 60: px0= 03;
	ldw	x, (0x01, sp)
	ld	a, #0x03
	and	a, #0x03
	push	a
	ld	a, #0xfc
	and	a, (x)
	or	a, (1, sp)
	ld	(x), a
	pop	a
;	bitfield_test.c: 61: px1= 10;
	ldw	x, (0x01, sp)
	ld	a, #0x0a
	sll	a
	sll	a
	and	a, #0x0c
	push	a
	ld	a, #0xf3
	and	a, (x)
	or	a, (1, sp)
	ld	(x), a
	pop	a
;	bitfield_test.c: 62: px2= 01;
	ldw	x, (0x01, sp)
	ld	a, #0x01
	sll	a
	sll	a
	sll	a
	sll	a
	and	a, #0x30
	push	a
	ld	a, #0xcf
	and	a, (x)
	or	a, (1, sp)
	ld	(x), a
	pop	a
;	bitfield_test.c: 63: px3= 01;
	ldw	x, (0x01, sp)
	ld	a, #0x01
	sll	a
	sll	a
	sll	a
	sll	a
	sll	a
	sll	a
	and	a, #0xc0
	push	a
	ld	a, #0x3f
	and	a, (x)
	or	a, (1, sp)
	ld	(x), a
	pop	a
;	bitfield_test.c: 66: printf("Wert von pixbyte nach dem Setzen von px3: %xh\n\r",cgabyte);
	ldw	x, (0x01, sp)
	ld	a, (x)
	clrw	x
	ld	xl, a
	ldw	y, #___str_4+0
	pushw	x
	pushw	y
	call	_my_printf
	addw	sp, #4
;	bitfield_test.c: 67: printf("Speichergroesse von pixbyte: %d\n\r",sizeof(pixbyte));
	ldw	x, #___str_5+0
	push	#0x01
	push	#0x00
	pushw	x
	call	_my_printf
	addw	sp, #4
;	bitfield_test.c: 70: while(1);
00102$:
	jra	00102$
	addw	sp, #2
	ret
;	bitfield_test.c: 83: void putchar(char ch)
;	-----------------------------------------
;	 function putchar
;	-----------------------------------------
_putchar:
;	bitfield_test.c: 85: uart_putchar(ch);
	ld	a, (0x03, sp)
	push	a
	call	_uart_putchar
	pop	a
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
	.ascii "STM8S103F3P6 - Bitfield - Demo"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_2:
	.ascii "15.12.2016  R. Seelig"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_3:
	.ascii "--------------------------------------"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_4:
	.ascii "Wert von pixbyte nach dem Setzen von px3: %xh"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_5:
	.ascii "Speichergroesse von pixbyte: %d"
	.db 0x0A
	.db 0x0D
	.db 0x00
	.area INITIALIZER
	.area CABS (ABS)
