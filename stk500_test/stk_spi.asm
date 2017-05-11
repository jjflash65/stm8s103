;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Aug 12 2015) (Linux)
; This file was generated Mon May  8 19:32:41 2017
;--------------------------------------------------------
	.module stk_spi
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _delay_us
	.globl _delay_ms
	.globl _spi_out
	.globl _spi_init
	.globl _stkspi_set_sck_duration
	.globl _stkspi_get_sck_duration
	.globl _stkspi_reset_pulse
	.globl _stkspi_init
	.globl _stkspi_mastertransmit
	.globl _stkspi_mastertransmit_16
	.globl _stkspi_mastertransmit_32
	.globl _stkspi_disable
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
_sck_dur:
	.ds 1
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area HOME
	.area GSINIT
	.area GSFINAL
	.area GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area HOME
	.area HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area CODE
;	stk_spi.c: 17: unsigned char  stkspi_set_sck_duration(unsigned char dur)
;	-----------------------------------------
;	 function stkspi_set_sck_duration
;	-----------------------------------------
_stkspi_set_sck_duration:
;	stk_spi.c: 19: if (dur >= 3)
	ld	a, (0x03, sp)
	cp	a, #0x03
	jrc	00133$
	clr	a
	jra	00134$
00133$:
	ld	a, #0x01
00134$:
	tnz	a
	jrne	00102$
;	stk_spi.c: 21: sck_dur=4;
	mov	_sck_dur+0, #0x04
;	stk_spi.c: 22: spi_init(7,0,0);
	push	#0x00
	push	#0x00
	push	#0x07
	call	_spi_init
	addw	sp, #3
;	stk_spi.c: 23: return(sck_dur);
	ld	a, _sck_dur+0
	jra	00111$
00102$:
;	stk_spi.c: 25: if (dur >= 3)
	tnz	a
	jrne	00104$
;	stk_spi.c: 27: sck_dur= 3;
	mov	_sck_dur+0, #0x03
;	stk_spi.c: 28: spi_init(3,0,0);
	push	#0x00
	push	#0x00
	push	#0x03
	call	_spi_init
	addw	sp, #3
;	stk_spi.c: 29: return(sck_dur);
	ld	a, _sck_dur+0
	jra	00111$
00104$:
;	stk_spi.c: 31: if (dur >= 2)
	ld	a, (0x03, sp)
	cp	a, #0x02
	jrc	00106$
;	stk_spi.c: 33: sck_dur=2;
	mov	_sck_dur+0, #0x02
;	stk_spi.c: 34: spi_init(2,0,0);
	push	#0x00
	push	#0x00
	push	#0x02
	call	_spi_init
	addw	sp, #3
;	stk_spi.c: 35: return(sck_dur);
	ld	a, _sck_dur+0
	jra	00111$
00106$:
;	stk_spi.c: 37: if (dur == 1)
	ld	a, (0x03, sp)
	cp	a, #0x01
	jrne	00108$
;	stk_spi.c: 39: sck_dur=1;
	mov	_sck_dur+0, #0x01
;	stk_spi.c: 40: spi_init(1,0,0);
	push	#0x00
	push	#0x00
	push	#0x01
	call	_spi_init
	addw	sp, #3
;	stk_spi.c: 41: return(sck_dur);
	ld	a, _sck_dur+0
	jra	00111$
00108$:
;	stk_spi.c: 44: if (dur == 0)
	tnz	(0x03, sp)
	jrne	00110$
;	stk_spi.c: 46: sck_dur=1;
	mov	_sck_dur+0, #0x01
;	stk_spi.c: 47: spi_init(1,0,0);
	push	#0x00
	push	#0x00
	push	#0x01
	call	_spi_init
	addw	sp, #3
;	stk_spi.c: 48: return(sck_dur);
	ld	a, _sck_dur+0
	jra	00111$
00110$:
;	stk_spi.c: 51: return(1); // we should never come here
	ld	a, #0x01
00111$:
	ret
;	stk_spi.c: 54: unsigned char stkspi_get_sck_duration(void)
;	-----------------------------------------
;	 function stkspi_get_sck_duration
;	-----------------------------------------
_stkspi_get_sck_duration:
;	stk_spi.c: 56: return(sck_dur);
	ld	a, _sck_dur+0
	ret
;	stk_spi.c: 60: void stkspi_reset_pulse(void)
;	-----------------------------------------
;	 function stkspi_reset_pulse
;	-----------------------------------------
_stkspi_reset_pulse:
;	stk_spi.c: 62: stkspi_reshi();
	ldw	x, #0x5005
	ld	a, (x)
	or	a, #0x10
	ld	(x), a
;	stk_spi.c: 63: delay_us(100);
	push	#0x64
	push	#0x00
	call	_delay_us
	popw	x
;	stk_spi.c: 64: stkspi_reslo();
	ldw	x, #0x5005
	ld	a, (x)
	and	a, #0xef
	ld	(x), a
;	stk_spi.c: 65: delay_ms(20);
	push	#0x14
	push	#0x00
	call	_delay_ms
	popw	x
	ret
;	stk_spi.c: 68: void stkspi_init(void)
;	-----------------------------------------
;	 function stkspi_init
;	-----------------------------------------
_stkspi_init:
;	stk_spi.c: 70: stkspi_res_init();
	ldw	x, #0x5007
	ld	a, (x)
	or	a, #0x10
	ld	(x), a
	ldw	x, #0x5008
	ld	a, (x)
	or	a, #0x10
	ld	(x), a
	ldw	x, #0x5009
	ld	a, (x)
	and	a, #0xef
	ld	(x), a
;	stk_spi.c: 71: stkspi_set_sck_duration(sck_dur);
	push	_sck_dur+0
	call	_stkspi_set_sck_duration
	pop	a
;	stk_spi.c: 72: stkspi_reset_pulse();
	jp	_stkspi_reset_pulse
;	stk_spi.c: 76: unsigned char stkspi_mastertransmit(unsigned char data)
;	-----------------------------------------
;	 function stkspi_mastertransmit
;	-----------------------------------------
_stkspi_mastertransmit:
;	stk_spi.c: 78: return spi_out(data);
	ld	a, (0x03, sp)
	push	a
	call	_spi_out
	addw	sp, #1
	ret
;	stk_spi.c: 82: unsigned char stkspi_mastertransmit_16(unsigned int data)
;	-----------------------------------------
;	 function stkspi_mastertransmit_16
;	-----------------------------------------
_stkspi_mastertransmit_16:
;	stk_spi.c: 84: stkspi_mastertransmit((data>>8)&0xFF);
	ld	a, (0x03, sp)
	ld	xh, a
	clr	a
	clr	a
	ld	a, xh
	push	a
	call	_stkspi_mastertransmit
	pop	a
;	stk_spi.c: 85: return(stkspi_mastertransmit(data&0xFF));
	ld	a, (0x04, sp)
	ld	xh, a
	clr	a
	ld	a, xh
	push	a
	call	_stkspi_mastertransmit
	addw	sp, #1
	ret
;	stk_spi.c: 89: unsigned char stkspi_mastertransmit_32(unsigned long data)
;	-----------------------------------------
;	 function stkspi_mastertransmit_32
;	-----------------------------------------
_stkspi_mastertransmit_32:
	sub	sp, #16
;	stk_spi.c: 91: stkspi_mastertransmit((data>>24)&0xFF);
	ld	a, (0x13, sp)
	clr	(0x0f, sp)
	clrw	x
	push	a
	clr	(0x0c, sp)
	clrw	x
	call	_stkspi_mastertransmit
	pop	a
;	stk_spi.c: 92: stkspi_mastertransmit((data>>16)&0xFF);
	ldw	y, (0x13, sp)
	clrw	x
	ld	a, yl
	push	a
	clr	(0x08, sp)
	clrw	x
	call	_stkspi_mastertransmit
	pop	a
;	stk_spi.c: 93: stkspi_mastertransmit((data>>8)&0xFF);
	ldw	y, (0x14, sp)
	ld	a, (0x13, sp)
	ld	xl, a
	clr	a
	ld	xh, a
	ld	a, yl
	push	a
	clr	(0x04, sp)
	clrw	x
	call	_stkspi_mastertransmit
	pop	a
;	stk_spi.c: 94: return(stkspi_mastertransmit(data&0xFF));
	ld	a, (0x16, sp)
	ld	xh, a
	clrw	y
	clr	a
	ld	a, xh
	push	a
	call	_stkspi_mastertransmit
	addw	sp, #17
	ret
;	stk_spi.c: 97: void stkspi_disable(void)
;	-----------------------------------------
;	 function stkspi_disable
;	-----------------------------------------
_stkspi_disable:
;	stk_spi.c: 99: }
	ret
	.area CODE
	.area INITIALIZER
__xinit__sck_dur:
	.db #0x01	; 1
	.area CABS (ABS)
