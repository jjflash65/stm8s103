;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Aug 12 2015) (Linux)
; This file was generated Wed May 10 22:58:22 2017
;--------------------------------------------------------
	.module ws2812_test2
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _egapalette
	.globl _main
	.globl _ws_buffer_rr
	.globl _ws_buffer_rl
	.globl _ws_blendup_right
	.globl _ws_blendup_left
	.globl _ws_setegacol
	.globl _ws_setrgbcol
	.globl _ws_clrarray
	.globl _ws_showarray
	.globl _ws_reset
	.globl _setrgbfromega
	.globl _setrgbcolor
	.globl _delay_us
	.globl _delay_ms
	.globl _sysclock_init
	.globl _rgbcolor
	.globl _ledbuffer
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
_ledbuffer::
	.ds 21
_rgbcolor::
	.ds 3
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
;	ws2812_test2.c: 128: void setrgbcolor(uint8_t r, uint8_t g, uint8_t b, struct colvalue *f)
;	-----------------------------------------
;	 function setrgbcolor
;	-----------------------------------------
_setrgbcolor:
	pushw	x
;	ws2812_test2.c: 130: (*f).r= r;
	ldw	y, (0x08, sp)
	ldw	(0x01, sp), y
	ldw	x, (0x01, sp)
	ld	a, (0x05, sp)
	ld	(x), a
;	ws2812_test2.c: 131: (*f).g= g;
	ldw	x, (0x01, sp)
	incw	x
	ld	a, (0x06, sp)
	ld	(x), a
;	ws2812_test2.c: 132: (*f).b= b;
	ldw	x, (0x01, sp)
	incw	x
	incw	x
	ld	a, (0x07, sp)
	ld	(x), a
	popw	x
	ret
;	ws2812_test2.c: 135: void setrgbfromega(uint8_t eganr, struct colvalue *f)
;	-----------------------------------------
;	 function setrgbfromega
;	-----------------------------------------
_setrgbfromega:
	sub	sp, #7
;	ws2812_test2.c: 137: (*f).g= egapalette[(eganr*3)+1];        // gruen
	ldw	y, (0x0b, sp)
	ldw	(0x06, sp), y
	ldw	x, (0x06, sp)
	incw	x
	ldw	(0x04, sp), x
	ldw	x, #_egapalette+0
	ldw	(0x02, sp), x
	ld	a, (0x0a, sp)
	ld	xl, a
	ld	a, #0x03
	mul	x, a
	exg	a, xl
	ld	(0x01, sp), a
	exg	a, xl
	ld	a, (0x01, sp)
	inc	a
	clrw	x
	ld	xl, a
	addw	x, (0x02, sp)
	ld	a, (x)
	ldw	x, (0x04, sp)
	ld	(x), a
;	ws2812_test2.c: 138: (*f).r= egapalette[(eganr*3)];          // rot
	clrw	x
	ld	a, (0x01, sp)
	ld	xl, a
	addw	x, (0x02, sp)
	ld	a, (x)
	ldw	x, (0x06, sp)
	ld	(x), a
;	ws2812_test2.c: 139: (*f).b= egapalette[(eganr*3)+2];        // blau
	ldw	y, (0x06, sp)
	addw	y, #0x0002
	ld	a, (0x01, sp)
	add	a, #0x02
	clrw	x
	ld	xl, a
	addw	x, (0x02, sp)
	ld	a, (x)
	ld	(y), a
	addw	sp, #7
	ret
;	ws2812_test2.c: 148: void ws_reset(void)
;	-----------------------------------------
;	 function ws_reset
;	-----------------------------------------
_ws_reset:
;	ws2812_test2.c: 152: __endasm;
	bres 0x500a, #5
;	ws2812_test2.c: 154: delay_us(100);
	push	#0x64
	push	#0x00
	call	_delay_us
	popw	x
	ret
;	ws2812_test2.c: 180: void ws_showarray(uint8_t *ptr, int anz)
;	-----------------------------------------
;	 function ws_showarray
;	-----------------------------------------
_ws_showarray:
;	ws2812_test2.c: 262: __endasm;
	push a
	pushw x
	pushw y
	ldw y,(0x0a, sp)
	addw y,(0x0a, sp)
	addw y,(0x0a, sp)
	decw y
	ldw x,(0x08, sp)
	    array_loop:
	pushw y
	ld a,(x)
	ldw y,#0x0007
	      loop0:
	rlc a
	jrc sendhi
	      sendlo:
	bset 0x500a, #5
	nop
	nop
	bres 0x500a, #5
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	jra loop0_end
	      sendhi:
	bset 0x500a, #5
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	bres 0x500a, #5
	nop
	nop
	      loop0_end:
	decw y
	jrpl loop0
	incw x
	popw y
	decw y
	jrpl array_loop
	popw y
	popw x
	pop a
	ret
;	ws2812_test2.c: 275: void ws_clrarray(uint8_t *ptr, int anz)
;	-----------------------------------------
;	 function ws_clrarray
;	-----------------------------------------
_ws_clrarray:
	pushw	x
;	ws2812_test2.c: 279: for (i= 0; i< (anz*3); i++)
	ldw	x, (0x07, sp)
	pushw	x
	push	#0x03
	push	#0x00
	call	__mulint
	addw	sp, #4
	ldw	(0x01, sp), x
	ldw	y, (0x05, sp)
	clrw	x
00103$:
	cpw	x, (0x01, sp)
	jrsge	00105$
;	ws2812_test2.c: 281: *ptr = 0x00;
	clr	(y)
;	ws2812_test2.c: 282: ptr++;
	incw	y
;	ws2812_test2.c: 279: for (i= 0; i< (anz*3); i++)
	incw	x
	jra	00103$
00105$:
	popw	x
	ret
;	ws2812_test2.c: 304: void ws_setrgbcol(uint8_t *ptr, uint16_t nr, struct colvalue *f)
;	-----------------------------------------
;	 function ws_setrgbcol
;	-----------------------------------------
_ws_setrgbcol:
	pushw	x
;	ws2812_test2.c: 306: ptr+= (nr*3);
	ldw	x, (0x07, sp)
	pushw	x
	push	#0x03
	push	#0x00
	call	__mulint
	addw	sp, #4
	addw	x, (0x05, sp)
	ldw	(0x05, sp), x
;	ws2812_test2.c: 307: *ptr= (*f).g;
	ldw	x, (0x05, sp)
	ldw	y, (0x09, sp)
	ldw	(0x01, sp), y
	ldw	y, (0x01, sp)
	ld	a, (0x1, y)
	ld	(x), a
;	ws2812_test2.c: 308: ptr++;
	incw	x
	ldw	(0x05, sp), x
;	ws2812_test2.c: 309: *ptr= (*f).r;
	ldw	x, (0x05, sp)
	ldw	y, (0x01, sp)
	ld	a, (y)
	ld	(x), a
;	ws2812_test2.c: 310: ptr++;
	incw	x
	ldw	(0x05, sp), x
;	ws2812_test2.c: 311: *ptr= (*f).b;
	ldw	y, (0x05, sp)
	ldw	x, (0x01, sp)
	ld	a, (0x2, x)
	ld	(y), a
	popw	x
	ret
;	ws2812_test2.c: 333: void ws_setegacol(uint8_t *ptr, uint16_t nr, uint8_t eganr)
;	-----------------------------------------
;	 function ws_setegacol
;	-----------------------------------------
_ws_setegacol:
	sub	sp, #3
;	ws2812_test2.c: 335: ptr+= (nr*3);
	ldw	x, (0x08, sp)
	pushw	x
	push	#0x03
	push	#0x00
	call	__mulint
	addw	sp, #4
	addw	x, (0x06, sp)
	ldw	(0x06, sp), x
;	ws2812_test2.c: 336: *ptr= egapalette[(eganr*3)+1];        // gruen
	ldw	y, (0x06, sp)
	ldw	x, #_egapalette+0
	ldw	(0x02, sp), x
	ld	a, (0x0a, sp)
	ld	xl, a
	ld	a, #0x03
	mul	x, a
	exg	a, xl
	ld	(0x01, sp), a
	exg	a, xl
	ld	a, (0x01, sp)
	inc	a
	clrw	x
	ld	xl, a
	addw	x, (0x02, sp)
	ld	a, (x)
	ld	(y), a
;	ws2812_test2.c: 337: ptr++;
	incw	y
	ldw	(0x06, sp), y
;	ws2812_test2.c: 338: *ptr= egapalette[(eganr*3)];          // rot
	ldw	y, (0x06, sp)
	clrw	x
	ld	a, (0x01, sp)
	ld	xl, a
	addw	x, (0x02, sp)
	ld	a, (x)
	ld	(y), a
;	ws2812_test2.c: 339: ptr++;
	incw	y
	ldw	(0x06, sp), y
;	ws2812_test2.c: 340: *ptr= egapalette[(eganr*3)+2];        // blau
	ldw	y, (0x06, sp)
	ld	a, (0x01, sp)
	add	a, #0x02
	clrw	x
	ld	xl, a
	addw	x, (0x02, sp)
	ld	a, (x)
	ld	(y), a
	addw	sp, #3
	ret
;	ws2812_test2.c: 356: void ws_blendup_left(uint8_t *ptr, uint8_t anz, struct colvalue *f, int dtime)
;	-----------------------------------------
;	 function ws_blendup_left
;	-----------------------------------------
_ws_blendup_left:
	sub	sp, #5
;	ws2812_test2.c: 360: ws_reset();
	call	_ws_reset
;	ws2812_test2.c: 361: for (i= 2; i< anz+1; i++)
	ld	a, #0x02
	ld	(0x01, sp), a
00103$:
	ld	a, (0x0a, sp)
	ld	(0x05, sp), a
	clr	(0x04, sp)
	ldw	x, (0x04, sp)
	incw	x
	ldw	(0x02, sp), x
	ld	a, (0x01, sp)
	ld	xl, a
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	xh, a
	cpw	x, (0x02, sp)
	jrsge	00105$
;	ws2812_test2.c: 363: ws_setrgbcol(ptr, i-1, f);
	decw	x
	ldw	y, (0x0b, sp)
	pushw	y
	pushw	x
	ldw	x, (0x0c, sp)
	pushw	x
	call	_ws_setrgbcol
	addw	sp, #6
;	ws2812_test2.c: 364: ws_showarray(ptr, anz);
	ldw	x, (0x04, sp)
	pushw	x
	ldw	x, (0x0a, sp)
	pushw	x
	call	_ws_showarray
	addw	sp, #4
;	ws2812_test2.c: 365: delay_ms(dtime);
	ldw	x, (0x0d, sp)
	pushw	x
	call	_delay_ms
	popw	x
;	ws2812_test2.c: 361: for (i= 2; i< anz+1; i++)
	inc	(0x01, sp)
	jra	00103$
00105$:
	addw	sp, #5
	ret
;	ws2812_test2.c: 382: void ws_blendup_right(uint8_t *ptr, uint8_t anz, struct colvalue *f, int dtime)
;	-----------------------------------------
;	 function ws_blendup_right
;	-----------------------------------------
_ws_blendup_right:
	push	a
;	ws2812_test2.c: 386: ws_reset();
	call	_ws_reset
;	ws2812_test2.c: 387: for (i= anz; i> -1; i--)
	ld	a, (0x06, sp)
	ld	(0x01, sp), a
00103$:
	ld	a, (0x01, sp)
	cp	a, #0xff
	jrsle	00105$
;	ws2812_test2.c: 389: ws_setrgbcol(ptr, i-1, f);
	ld	a, (0x01, sp)
	ld	xl, a
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	xh, a
	decw	x
	ldw	y, (0x07, sp)
	pushw	y
	pushw	x
	ldw	x, (0x08, sp)
	pushw	x
	call	_ws_setrgbcol
	addw	sp, #6
;	ws2812_test2.c: 390: ws_showarray(ptr, ledanz);
	push	#0x07
	push	#0x00
	ldw	x, (0x06, sp)
	pushw	x
	call	_ws_showarray
	addw	sp, #4
;	ws2812_test2.c: 391: delay_ms(dtime);
	ldw	x, (0x09, sp)
	pushw	x
	call	_delay_ms
	popw	x
;	ws2812_test2.c: 387: for (i= anz; i> -1; i--)
	dec	(0x01, sp)
	jra	00103$
00105$:
	pop	a
	ret
;	ws2812_test2.c: 404: void ws_buffer_rl(uint8_t *ptr, uint8_t lanz)
;	-----------------------------------------
;	 function ws_buffer_rl
;	-----------------------------------------
_ws_buffer_rl:
	sub	sp, #10
;	ws2812_test2.c: 410: for (j= 0; j< 3; j++)
	ld	a, (0x0f, sp)
	ld	xl, a
	ld	a, #0x03
	mul	x, a
	decw	x
	ldw	(0x09, sp), x
	ldw	y, (0x09, sp)
	ldw	(0x07, sp), y
	clr	(0x02, sp)
00106$:
;	ws2812_test2.c: 412: hptr1 = ptr;
	ldw	y, (0x0d, sp)
	ldw	(0x05, sp), y
;	ws2812_test2.c: 413: hptr1 += (lanz*3)-1;
	ldw	x, (0x05, sp)
	addw	x, (0x09, sp)
;	ws2812_test2.c: 414: b= *hptr1;
	ld	a, (x)
	ld	(0x01, sp), a
;	ws2812_test2.c: 415: for (i= (lanz*3)-1; i> 0; i--)
	ldw	x, (0x07, sp)
00104$:
	cpw	x, #0x0000
	jrsle	00101$
;	ws2812_test2.c: 418: hptr2 += (i-1);
	decw	x
	ldw	(0x03, sp), x
	ldw	x, (0x05, sp)
	addw	x, (0x03, sp)
;	ws2812_test2.c: 419: b2= *hptr2;
	ld	a, (x)
;	ws2812_test2.c: 420: hptr2++;
	incw	x
;	ws2812_test2.c: 421: *hptr2= b2;
	ld	(x), a
;	ws2812_test2.c: 415: for (i= (lanz*3)-1; i> 0; i--)
	ldw	x, (0x03, sp)
	jra	00104$
00101$:
;	ws2812_test2.c: 423: *ptr= b;
	ldw	x, (0x05, sp)
	ld	a, (0x01, sp)
	ld	(x), a
;	ws2812_test2.c: 410: for (j= 0; j< 3; j++)
	inc	(0x02, sp)
	ld	a, (0x02, sp)
	cp	a, #0x03
	jrc	00106$
	addw	sp, #10
	ret
;	ws2812_test2.c: 435: void ws_buffer_rr(uint8_t *ptr, uint8_t lanz)
;	-----------------------------------------
;	 function ws_buffer_rr
;	-----------------------------------------
_ws_buffer_rr:
	sub	sp, #8
;	ws2812_test2.c: 442: for (j= 0; j< 3; j++)
	ld	a, (0x0d, sp)
	ld	xl, a
	ld	a, #0x03
	mul	x, a
	decw	x
	ldw	(0x07, sp), x
	ldw	y, (0x0b, sp)
	ldw	(0x05, sp), y
	clr	(0x02, sp)
00106$:
;	ws2812_test2.c: 444: b= *ptr;
	ldw	x, (0x05, sp)
	ld	a, (x)
	ld	(0x01, sp), a
;	ws2812_test2.c: 445: for (i= 0; i < (lanz*3)-1;  i++)
	clrw	x
00104$:
	cpw	x, (0x07, sp)
	jrsge	00101$
;	ws2812_test2.c: 447: hptr2= ptr;
	ldw	y, (0x05, sp)
;	ws2812_test2.c: 448: hptr2 += i+1;
	incw	x
	ldw	(0x03, sp), x
	addw	y, (0x03, sp)
;	ws2812_test2.c: 449: b2= *hptr2;
	ld	a, (y)
;	ws2812_test2.c: 450: hptr2--;
	decw	y
;	ws2812_test2.c: 451: *hptr2= b2;
	ld	(y), a
;	ws2812_test2.c: 445: for (i= 0; i < (lanz*3)-1;  i++)
	ldw	x, (0x03, sp)
	jra	00104$
00101$:
;	ws2812_test2.c: 454: hptr1 += (lanz*3)-1;
	ldw	x, (0x05, sp)
	addw	x, (0x07, sp)
;	ws2812_test2.c: 455: *hptr1= b;
	ld	a, (0x01, sp)
	ld	(x), a
;	ws2812_test2.c: 442: for (j= 0; j< 3; j++)
	inc	(0x02, sp)
	ld	a, (0x02, sp)
	cp	a, #0x03
	jrc	00106$
	addw	sp, #8
	ret
;	ws2812_test2.c: 464: int main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #24
;	ws2812_test2.c: 470: sysclock_init(0);                     //  initialisieren mit internem RC-Taktgeber
	push	#0x00
	call	_sysclock_init
	pop	a
;	ws2812_test2.c: 471: ws_init();
	ldw	x, #0x500c
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
	ldw	x, #0x500d
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
	ldw	x, #0x500e
	ld	a, (x)
	and	a, #0xdf
	ld	(x), a
;	ws2812_test2.c: 472: ws_reset();
	call	_ws_reset
;	ws2812_test2.c: 475: while(1)
00106$:
;	ws2812_test2.c: 478: ws_clrarray(&ledbuffer[0],ledanz);
	ldw	x, #_ledbuffer+0
	push	#0x07
	push	#0x00
	pushw	x
	call	_ws_clrarray
	addw	sp, #4
;	ws2812_test2.c: 479: ws_showarray(&ledbuffer[0], ledanz);   // leeren LED-Strang anzeigen
	ldw	x, #_ledbuffer+0
	push	#0x07
	push	#0x00
	pushw	x
	call	_ws_showarray
	addw	sp, #4
;	ws2812_test2.c: 480: delay_ms(1);
	push	#0x01
	push	#0x00
	call	_delay_ms
	popw	x
;	ws2812_test2.c: 484: setrgbcolor(0,0,5, &rgbcol);
	ldw	x, sp
	incw	x
	ldw	(0x11, sp), x
	ldw	x, (0x11, sp)
	pushw	x
	push	#0x05
	push	#0x00
	push	#0x00
	call	_setrgbcolor
	addw	sp, #5
;	ws2812_test2.c: 485: ws_setrgbcol(&ledbuffer[0], 1, &rgbcol);
	ldw	y, (0x11, sp)
	ldw	x, #_ledbuffer+0
	pushw	y
	push	#0x01
	push	#0x00
	pushw	x
	call	_ws_setrgbcol
	addw	sp, #6
;	ws2812_test2.c: 489: for (i= 0; i< (ledanz * 4)-1; i++)
	clr	a
00108$:
;	ws2812_test2.c: 491: ws_showarray(&ledbuffer[0], ledanz);
	ldw	x, #_ledbuffer+0
	push	a
	push	#0x07
	push	#0x00
	pushw	x
	call	_ws_showarray
	addw	sp, #4
	push	#0x64
	push	#0x00
	call	_delay_ms
	popw	x
	pop	a
;	ws2812_test2.c: 493: ws_buffer_rl(&ledbuffer[0], ledanz);
	ldw	x, #_ledbuffer+0
	push	a
	push	#0x07
	pushw	x
	call	_ws_buffer_rl
	addw	sp, #3
	pop	a
;	ws2812_test2.c: 489: for (i= 0; i< (ledanz * 4)-1; i++)
	inc	a
	cp	a, #0x1b
	jrslt	00108$
;	ws2812_test2.c: 495: for (i= 0; i< (ledanz * 4)-1; i++)
	clr	(0x04, sp)
00110$:
;	ws2812_test2.c: 497: ws_showarray(&ledbuffer[0], ledanz);
	ldw	x, #_ledbuffer+0
	push	#0x07
	push	#0x00
	pushw	x
	call	_ws_showarray
	addw	sp, #4
;	ws2812_test2.c: 498: delay_ms(100);
	push	#0x64
	push	#0x00
	call	_delay_ms
	popw	x
;	ws2812_test2.c: 499: ws_buffer_rr(&ledbuffer[0], ledanz);
	ldw	x, #_ledbuffer+0
	push	#0x07
	pushw	x
	call	_ws_buffer_rr
	addw	sp, #3
;	ws2812_test2.c: 495: for (i= 0; i< (ledanz * 4)-1; i++)
	inc	(0x04, sp)
	ld	a, (0x04, sp)
	cp	a, #0x1b
	jrslt	00110$
;	ws2812_test2.c: 501: delay_ms(1500);
	push	#0xdc
	push	#0x05
	call	_delay_ms
	popw	x
;	ws2812_test2.c: 505: ws_clrarray(&ledbuffer[0],ledanz);
	ldw	x, #_ledbuffer+0
	push	#0x07
	push	#0x00
	pushw	x
	call	_ws_clrarray
	addw	sp, #4
;	ws2812_test2.c: 506: for (i= 1; i< 4; i++)
	ldw	y, (0x11, sp)
	ldw	(0x05, sp), y
	ldw	y, (0x11, sp)
	ldw	(0x0f, sp), y
	ldw	y, (0x11, sp)
	ldw	(0x0b, sp), y
	ldw	y, (0x11, sp)
	ldw	(0x0d, sp), y
	ldw	y, (0x11, sp)
	ldw	(0x09, sp), y
	ldw	y, (0x11, sp)
	ldw	(0x07, sp), y
	ldw	y, (0x11, sp)
	ldw	(0x17, sp), y
	ldw	y, (0x11, sp)
	ldw	(0x15, sp), y
	ld	a, #0x01
	ld	(0x04, sp), a
00112$:
;	ws2812_test2.c: 508: setrgbcolor(0,2,0, &rgbcol);
	ldw	x, (0x05, sp)
	pushw	x
	push	#0x00
	push	#0x02
	push	#0x00
	call	_setrgbcolor
	addw	sp, #5
;	ws2812_test2.c: 509: ws_blendup_left(&ledbuffer[0], ledanz, &rgbcol, 35);
	ldw	y, (0x0f, sp)
	ldw	x, #_ledbuffer+0
	push	#0x23
	push	#0x00
	pushw	y
	push	#0x07
	pushw	x
	call	_ws_blendup_left
	addw	sp, #7
;	ws2812_test2.c: 510: setrgbcolor(2,0,0, &rgbcol);
	ldw	x, (0x0b, sp)
	pushw	x
	push	#0x00
	push	#0x00
	push	#0x02
	call	_setrgbcolor
	addw	sp, #5
;	ws2812_test2.c: 511: ws_blendup_left(&ledbuffer[0], ledanz, &rgbcol, 35);
	ldw	y, (0x0d, sp)
	ldw	x, #_ledbuffer+0
	push	#0x23
	push	#0x00
	pushw	y
	push	#0x07
	pushw	x
	call	_ws_blendup_left
	addw	sp, #7
;	ws2812_test2.c: 512: setrgbcolor(0,0,2, &rgbcol);
	ldw	x, (0x09, sp)
	pushw	x
	push	#0x02
	push	#0x00
	push	#0x00
	call	_setrgbcolor
	addw	sp, #5
;	ws2812_test2.c: 513: ws_blendup_left(&ledbuffer[0], ledanz, &rgbcol, 35);
	ldw	y, (0x07, sp)
	ldw	x, #_ledbuffer+0
	push	#0x23
	push	#0x00
	pushw	y
	push	#0x07
	pushw	x
	call	_ws_blendup_left
	addw	sp, #7
;	ws2812_test2.c: 514: setrgbcolor(2,0,2, &rgbcol);
	ldw	x, (0x17, sp)
	pushw	x
	push	#0x02
	push	#0x00
	push	#0x02
	call	_setrgbcolor
	addw	sp, #5
;	ws2812_test2.c: 515: ws_blendup_left(&ledbuffer[0], ledanz, &rgbcol, 35);
	ldw	y, (0x15, sp)
	ldw	x, #_ledbuffer+0
	push	#0x23
	push	#0x00
	pushw	y
	push	#0x07
	pushw	x
	call	_ws_blendup_left
	addw	sp, #7
;	ws2812_test2.c: 506: for (i= 1; i< 4; i++)
	inc	(0x04, sp)
	ld	a, (0x04, sp)
	cp	a, #0x04
	jrsge	00160$
	jp	00112$
00160$:
;	ws2812_test2.c: 518: delay_ms(1000);
	push	#0xe8
	push	#0x03
	call	_delay_ms
	popw	x
;	ws2812_test2.c: 521: for (i= 1; i< ledanz+1; i++)
	ld	a, #0x01
00114$:
;	ws2812_test2.c: 523: ws_setegacol(&ledbuffer[0], i-1, i);
	ld	xl, a
	push	a
	ld	a, xl
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	xh, a
	pop	a
	decw	x
	ldw	(0x13, sp), x
	ldw	x, #_ledbuffer+0
	push	a
	push	a
	ldw	y, (0x15, sp)
	pushw	y
	pushw	x
	call	_ws_setegacol
	addw	sp, #5
	pop	a
;	ws2812_test2.c: 521: for (i= 1; i< ledanz+1; i++)
	inc	a
	cp	a, #0x08
	jrslt	00114$
;	ws2812_test2.c: 526: ws_reset();
	call	_ws_reset
;	ws2812_test2.c: 527: ws_showarray(&ledbuffer[0], ledanz);
	ldw	x, #_ledbuffer+0
	push	#0x07
	push	#0x00
	pushw	x
	call	_ws_showarray
	addw	sp, #4
;	ws2812_test2.c: 529: delay_ms(3000);
	push	#0xb8
	push	#0x0b
	call	_delay_ms
	popw	x
	jp	00106$
	addw	sp, #24
	ret
	.area CODE
_egapalette:
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x06	; 6
	.db #0x01	; 1
	.db #0x06	; 6
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x06	; 6
	.db #0x06	; 6
	.db #0x06	; 6
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x06	; 6
	.db #0x01	; 1
	.db #0x06	; 6
	.db #0x06	; 6
	.db #0x06	; 6
	.db #0x01	; 1
	.db #0x06	; 6
	.db #0x06	; 6
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xAA	; 170
	.db #0x00	; 0
	.db #0xAA	; 170
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xAA	; 170
	.db #0xAA	; 170
	.db #0xAA	; 170
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xAA	; 170
	.db #0x00	; 0
	.db #0xAA	; 170
	.db #0xAA	; 170
	.db #0x55	; 85	'U'
	.db #0x00	; 0
	.db #0xAA	; 170
	.db #0xAA	; 170
	.db #0xAA	; 170
	.db #0x55	; 85	'U'
	.db #0x55	; 85	'U'
	.db #0x55	; 85	'U'
	.db #0x55	; 85	'U'
	.db #0x55	; 85	'U'
	.db #0xFF	; 255
	.db #0x55	; 85	'U'
	.db #0xFF	; 255
	.db #0x55	; 85	'U'
	.db #0x55	; 85	'U'
	.db #0xFF	; 255
	.db #0xFF	; 255
	.db #0xFF	; 255
	.db #0x55	; 85	'U'
	.db #0x55	; 85	'U'
	.db #0xFF	; 255
	.db #0x55	; 85	'U'
	.db #0xFF	; 255
	.db #0xFF	; 255
	.db #0xFF	; 255
	.db #0x55	; 85	'U'
	.db #0xFF	; 255
	.db #0xFF	; 255
	.db #0xFF	; 255
	.area INITIALIZER
	.area CABS (ABS)
