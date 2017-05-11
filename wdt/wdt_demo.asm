;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Aug 12 2015) (Linux)
; This file was generated Mon May  8 20:46:45 2017
;--------------------------------------------------------
	.module wdt_demo
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _iwdg_reset
	.globl _iwdg_init
	.globl _int_enable
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
;	wdt_demo.c: 81: void iwdg_init(void)
;	-----------------------------------------
;	 function iwdg_init
;	-----------------------------------------
_iwdg_init:
;	wdt_demo.c: 85: IWDG_KR= 0xcc;                        // Start des Watchdogs
	mov	0x50e0+0, #0xcc
;	wdt_demo.c: 86: IWDG_KR= 0x55;                        // Schreiberlaubnis auf IWDG Register
	mov	0x50e0+0, #0x55
;	wdt_demo.c: 87: IWDG_PR= 0x06;                        // Prescaler:
	mov	0x50e1+0, #0x06
;	wdt_demo.c: 92: IWDG_RLR= 0xff;                       // Reload Zaehler, wird mit dem WDT-Takt heruntergezaehlt
	mov	0x50e2+0, #0xff
;	wdt_demo.c: 94: IWDG_KR= 0xaa;                        // Zaehler-Reset
	mov	0x50e0+0, #0xaa
	ret
;	wdt_demo.c: 97: iwdg_reset(void)
;	-----------------------------------------
;	 function iwdg_reset
;	-----------------------------------------
_iwdg_reset:
;	wdt_demo.c: 99: IWDG_KR= 0xaa;
	mov	0x50e0+0, #0xaa
	ret
;	wdt_demo.c: 103: int main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	wdt_demo.c: 106: sysclock_init(0);                     // erst Initialisieren mit internem RC
	push	#0x00
	call	_sysclock_init
	pop	a
;	wdt_demo.c: 107: iwdg_init();
	call	_iwdg_init
;	wdt_demo.c: 108: int_enable();
	call	_int_enable
;	wdt_demo.c: 110: led1_init();
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
;	wdt_demo.c: 112: led1_clr();
	ldw	x, #0x5005
	ld	a, (x)
	and	a, #0xdf
	ld	(x), a
;	wdt_demo.c: 113: delay_ms(100);
	push	#0x64
	push	#0x00
	call	_delay_ms
	popw	x
;	wdt_demo.c: 114: led1_set();
	ldw	x, #0x5005
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
;	wdt_demo.c: 115: while(1);                             // normalerweise wuerde die LED einmal auf-
00102$:
	jra	00102$
	ret
	.area CODE
	.area INITIALIZER
	.area CABS (ABS)
