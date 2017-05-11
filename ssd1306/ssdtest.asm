;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Aug 12 2015) (Linux)
; This file was generated Sun Apr 23 21:54:20 2017
;--------------------------------------------------------
	.module ssdtest
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _font8x8h
	.globl _main
	.globl _show_vled
	.globl _showimage_d
	.globl _reversebyte
	.globl _oled_putchar
	.globl _gotoxy
	.globl _oled_setpageadr
	.globl _clrscr
	.globl _oled_setxybyte
	.globl _oled_init
	.globl _spi_out
	.globl _my_printf
	.globl _delay_ms
	.globl _sysclock_init
	.globl _textcolor
	.globl _bkcolor
	.globl _aktyp
	.globl _aktxp
	.globl _doublechar
	.globl _putchar
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
_doublechar::
	.ds 1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
_aktxp::
	.ds 1
_aktyp::
	.ds 1
_bkcolor::
	.ds 1
_textcolor::
	.ds 1
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
;	ssdtest.c: 184: void spi_out(uint8_t value)
;	-----------------------------------------
;	 function spi_out
;	-----------------------------------------
_spi_out:
	push	a
;	ssdtest.c: 188: for (a= 0; a< 8; a++)
	clr	(0x01, sp)
00105$:
;	ssdtest.c: 190: if((value & 0x80)> 0) { mosi_set(); }
	ldw	x, #0x500a
	ld	a, (x)
	tnz	(0x04, sp)
	jrpl	00102$
	or	a, #0x40
	ldw	x, #0x500a
	ld	(x), a
	jra	00103$
00102$:
;	ssdtest.c: 191: else { mosi_clr(); }
	and	a, #0xbf
	ldw	x, #0x500a
	ld	(x), a
00103$:
;	ssdtest.c: 193: sck_set();
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
;	ssdtest.c: 194: sck_clr();
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xdf
	ld	(x), a
;	ssdtest.c: 195: value= value << 1;
	sll	(0x04, sp)
;	ssdtest.c: 188: for (a= 0; a< 8; a++)
	inc	(0x01, sp)
	ld	a, (0x01, sp)
	cp	a, #0x08
	jrslt	00105$
	pop	a
	ret
;	ssdtest.c: 203: void oled_init(void)
;	-----------------------------------------
;	 function oled_init
;	-----------------------------------------
_oled_init:
;	ssdtest.c: 205: sw_mosiinit();
	ldw	x, #0x500c
	ld	a, (x)
	or	a, #0x40
	ld	(x), a
	ldw	x, #0x500d
	ld	a, (x)
	or	a, #0x40
	ld	(x), a
	ldw	x, #0x500e
	ld	a, (x)
	and	a, #0xbf
	ld	(x), a
;	ssdtest.c: 206: sw_csinit();
	ldw	x, #0x5011
	ld	a, (x)
	or	a, #0x02
	ld	(x), a
	ldw	x, #0x5012
	ld	a, (x)
	or	a, #0x02
	ld	(x), a
	ldw	x, #0x5013
	ld	a, (x)
	and	a, #0xfd
	ld	(x), a
;	ssdtest.c: 207: sw_resinit();
	ldw	x, #0x500c
	ld	a, (x)
	or	a, #0x08
	ld	(x), a
	ldw	x, #0x500d
	ld	a, (x)
	or	a, #0x08
	ld	(x), a
	ldw	x, #0x500e
	ld	a, (x)
	and	a, #0xf7
	ld	(x), a
;	ssdtest.c: 208: sw_dcinit();
	ldw	x, #0x500c
	ld	a, (x)
	or	a, #0x10
	ld	(x), a
	ldw	x, #0x500d
	ld	a, (x)
	or	a, #0x10
	ld	(x), a
	ldw	x, #0x500e
	ld	a, (x)
	and	a, #0xef
	ld	(x), a
;	ssdtest.c: 209: sw_sckinit();
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
;	ssdtest.c: 211: oled_enable();
	ldw	x, #0x500f
	ld	a, (x)
	and	a, #0xfd
	ld	(x), a
;	ssdtest.c: 212: delay_ms(10);
	push	#0x0a
	push	#0x00
	call	_delay_ms
	popw	x
;	ssdtest.c: 214: rst_clr();                    // Display-reset
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xf7
	ld	(x), a
;	ssdtest.c: 215: delay_ms(10);
	push	#0x0a
	push	#0x00
	call	_delay_ms
	popw	x
;	ssdtest.c: 216: rst_set();
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x08
	ld	(x), a
;	ssdtest.c: 218: oled_cmdmode();               // nachfolgende Daten als Kommando
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xef
	ld	(x), a
;	ssdtest.c: 220: spi_out(0x8d);                // Ladungspumpe an
	push	#0x8d
	call	_spi_out
	pop	a
;	ssdtest.c: 221: spi_out(0x14);
	push	#0x14
	call	_spi_out
	pop	a
;	ssdtest.c: 223: spi_out(0xaf);                // Display on
	push	#0xaf
	call	_spi_out
	pop	a
;	ssdtest.c: 224: delay_ms(150);
	push	#0x96
	push	#0x00
	call	_delay_ms
	popw	x
;	ssdtest.c: 226: spi_out(0xa1);                // Segment Map
	push	#0xa1
	call	_spi_out
	pop	a
;	ssdtest.c: 227: spi_out(0xc0);                // Direction Map
	push	#0xc0
	call	_spi_out
	pop	a
;	ssdtest.c: 228: oled_datamode();
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x10
	ld	(x), a
	ret
;	ssdtest.c: 244: void oled_setxybyte(uint8_t x, uint8_t y, uint8_t value)
;	-----------------------------------------
;	 function oled_setxybyte
;	-----------------------------------------
_oled_setxybyte:
;	ssdtest.c: 246: oled_cmdmode();
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xef
	ld	(x), a
;	ssdtest.c: 247: y= 7-y;
	ld	a, #0x07
	sub	a, (0x04, sp)
	ld	(0x04, sp), a
;	ssdtest.c: 249: spi_out(0xb0 | (y & 0x0f));
	ld	a, (0x04, sp)
	and	a, #0x0f
	or	a, #0xb0
	push	a
	call	_spi_out
	pop	a
;	ssdtest.c: 250: spi_out(0x10 | (x >> 4 & 0x0f));
	ld	a, (0x03, sp)
	swap	a
	and	a, #0x0f
	and	a, #0x0f
	or	a, #0x10
	push	a
	call	_spi_out
	pop	a
;	ssdtest.c: 251: spi_out(x & 0x0f);
	ld	a, (0x03, sp)
	and	a, #0x0f
	push	a
	call	_spi_out
	pop	a
;	ssdtest.c: 253: oled_datamode();
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x10
	ld	(x), a
;	ssdtest.c: 254: if ((!textcolor)) value= ~value;
	tnz	_textcolor+0
	jrne	00102$
	cpl	(0x05, sp)
00102$:
;	ssdtest.c: 255: spi_out(value);
	ld	a, (0x05, sp)
	push	a
	call	_spi_out
	pop	a
	ret
;	ssdtest.c: 265: void clrscr(void)
;	-----------------------------------------
;	 function clrscr
;	-----------------------------------------
_clrscr:
	push	a
;	ssdtest.c: 269: oled_enable();
	ldw	x, #0x500f
	ld	a, (x)
	and	a, #0xfd
	ld	(x), a
;	ssdtest.c: 271: rst_clr();                    // Display-reset
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xf7
	ld	(x), a
;	ssdtest.c: 272: delay_ms(1);
	push	#0x01
	push	#0x00
	call	_delay_ms
	popw	x
;	ssdtest.c: 273: rst_set();
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x08
	ld	(x), a
;	ssdtest.c: 275: oled_cmdmode();               // nachfolgende Daten als Kommando
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xef
	ld	(x), a
;	ssdtest.c: 277: spi_out(0x8d);                // Ladungspumpe an
	push	#0x8d
	call	_spi_out
	pop	a
;	ssdtest.c: 278: spi_out(0x14);
	push	#0x14
	call	_spi_out
	pop	a
;	ssdtest.c: 280: spi_out(0xaf);                // Display on
	push	#0xaf
	call	_spi_out
	pop	a
;	ssdtest.c: 282: spi_out(0xa1);                // Segment Map
	push	#0xa1
	call	_spi_out
	pop	a
;	ssdtest.c: 283: spi_out(0xc0);                // Direction Map
	push	#0xc0
	call	_spi_out
	pop	a
;	ssdtest.c: 284: oled_datamode();
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x10
	ld	(x), a
;	ssdtest.c: 287: for (y= 0; y< 8; y++)         // ein Byte in Y-Achse = 8 Pixel...
	clr	(0x01, sp)
00108$:
;	ssdtest.c: 290: oled_cmdmode();
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xef
	ld	(x), a
;	ssdtest.c: 292: spi_out(0xb0 | y);          // Pageadresse schreiben
	ld	a, (0x01, sp)
	or	a, #0xb0
	push	a
	call	_spi_out
	pop	a
;	ssdtest.c: 293: spi_out(0x00);              // MSB X-Adresse
	push	#0x00
	call	_spi_out
	pop	a
;	ssdtest.c: 294: spi_out(0x00);              // LSB X-Adresse (+Offset)
	push	#0x00
	call	_spi_out
	pop	a
;	ssdtest.c: 296: oled_datamode();
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x10
	ld	(x), a
;	ssdtest.c: 297: for (x= 0; x< 128; x++)
	clr	a
00106$:
;	ssdtest.c: 299: if (bkcolor) spi_out(0xff); else spi_out(0x00);
	tnz	_bkcolor+0
	jreq	00102$
	push	a
	push	#0xff
	call	_spi_out
	pop	a
	pop	a
	jra	00107$
00102$:
	push	a
	push	#0x00
	call	_spi_out
	pop	a
	pop	a
00107$:
;	ssdtest.c: 297: for (x= 0; x< 128; x++)
	inc	a
	cp	a, #0x80
	jrc	00106$
;	ssdtest.c: 287: for (y= 0; y< 8; y++)         // ein Byte in Y-Achse = 8 Pixel...
	inc	(0x01, sp)
	ld	a, (0x01, sp)
	cp	a, #0x08
	jrc	00108$
	pop	a
	ret
;	ssdtest.c: 312: void oled_setpageadr(uint8_t x, uint8_t y)
;	-----------------------------------------
;	 function oled_setpageadr
;	-----------------------------------------
_oled_setpageadr:
;	ssdtest.c: 314: oled_cmdmode();
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xef
	ld	(x), a
;	ssdtest.c: 315: y= 7-y;
	ld	a, #0x07
	sub	a, (0x04, sp)
	ld	(0x04, sp), a
;	ssdtest.c: 317: spi_out(0xb0 | (y & 0x0f));
	ld	a, (0x04, sp)
	and	a, #0x0f
	or	a, #0xb0
	push	a
	call	_spi_out
	pop	a
;	ssdtest.c: 318: spi_out(0x10 | (x >> 4 & 0x0f));
	ld	a, (0x03, sp)
	swap	a
	and	a, #0x0f
	and	a, #0x0f
	or	a, #0x10
	push	a
	call	_spi_out
	pop	a
;	ssdtest.c: 319: spi_out(x & 0x0f);
	ld	a, (0x03, sp)
	and	a, #0x0f
	push	a
	call	_spi_out
	pop	a
;	ssdtest.c: 321: oled_datamode();
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x10
	ld	(x), a
	ret
;	ssdtest.c: 331: void gotoxy(uint8_t x, uint8_t y)
;	-----------------------------------------
;	 function gotoxy
;	-----------------------------------------
_gotoxy:
;	ssdtest.c: 333: aktxp= x;
	ld	a, (0x03, sp)
	ld	xh, a
	ld	_aktxp+0, a
;	ssdtest.c: 334: aktyp= y;
	ld	a, (0x04, sp)
	ld	_aktyp+0, a
;	ssdtest.c: 335: x *= 8;
	ld	a, xh
	sll	a
	sll	a
	sll	a
	ld	(0x03, sp), a
;	ssdtest.c: 336: y= 7-y;
	ld	a, #0x07
	sub	a, (0x04, sp)
	ld	(0x04, sp), a
;	ssdtest.c: 337: oled_cmdmode();
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xef
	ld	(x), a
;	ssdtest.c: 338: spi_out(0xb0 | (y & 0x0f));
	ld	a, (0x04, sp)
	and	a, #0x0f
	or	a, #0xb0
	push	a
	call	_spi_out
	pop	a
;	ssdtest.c: 339: spi_out(0x10 | (x >> 4 & 0x0f));
	ld	a, (0x03, sp)
	swap	a
	and	a, #0x0f
	and	a, #0x0f
	or	a, #0x10
	push	a
	call	_spi_out
	pop	a
;	ssdtest.c: 340: spi_out(x & 0x0f);
	ld	a, (0x03, sp)
	and	a, #0x0f
	push	a
	call	_spi_out
	pop	a
;	ssdtest.c: 341: oled_datamode();
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x10
	ld	(x), a
	ret
;	ssdtest.c: 354: void oled_putchar(uint8_t ch)
;	-----------------------------------------
;	 function oled_putchar
;	-----------------------------------------
_oled_putchar:
	sub	sp, #43
;	ssdtest.c: 361: if (ch== 13)                                          // Fuer <printf> "/r" Implementation
	ld	a, (0x2e, sp)
	cp	a, #0x0d
	jrne	00102$
;	ssdtest.c: 363: aktxp= 0;
	clr	_aktxp+0
;	ssdtest.c: 364: gotoxy(aktxp, aktyp);
	push	_aktyp+0
	push	#0x00
	call	_gotoxy
	popw	x
;	ssdtest.c: 365: return;
	jp	00146$
00102$:
;	ssdtest.c: 367: if (ch== 10)                                          // fuer <printf> "/n" Implementation
	ld	a, (0x2e, sp)
	cp	a, #0x0a
	jrne	00104$
;	ssdtest.c: 369: aktyp++;
	ld	a, _aktyp+0
	inc	a
	ld	_aktyp+0, a
;	ssdtest.c: 370: gotoxy(aktxp, aktyp);
	push	_aktyp+0
	push	_aktxp+0
	call	_gotoxy
	popw	x
;	ssdtest.c: 371: return;
	jp	00146$
00104$:
;	ssdtest.c: 374: if (ch== 8)
	ld	a, (0x2e, sp)
	cp	a, #0x08
	jrne	00112$
;	ssdtest.c: 376: if ((aktxp> 0))
	tnz	_aktxp+0
	jrne	00259$
	jp	00146$
00259$:
;	ssdtest.c: 379: aktxp--;
	dec	_aktxp+0
;	ssdtest.c: 380: gotoxy(aktxp, aktyp);
	push	_aktyp+0
	push	_aktxp+0
	call	_gotoxy
	popw	x
;	ssdtest.c: 382: for (i= 0; i< 8; i++)
	clr	a
00134$:
;	ssdtest.c: 384: if ((!textcolor)) spi_out(0xff); else spi_out(0x00);
	tnz	_textcolor+0
	jrne	00106$
	push	a
	push	#0xff
	call	_spi_out
	pop	a
	pop	a
	jra	00135$
00106$:
	push	a
	push	#0x00
	call	_spi_out
	pop	a
	pop	a
00135$:
;	ssdtest.c: 382: for (i= 0; i< 8; i++)
	inc	a
	cp	a, #0x08
	jrc	00134$
;	ssdtest.c: 386: gotoxy(aktxp, aktyp);
	push	_aktyp+0
	push	_aktxp+0
	call	_gotoxy
	popw	x
;	ssdtest.c: 388: return;
	jp	00146$
00112$:
;	ssdtest.c: 397: z1= font8x8h[ch-' '][i];
	clrw	x
	ld	a, (0x2e, sp)
	ld	xl, a
	subw	x, #0x0020
	sllw	x
	sllw	x
	sllw	x
	ldw	(0x24, sp), x
;	ssdtest.c: 392: if (doublechar)
	tnz	_doublechar+0
	jrne	00262$
	jp	00169$
00262$:
;	ssdtest.c: 394: for (i= 0; i< 8; i++)
	ldw	x, #_font8x8h+0
	ldw	(0x2a, sp), x
	ldw	x, sp
	addw	x, #5
	ldw	(0x18, sp), x
	clr	(0x04, sp)
00138$:
;	ssdtest.c: 397: z1= font8x8h[ch-' '][i];
	ldw	x, (0x2a, sp)
	addw	x, (0x24, sp)
	ld	a, xl
	add	a, (0x04, sp)
	rlwa	x
	adc	a, #0x00
	ld	xh, a
	ld	a, (x)
	ld	(0x15, sp), a
;	ssdtest.c: 398: z2[i]= 0;
	clrw	x
	ld	a, (0x04, sp)
	ld	xl, a
	sllw	x
	addw	x, (0x18, sp)
	ldw	(0x1e, sp), x
	ldw	x, (0x1e, sp)
	clr	(0x1, x)
	clr	(x)
;	ssdtest.c: 399: for (b= 0; b< 8; b++)
	clr	(0x03, sp)
00136$:
;	ssdtest.c: 401: if (z1 & (1 << b))
	ldw	x, #0x0001
	ld	a, (0x03, sp)
	jreq	00264$
00263$:
	sllw	x
	dec	a
	jrne	00263$
00264$:
	ld	a, (0x15, sp)
	ld	(0x17, sp), a
	clr	(0x16, sp)
	ld	a, xl
	and	a, (0x17, sp)
	rlwa	x
	and	a, (0x16, sp)
	ld	xh, a
	tnzw	x
	jreq	00137$
;	ssdtest.c: 403: z2[i] |= (1 << (b*2));
	ldw	x, (0x1e, sp)
	ldw	x, (x)
	ldw	(0x22, sp), x
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	sllw	x
	ldw	(0x26, sp), x
	ldw	x, #0x0001
	ld	a, (0x27, sp)
	jreq	00267$
00266$:
	sllw	x
	dec	a
	jrne	00266$
00267$:
	ld	a, xl
	or	a, (0x23, sp)
	ld	(0x1b, sp), a
	ld	a, xh
	or	a, (0x22, sp)
	ld	(0x1a, sp), a
	ldw	x, (0x1e, sp)
	ldw	y, (0x1a, sp)
	ldw	(x), y
;	ssdtest.c: 404: z2[i] |= (1 << ((b*2)+1));
	ldw	x, (0x26, sp)
	incw	x
	ldw	(0x1c, sp), x
	ldw	x, #0x0001
	ld	a, (0x1d, sp)
	jreq	00269$
00268$:
	sllw	x
	dec	a
	jrne	00268$
00269$:
	ld	a, xl
	or	a, (0x1b, sp)
	rlwa	x
	or	a, (0x1a, sp)
	ld	xh, a
	ldw	y, (0x1e, sp)
	ldw	(y), x
00137$:
;	ssdtest.c: 399: for (b= 0; b< 8; b++)
	inc	(0x03, sp)
	ld	a, (0x03, sp)
	cp	a, #0x08
	jrc	00136$
;	ssdtest.c: 394: for (i= 0; i< 8; i++)
	inc	(0x04, sp)
	ld	a, (0x04, sp)
	cp	a, #0x08
	jrnc	00271$
	jp	00138$
00271$:
;	ssdtest.c: 409: for (i= 0; i< 8; i++)
	clr	(0x04, sp)
00140$:
;	ssdtest.c: 411: z= z2[i];
	clrw	x
	ld	a, (0x04, sp)
	ld	xl, a
	sllw	x
	addw	x, (0x18, sp)
	ldw	x, (x)
	ldw	(0x28, sp), x
;	ssdtest.c: 412: if ((!textcolor)) z= ~z;
	tnz	_textcolor+0
	jrne	00118$
	ldw	x, (0x28, sp)
	cplw	x
	ldw	(0x28, sp), x
00118$:
;	ssdtest.c: 413: z= z >> 8;
	ld	a, (0x28, sp)
	ld	xh, a
	clr	a
;	ssdtest.c: 414: spi_out(z);
	ld	a, xh
	push	a
	push	a
	call	_spi_out
	pop	a
	call	_spi_out
	pop	a
;	ssdtest.c: 409: for (i= 0; i< 8; i++)
	inc	(0x04, sp)
	ld	a, (0x04, sp)
	cp	a, #0x08
	jrc	00140$
;	ssdtest.c: 417: gotoxy(aktxp, aktyp+1);
	ld	a, _aktyp+0
	inc	a
	push	a
	push	_aktxp+0
	call	_gotoxy
	popw	x
;	ssdtest.c: 418: for (i= 0; i< 8; i++)
	clr	(0x04, sp)
00142$:
;	ssdtest.c: 420: z= z2[i];
	clrw	x
	ld	a, (0x04, sp)
	ld	xl, a
	sllw	x
	addw	x, (0x18, sp)
	ldw	x, (x)
	ldw	(0x01, sp), x
;	ssdtest.c: 421: if ((!textcolor)) z= ~z;
	tnz	_textcolor+0
	jrne	00121$
	ldw	x, (0x01, sp)
	cplw	x
	ldw	(0x01, sp), x
00121$:
;	ssdtest.c: 422: z= z & 0xff;
	ld	a, (0x02, sp)
	ld	xh, a
	clr	a
;	ssdtest.c: 423: spi_out(z);
	ld	a, xh
	push	a
	push	a
	call	_spi_out
	pop	a
	call	_spi_out
	pop	a
;	ssdtest.c: 418: for (i= 0; i< 8; i++)
	inc	(0x04, sp)
	ld	a, (0x04, sp)
	cp	a, #0x08
	jrc	00142$
;	ssdtest.c: 426: aktyp--;
	ld	a, _aktyp+0
	dec	a
	ld	_aktyp+0, a
;	ssdtest.c: 427: aktxp +=2;
	ld	a, _aktxp+0
	add	a, #0x02
;	ssdtest.c: 428: if (aktxp> 15)
	ld	_aktxp+0, a
	cp	a, #0x0f
	jrule	00124$
;	ssdtest.c: 430: aktxp= 0;
	clr	_aktxp+0
;	ssdtest.c: 431: aktyp +=2;
	ld	a, _aktyp+0
	add	a, #0x02
	ld	_aktyp+0, a
00124$:
;	ssdtest.c: 433: gotoxy(aktxp,aktyp);
	push	_aktyp+0
	push	_aktxp+0
	call	_gotoxy
	popw	x
	jra	00146$
;	ssdtest.c: 437: for (i= 0; i< 8; i++)
00169$:
	ldw	x, #_font8x8h+0
	ldw	(0x20, sp), x
	clr	(0x04, sp)
00144$:
;	ssdtest.c: 439: if ((!textcolor)) spi_out(~(font8x8h[ch-' '][i]));
	ldw	x, (0x20, sp)
	addw	x, (0x24, sp)
	ld	a, xl
	add	a, (0x04, sp)
	rlwa	x
	adc	a, #0x00
	ld	xh, a
	ld	a, (x)
	tnz	_textcolor+0
	jrne	00126$
	cpl	a
	push	a
	call	_spi_out
	pop	a
	jra	00145$
00126$:
;	ssdtest.c: 440: else spi_out(font8x8h[ch-' '][i]);
	push	a
	call	_spi_out
	pop	a
00145$:
;	ssdtest.c: 437: for (i= 0; i< 8; i++)
	inc	(0x04, sp)
	ld	a, (0x04, sp)
	cp	a, #0x08
	jrc	00144$
;	ssdtest.c: 442: aktxp++;
	ld	a, _aktxp+0
	inc	a
;	ssdtest.c: 443: if (aktxp> 15)
	ld	_aktxp+0, a
	cp	a, #0x0f
	jrule	00130$
;	ssdtest.c: 445: aktxp= 0;
	clr	_aktxp+0
;	ssdtest.c: 446: aktyp++;
	ld	a, _aktyp+0
	inc	a
	ld	_aktyp+0, a
00130$:
;	ssdtest.c: 448: gotoxy(aktxp,aktyp);
	push	_aktyp+0
	push	_aktxp+0
	call	_gotoxy
	popw	x
00146$:
	addw	sp, #43
	ret
;	ssdtest.c: 458: uint8_t reversebyte(uint8_t value)
;	-----------------------------------------
;	 function reversebyte
;	-----------------------------------------
_reversebyte:
	sub	sp, #4
;	ssdtest.c: 462: hb= 0;
	clr	(0x02, sp)
;	ssdtest.c: 463: for (b= 0; b< 8; b++)
	clr	(0x01, sp)
00104$:
;	ssdtest.c: 465: if (value & (1 << b)) hb |= (1 << (7-b));
	ldw	x, #0x0001
	ld	a, (0x01, sp)
	jreq	00122$
00121$:
	sllw	x
	dec	a
	jrne	00121$
00122$:
	ld	a, (0x07, sp)
	ld	(0x04, sp), a
	clr	(0x03, sp)
	ld	a, xl
	and	a, (0x04, sp)
	rlwa	x
	and	a, (0x03, sp)
	ld	xh, a
	tnzw	x
	jreq	00105$
	ld	a, #0x07
	sub	a, (0x01, sp)
	ld	xh, a
	ld	a, #0x01
	push	a
	ld	a, xh
	tnz	a
	jreq	00125$
00124$:
	sll	(1, sp)
	dec	a
	jrne	00124$
00125$:
	pop	a
	or	a, (0x02, sp)
	ld	(0x02, sp), a
00105$:
;	ssdtest.c: 463: for (b= 0; b< 8; b++)
	inc	(0x01, sp)
	ld	a, (0x01, sp)
	cp	a, #0x08
	jrc	00104$
;	ssdtest.c: 467: return hb;
	ld	a, (0x02, sp)
	addw	sp, #4
	ret
;	ssdtest.c: 520: void showimage_d(uint8_t ox, uint8_t oy, const unsigned char* const image, char mode)
;	-----------------------------------------
;	 function showimage_d
;	-----------------------------------------
_showimage_d:
	sub	sp, #24
;	ssdtest.c: 528: resX= image[0];
	ldw	y, (0x1d, sp)
	ldw	(0x11, sp), y
	ldw	x, (0x11, sp)
	ld	a, (x)
	ld	xh, a
;	ssdtest.c: 529: resY= image[1];
	ldw	y, (0x11, sp)
	ld	a, (0x1, y)
	ld	(0x04, sp), a
;	ssdtest.c: 531: if ((resX % 8) == 0) { resX= resX / 8; }
	ld	a, xh
	and	a, #0x07
	ld	(0x14, sp), a
	ld	a, xh
	srl	a
	srl	a
	srl	a
	tnz	(0x14, sp)
	jrne	00102$
	ld	(0x05, sp), a
	jra	00138$
00102$:
;	ssdtest.c: 532: else  { resX= (resX / 8)+1; }
	inc	a
	ld	(0x05, sp), a
;	ssdtest.c: 534: for (y=0; y < (resY / 8); y++)
00138$:
	ld	a, (0x1c, sp)
	srl	a
	srl	a
	srl	a
	ld	(0x13, sp), a
	ld	a, (0x1f, sp)
	cp	a, #0x02
	jrne	00177$
	ld	a, #0x01
	ld	(0x10, sp), a
	jra	00178$
00177$:
	clr	(0x10, sp)
00178$:
	ld	a, (0x1f, sp)
	cp	a, #0x01
	jrne	00180$
	ld	a, #0x01
	ld	(0x0f, sp), a
	jra	00181$
00180$:
	clr	(0x0f, sp)
00181$:
	ld	a, (0x04, sp)
	srl	a
	srl	a
	srl	a
	ld	(0x18, sp), a
	clr	(0x02, sp)
00124$:
	ld	a, (0x02, sp)
	cp	a, (0x18, sp)
	jrc	00182$
	jp	00126$
00182$:
;	ssdtest.c: 536: xp= 0;
	clr	(0x17, sp)
;	ssdtest.c: 537: oled_setpageadr(ox, y + (oy / 8));
	ld	a, (0x02, sp)
	add	a, (0x13, sp)
	push	a
	ld	a, (0x1c, sp)
	push	a
	call	_oled_setpageadr
	popw	x
;	ssdtest.c: 539: for (x= 0; x < (resX * 8); x++)
	clr	(0x03, sp)
00121$:
	ld	a, (0x05, sp)
	ld	(0x16, sp), a
	clr	(0x15, sp)
	ldw	x, (0x15, sp)
	sllw	x
	sllw	x
	sllw	x
	ldw	(0x08, sp), x
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	cpw	x, (0x08, sp)
	jrslt	00183$
	jp	00125$
00183$:
;	ssdtest.c: 542: if ((mode==1) || (mode==2))
	tnz	(0x0f, sp)
	jrne	00112$
	tnz	(0x10, sp)
	jrne	00185$
	jp	00113$
00185$:
00112$:
;	ssdtest.c: 545: b= 0xff;
	ld	a, #0xff
	ld	(0x07, sp), a
;	ssdtest.c: 546: for (i= 0; i < 8; i++)
	ld	a, (0x03, sp)
	srl	a
	srl	a
	srl	a
	ld	(0x06, sp), a
	ld	a, #0x07
	sub	a, (0x17, sp)
	ld	xh, a
	ld	a, #0x01
	ld	(0x0e, sp), a
	ld	a, xh
	tnz	a
	jreq	00187$
00186$:
	sll	(0x0e, sp)
	dec	a
	jrne	00186$
00187$:
	clr	(0x01, sp)
00118$:
;	ssdtest.c: 548: hb = image[(((y*8)+i) * resX) +(x / 8)+2];
	clrw	x
	ld	a, (0x02, sp)
	ld	xl, a
	sllw	x
	sllw	x
	sllw	x
	ldw	(0x0c, sp), x
	ld	a, (0x01, sp)
	ld	xl, a
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	xh, a
	addw	x, (0x0c, sp)
	ldw	y, (0x15, sp)
	pushw	y
	pushw	x
	call	__mulint
	addw	sp, #4
	ld	a, (0x06, sp)
	ld	(0x0b, sp), a
	clr	(0x0a, sp)
	addw	x, (0x0a, sp)
	incw	x
	incw	x
	addw	x, (0x11, sp)
	ld	a, (x)
;	ssdtest.c: 549: hb &= 1<<(7-xp);
	and	a, (0x0e, sp)
;	ssdtest.c: 550: if (hb != 0)
	tnz	a
	jreq	00119$
;	ssdtest.c: 552: b&= ~(1 << i);
	ld	a, #0x01
	push	a
	ld	a, (0x02, sp)
	jreq	00190$
00189$:
	sll	(1, sp)
	dec	a
	jrne	00189$
00190$:
	pop	a
	cpl	a
	and	a, (0x07, sp)
	ld	(0x07, sp), a
00119$:
;	ssdtest.c: 546: for (i= 0; i < 8; i++)
	inc	(0x01, sp)
	ld	a, (0x01, sp)
	cp	a, #0x08
	jrslt	00118$
;	ssdtest.c: 556: xp++;
	ld	a, (0x17, sp)
	inc	a
;	ssdtest.c: 557: xp = xp % 8;
	and	a, #0x07
	ld	(0x17, sp), a
;	ssdtest.c: 558: b = reversebyte(b);
	ld	a, (0x07, sp)
	push	a
	call	_reversebyte
	addw	sp, #1
;	ssdtest.c: 559: if (mode==2) b= ~b;
	tnz	(0x10, sp)
	jreq	00108$
	cpl	a
00108$:
;	ssdtest.c: 560: spi_out(b);
	push	a
	call	_spi_out
	pop	a
	jra	00122$
00113$:
;	ssdtest.c: 564: if (bkcolor) spi_out(0xff); else  spi_out(0x00);
	tnz	_bkcolor+0
	jreq	00110$
	push	#0xff
	call	_spi_out
	pop	a
	jra	00122$
00110$:
	push	#0x00
	call	_spi_out
	pop	a
00122$:
;	ssdtest.c: 539: for (x= 0; x < (resX * 8); x++)
	inc	(0x03, sp)
	jp	00121$
00125$:
;	ssdtest.c: 534: for (y=0; y < (resY / 8); y++)
	inc	(0x02, sp)
	jp	00124$
00126$:
	addw	sp, #24
	ret
;	ssdtest.c: 570: void show_vled(uint8_t value)
;	-----------------------------------------
;	 function show_vled
;	-----------------------------------------
_show_vled:
	sub	sp, #3
;	ssdtest.c: 574: for (b= 7; b > -1; b--)
	ld	a, #0x07
	ld	(0x01, sp), a
00105$:
;	ssdtest.c: 576: if (value & (1 << b)) oled_putchar(129); else oled_putchar(128);
	ldw	x, #0x0001
	ld	a, (0x01, sp)
	jreq	00119$
00118$:
	sllw	x
	dec	a
	jrne	00118$
00119$:
	ld	a, (0x06, sp)
	ld	(0x03, sp), a
	clr	(0x02, sp)
	ld	a, xl
	and	a, (0x03, sp)
	rlwa	x
	and	a, (0x02, sp)
	ld	xh, a
	tnzw	x
	jreq	00102$
	push	#0x81
	call	_oled_putchar
	pop	a
	jra	00106$
00102$:
	push	#0x80
	call	_oled_putchar
	pop	a
00106$:
;	ssdtest.c: 574: for (b= 7; b > -1; b--)
	dec	(0x01, sp)
	ld	a, (0x01, sp)
	cp	a, #0xff
	jrsgt	00105$
	addw	sp, #3
	ret
;	ssdtest.c: 580: void putchar(char ch)
;	-----------------------------------------
;	 function putchar
;	-----------------------------------------
_putchar:
;	ssdtest.c: 582: oled_putchar(ch);
	ld	a, (0x03, sp)
	push	a
	call	_oled_putchar
	pop	a
	ret
;	ssdtest.c: 589: int main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #6
;	ssdtest.c: 593: sysclock_init(0);                     // zuerst System fuer internen Takt
	push	#0x00
	call	_sysclock_init
	pop	a
;	ssdtest.c: 594: oled_init();
	call	_oled_init
;	ssdtest.c: 596: while(1)
00111$:
;	ssdtest.c: 598: bkcolor= 0;
	clr	_bkcolor+0
;	ssdtest.c: 599: textcolor= 1;
	mov	_textcolor+0, #0x01
;	ssdtest.c: 600: clrscr();
	call	_clrscr
;	ssdtest.c: 602: gotoxy(0,0);
	push	#0x00
	push	#0x00
	call	_gotoxy
	popw	x
;	ssdtest.c: 603: printf("STM8S103   16MHz\n\r");
	ldw	x, #___str_0+0
	pushw	x
	call	_my_printf
	popw	x
;	ssdtest.c: 604: printf("----------------");
	ldw	x, #___str_1+0
	ldw	(0x05, sp), x
	ldw	x, (0x05, sp)
	pushw	x
	call	_my_printf
	popw	x
;	ssdtest.c: 606: doublechar= 1;
	mov	_doublechar+0, #0x01
;	ssdtest.c: 607: gotoxy(3,3);
	push	#0x03
	push	#0x03
	call	_gotoxy
	popw	x
;	ssdtest.c: 608: printf("STM8S");
	ldw	x, #___str_2+0
	pushw	x
	call	_my_printf
	popw	x
;	ssdtest.c: 609: doublechar= 0;
	clr	_doublechar+0
;	ssdtest.c: 610: gotoxy(3,5);
	push	#0x05
	push	#0x03
	call	_gotoxy
	popw	x
;	ssdtest.c: 611: printf("Hallo Welt");
	ldw	x, #___str_3+0
	pushw	x
	call	_my_printf
	popw	x
;	ssdtest.c: 612: gotoxy(0,7);
	push	#0x07
	push	#0x00
	call	_gotoxy
	popw	x
;	ssdtest.c: 613: for (b= 5; b>0; b--)
	ldw	x, #___str_4+0
	ldw	(0x03, sp), x
	ld	a, #0x05
	ld	(0x02, sp), a
00113$:
;	ssdtest.c: 615: printf("\r   Coundown: %d ",b);
	clrw	x
	ld	a, (0x02, sp)
	ld	xl, a
	ldw	y, (0x03, sp)
	pushw	x
	pushw	y
	call	_my_printf
	addw	sp, #4
;	ssdtest.c: 616: delay_ms(1000);
	push	#0xe8
	push	#0x03
	call	_delay_ms
	popw	x
;	ssdtest.c: 613: for (b= 5; b>0; b--)
	dec	(0x02, sp)
	tnz	(0x02, sp)
	jrne	00113$
;	ssdtest.c: 619: textcolor= 0;
	clr	_textcolor+0
;	ssdtest.c: 620: bkcolor= 0;
	clr	_bkcolor+0
;	ssdtest.c: 621: clrscr();
	call	_clrscr
;	ssdtest.c: 622: showimage_d(20,0,&bmppic[0],1);
	ldw	x, #_bmppic+0
	push	#0x01
	pushw	x
	push	#0x00
	push	#0x14
	call	_showimage_d
	addw	sp, #5
;	ssdtest.c: 623: gotoxy(0,7);
	push	#0x07
	push	#0x00
	call	_gotoxy
	popw	x
;	ssdtest.c: 624: for (b= 5; b>0; b--)
	ld	a, #0x05
00115$:
;	ssdtest.c: 626: delay_ms(1000);
	push	a
	push	#0xe8
	push	#0x03
	call	_delay_ms
	popw	x
	pop	a
;	ssdtest.c: 624: for (b= 5; b>0; b--)
	dec	a
	tnz	a
	jrne	00115$
;	ssdtest.c: 629: textcolor= 1;
	mov	_textcolor+0, #0x01
;	ssdtest.c: 630: bkcolor= 0;
	clr	_bkcolor+0
;	ssdtest.c: 631: clrscr();
	call	_clrscr
;	ssdtest.c: 633: gotoxy(0,0);
	push	#0x00
	push	#0x00
	call	_gotoxy
	popw	x
;	ssdtest.c: 634: printf("Virtuelle LED's\n\r");
	ldw	x, #___str_5+0
	pushw	x
	call	_my_printf
	popw	x
;	ssdtest.c: 635: printf("----------------");
	ldw	x, (0x05, sp)
	pushw	x
	call	_my_printf
	popw	x
;	ssdtest.c: 637: doublechar= 1;
	mov	_doublechar+0, #0x01
;	ssdtest.c: 639: for (i= 0; i< 2; i++)
	clr	(0x01, sp)
00117$:
;	ssdtest.c: 641: b= 0x80;
	ld	a, #0x80
;	ssdtest.c: 642: while(b> 0)
00103$:
	tnz	a
	jreq	00105$
;	ssdtest.c: 644: gotoxy(0,4);
	push	a
	push	#0x04
	push	#0x00
	call	_gotoxy
	popw	x
	pop	a
;	ssdtest.c: 645: show_vled(b);
	push	a
	push	a
	call	_show_vled
	pop	a
	push	#0x64
	push	#0x00
	call	_delay_ms
	popw	x
	pop	a
;	ssdtest.c: 647: b= b>> 1;
	srl	a
	jra	00103$
00105$:
;	ssdtest.c: 650: b= 0x02;
	ld	a, #0x02
;	ssdtest.c: 651: while(b< 80)
00106$:
	cp	a, #0x50
	jrnc	00118$
;	ssdtest.c: 653: gotoxy(0,4);
	push	a
	push	#0x04
	push	#0x00
	call	_gotoxy
	popw	x
	pop	a
;	ssdtest.c: 654: show_vled(b);
	push	a
	push	a
	call	_show_vled
	pop	a
	push	#0x64
	push	#0x00
	call	_delay_ms
	popw	x
	pop	a
;	ssdtest.c: 656: b= b<< 1;
	sll	a
	jra	00106$
00118$:
;	ssdtest.c: 639: for (i= 0; i< 2; i++)
	inc	(0x01, sp)
	push	a
	ld	a, (0x02, sp)
	cp	a, #0x02
	pop	a
	jrc	00117$
;	ssdtest.c: 659: gotoxy(0,4);
	push	a
	push	#0x04
	push	#0x00
	call	_gotoxy
	popw	x
	call	_show_vled
	pop	a
;	ssdtest.c: 661: delay_ms(300);
	push	#0x2c
	push	#0x01
	call	_delay_ms
	popw	x
;	ssdtest.c: 663: doublechar= 0;
	clr	_doublechar+0
;	ssdtest.c: 664: gotoxy(2,2); printf("%d = 0x%x =", 0x4e, 0x4e);
	push	#0x02
	push	#0x02
	call	_gotoxy
	popw	x
	ldw	x, #___str_6+0
	push	#0x4e
	push	#0x00
	push	#0x4e
	push	#0x00
	pushw	x
	call	_my_printf
	addw	sp, #6
;	ssdtest.c: 665: gotoxy(0,4);
	push	#0x04
	push	#0x00
	call	_gotoxy
	popw	x
;	ssdtest.c: 666: doublechar= 1;
	mov	_doublechar+0, #0x01
;	ssdtest.c: 667: show_vled(0x4e);
	push	#0x4e
	call	_show_vled
	pop	a
;	ssdtest.c: 668: doublechar= 0;
	clr	_doublechar+0
;	ssdtest.c: 670: delay_ms(3000);
	push	#0xb8
	push	#0x0b
	call	_delay_ms
	popw	x
	jp	00111$
	addw	sp, #6
	ret
	.area CODE
_bmppic:
	.db #0x5C	; 92
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3F	; 63
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7F	; 127
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xFB	; 251
	.db #0xC0	; 192
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xEF	; 239
	.db #0xC0	; 192
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0xFD	; 253
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0xD7	; 215
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0xBD	; 189
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0xD3	; 211
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x94	; 148
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x34	; 52	'4'
	.db #0x03	; 3
	.db #0x54	; 84	'T'
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3E	; 62
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7F	; 127
	.db #0x0F	; 15
	.db #0xC2	; 194
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x02	; 2
	.db #0xFA	; 250
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xEB	; 235
	.db #0xFE	; 254
	.db #0x42	; 66	'B'
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x07	; 7
	.db #0xF9	; 249
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x54	; 84	'T'
	.db #0x98	; 152
	.db #0x28	; 40
	.db #0xB0	; 176
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0xFA	; 250
	.db #0x80	; 128
	.db #0x03	; 3
	.db #0x49	; 73	'I'
	.db #0x32	; 50	'2'
	.db #0x93	; 147
	.db #0xA0	; 160
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0xCD	; 205
	.db #0xA0	; 160
	.db #0x07	; 7
	.db #0x67	; 103	'g'
	.db #0x49	; 73	'I'
	.db #0x48	; 72	'H'
	.db #0xE0	; 224
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x07	; 7
	.db #0x26	; 38
	.db #0xC0	; 192
	.db #0x06	; 6
	.db #0x96	; 150
	.db #0xD7	; 215
	.db #0x64	; 100	'd'
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x17	; 23
	.db #0xB7	; 183
	.db #0xE0	; 224
	.db #0x06	; 6
	.db #0xDD	; 221
	.db #0x95	; 149
	.db #0x55	; 85	'U'
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x07	; 7
	.db #0x59	; 89	'Y'
	.db #0xB0	; 176
	.db #0x0D	; 13
	.db #0x59	; 89	'Y'
	.db #0xAB	; 171
	.db #0xD8	; 216
	.db #0xAC	; 172
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x0F	; 15
	.db #0x25	; 37
	.db #0xF8	; 248
	.db #0x0C	; 12
	.db #0xB1	; 177
	.db #0x56	; 86	'V'
	.db #0xA7	; 167
	.db #0xFE	; 254
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x1C	; 28
	.db #0x56	; 86	'V'
	.db #0xEE	; 238
	.db #0x0D	; 13
	.db #0x71	; 113	'q'
	.db #0x5B	; 91
	.db #0x9C	; 156
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x2E	; 46
	.db #0x5B	; 91
	.db #0x7F	; 127
	.db #0x93	; 147
	.db #0x63	; 99	'c'
	.db #0x56	; 86	'V'
	.db #0x30	; 48	'0'
	.db #0x01	; 1
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x1D	; 29
	.db #0x1D	; 29
	.db #0xD6	; 214
	.db #0x76	; 118	'v'
	.db #0xE3	; 227
	.db #0xAC	; 172
	.db #0xE1	; 225
	.db #0x70	; 112	'p'
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0xC7	; 199
	.db #0x76	; 118	'v'
	.db #0x25	; 37
	.db #0xC3	; 195
	.db #0x35	; 53	'5'
	.db #0x8F	; 143
	.db #0x9E	; 158
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x1C	; 28
	.db #0x77	; 119	'w'
	.db #0xEC	; 236
	.db #0x4D	; 77	'M'
	.db #0x93	; 147
	.db #0xBB	; 187
	.db #0x1A	; 26
	.db #0xD3	; 211
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x5C	; 92
	.db #0x9D	; 157
	.db #0xB8	; 184
	.db #0x0F	; 15
	.db #0x86	; 134
	.db #0xA6	; 166
	.db #0x6D	; 109	'm'
	.db #0x20	; 32
	.db #0xE0	; 224
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x5F	; 95
	.db #0x47	; 71	'G'
	.db #0xE8	; 232
	.db #0xEB	; 235
	.db #0x06	; 6
	.db #0xAC	; 172
	.db #0xD5	; 213
	.db #0x97	; 151
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x1D	; 29
	.db #0xBF	; 191
	.db #0x53	; 83	'S'
	.db #0xF6	; 246
	.db #0x46	; 70	'F'
	.db #0xB9	; 185
	.db #0xB7	; 183
	.db #0xDA	; 218
	.db #0xA0	; 160
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x1C	; 28
	.db #0x7D	; 125
	.db #0xDF	; 223
	.db #0xEE	; 238
	.db #0x0F	; 15
	.db #0x51	; 81	'Q'
	.db #0x9E	; 158
	.db #0xAA	; 170
	.db #0xB0	; 176
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x2D	; 45
	.db #0xAE	; 174
	.db #0xFD	; 253
	.db #0x34	; 52	'4'
	.db #0x2D	; 45
	.db #0x73	; 115	's'
	.db #0x60	; 96
	.db #0x39	; 57	'9'
	.db #0xD0	; 208
	.db #0x01	; 1
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x2C	; 44
	.db #0xFB	; 251
	.db #0xFD	; 253
	.db #0x98	; 152
	.db #0x8D	; 141
	.db #0x67	; 103	'g'
	.db #0x80	; 128
	.db #0x0E	; 14
	.db #0xB0	; 176
	.db #0x07	; 7
	.db #0xF0	; 240
	.db #0x00	; 0
	.db #0x2E	; 46
	.db #0x1F	; 31
	.db #0xB6	; 182
	.db #0x5A	; 90	'Z'
	.db #0x1A	; 26
	.db #0xCF	; 207
	.db #0x0A	; 10
	.db #0x8F	; 143
	.db #0xD0	; 208
	.db #0x0F	; 15
	.db #0xF8	; 248
	.db #0x00	; 0
	.db #0x0F	; 15
	.db #0xB3	; 179
	.db #0xEA	; 234
	.db #0x18	; 24
	.db #0x1B	; 27
	.db #0x8D	; 141
	.db #0x29	; 41
	.db #0x0F	; 15
	.db #0xF8	; 248
	.db #0x29	; 41
	.db #0xFC	; 252
	.db #0x00	; 0
	.db #0x1E	; 30
	.db #0xFF	; 255
	.db #0x75	; 117	'u'
	.db #0x50	; 80	'P'
	.db #0xB5	; 181
	.db #0xBC	; 188
	.db #0x3F	; 63
	.db #0x46	; 70	'F'
	.db #0x70	; 112	'p'
	.db #0x46	; 70	'F'
	.db #0x7E	; 126
	.db #0x00	; 0
	.db #0x0D	; 13
	.db #0x2B	; 43
	.db #0x99	; 153
	.db #0xAA	; 170
	.db #0x2F	; 47
	.db #0x3A	; 58
	.db #0x7F	; 127
	.db #0xCF	; 207
	.db #0xDC	; 220
	.db #0x15	; 21
	.db #0x9F	; 159
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0xF7	; 247
	.db #0x84	; 132
	.db #0xD8	; 216
	.db #0x6A	; 106	'j'
	.db #0x34	; 52	'4'
	.db #0xE0	; 224
	.db #0xA4	; 164
	.db #0xB4	; 180
	.db #0x9B	; 155
	.db #0x2F	; 47
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0xFE	; 254
	.db #0xE2	; 226
	.db #0x6C	; 108	'l'
	.db #0xDE	; 222
	.db #0xF1	; 241
	.db #0x9C	; 156
	.db #0x67	; 103	'g'
	.db #0xD4	; 212
	.db #0xBA	; 186
	.db #0xF7	; 247
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x17	; 23
	.db #0x39	; 57	'9'
	.db #0xAC	; 172
	.db #0xB4	; 180
	.db #0xEB	; 235
	.db #0x28	; 40
	.db #0x53	; 83	'S'
	.db #0x4D	; 77	'M'
	.db #0xED	; 237
	.db #0x05	; 5
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x06	; 6
	.db #0xDE	; 222
	.db #0xED	; 237
	.db #0xC3	; 195
	.db #0x3E	; 62
	.db #0x64	; 100	'd'
	.db #0xB5	; 181
	.db #0x5A	; 90	'Z'
	.db #0xD7	; 215
	.db #0xC0	; 192
	.db #0x00	; 0
	.db #0x07	; 7
	.db #0xFB	; 251
	.db #0x6B	; 107	'k'
	.db #0xDD	; 221
	.db #0xA9	; 169
	.db #0x3C	; 60
	.db #0xA5	; 165
	.db #0x16	; 22
	.db #0xB7	; 183
	.db #0x3D	; 61
	.db #0xC0	; 192
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x3F	; 63
	.db #0xBD	; 189
	.db #0xBB	; 187
	.db #0x81	; 129
	.db #0xBC	; 188
	.db #0x84	; 132
	.db #0x0D	; 13
	.db #0xED	; 237
	.db #0x63	; 99	'c'
	.db #0xC0	; 192
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0xD4	; 212
	.db #0xDA	; 218
	.db #0x94	; 148
	.db #0xC1	; 193
	.db #0x89	; 137
	.db #0x4B	; 75	'K'
	.db #0xB3	; 179
	.db #0x91	; 145
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x07	; 7
	.db #0xAF	; 175
	.db #0xF6	; 246
	.db #0x77	; 119	'w'
	.db #0x10	; 16
	.db #0x3E	; 62
	.db #0x0D	; 13
	.db #0xCA	; 202
	.db #0xDC	; 220
	.db #0x4B	; 75	'K'
	.db #0xC0	; 192
	.db #0x00	; 0
	.db #0x07	; 7
	.db #0xF5	; 245
	.db #0x68	; 104	'h'
	.db #0x4C	; 76	'L'
	.db #0x55	; 85	'U'
	.db #0x04	; 4
	.db #0x45	; 69	'E'
	.db #0xD3	; 211
	.db #0x77	; 119	'w'
	.db #0xBF	; 191
	.db #0xC0	; 192
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0xFF	; 255
	.db #0xEA	; 234
	.db #0x20	; 32
	.db #0xA0	; 160
	.db #0x15	; 21
	.db #0x5B	; 91
	.db #0x7C	; 124
	.db #0xA1	; 161
	.db #0xC0	; 192
	.db #0x00	; 0
	.db #0x07	; 7
	.db #0xBE	; 190
	.db #0xAF	; 175
	.db #0xAA	; 170
	.db #0x9D	; 157
	.db #0x16	; 22
	.db #0xA5	; 165
	.db #0x95	; 149
	.db #0xAB	; 171
	.db #0x47	; 71	'G'
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0xD4	; 212
	.db #0x77	; 119	'w'
	.db #0xD6	; 214
	.db #0xBE	; 190
	.db #0xE5	; 229
	.db #0x5A	; 90	'Z'
	.db #0xCB	; 203
	.db #0x76	; 118	'v'
	.db #0xAB	; 171
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0xA8	; 168
	.db #0x45	; 69	'E'
	.db #0xD8	; 216
	.db #0x6F	; 111	'o'
	.db #0xB7	; 183
	.db #0x56	; 86	'V'
	.db #0x37	; 55	'7'
	.db #0x9C	; 156
	.db #0x97	; 151
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xC0	; 192
	.db #0x87	; 135
	.db #0xEA	; 234
	.db #0x84	; 132
	.db #0xD5	; 213
	.db #0xAF	; 175
	.db #0x2A	; 42
	.db #0xE7	; 231
	.db #0x57	; 87	'W'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x75	; 117	'u'
	.db #0x03	; 3
	.db #0x75	; 117	'u'
	.db #0x37	; 55	'7'
	.db #0x75	; 117	'u'
	.db #0x76	; 118	'v'
	.db #0xBD	; 189
	.db #0x31	; 49	'1'
	.db #0xAE	; 174
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x34	; 52	'4'
	.db #0x01	; 1
	.db #0xED	; 237
	.db #0x8B	; 139
	.db #0x9D	; 157
	.db #0xBE	; 190
	.db #0x7B	; 123
	.db #0xCD	; 205
	.db #0x4E	; 78	'N'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x01	; 1
	.db #0xEE	; 238
	.db #0xB1	; 177
	.db #0xE7	; 231
	.db #0xF6	; 246
	.db #0xEA	; 234
	.db #0xB4	; 180
	.db #0x3C	; 60
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xFD	; 253
	.db #0x9D	; 157
	.db #0xB8	; 184
	.db #0xAD	; 173
	.db #0xFA	; 250
	.db #0xD2	; 210
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x75	; 117	'u'
	.db #0x56	; 86	'V'
	.db #0xCC	; 204
	.db #0x3D	; 61
	.db #0x4D	; 77	'M'
	.db #0x2C	; 44
	.db #0xF0	; 240
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3B	; 59
	.db #0x6F	; 111	'o'
	.db #0x73	; 115	's'
	.db #0x9A	; 154
	.db #0xC2	; 194
	.db #0xE1	; 225
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x02	; 2
	.db #0x5D	; 93
	.db #0xD9	; 217
	.db #0x9F	; 159
	.db #0xF5	; 245
	.db #0x80	; 128
	.db #0x1F	; 31
	.db #0xC0	; 192
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x0A	; 10
	.db #0x66	; 102	'f'
	.db #0x76	; 118	'v'
	.db #0x6F	; 111	'o'
	.db #0xEB	; 235
	.db #0x01	; 1
	.db #0x27	; 39
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x0B	; 11
	.db #0xCF	; 207
	.db #0x35	; 53	'5'
	.db #0xB9	; 185
	.db #0x56	; 86	'V'
	.db #0x00	; 0
	.db #0x5E	; 94
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x05	; 5
	.db #0x1A	; 26
	.db #0xD5	; 213
	.db #0x57	; 87	'W'
	.db #0x8C	; 140
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x1C	; 28
	.db #0x6B	; 107	'k'
	.db #0xFD	; 253
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x1C	; 28
	.db #0xA7	; 167
	.db #0xC0	; 192
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x0F	; 15
	.db #0x5D	; 93
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0xD4	; 212
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
_font8x8h:
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xFA	; 250
	.db #0xFA	; 250
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xE0	; 224
	.db #0xE0	; 224
	.db #0x00	; 0
	.db #0xE0	; 224
	.db #0xE0	; 224
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x28	; 40
	.db #0xFE	; 254
	.db #0xFE	; 254
	.db #0x28	; 40
	.db #0xFE	; 254
	.db #0xFE	; 254
	.db #0x28	; 40
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x24	; 36
	.db #0x54	; 84	'T'
	.db #0xFE	; 254
	.db #0xFE	; 254
	.db #0x54	; 84	'T'
	.db #0x48	; 72	'H'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x62	; 98	'b'
	.db #0x66	; 102	'f'
	.db #0x0C	; 12
	.db #0x18	; 24
	.db #0x30	; 48	'0'
	.db #0x66	; 102	'f'
	.db #0x46	; 70	'F'
	.db #0x00	; 0
	.db #0x0C	; 12
	.db #0x5E	; 94
	.db #0xF2	; 242
	.db #0xBA	; 186
	.db #0xEC	; 236
	.db #0x5E	; 94
	.db #0x12	; 18
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0xE0	; 224
	.db #0xC0	; 192
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x7C	; 124
	.db #0xC6	; 198
	.db #0x82	; 130
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x82	; 130
	.db #0xC6	; 198
	.db #0x7C	; 124
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x54	; 84	'T'
	.db #0x7C	; 124
	.db #0x38	; 56	'8'
	.db #0x38	; 56	'8'
	.db #0x7C	; 124
	.db #0x54	; 84	'T'
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x7C	; 124
	.db #0x7C	; 124
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x0C	; 12
	.db #0x18	; 24
	.db #0x30	; 48	'0'
	.db #0x60	; 96
	.db #0xC0	; 192
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x7C	; 124
	.db #0xFE	; 254
	.db #0x8A	; 138
	.db #0x92	; 146
	.db #0xA2	; 162
	.db #0xFE	; 254
	.db #0x7C	; 124
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x40	; 64
	.db #0xFE	; 254
	.db #0xFE	; 254
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x42	; 66	'B'
	.db #0xC6	; 198
	.db #0x8E	; 142
	.db #0x9A	; 154
	.db #0xF2	; 242
	.db #0x62	; 98	'b'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0xC6	; 198
	.db #0x92	; 146
	.db #0x92	; 146
	.db #0xFE	; 254
	.db #0x6C	; 108	'l'
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x38	; 56	'8'
	.db #0x68	; 104	'h'
	.db #0xC8	; 200
	.db #0xFE	; 254
	.db #0xFE	; 254
	.db #0x08	; 8
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xE4	; 228
	.db #0xE6	; 230
	.db #0xA2	; 162
	.db #0xA2	; 162
	.db #0xBE	; 190
	.db #0x9C	; 156
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7C	; 124
	.db #0xFE	; 254
	.db #0x92	; 146
	.db #0x92	; 146
	.db #0xDE	; 222
	.db #0x4C	; 76	'L'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x8E	; 142
	.db #0x9E	; 158
	.db #0xF0	; 240
	.db #0xE0	; 224
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x6C	; 108	'l'
	.db #0xFE	; 254
	.db #0x92	; 146
	.db #0x92	; 146
	.db #0xFE	; 254
	.db #0x6C	; 108	'l'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0xF2	; 242
	.db #0x96	; 150
	.db #0x9C	; 156
	.db #0xF8	; 248
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x36	; 54	'6'
	.db #0x36	; 54	'6'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0xB6	; 182
	.db #0x36	; 54	'6'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x38	; 56	'8'
	.db #0x6C	; 108	'l'
	.db #0xC6	; 198
	.db #0x82	; 130
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x24	; 36
	.db #0x24	; 36
	.db #0x24	; 36
	.db #0x24	; 36
	.db #0x24	; 36
	.db #0x24	; 36
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x82	; 130
	.db #0xC6	; 198
	.db #0x6C	; 108	'l'
	.db #0x38	; 56	'8'
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x40	; 64
	.db #0xC0	; 192
	.db #0x8A	; 138
	.db #0x9A	; 154
	.db #0xF0	; 240
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x7C	; 124
	.db #0xFE	; 254
	.db #0x82	; 130
	.db #0xBA	; 186
	.db #0xBA	; 186
	.db #0xFA	; 250
	.db #0x78	; 120	'x'
	.db #0x00	; 0
	.db #0x3E	; 62
	.db #0x7E	; 126
	.db #0xC8	; 200
	.db #0x88	; 136
	.db #0xC8	; 200
	.db #0x7E	; 126
	.db #0x3E	; 62
	.db #0x00	; 0
	.db #0xFE	; 254
	.db #0xFE	; 254
	.db #0x92	; 146
	.db #0x92	; 146
	.db #0x92	; 146
	.db #0xFE	; 254
	.db #0x6C	; 108	'l'
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x7C	; 124
	.db #0xC6	; 198
	.db #0x82	; 130
	.db #0x82	; 130
	.db #0xC6	; 198
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0xFE	; 254
	.db #0xFE	; 254
	.db #0x82	; 130
	.db #0x82	; 130
	.db #0xC6	; 198
	.db #0x7C	; 124
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0xFE	; 254
	.db #0xFE	; 254
	.db #0x92	; 146
	.db #0x92	; 146
	.db #0x92	; 146
	.db #0x82	; 130
	.db #0x82	; 130
	.db #0x00	; 0
	.db #0xFE	; 254
	.db #0xFE	; 254
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x7C	; 124
	.db #0xC6	; 198
	.db #0x82	; 130
	.db #0x8A	; 138
	.db #0xCE	; 206
	.db #0x4E	; 78	'N'
	.db #0x00	; 0
	.db #0xFE	; 254
	.db #0xFE	; 254
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0xFE	; 254
	.db #0xFE	; 254
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x82	; 130
	.db #0xFE	; 254
	.db #0xFE	; 254
	.db #0x82	; 130
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x0C	; 12
	.db #0x0E	; 14
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0xFE	; 254
	.db #0xFC	; 252
	.db #0x00	; 0
	.db #0xFE	; 254
	.db #0xFE	; 254
	.db #0x90	; 144
	.db #0xB8	; 184
	.db #0x6C	; 108	'l'
	.db #0xC6	; 198
	.db #0x82	; 130
	.db #0x00	; 0
	.db #0xFE	; 254
	.db #0xFE	; 254
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x00	; 0
	.db #0xFE	; 254
	.db #0xFE	; 254
	.db #0x60	; 96
	.db #0x30	; 48	'0'
	.db #0x60	; 96
	.db #0xFE	; 254
	.db #0xFE	; 254
	.db #0x00	; 0
	.db #0xFE	; 254
	.db #0xFE	; 254
	.db #0x60	; 96
	.db #0x30	; 48	'0'
	.db #0x18	; 24
	.db #0xFE	; 254
	.db #0xFE	; 254
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x7C	; 124
	.db #0xC6	; 198
	.db #0x82	; 130
	.db #0xC6	; 198
	.db #0x7C	; 124
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0xFE	; 254
	.db #0xFE	; 254
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0xF0	; 240
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x7C	; 124
	.db #0xC6	; 198
	.db #0x8A	; 138
	.db #0xCC	; 204
	.db #0x76	; 118	'v'
	.db #0x3A	; 58
	.db #0x00	; 0
	.db #0xFE	; 254
	.db #0xFE	; 254
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0x98	; 152
	.db #0xFE	; 254
	.db #0x66	; 102	'f'
	.db #0x00	; 0
	.db #0x64	; 100	'd'
	.db #0xF6	; 246
	.db #0x92	; 146
	.db #0x92	; 146
	.db #0x92	; 146
	.db #0xDE	; 222
	.db #0x4C	; 76	'L'
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0xFE	; 254
	.db #0xFE	; 254
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xFC	; 252
	.db #0xFE	; 254
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0xFE	; 254
	.db #0xFC	; 252
	.db #0x00	; 0
	.db #0xF8	; 248
	.db #0xFC	; 252
	.db #0x06	; 6
	.db #0x02	; 2
	.db #0x06	; 6
	.db #0xFC	; 252
	.db #0xF8	; 248
	.db #0x00	; 0
	.db #0xFE	; 254
	.db #0xFE	; 254
	.db #0x0C	; 12
	.db #0x18	; 24
	.db #0x0C	; 12
	.db #0xFE	; 254
	.db #0xFE	; 254
	.db #0x00	; 0
	.db #0xC6	; 198
	.db #0xEE	; 238
	.db #0x38	; 56	'8'
	.db #0x10	; 16
	.db #0x38	; 56	'8'
	.db #0xEE	; 238
	.db #0xC6	; 198
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xE0	; 224
	.db #0xF0	; 240
	.db #0x1E	; 30
	.db #0x1E	; 30
	.db #0xF0	; 240
	.db #0xE0	; 224
	.db #0x00	; 0
	.db #0x82	; 130
	.db #0x86	; 134
	.db #0x8E	; 142
	.db #0x9A	; 154
	.db #0xB2	; 178
	.db #0xE2	; 226
	.db #0xC2	; 194
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xFE	; 254
	.db #0xFE	; 254
	.db #0x82	; 130
	.db #0x82	; 130
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0xC0	; 192
	.db #0x60	; 96
	.db #0x30	; 48	'0'
	.db #0x18	; 24
	.db #0x0C	; 12
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x82	; 130
	.db #0x82	; 130
	.db #0xFE	; 254
	.db #0xFE	; 254
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x30	; 48	'0'
	.db #0x60	; 96
	.db #0xC0	; 192
	.db #0x60	; 96
	.db #0x30	; 48	'0'
	.db #0x10	; 16
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0xC0	; 192
	.db #0x60	; 96
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x04	; 4
	.db #0x2E	; 46
	.db #0x2A	; 42
	.db #0x2A	; 42
	.db #0x2A	; 42
	.db #0x3E	; 62
	.db #0x1E	; 30
	.db #0x00	; 0
	.db #0xFE	; 254
	.db #0xFE	; 254
	.db #0x22	; 34
	.db #0x22	; 34
	.db #0x22	; 34
	.db #0x3E	; 62
	.db #0x1C	; 28
	.db #0x00	; 0
	.db #0x1C	; 28
	.db #0x3E	; 62
	.db #0x22	; 34
	.db #0x22	; 34
	.db #0x22	; 34
	.db #0x36	; 54	'6'
	.db #0x14	; 20
	.db #0x00	; 0
	.db #0x1C	; 28
	.db #0x3E	; 62
	.db #0x22	; 34
	.db #0x22	; 34
	.db #0x22	; 34
	.db #0xFE	; 254
	.db #0xFE	; 254
	.db #0x00	; 0
	.db #0x1C	; 28
	.db #0x3E	; 62
	.db #0x2A	; 42
	.db #0x2A	; 42
	.db #0x2A	; 42
	.db #0x3A	; 58
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x7E	; 126
	.db #0xFE	; 254
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0xC0	; 192
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x19	; 25
	.db #0x3D	; 61
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x3F	; 63
	.db #0x3E	; 62
	.db #0x00	; 0
	.db #0xFE	; 254
	.db #0xFE	; 254
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x3E	; 62
	.db #0x1E	; 30
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xBE	; 190
	.db #0xBE	; 190
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0xBF	; 191
	.db #0xBE	; 190
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xFE	; 254
	.db #0xFE	; 254
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x1C	; 28
	.db #0x36	; 54	'6'
	.db #0x22	; 34
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xFE	; 254
	.db #0xFE	; 254
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x1E	; 30
	.db #0x3E	; 62
	.db #0x30	; 48	'0'
	.db #0x18	; 24
	.db #0x30	; 48	'0'
	.db #0x3E	; 62
	.db #0x1E	; 30
	.db #0x00	; 0
	.db #0x3E	; 62
	.db #0x3E	; 62
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x3E	; 62
	.db #0x1E	; 30
	.db #0x00	; 0
	.db #0x1C	; 28
	.db #0x3E	; 62
	.db #0x22	; 34
	.db #0x22	; 34
	.db #0x22	; 34
	.db #0x3E	; 62
	.db #0x1C	; 28
	.db #0x00	; 0
	.db #0x3F	; 63
	.db #0x3F	; 63
	.db #0x24	; 36
	.db #0x24	; 36
	.db #0x24	; 36
	.db #0x3C	; 60
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x3C	; 60
	.db #0x24	; 36
	.db #0x24	; 36
	.db #0x24	; 36
	.db #0x3F	; 63
	.db #0x3F	; 63
	.db #0x00	; 0
	.db #0x3E	; 62
	.db #0x3E	; 62
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x30	; 48	'0'
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x12	; 18
	.db #0x3A	; 58
	.db #0x2A	; 42
	.db #0x2A	; 42
	.db #0x2A	; 42
	.db #0x2E	; 46
	.db #0x04	; 4
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0xFC	; 252
	.db #0xFE	; 254
	.db #0x22	; 34
	.db #0x22	; 34
	.db #0x26	; 38
	.db #0x04	; 4
	.db #0x00	; 0
	.db #0x3C	; 60
	.db #0x3E	; 62
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x3E	; 62
	.db #0x3E	; 62
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x3C	; 60
	.db #0x06	; 6
	.db #0x02	; 2
	.db #0x06	; 6
	.db #0x3C	; 60
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x3C	; 60
	.db #0x3E	; 62
	.db #0x06	; 6
	.db #0x0C	; 12
	.db #0x06	; 6
	.db #0x3E	; 62
	.db #0x3C	; 60
	.db #0x00	; 0
	.db #0x22	; 34
	.db #0x36	; 54	'6'
	.db #0x1C	; 28
	.db #0x08	; 8
	.db #0x1C	; 28
	.db #0x36	; 54	'6'
	.db #0x22	; 34
	.db #0x00	; 0
	.db #0x39	; 57	'9'
	.db #0x3D	; 61
	.db #0x05	; 5
	.db #0x05	; 5
	.db #0x05	; 5
	.db #0x3F	; 63
	.db #0x3E	; 62
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x22	; 34
	.db #0x26	; 38
	.db #0x2E	; 46
	.db #0x3A	; 58
	.db #0x32	; 50	'2'
	.db #0x22	; 34
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x7C	; 124
	.db #0xEE	; 238
	.db #0x82	; 130
	.db #0x82	; 130
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xEE	; 238
	.db #0xEE	; 238
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x82	; 130
	.db #0x82	; 130
	.db #0xEE	; 238
	.db #0x7C	; 124
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x40	; 64
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x0E	; 14
	.db #0x1E	; 30
	.db #0x32	; 50	'2'
	.db #0x62	; 98	'b'
	.db #0x62	; 98	'b'
	.db #0x32	; 50	'2'
	.db #0x1E	; 30
	.db #0x0E	; 14
	.db #0x3C	; 60
	.db #0x42	; 66	'B'
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x42	; 66	'B'
	.db #0x3C	; 60
	.db #0x00	; 0
	.db #0x3C	; 60
	.db #0x42	; 66	'B'
	.db #0xBD	; 189
	.db #0xBD	; 189
	.db #0xBD	; 189
	.db #0x42	; 66	'B'
	.db #0x3C	; 60
	.db #0x00	; 0
___str_0:
	.ascii "STM8S103   16MHz"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_1:
	.ascii "----------------"
	.db 0x00
___str_2:
	.ascii "STM8S"
	.db 0x00
___str_3:
	.ascii "Hallo Welt"
	.db 0x00
___str_4:
	.db 0x0D
	.ascii "   Coundown: %d "
	.db 0x00
___str_5:
	.ascii "Virtuelle LED's"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_6:
	.ascii "%d = 0x%x ="
	.db 0x00
	.area INITIALIZER
__xinit__aktxp:
	.db #0x00	; 0
__xinit__aktyp:
	.db #0x00	; 0
__xinit__bkcolor:
	.db #0x00	; 0
__xinit__textcolor:
	.db #0x01	; 1
	.area CABS (ABS)
