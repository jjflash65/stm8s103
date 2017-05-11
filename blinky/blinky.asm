;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Aug 12 2015) (Linux)
; This file was generated Mon May  8 21:46:46 2017
;--------------------------------------------------------
	.module blinky
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _pol_delay
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
;	blinky.c: 87: void pol_delay(uint16_t cnt)
;	-----------------------------------------
;	 function pol_delay
;	-----------------------------------------
_pol_delay:
	pushw	x
;	blinky.c: 91: while (cnt)
	ldw	y, (0x05, sp)
00104$:
	tnzw	y
	jreq	00107$
;	blinky.c: 93: cnt2= 1435;
	ldw	x, #0x059b
	ldw	(0x01, sp), x
;	blinky.c: 94: while(cnt2)
00101$:
	ldw	x, (0x01, sp)
	jreq	00103$
;	blinky.c: 96: cnt2--;
	ldw	x, (0x01, sp)
	decw	x
	ldw	(0x01, sp), x
	jra	00101$
00103$:
;	blinky.c: 98: cnt--;
	decw	y
	jra	00104$
00107$:
	popw	x
	ret
;	blinky.c: 102: int main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	blinky.c: 104: sysclock_init(0);                     // erst Initialisieren mit internem RC
	push	#0x00
	call	_sysclock_init
	pop	a
;	blinky.c: 107: led1_init();
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
;	blinky.c: 108: led2_init();
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
;	blinky.c: 109: button_init();
	ldw	x, #0x5007
	ld	a, (x)
	and	a, #0xef
	ld	(x), a
	ldw	x, #0x5008
	ld	a, (x)
	or	a, #0x10
	ld	(x), a
;	blinky.c: 111: while(1)
00106$:
;	blinky.c: 113: led1_set();
	ldw	x, #0x5005
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
;	blinky.c: 115: if (is_button()) led2_clr();
	ldw	x, #0x5006
	ld	a, (x)
	and	a, #0x10
	swap	a
	and	a, #0x0f
	tnz	a
	jreq	00102$
	ldw	x, #0x500f
	ld	a, (x)
	and	a, #0xef
	ld	(x), a
00102$:
;	blinky.c: 117: pol_delay(800);
	push	#0x20
	push	#0x03
	call	_pol_delay
	popw	x
;	blinky.c: 118: led1_clr();
	ldw	x, #0x5005
	ld	a, (x)
	and	a, #0xdf
	ld	(x), a
;	blinky.c: 120: if (is_button()) led2_set();
	ldw	x, #0x5006
	ld	a, (x)
	and	a, #0x10
	swap	a
	and	a, #0x0f
	tnz	a
	jreq	00104$
	ldw	x, #0x500f
	ld	a, (x)
	or	a, #0x10
	ld	(x), a
00104$:
;	blinky.c: 122: pol_delay(50);
	push	#0x32
	push	#0x00
	call	_pol_delay
	popw	x
	jra	00106$
	ret
	.area CODE
	.area INITIALIZER
	.area CABS (ABS)
