;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Aug 12 2015) (Linux)
; This file was generated Wed Nov  9 16:14:35 2016
;--------------------------------------------------------
	.module pcf8574_test
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _i2c_write
	.globl _i2c_stop
	.globl _i2c_start
	.globl _i2c_master_init
	.globl _delay_ms
	.globl _sysclock_init
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
;	pcf8574_test.c: 48: int main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	pushw	x
;	pcf8574_test.c: 53: sysclock_init(0);
	push	#0x00
	call	_sysclock_init
	pop	a
;	pcf8574_test.c: 54: outby= 1; dir = 1;
	ld	a, #0x01
	ld	(0x02, sp), a
	ld	a, #0x01
	ld	(0x01, sp), a
;	pcf8574_test.c: 56: i2c_master_init();
	call	_i2c_master_init
;	pcf8574_test.c: 57: while(1)
00109$:
;	pcf8574_test.c: 59: i2c_start(0x40);
	push	#0x40
	call	_i2c_start
	pop	a
;	pcf8574_test.c: 60: i2c_write(~(outby));
	ld	a, (0x02, sp)
	cpl	a
	push	a
	call	_i2c_write
	pop	a
;	pcf8574_test.c: 61: i2c_stop();
	call	_i2c_stop
;	pcf8574_test.c: 62: delay_ms(laufspeed);
	push	#0x32
	push	#0x00
	call	_delay_ms
	popw	x
;	pcf8574_test.c: 64: if (dir)
	tnz	(0x01, sp)
	jreq	00106$
;	pcf8574_test.c: 66: outby= outby << 1;
	sll	(0x02, sp)
;	pcf8574_test.c: 67: if (outby== 0x80) dir= 0;      // Laufrichtung umschalten
	ld	a, (0x02, sp)
	cp	a, #0x80
	jrne	00109$
	clr	(0x01, sp)
	jra	00109$
00106$:
;	pcf8574_test.c: 71: outby= outby >> 1;
	srl	(0x02, sp)
;	pcf8574_test.c: 72: if (outby== 0x01) dir= 1;
	ld	a, (0x02, sp)
	cp	a, #0x01
	jrne	00109$
	ld	a, #0x01
	ld	(0x01, sp), a
	jra	00109$
	addw	sp, #2
	ret
	.area CODE
	.area INITIALIZER
	.area CABS (ABS)
