;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Aug 12 2015) (Linux)
; This file was generated Thu Feb  2 01:28:45 2017
;--------------------------------------------------------
	.module notendemo
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _playstring
	.globl _tim1_init
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
	int _tim1_ovf ;int11
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
;	notendemo.c: 26: int main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	notendemo.c: 29: sysclock_init(0);                     // erst Initialisieren mit internem RC
	push	#0x00
	call	_sysclock_init
	pop	a
;	notendemo.c: 30: spk_init();
	ldw	x, #0x5011
	ld	a, (x)
	or	a, #0x10
	ld	(x), a
	ldw	x, #0x5012
	ld	a, (x)
	or	a, #0x10
	ld	(x), a
	ldw	x, #0x5013
	ld	a, (x)
	and	a, #0xef
	ld	(x), a
;	notendemo.c: 31: led1_init();
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
;	notendemo.c: 32: tim1_init();
	call	_tim1_init
;	notendemo.c: 34: led1_clr();
	ldw	x, #0x5005
	ld	a, (x)
	and	a, #0xdf
	ld	(x), a
;	notendemo.c: 37: playstring("c4d4e2g4e2g4e1d4e4f2g4f2g4f1g4a4h2+f4-h2+f4-h1a4h4+c2e4c2-a4g1e4g4+c1-h1+d1c1-a2+c4-a2+c4-a1");
	ldw	x, #___str_0+0
	pushw	x
	call	_playstring
	popw	x
;	notendemo.c: 40: sound= 0;
	clr	_sound+0
;	notendemo.c: 41: led1_set();
	ldw	x, #0x5005
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
;	notendemo.c: 42: while(1);
00102$:
	jra	00102$
	ret
	.area CODE
___str_0:
	.ascii "c4d4e2g4e2g4e1d4e4f2g4f2g4f1g4a4h2+f4-h2+f4-h1a4h4+c2e4c2-a4"
	.ascii "g1e4g4+c1-h1+d1c1-a2+c4-a2+c4-a1"
	.db 0x00
	.area INITIALIZER
	.area CABS (ABS)
