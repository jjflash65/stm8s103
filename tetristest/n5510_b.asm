;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Aug 12 2015) (Linux)
; This file was generated Tue May  9 22:19:50 2017
;--------------------------------------------------------
	.module n5510_b
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _spi_delay
	.globl _spi_out
	.globl _spi_init
	.globl _delay_us
	.globl _delay_ms
	.globl _abs
	.globl _memset
	.globl _outmode
	.globl _wherey
	.globl _wherex
	.globl _LcdFrameBuffer
	.globl _signal
	.globl _aktyp
	.globl _aktxp
	.globl _textsize
	.globl _Lcd_FrameIdx
	.globl _wrcmd
	.globl _wrdata
	.globl _lcd_init
	.globl _clrscr
	.globl _gotoxy
	.globl _lcd_putcharxy
	.globl _lcd_putchar
	.globl _outtextxy
	.globl _putpixel
	.globl _line
	.globl _rectangle
	.globl _ellipse
	.globl _circle
	.globl _showimage
	.globl _yline
	.globl _scr_update
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
_Lcd_FrameIdx::
	.ds 2
_textsize::
	.ds 1
_aktxp::
	.ds 1
_aktyp::
	.ds 1
_signal::
	.ds 84
_LcdFrameBuffer::
	.ds 504
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
_wherex::
	.ds 1
_wherey::
	.ds 1
_outmode::
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
;	n5510_b.c: 33: void spi_delay(void)
;	-----------------------------------------
;	 function spi_delay
;	-----------------------------------------
_spi_delay:
;	n5510_b.c: 41: __endasm;
;
	nop
	nop
	nop
	nop
	ret
;	n5510_b.c: 50: void wrcmd(uint8_t cmd)
;	-----------------------------------------
;	 function wrcmd
;	-----------------------------------------
_wrcmd:
;	n5510_b.c: 52: LCD_PORT &= ~(1 << LCD_DC_PIN);                    // C/D = 0 Kommandomodus
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xef
	ld	(x), a
;	n5510_b.c: 53: spi_out(cmd);                                      // senden
	ld	a, (0x03, sp)
	push	a
	call	_spi_out
	pop	a
;	n5510_b.c: 54: delay_us(10);
	push	#0x0a
	push	#0x00
	call	_delay_us
	popw	x
	ret
;	n5510_b.c: 62: void wrdata(uint8_t data)
;	-----------------------------------------
;	 function wrdata
;	-----------------------------------------
_wrdata:
;	n5510_b.c: 64: LCD_PORT |= (1 << LCD_DC_PIN);                     // C/D = 1 Kommandomodus
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x10
	ld	(x), a
;	n5510_b.c: 65: spi_delay();
	call	_spi_delay
;	n5510_b.c: 66: spi_out(data);                                     // senden
	ld	a, (0x03, sp)
	push	a
	call	_spi_out
	pop	a
;	n5510_b.c: 67: spi_delay();
	jp	_spi_delay
;	n5510_b.c: 82: void lcd_init(void)
;	-----------------------------------------
;	 function lcd_init
;	-----------------------------------------
_lcd_init:
;	n5510_b.c: 86: LCD_DDR |= ((1 << LCD_RST_PIN) | (1 << LCD_DC_PIN));
	ldw	x, #0x500c
	ld	a, (x)
	or	a, #0x18
	ld	(x), a
;	n5510_b.c: 87: LCD_CR1 |= ((1 << LCD_RST_PIN) | (1 << LCD_DC_PIN));
	ldw	x, #0x500d
	ld	a, (x)
	or	a, #0x18
	ld	(x), a
;	n5510_b.c: 88: spi_init(1,0,0);                                       // Taktteiler fuer SPI/4, keine Taktinvertierung, Phase 0
	push	#0x00
	push	#0x00
	push	#0x01
	call	_spi_init
	addw	sp, #3
;	n5510_b.c: 90: LCD_PORT &= ~(1 << LCD_RST_PIN);                       // Resets LCD controler
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xf7
	ld	(x), a
;	n5510_b.c: 91: delay_ms(10);
	push	#0x0a
	push	#0x00
	call	_delay_ms
	popw	x
;	n5510_b.c: 92: LCD_PORT |= (1 << LCD_RST_PIN);                        // Set LCD CE = 1 (Disabled)
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x08
	ld	(x), a
;	n5510_b.c: 110: wrcmd(0x21);                            // Erweiterter Kommandomodus
	push	#0x21
	call	_wrcmd
	pop	a
;	n5510_b.c: 111: delay_ms(1);
	push	#0x01
	push	#0x00
	call	_delay_ms
	popw	x
;	n5510_b.c: 112: wrcmd(0x09);                            // Set int. HV Generator (ca. 7V an Pin7)
	push	#0x09
	call	_wrcmd
	pop	a
;	n5510_b.c: 113: delay_ms(1);
	push	#0x01
	push	#0x00
	call	_delay_ms
	popw	x
;	n5510_b.c: 114: wrcmd(0xc8);                            // VOP max
	push	#0xc8
	call	_wrcmd
	pop	a
;	n5510_b.c: 115: delay_ms(1);
	push	#0x01
	push	#0x00
	call	_delay_ms
	popw	x
;	n5510_b.c: 116: wrcmd(0x10);                            // BIAS = 2
	push	#0x10
	call	_wrcmd
	pop	a
;	n5510_b.c: 117: delay_ms(1);
	push	#0x01
	push	#0x00
	call	_delay_ms
	popw	x
;	n5510_b.c: 118: wrcmd(0x04);                            // Temp. Koeffizient = 2
	push	#0x04
	call	_wrcmd
	pop	a
;	n5510_b.c: 119: delay_ms(1);
	push	#0x01
	push	#0x00
	call	_delay_ms
	popw	x
;	n5510_b.c: 120: wrcmd(0x20);                            // Standart Kommandomodus
	push	#0x20
	call	_wrcmd
	pop	a
;	n5510_b.c: 121: delay_ms(1);
	push	#0x01
	push	#0x00
	call	_delay_ms
	popw	x
;	n5510_b.c: 122: wrcmd(0x0c);                            // normale Ausgabe (normal = 0Ch, invertiert = 0Dh)
	push	#0x0c
	call	_wrcmd
	pop	a
;	n5510_b.c: 137: memset(LcdFrameBuffer,0x00,LCD_FB_SIZE);              // LCD Cache loeschen
	ldw	y, #_LcdFrameBuffer+0
	push	#0xf8
	push	#0x01
	clrw	x
	pushw	x
	pushw	y
	call	_memset
	addw	sp, #6
;	n5510_b.c: 141: wrcmd( 0x80);
	push	#0x80
	call	_wrcmd
	pop	a
;	n5510_b.c: 142: wrcmd( 0x40);
	push	#0x40
	call	_wrcmd
	pop	a
;	n5510_b.c: 143: for(n=0; n<(LCD_REAL_X_RES*LCD_REAL_Y_RES); n++) wrdata(0x00);
	clrw	x
00102$:
	pushw	x
	push	#0x00
	call	_wrdata
	pop	a
	popw	x
	incw	x
	cpw	x, #0x0fc0
	jrslt	00102$
;	n5510_b.c: 145: outmode= 0;
	clr	_outmode+0
;	n5510_b.c: 146: textsize= 0;
	clr	_textsize+0
;	n5510_b.c: 147: aktxp= 0; aktyp= 0;
	clr	_aktxp+0
	clr	_aktyp+0
	ret
;	n5510_b.c: 156: void clrscr(void)
;	-----------------------------------------
;	 function clrscr
;	-----------------------------------------
_clrscr:
;	n5510_b.c: 160: memset(LcdFrameBuffer,0x00,LCD_FB_SIZE);              // LCD Cache loeschen
	ldw	y, #_LcdFrameBuffer+0
	push	#0xf8
	push	#0x01
	clrw	x
	pushw	x
	pushw	y
	call	_memset
	addw	sp, #6
;	n5510_b.c: 161: wrcmd( 0x80);
	push	#0x80
	call	_wrcmd
	pop	a
;	n5510_b.c: 162: wrcmd( 0x40);
	push	#0x40
	call	_wrcmd
	pop	a
;	n5510_b.c: 163: for(n=0; n<(LCD_REAL_X_RES*LCD_REAL_Y_RES); n++) wrdata(0x00);
	clrw	x
00102$:
	pushw	x
	push	#0x00
	call	_wrdata
	pop	a
	popw	x
	incw	x
	cpw	x, #0x0fc0
	jrslt	00102$
;	n5510_b.c: 164: gotoxy(0,0);
	push	#0x00
	push	#0x00
	call	_gotoxy
	popw	x
	ret
;	n5510_b.c: 175: void gotoxy(unsigned char x, unsigned char y)
;	-----------------------------------------
;	 function gotoxy
;	-----------------------------------------
_gotoxy:
;	n5510_b.c: 178: aktxp= x*(fontsizex+(textsize*fontsizex));
	ld	a, _textsize+0
	ld	xl, a
	ld	a, #0x05
	mul	x, a
	addw	x, #5
	ld	a, (0x03, sp)
	mul	x, a
	ld	a, xl
	ld	_aktxp+0, a
;	n5510_b.c: 179: aktyp= y*(fontsizey+(textsize*fontsizey));
	ld	a, _textsize+0
	sll	a
	sll	a
	sll	a
	add	a, #0x08
	ld	xl, a
	ld	a, (0x04, sp)
	mul	x, a
	ld	a, xl
	ld	_aktyp+0, a
;	n5510_b.c: 181: wherex= x;
	ld	a, (0x03, sp)
	ld	_wherex+0, a
;	n5510_b.c: 182: wherey= y;
	ld	a, (0x04, sp)
	ld	_wherey+0, a
	ret
;	n5510_b.c: 193: void lcd_putcharxy(uint8_t oldx, uint8_t oldy, uint8_t drawmode, char ch)
;	-----------------------------------------
;	 function lcd_putcharxy
;	-----------------------------------------
_lcd_putcharxy:
	sub	sp, #11
;	n5510_b.c: 198: oldy--;
	dec	(0x0f, sp)
;	n5510_b.c: 200: for (i=0; i<fontsizex; i++)
	ldw	x, #_fonttab+0
	ldw	(0x07, sp), x
	clr	(0x03, sp)
00118$:
;	n5510_b.c: 202: b= fonttab[ch-32][i];
	ld	a, (0x11, sp)
	ld	xl, a
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	xh, a
	subw	x, #0x0020
	pushw	x
	push	#0x05
	push	#0x00
	call	__mulint
	addw	sp, #4
	addw	x, (0x07, sp)
	ld	a, xl
	add	a, (0x03, sp)
	rlwa	x
	adc	a, #0x00
	ld	xh, a
	ld	a, (x)
	ld	(0x01, sp), a
;	n5510_b.c: 203: for (i2= 0; i2<fontsizey; i2++)
	ld	a, (0x0e, sp)
	inc	a
	ld	(0x09, sp), a
	ld	a, (0x09, sp)
	ld	(0x06, sp), a
	ld	a, (0x09, sp)
	ld	(0x05, sp), a
	clr	(0x02, sp)
00116$:
;	n5510_b.c: 209: putpixel(oldx,oldy + (fontsizey-i2),1);
	ld	a, #0x08
	sub	a, (0x02, sp)
	ld	xl, a
	add	a, (0x0f, sp)
	ld	(0x0a, sp), a
;	n5510_b.c: 213: putpixel(oldx,oldy + ((fontsizey-i2)*2),1);
	sllw	x
	ld	a, xl
	add	a, (0x0f, sp)
	ld	(0x04, sp), a
;	n5510_b.c: 215: putpixel(oldx,oldy + ((fontsizey-i2)*2)-1,1);
	ld	a, (0x04, sp)
	dec	a
	ld	(0x0b, sp), a
;	n5510_b.c: 205: if (0x80 & b)
	tnz	(0x01, sp)
	jrpl	00110$
;	n5510_b.c: 207: if (!textsize)
	tnz	_textsize+0
	jrne	00102$
;	n5510_b.c: 209: putpixel(oldx,oldy + (fontsizey-i2),1);
	push	#0x01
	ld	a, (0x0b, sp)
	push	a
	ld	a, (0x10, sp)
	push	a
	call	_putpixel
	addw	sp, #3
	jp	00111$
00102$:
;	n5510_b.c: 213: putpixel(oldx,oldy + ((fontsizey-i2)*2),1);
	push	#0x01
	ld	a, (0x05, sp)
	push	a
	ld	a, (0x10, sp)
	push	a
	call	_putpixel
	addw	sp, #3
;	n5510_b.c: 214: putpixel(oldx+1,oldy + ((fontsizey-i2)*2),1);
	push	#0x01
	ld	a, (0x05, sp)
	push	a
	ld	a, (0x07, sp)
	push	a
	call	_putpixel
	addw	sp, #3
;	n5510_b.c: 215: putpixel(oldx,oldy + ((fontsizey-i2)*2)-1,1);
	push	#0x01
	ld	a, (0x0c, sp)
	push	a
	ld	a, (0x10, sp)
	push	a
	call	_putpixel
	addw	sp, #3
;	n5510_b.c: 216: putpixel(oldx+1,oldy + ((fontsizey-i2)*2)-1,1);
	push	#0x01
	ld	a, (0x0c, sp)
	push	a
	ld	a, (0x07, sp)
	push	a
	call	_putpixel
	addw	sp, #3
	jra	00111$
00110$:
;	n5510_b.c: 221: if (drawmode)
	tnz	(0x10, sp)
	jreq	00111$
;	n5510_b.c: 223: if (!textsize)
	tnz	_textsize+0
	jrne	00105$
;	n5510_b.c: 225: putpixel(oldx,oldy + (fontsizey-i2),0);
	push	#0x00
	ld	a, (0x0b, sp)
	push	a
	ld	a, (0x10, sp)
	push	a
	call	_putpixel
	addw	sp, #3
	jra	00111$
00105$:
;	n5510_b.c: 229: putpixel(oldx,oldy + ((fontsizey-i2)*2),0);
	push	#0x00
	ld	a, (0x05, sp)
	push	a
	ld	a, (0x10, sp)
	push	a
	call	_putpixel
	addw	sp, #3
;	n5510_b.c: 230: putpixel(oldx+1,oldy + ((fontsizey-i2)*2),0);
	push	#0x00
	ld	a, (0x05, sp)
	push	a
	ld	a, (0x08, sp)
	push	a
	call	_putpixel
	addw	sp, #3
;	n5510_b.c: 231: putpixel(oldx,oldy + ((fontsizey-i2)*2)-1,0);
	push	#0x00
	ld	a, (0x0c, sp)
	push	a
	ld	a, (0x10, sp)
	push	a
	call	_putpixel
	addw	sp, #3
;	n5510_b.c: 232: putpixel(oldx+1,oldy + ((fontsizey-i2)*2)-1,0);
	push	#0x00
	ld	a, (0x0c, sp)
	push	a
	ld	a, (0x08, sp)
	push	a
	call	_putpixel
	addw	sp, #3
00111$:
;	n5510_b.c: 236: b= b << 1;
	sll	(0x01, sp)
;	n5510_b.c: 203: for (i2= 0; i2<fontsizey; i2++)
	inc	(0x02, sp)
	ld	a, (0x02, sp)
	cp	a, #0x08
	jrnc	00160$
	jp	00116$
00160$:
;	n5510_b.c: 238: oldx++;
	ld	a, (0x09, sp)
	ld	(0x0e, sp), a
;	n5510_b.c: 239: if (textsize) { oldx++; }
	tnz	_textsize+0
	jreq	00119$
	inc	(0x0e, sp)
00119$:
;	n5510_b.c: 200: for (i=0; i<fontsizex; i++)
	inc	(0x03, sp)
	ld	a, (0x03, sp)
	cp	a, #0x05
	jrnc	00162$
	jp	00118$
00162$:
	addw	sp, #11
	ret
;	n5510_b.c: 252: void lcd_putchar(uint8_t ch)
;	-----------------------------------------
;	 function lcd_putchar
;	-----------------------------------------
_lcd_putchar:
;	n5510_b.c: 256: if (ch== 13)                                          // Fuer <printf> "/r" Implementation
	ld	a, (0x03, sp)
	cp	a, #0x0d
	jrne	00102$
;	n5510_b.c: 258: gotoxy(0,wherey);
	push	_wherey+0
	push	#0x00
	call	_gotoxy
	popw	x
;	n5510_b.c: 259: return;
	jra	00108$
00102$:
;	n5510_b.c: 261: if (ch== 10)                                          // fuer <printf> "/n" Implementation
	ld	a, (0x03, sp)
	cp	a, #0x0a
	jrne	00104$
;	n5510_b.c: 263: wherey++;
	inc	_wherey+0
;	n5510_b.c: 264: gotoxy(wherex,wherey);
	push	_wherey+0
	push	_wherex+0
	call	_gotoxy
	popw	x
;	n5510_b.c: 265: return;
	jra	00108$
00104$:
;	n5510_b.c: 267: if ((ch<0x20)||(ch>lastascii)) ch = 92;               // ASCII Zeichen umrechnen
	ld	a, (0x03, sp)
	cp	a, #0x20
	jrc	00105$
	ld	a, (0x03, sp)
	cp	a, #0x7e
	jrule	00106$
00105$:
	ld	a, #0x5c
	ld	(0x03, sp), a
00106$:
;	n5510_b.c: 269: oldx= aktxp;
	ld	a, _aktxp+0
	ld	xh, a
;	n5510_b.c: 271: lcd_putcharxy(oldx, aktyp, 1, ch);
	ld	a, (0x03, sp)
	push	a
	push	#0x01
	push	_aktyp+0
	ld	a, xh
	push	a
	call	_lcd_putcharxy
	addw	sp, #4
;	n5510_b.c: 273: aktxp += (fontsizex+1)*(textsize+1);
	ld	a, _textsize+0
	ld	xl, a
	incw	x
	ld	a, #0x06
	mul	x, a
	ld	a, xl
	add	a, _aktxp+0
	ld	_aktxp+0, a
;	n5510_b.c: 274: wherex++;
	inc	_wherex+0
00108$:
	ret
;	n5510_b.c: 283: void outtextxy(uint8_t x, uint8_t y, char *c)
;	-----------------------------------------
;	 function outtextxy
;	-----------------------------------------
_outtextxy:
	push	a
;	n5510_b.c: 287: oldx= x;
	ld	a, (0x04, sp)
	ld	(0x01, sp), a
;	n5510_b.c: 288: while (*c)
	ldw	x, (0x06, sp)
00101$:
	ld	a, (x)
	tnz	a
	jreq	00104$
;	n5510_b.c: 290: lcd_putcharxy(oldx, y, 0, *c++);
	incw	x
	pushw	x
	push	a
	push	#0x00
	ld	a, (0x09, sp)
	push	a
	ld	a, (0x06, sp)
	push	a
	call	_lcd_putcharxy
	addw	sp, #4
	popw	x
;	n5510_b.c: 291: oldx += (fontsizex+1)*(textsize+1);
	ld	a, _textsize+0
	inc	a
	pushw	x
	exg	a, xl
	ld	a, #0x06
	exg	a, xl
	mul	x, a
	ld	a, xl
	popw	x
	add	a, (0x01, sp)
	ld	(0x01, sp), a
	jra	00101$
00104$:
	pop	a
	ret
;	n5510_b.c: 307: void putpixel(unsigned char x, unsigned char y, PixelMode mode )
;	-----------------------------------------
;	 function putpixel
;	-----------------------------------------
_putpixel:
	sub	sp, #9
;	n5510_b.c: 316: case 0  :  x2= x; y2= y; break;
	ld	a, (0x0c, sp)
	ld	xl, a
	ld	a, (0x0d, sp)
;	n5510_b.c: 314: switch (outmode)
	push	a
	ld	a, _outmode+0
	cp	a, #0x00
	pop	a
	jreq	00101$
	push	a
	ld	a, _outmode+0
	cp	a, #0x01
	pop	a
	jreq	00102$
	ld	a, _outmode+0
	cp	a, #0x02
	jreq	00103$
	ld	a, _outmode+0
	cp	a, #0x03
	jreq	00104$
	jra	00106$
;	n5510_b.c: 316: case 0  :  x2= x; y2= y; break;
00101$:
	rlwa	x
	ld	a, xh
	rrwa	x
	jra	00106$
;	n5510_b.c: 317: case 1  :  x2=y; y2= _yres-1-x; break;
00102$:
	ld	xh, a
	ld	a, #0x2f
	sub	a, (0x0c, sp)
	jra	00106$
;	n5510_b.c: 318: case 2  :  x2= _xres-1-y; y2= x; break;
00103$:
	ld	a, #0x53
	sub	a, (0x0d, sp)
	rrwa	x
	jra	00106$
;	n5510_b.c: 319: case 3  :  x2= _xres-1-x; y2= _yres-1-y; break;
00104$:
	ld	a, #0x53
	sub	a, (0x0c, sp)
	ld	xh, a
	ld	a, #0x2f
	sub	a, (0x0d, sp)
;	n5510_b.c: 323: }
00106$:
;	n5510_b.c: 326: index=((y2/8)*LCD_VISIBLE_X_RES)+x2;
	ld	xl, a
	srl	a
	srl	a
	srl	a
	exg	a, xl
	pushw	x
	push	a
	ld	a, #0x54
	mul	x, a
	ldw	(0x0b, sp), x
	pop	a
	popw	x
	clrw	y
	exg	a, yl
	ld	a, xh
	exg	a, yl
	addw	y, (0x08, sp)
	ldw	(0x02, sp), y
;	n5510_b.c: 327: offset=y2-((y2/8)*8);
	sllw	x
	sllw	x
	sllw	x
	pushw	x
	sub	a, (#2, sp)
	popw	x
	ld	(0x04, sp), a
;	n5510_b.c: 331: data=LcdFrameBuffer[index];
	ldw	x, #_LcdFrameBuffer+0
	addw	x, (0x02, sp)
	ld	a, (x)
;	n5510_b.c: 332: if (mode==PIXEL_ON) data |= (0x01<<offset);                          // Pixel setzen
	push	a
	ld	a, #0x01
	ld	(0x08, sp), a
	ld	a, (0x05, sp)
	jreq	00158$
00157$:
	sll	(0x08, sp)
	dec	a
	jrne	00157$
00158$:
	ld	a, (0x0f, sp)
	cp	a, #0x01
	pop	a
	jrne	00113$
	or	a, (0x07, sp)
	jra	00114$
00113$:
;	n5510_b.c: 333: else if (mode==PIXEL_OFF) data &= (~(0x01<<offset));                 // Pixel loeschen
	tnz	(0x0e, sp)
	jrne	00110$
	push	a
	ld	a, (0x08, sp)
	cpl	a
	ld	(0x07, sp), a
	pop	a
	and	a, (0x06, sp)
	jra	00114$
00110$:
;	n5510_b.c: 334: else if (mode==PIXEL_XOR) data ^= (0x01<<offset);                    // Pixel im XOR-Mode setzen
	push	a
	ld	a, (0x0f, sp)
	cp	a, #0x02
	pop	a
	jrne	00114$
	xor	a, (0x07, sp)
00114$:
;	n5510_b.c: 335: LcdFrameBuffer[index]=data;
	ld	(x), a
	addw	sp, #9
	ret
;	n5510_b.c: 353: void line(int x0, int y0, int x1, int y1, PixelMode mode)
;	-----------------------------------------
;	 function line
;	-----------------------------------------
_line:
	sub	sp, #10
;	n5510_b.c: 359: int dx =  abs(x1-x0), sx = x0<x1 ? 1 : -1;
	ldw	x, (0x11, sp)
	subw	x, (0x0d, sp)
	pushw	x
	call	_abs
	addw	sp, #2
	ldw	(0x07, sp), x
	ldw	x, (0x0d, sp)
	cpw	x, (0x11, sp)
	jrsge	00113$
	ld	a, #0x01
	jra	00114$
00113$:
	ld	a, #0xff
00114$:
	ld	xl, a
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	xh, a
	ldw	(0x05, sp), x
;	n5510_b.c: 360: int dy = -abs(y1-y0), sy = y0<y1 ? 1 : -1;
	ldw	x, (0x13, sp)
	subw	x, (0x0f, sp)
	pushw	x
	call	_abs
	addw	sp, #2
	negw	x
	ldw	(0x09, sp), x
	ldw	x, (0x0f, sp)
	cpw	x, (0x13, sp)
	jrsge	00115$
	ld	a, #0x01
	jra	00116$
00115$:
	ld	a, #0xff
00116$:
	ld	xl, a
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	xh, a
	ldw	(0x03, sp), x
;	n5510_b.c: 361: int err = dx+dy, e2;
	ldw	y, (0x07, sp)
	addw	y, (0x09, sp)
	ldw	(0x01, sp), y
00109$:
;	n5510_b.c: 365: putpixel(x0,y0,mode);
	ld	a, (0x10, sp)
	ld	xl, a
	ld	a, (0x0e, sp)
	ld	xh, a
	ld	a, (0x15, sp)
	push	a
	ld	a, xl
	push	a
	ld	a, xh
	push	a
	call	_putpixel
	addw	sp, #3
;	n5510_b.c: 366: if (x0==x1 && y0==y1) break;
	ldw	x, (0x0d, sp)
	cpw	x, (0x11, sp)
	jrne	00102$
	ldw	x, (0x0f, sp)
	cpw	x, (0x13, sp)
	jreq	00111$
00102$:
;	n5510_b.c: 367: e2 = 2*err;
	ldw	x, (0x01, sp)
	sllw	x
;	n5510_b.c: 368: if (e2 > dy) { err += dy; x0 += sx; }
	cpw	x, (0x09, sp)
	jrsle	00105$
	ldw	y, (0x01, sp)
	addw	y, (0x09, sp)
	ldw	(0x01, sp), y
	ldw	y, (0x0d, sp)
	addw	y, (0x05, sp)
	ldw	(0x0d, sp), y
00105$:
;	n5510_b.c: 369: if (e2 < dx) { err += dx; y0 += sy; }
	cpw	x, (0x07, sp)
	jrsge	00109$
	ldw	y, (0x01, sp)
	addw	y, (0x07, sp)
	ldw	(0x01, sp), y
	ldw	y, (0x0f, sp)
	addw	y, (0x03, sp)
	ldw	(0x0f, sp), y
	jra	00109$
00111$:
	addw	sp, #10
	ret
;	n5510_b.c: 387: void rectangle(uint8_t x1, uint8_t y1, uint8_t x2, uint8_t y2, PixelMode mode)
;	-----------------------------------------
;	 function rectangle
;	-----------------------------------------
_rectangle:
	sub	sp, #6
;	n5510_b.c: 389: line(x1,y1,x2,y1, mode);
	ld	a, (0x0a, sp)
	ld	(0x06, sp), a
	clr	(0x05, sp)
	ld	a, (0x0b, sp)
	ld	(0x04, sp), a
	clr	(0x03, sp)
	ld	a, (0x09, sp)
	ld	(0x02, sp), a
	clr	(0x01, sp)
	ld	a, (0x0d, sp)
	push	a
	ldw	x, (0x06, sp)
	pushw	x
	ldw	x, (0x06, sp)
	pushw	x
	ldw	x, (0x0a, sp)
	pushw	x
	ldw	x, (0x08, sp)
	pushw	x
	call	_line
	addw	sp, #9
;	n5510_b.c: 390: line(x2,y1,x2,y2, mode);
	clrw	x
	ld	a, (0x0c, sp)
	ld	xl, a
	pushw	x
	ld	a, (0x0f, sp)
	push	a
	pushw	x
	ldw	y, (0x08, sp)
	pushw	y
	ldw	y, (0x0c, sp)
	pushw	y
	ldw	y, (0x0c, sp)
	pushw	y
	call	_line
	addw	sp, #9
	popw	x
;	n5510_b.c: 391: line(x1,y2,x2,y2, mode);
	pushw	x
	ld	a, (0x0f, sp)
	push	a
	pushw	x
	ldw	y, (0x08, sp)
	pushw	y
	pushw	x
	ldw	y, (0x0a, sp)
	pushw	y
	call	_line
	addw	sp, #9
	popw	x
;	n5510_b.c: 392: line(x1,y1,x1,y2, mode);
	ld	a, (0x0d, sp)
	push	a
	pushw	x
	ldw	x, (0x04, sp)
	pushw	x
	ldw	x, (0x0a, sp)
	pushw	x
	ldw	x, (0x08, sp)
	pushw	x
	call	_line
	addw	sp, #15
	ret
;	n5510_b.c: 410: void ellipse(int xm, int ym, int a, int b, PixelMode mode )
;	-----------------------------------------
;	 function ellipse
;	-----------------------------------------
_ellipse:
	sub	sp, #69
;	n5510_b.c: 414: int dx = 0, dy = b;                       // im I. Quadranten von links oben nach rechts unten
	ldw	y, (0x4e, sp)
	ldw	(0x01, sp), y
;	n5510_b.c: 415: long a2 = a*a, b2 = b*b;
	ldw	x, (0x4c, sp)
	pushw	x
	ldw	x, (0x4e, sp)
	pushw	x
	call	__mulint
	addw	sp, #4
	clrw	y
	tnzw	x
	jrpl	00138$
	decw	y
00138$:
	ldw	(0x09, sp), x
	ldw	(0x07, sp), y
	ldw	x, (0x01, sp)
	pushw	x
	ldw	x, (0x03, sp)
	pushw	x
	call	__mulint
	addw	sp, #4
	clrw	y
	tnzw	x
	jrpl	00139$
	decw	y
00139$:
	ldw	(0x13, sp), x
	ldw	(0x11, sp), y
;	n5510_b.c: 416: long err = b2-(2*b-1)*a2, e2;             // Fehler im 1. Schritt */
	ldw	x, (0x01, sp)
	sllw	x
	decw	x
	ldw	(0x1d, sp), x
	ldw	y, (0x1d, sp)
	ldw	(0x1b, sp), y
	clrw	y
	tnz	(0x1b, sp)
	jrpl	00140$
	decw	y
00140$:
	ldw	x, (0x09, sp)
	pushw	x
	ldw	x, (0x09, sp)
	pushw	x
	ldw	x, (0x1f, sp)
	pushw	x
	pushw	y
	call	__mullong
	addw	sp, #8
	ldw	(0x17, sp), x
	ldw	(0x15, sp), y
	ldw	x, (0x13, sp)
	subw	x, (0x17, sp)
	ldw	(0x05, sp), x
	ld	a, (0x12, sp)
	sbc	a, (0x16, sp)
	ld	(0x04, sp), a
	ld	a, (0x11, sp)
	sbc	a, (0x15, sp)
	ld	(0x03, sp), a
	ldw	y, (0x04, sp)
	ldw	(0x04, sp), y
;	n5510_b.c: 418: do
	ld	a, (0x1e, sp)
	neg	a
	ld	(0x37, sp), a
	clr	a
	sbc	a, (0x1d, sp)
	ld	(0x36, sp), a
	clrw	x
	ldw	(0x0f, sp), x
	ldw	y, (0x01, sp)
	ldw	(0x34, sp), y
00105$:
;	n5510_b.c: 420: putpixel(xm+dx, ym+dy,mode);            // I.   Quadrant
	ld	a, (0x4b, sp)
	ld	xl, a
	ld	a, (0x35, sp)
	ld	(0x33, sp), a
	ld	a, xl
	add	a, (0x33, sp)
	ld	(0x32, sp), a
	ld	a, (0x49, sp)
	ld	(0x31, sp), a
	ld	a, (0x10, sp)
	ld	(0x30, sp), a
	ld	a, (0x31, sp)
	add	a, (0x30, sp)
	ld	xh, a
	pushw	x
	ld	a, (0x52, sp)
	push	a
	ld	a, (0x35, sp)
	push	a
	ld	a, xh
	push	a
	call	_putpixel
	addw	sp, #3
	popw	x
;	n5510_b.c: 421: putpixel(xm-dx, ym+dy,mode);            // II.  Quadrant
	ld	a, (0x31, sp)
	sub	a, (0x30, sp)
	ld	(0x2f, sp), a
	pushw	x
	ld	a, (0x52, sp)
	push	a
	ld	a, (0x35, sp)
	push	a
	ld	a, (0x33, sp)
	push	a
	call	_putpixel
	addw	sp, #3
	popw	x
;	n5510_b.c: 422: putpixel(xm-dx, ym-dy,mode);            // III. Quadrant
	ld	a, xl
	sub	a, (0x33, sp)
	ld	xl, a
	pushw	x
	ld	a, (0x52, sp)
	push	a
	ld	a, xl
	push	a
	ld	a, (0x33, sp)
	push	a
	call	_putpixel
	addw	sp, #3
	popw	x
;	n5510_b.c: 423: putpixel(xm+dx, ym-dy,mode);            // IV.  Quadrant
	ld	a, (0x50, sp)
	push	a
	ld	a, xl
	push	a
	ld	a, xh
	push	a
	call	_putpixel
	addw	sp, #3
;	n5510_b.c: 425: e2 = 2*err;
	ldw	y, (0x05, sp)
	ldw	x, (0x03, sp)
	sllw	y
	rlcw	x
	ldw	(0x0d, sp), y
	ldw	(0x0b, sp), x
;	n5510_b.c: 426: if (e2 <  (2*dx+1)*b2) { dx++; err += (2*dx+1)*b2; }
	ldw	x, (0x0f, sp)
	sllw	x
	incw	x
	ldw	(0x2d, sp), x
	clrw	y
	tnz	(0x2d, sp)
	jrpl	00141$
	decw	y
00141$:
	ldw	x, (0x13, sp)
	pushw	x
	ldw	x, (0x13, sp)
	pushw	x
	ldw	x, (0x31, sp)
	pushw	x
	pushw	y
	call	__mullong
	addw	sp, #8
	ldw	(0x29, sp), x
	ldw	(0x27, sp), y
	ldw	x, (0x0d, sp)
	cpw	x, (0x29, sp)
	ld	a, (0x0c, sp)
	sbc	a, (0x28, sp)
	ld	a, (0x0b, sp)
	sbc	a, (0x27, sp)
	jrsge	00102$
	ldw	x, (0x0f, sp)
	incw	x
	ldw	(0x0f, sp), x
	ldw	x, (0x0f, sp)
	sllw	x
	incw	x
	ldw	(0x25, sp), x
	clrw	y
	tnz	(0x25, sp)
	jrpl	00143$
	decw	y
00143$:
	ldw	x, (0x13, sp)
	pushw	x
	ldw	x, (0x13, sp)
	pushw	x
	ldw	x, (0x29, sp)
	pushw	x
	pushw	y
	call	__mullong
	addw	sp, #8
	exgw	x, y
	addw	y, (0x05, sp)
	ld	a, xl
	adc	a, (0x04, sp)
	rlwa	x
	adc	a, (0x03, sp)
	ld	xh, a
	ldw	(0x05, sp), y
	ldw	(0x03, sp), x
00102$:
;	n5510_b.c: 427: if (e2 > -(2*dy-1)*a2) { dy--; err -= (2*dy-1)*a2; }
	ldw	y, (0x36, sp)
	ldw	(0x21, sp), y
	clrw	y
	tnz	(0x21, sp)
	jrpl	00144$
	decw	y
00144$:
	ldw	x, (0x09, sp)
	pushw	x
	ldw	x, (0x09, sp)
	pushw	x
	ldw	x, (0x25, sp)
	pushw	x
	pushw	y
	call	__mullong
	addw	sp, #8
	ld	a, yl
	push	a
	cpw	x, (0x0e, sp)
	pop	a
	sbc	a, (0x0c, sp)
	ld	a, yh
	sbc	a, (0x0b, sp)
	jrsge	00106$
	ldw	x, (0x34, sp)
	decw	x
	ldw	(0x34, sp), x
	ldw	x, (0x34, sp)
	sllw	x
	decw	x
	ldw	(0x44, sp), x
	clrw	y
	tnz	(0x44, sp)
	jrpl	00146$
	decw	y
00146$:
	ldw	x, (0x09, sp)
	pushw	x
	ldw	x, (0x09, sp)
	pushw	x
	ldw	x, (0x48, sp)
	pushw	x
	pushw	y
	call	__mullong
	addw	sp, #8
	ldw	(0x40, sp), x
	ldw	(0x3e, sp), y
	ldw	x, (0x05, sp)
	subw	x, (0x40, sp)
	ldw	(0x3c, sp), x
	ld	a, (0x04, sp)
	sbc	a, (0x3f, sp)
	ld	(0x3b, sp), a
	ld	a, (0x03, sp)
	sbc	a, (0x3e, sp)
	ld	(0x03, sp), a
	ldw	y, (0x3c, sp)
	ldw	(0x05, sp), y
	ld	a, (0x3b, sp)
	ld	(0x04, sp), a
00106$:
;	n5510_b.c: 428: } while (dy >= 0);
	tnz	(0x34, sp)
	jrmi	00147$
	jp	00105$
00147$:
;	n5510_b.c: 430: while (dx++ < a)                         // fehlerhafter Abbruch bei flachen Ellipsen (b=1)
00108$:
	ldw	y, (0x0f, sp)
	ldw	x, (0x0f, sp)
	incw	x
	ldw	(0x0f, sp), x
	ldw	x, y
	cpw	x, (0x4c, sp)
	jrsge	00111$
;	n5510_b.c: 432: putpixel(xm+dx, ym,mode);              // -> Spitze der Ellipse vollenden
	ld	a, (0x4b, sp)
	ld	(0x39, sp), a
	ld	a, (0x10, sp)
	ld	(0x38, sp), a
	ld	a, (0x31, sp)
	add	a, (0x38, sp)
	ld	xh, a
	ld	a, (0x50, sp)
	push	a
	ld	a, (0x3a, sp)
	push	a
	ld	a, xh
	push	a
	call	_putpixel
	addw	sp, #3
;	n5510_b.c: 433: putpixel(xm-dx, ym,mode);
	ld	a, (0x31, sp)
	sub	a, (0x38, sp)
	ld	xh, a
	ld	a, (0x50, sp)
	push	a
	ld	a, (0x3a, sp)
	push	a
	ld	a, xh
	push	a
	call	_putpixel
	addw	sp, #3
	jra	00108$
00111$:
	addw	sp, #69
	ret
;	n5510_b.c: 449: void circle(int x, int y, int r, PixelMode mode )
;	-----------------------------------------
;	 function circle
;	-----------------------------------------
_circle:
;	n5510_b.c: 451: ellipse(x,y,r,r,mode);
	ld	a, (0x09, sp)
	push	a
	ldw	x, (0x08, sp)
	pushw	x
	ldw	x, (0x0a, sp)
	pushw	x
	ldw	x, (0x0a, sp)
	pushw	x
	ldw	x, (0x0a, sp)
	pushw	x
	call	_ellipse
	addw	sp, #9
	ret
;	n5510_b.c: 476: void showimage(char ox, char oy, const unsigned char* const image, PixelMode mode)
;	-----------------------------------------
;	 function showimage
;	-----------------------------------------
_showimage:
	sub	sp, #20
;	n5510_b.c: 483: resX= image[0];
	ldw	y, (0x19, sp)
	ldw	(0x11, sp), y
	ldw	x, (0x11, sp)
	ld	a, (x)
	ld	xh, a
;	n5510_b.c: 484: resY= image[1];
	ldw	y, (0x11, sp)
	ld	a, (0x1, y)
	ld	(0x05, sp), a
;	n5510_b.c: 485: if ((resX % 8) == 0) { resX= resX / 8; }
	ld	a, xh
	and	a, #0x07
	ld	(0x09, sp), a
	ld	a, xh
	srl	a
	srl	a
	srl	a
	tnz	(0x09, sp)
	jrne	00102$
	ld	(0x06, sp), a
	jra	00128$
00102$:
;	n5510_b.c: 486: else  { resX= (resX / 8)+1; }
	inc	a
	ld	(0x06, sp), a
;	n5510_b.c: 488: for (y=0;y< resY;y++)
00128$:
	clrw	x
	ldw	(0x01, sp), x
00115$:
	ld	a, (0x05, sp)
	ld	(0x14, sp), a
	clr	(0x13, sp)
	ldw	x, (0x01, sp)
	cpw	x, (0x13, sp)
	jrslt	00157$
	jp	00117$
00157$:
;	n5510_b.c: 490: for (x= 0;x<resX;x++)
	clrw	x
	ldw	(0x03, sp), x
00112$:
	ld	a, (0x06, sp)
	ld	(0x0d, sp), a
	clr	(0x0c, sp)
	ldw	x, (0x03, sp)
	cpw	x, (0x0c, sp)
	jrsge	00116$
;	n5510_b.c: 492: b= image[y *resX +x+2];
	ldw	x, (0x0c, sp)
	pushw	x
	ldw	x, (0x03, sp)
	pushw	x
	call	__mulint
	addw	sp, #4
	addw	x, (0x03, sp)
	incw	x
	incw	x
	addw	x, (0x11, sp)
	ld	a, (x)
	ld	(0x08, sp), a
;	n5510_b.c: 493: for (bp=8;bp>0;bp--)
	ld	a, #0x08
	ld	(0x07, sp), a
00109$:
;	n5510_b.c: 495: if (b& 1<<bp-1) {putpixel(ox+(x*8)+8-bp,oy+y,mode);}
	clrw	x
	ld	a, (0x07, sp)
	ld	xl, a
	decw	x
	ld	a, xl
	ldw	x, #0x0001
	tnz	a
	jreq	00160$
00159$:
	sllw	x
	dec	a
	jrne	00159$
00160$:
	ld	a, (0x08, sp)
	ld	(0x0b, sp), a
	clr	(0x0a, sp)
	ld	a, xl
	and	a, (0x0b, sp)
	ld	(0x10, sp), a
	ld	a, xh
	and	a, (0x0a, sp)
	ld	(0x0f, sp), a
	ldw	x, (0x0f, sp)
	jreq	00110$
	ld	a, (0x02, sp)
	add	a, (0x18, sp)
	ld	xl, a
	ld	a, (0x04, sp)
	sll	a
	sll	a
	sll	a
	add	a, (0x17, sp)
	add	a, #0x08
	ld	xh, a
	ld	a, (0x07, sp)
	ld	(0x0e, sp), a
	ld	a, xh
	sub	a, (0x0e, sp)
	ld	xh, a
	ld	a, (0x1b, sp)
	push	a
	ld	a, xl
	push	a
	ld	a, xh
	push	a
	call	_putpixel
	addw	sp, #3
00110$:
;	n5510_b.c: 493: for (bp=8;bp>0;bp--)
	dec	(0x07, sp)
	tnz	(0x07, sp)
	jrne	00109$
;	n5510_b.c: 490: for (x= 0;x<resX;x++)
	ldw	x, (0x03, sp)
	incw	x
	ldw	(0x03, sp), x
	jra	00112$
00116$:
;	n5510_b.c: 488: for (y=0;y< resY;y++)
	ldw	x, (0x01, sp)
	incw	x
	ldw	(0x01, sp), x
	jp	00115$
00117$:
	addw	sp, #20
	ret
;	n5510_b.c: 502: void yline(char x, char y1, char y2)
;	-----------------------------------------
;	 function yline
;	-----------------------------------------
_yline:
	sub	sp, #13
;	n5510_b.c: 506: if (y2< y1)
	ld	a, (0x12, sp)
	cp	a, (0x11, sp)
	jrsge	00102$
;	n5510_b.c: 508: y= y2; y2= y1; y1= y;
	ld	a, (0x12, sp)
	push	a
	ld	a, (0x12, sp)
	ld	(0x13, sp), a
	pop	a
	ld	(0x11, sp), a
00102$:
;	n5510_b.c: 510: yd1= y1>>3; yd2= y2>>3;
	ld	a, (0x11, sp)
	sra	a
	sra	a
	sra	a
	ld	(0x04, sp), a
	ld	a, (0x12, sp)
	sra	a
	sra	a
	sra	a
	ld	(0x01, sp), a
;	n5510_b.c: 511: b= y1 % 8;
	push	#0x08
	ld	a, (0x12, sp)
	push	a
	call	__moduschar
	addw	sp, #2
;	n5510_b.c: 512: b2= 1<< b;
	ld	a, #0x01
	push	a
	ld	a, xl
	tnz	a
	jreq	00169$
00168$:
	sll	(1, sp)
	dec	a
	jrne	00168$
00169$:
	pop	a
	ld	(0x0b, sp), a
;	n5510_b.c: 513: for (i=b; i<7; i++)
00111$:
	ld	a, xl
	cp	a, #0x07
	jrnc	00103$
;	n5510_b.c: 515: b2+= 1<<(i+1);
	incw	x
	ld	a, #0x01
	push	a
	ld	a, xl
	tnz	a
	jreq	00172$
00171$:
	sll	(1, sp)
	dec	a
	jrne	00171$
00172$:
	pop	a
	add	a, (0x0b, sp)
	ld	(0x0b, sp), a
;	n5510_b.c: 513: for (i=b; i<7; i++)
	jra	00111$
00103$:
;	n5510_b.c: 517: wrcmd(0x80+x);
	ld	a, (0x10, sp)
	add	a, #0x80
	ld	(0x0c, sp), a
	ld	a, (0x0c, sp)
	push	a
	call	_wrcmd
	pop	a
;	n5510_b.c: 518: wrcmd(0x40+yd1);
	ld	a, (0x04, sp)
	add	a, #0x40
	ld	(0x0d, sp), a
	ld	a, (0x0d, sp)
	push	a
	call	_wrcmd
	pop	a
;	n5510_b.c: 519: wrdata(b2);
	ld	a, (0x0b, sp)
	push	a
	call	_wrdata
	pop	a
;	n5510_b.c: 522: b= y2%8;
	push	#0x08
	ld	a, (0x13, sp)
	push	a
;	n5510_b.c: 520: if (yd1 == yd2)
	call	__moduschar
	addw	sp, #2
	ld	a, (0x04, sp)
	cp	a, (0x01, sp)
	jrne	00108$
;	n5510_b.c: 522: b= y2%8;
	exg	a, yl
	ld	a, xl
	exg	a, yl
;	n5510_b.c: 523: b3=0;
	clr	a
;	n5510_b.c: 524: for (i=8; i> b+1;i--)
	push	a
	ld	a, #0x08
	ld	(0x04, sp), a
	pop	a
00114$:
	clrw	x
	exg	a, xl
	ld	a, yl
	exg	a, xl
	incw	x
	ldw	(0x07, sp), x
	clrw	x
	exg	a, xl
	ld	a, (0x03, sp)
	exg	a, xl
	cpw	x, (0x07, sp)
	jrsle	00104$
;	n5510_b.c: 526: b3= 0x80+(b3>>1);
	srl	a
	add	a, #0x80
;	n5510_b.c: 524: for (i=8; i> b+1;i--)
	dec	(0x03, sp)
	jra	00114$
00104$:
;	n5510_b.c: 528: b3=~b3;
	cpl	a
;	n5510_b.c: 529: b2 &= b3;
	and	a, (0x0b, sp)
	ld	(0x02, sp), a
;	n5510_b.c: 530: wrcmd(0x80+x);
	ld	a, (0x0c, sp)
	push	a
	call	_wrcmd
	pop	a
;	n5510_b.c: 531: wrcmd(0x40+yd1);
	ld	a, (0x0d, sp)
	push	a
	call	_wrcmd
	pop	a
;	n5510_b.c: 532: wrdata(b2);
	ld	a, (0x02, sp)
	push	a
	call	_wrdata
	pop	a
	jra	00109$
00108$:
;	n5510_b.c: 536: for (y= (yd1+1); y< yd2; y++)
	ld	a, (0x04, sp)
	inc	a
	ld	xh, a
00117$:
	ld	a, xh
	cp	a, (0x01, sp)
	jrnc	00105$
;	n5510_b.c: 538: wrcmd(0x80+x);
	pushw	x
	ld	a, (0x0e, sp)
	push	a
	call	_wrcmd
	pop	a
	popw	x
;	n5510_b.c: 539: wrcmd(0x40+y);
	ld	a, xh
	add	a, #0x40
	pushw	x
	push	a
	call	_wrcmd
	pop	a
	push	#0xff
	call	_wrdata
	pop	a
	popw	x
;	n5510_b.c: 536: for (y= (yd1+1); y< yd2; y++)
	addw	x, #256
	jra	00117$
00105$:
;	n5510_b.c: 542: b= y2%8;
	exg	a, xl
	ld	(0x09, sp), a
	exg	a, xl
;	n5510_b.c: 543: b2=0;
	clr	(0x0a, sp)
;	n5510_b.c: 544: for (i= 0; i< b+1;i++)
	clr	(0x03, sp)
00120$:
	clrw	x
	ld	a, (0x09, sp)
	ld	xl, a
	incw	x
	ldw	(0x05, sp), x
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	cpw	x, (0x05, sp)
	jrsge	00106$
;	n5510_b.c: 546: b2 = b2+(1<<i);
	ld	a, #0x01
	push	a
	ld	a, (0x04, sp)
	jreq	00180$
00179$:
	sll	(1, sp)
	dec	a
	jrne	00179$
00180$:
	pop	a
	add	a, (0x0a, sp)
	ld	(0x0a, sp), a
;	n5510_b.c: 544: for (i= 0; i< b+1;i++)
	inc	(0x03, sp)
	jra	00120$
00106$:
;	n5510_b.c: 548: wrcmd(0x80+x);
	ld	a, (0x0c, sp)
	push	a
	call	_wrcmd
	pop	a
;	n5510_b.c: 549: wrcmd(0x40+yd2);
	ld	a, (0x01, sp)
	add	a, #0x40
	push	a
	call	_wrcmd
	pop	a
;	n5510_b.c: 550: wrdata(b2);
	ld	a, (0x0a, sp)
	push	a
	call	_wrdata
	pop	a
00109$:
;	n5510_b.c: 552: wrcmd(0);
	push	#0x00
	call	_wrcmd
	addw	sp, #14
	ret
;	n5510_b.c: 563: void scr_update(void)
;	-----------------------------------------
;	 function scr_update
;	-----------------------------------------
_scr_update:
	sub	sp, #8
;	n5510_b.c: 566: unsigned int i=0;
	clrw	x
	ldw	(0x02, sp), x
;	n5510_b.c: 570: for (row=0; row<(LCD_VISIBLE_Y_RES / 8); row++)
	ldw	x, #_LcdFrameBuffer+0
	ldw	(0x05, sp), x
	clr	(0x01, sp)
00105$:
;	n5510_b.c: 572: wrcmd( 0x80);
	push	#0x80
	call	_wrcmd
	pop	a
;	n5510_b.c: 573: wrcmd( 0x40 | row);
	ld	a, (0x01, sp)
	or	a, #0x40
	push	a
	call	_wrcmd
	pop	a
;	n5510_b.c: 574: for (col=0; col<LCD_VISIBLE_X_RES; col++) wrdata(LcdFrameBuffer[i++]);
	ldw	x, (0x02, sp)
	clr	(0x04, sp)
00103$:
	ldw	(0x07, sp), x
	incw	x
	ldw	y, (0x05, sp)
	addw	y, (0x07, sp)
	ld	a, (y)
	pushw	x
	push	a
	call	_wrdata
	pop	a
	popw	x
	inc	(0x04, sp)
	ld	a, (0x04, sp)
	cp	a, #0x54
	jrc	00103$
;	n5510_b.c: 570: for (row=0; row<(LCD_VISIBLE_Y_RES / 8); row++)
	ldw	(0x02, sp), x
	inc	(0x01, sp)
	ld	a, (0x01, sp)
	cp	a, #0x06
	jrc	00105$
	addw	sp, #8
	ret
	.area CODE
_fonttab:
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x2F	; 47
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x07	; 7
	.db #0x00	; 0
	.db #0x07	; 7
	.db #0x00	; 0
	.db #0x14	; 20
	.db #0x7F	; 127
	.db #0x14	; 20
	.db #0x7F	; 127
	.db #0x14	; 20
	.db #0x24	; 36
	.db #0x2A	; 42
	.db #0x7F	; 127
	.db #0x2A	; 42
	.db #0x12	; 18
	.db #0xC4	; 196
	.db #0xC8	; 200
	.db #0x10	; 16
	.db #0x26	; 38
	.db #0x46	; 70	'F'
	.db #0x36	; 54	'6'
	.db #0x49	; 73	'I'
	.db #0x55	; 85	'U'
	.db #0x22	; 34
	.db #0x50	; 80	'P'
	.db #0x00	; 0
	.db #0x05	; 5
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x1C	; 28
	.db #0x22	; 34
	.db #0x41	; 65	'A'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x41	; 65	'A'
	.db #0x22	; 34
	.db #0x1C	; 28
	.db #0x00	; 0
	.db #0x14	; 20
	.db #0x08	; 8
	.db #0x3E	; 62
	.db #0x08	; 8
	.db #0x14	; 20
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x3E	; 62
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x50	; 80	'P'
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x10	; 16
	.db #0x08	; 8
	.db #0x04	; 4
	.db #0x02	; 2
	.db #0x3E	; 62
	.db #0x51	; 81	'Q'
	.db #0x49	; 73	'I'
	.db #0x45	; 69	'E'
	.db #0x3E	; 62
	.db #0x00	; 0
	.db #0x42	; 66	'B'
	.db #0x7F	; 127
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x42	; 66	'B'
	.db #0x61	; 97	'a'
	.db #0x51	; 81	'Q'
	.db #0x49	; 73	'I'
	.db #0x46	; 70	'F'
	.db #0x21	; 33
	.db #0x41	; 65	'A'
	.db #0x45	; 69	'E'
	.db #0x4B	; 75	'K'
	.db #0x31	; 49	'1'
	.db #0x18	; 24
	.db #0x14	; 20
	.db #0x12	; 18
	.db #0x7F	; 127
	.db #0x10	; 16
	.db #0x27	; 39
	.db #0x45	; 69	'E'
	.db #0x45	; 69	'E'
	.db #0x45	; 69	'E'
	.db #0x39	; 57	'9'
	.db #0x3C	; 60
	.db #0x4A	; 74	'J'
	.db #0x49	; 73	'I'
	.db #0x49	; 73	'I'
	.db #0x30	; 48	'0'
	.db #0x01	; 1
	.db #0x71	; 113	'q'
	.db #0x09	; 9
	.db #0x05	; 5
	.db #0x03	; 3
	.db #0x36	; 54	'6'
	.db #0x49	; 73	'I'
	.db #0x49	; 73	'I'
	.db #0x49	; 73	'I'
	.db #0x36	; 54	'6'
	.db #0x06	; 6
	.db #0x49	; 73	'I'
	.db #0x49	; 73	'I'
	.db #0x29	; 41
	.db #0x1E	; 30
	.db #0x00	; 0
	.db #0x36	; 54	'6'
	.db #0x36	; 54	'6'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x56	; 86	'V'
	.db #0x36	; 54	'6'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x14	; 20
	.db #0x22	; 34
	.db #0x41	; 65	'A'
	.db #0x00	; 0
	.db #0x14	; 20
	.db #0x14	; 20
	.db #0x14	; 20
	.db #0x14	; 20
	.db #0x14	; 20
	.db #0x00	; 0
	.db #0x41	; 65	'A'
	.db #0x22	; 34
	.db #0x14	; 20
	.db #0x08	; 8
	.db #0x02	; 2
	.db #0x01	; 1
	.db #0x51	; 81	'Q'
	.db #0x09	; 9
	.db #0x06	; 6
	.db #0x32	; 50	'2'
	.db #0x49	; 73	'I'
	.db #0x59	; 89	'Y'
	.db #0x51	; 81	'Q'
	.db #0x3E	; 62
	.db #0x7E	; 126
	.db #0x11	; 17
	.db #0x11	; 17
	.db #0x11	; 17
	.db #0x7E	; 126
	.db #0x7F	; 127
	.db #0x49	; 73	'I'
	.db #0x49	; 73	'I'
	.db #0x49	; 73	'I'
	.db #0x36	; 54	'6'
	.db #0x3E	; 62
	.db #0x41	; 65	'A'
	.db #0x41	; 65	'A'
	.db #0x41	; 65	'A'
	.db #0x22	; 34
	.db #0x7F	; 127
	.db #0x41	; 65	'A'
	.db #0x41	; 65	'A'
	.db #0x22	; 34
	.db #0x1C	; 28
	.db #0x7F	; 127
	.db #0x49	; 73	'I'
	.db #0x49	; 73	'I'
	.db #0x49	; 73	'I'
	.db #0x41	; 65	'A'
	.db #0x7F	; 127
	.db #0x09	; 9
	.db #0x09	; 9
	.db #0x09	; 9
	.db #0x01	; 1
	.db #0x3E	; 62
	.db #0x41	; 65	'A'
	.db #0x49	; 73	'I'
	.db #0x49	; 73	'I'
	.db #0x7A	; 122	'z'
	.db #0x7F	; 127
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x7F	; 127
	.db #0x00	; 0
	.db #0x41	; 65	'A'
	.db #0x7F	; 127
	.db #0x41	; 65	'A'
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x40	; 64
	.db #0x41	; 65	'A'
	.db #0x3F	; 63
	.db #0x01	; 1
	.db #0x7F	; 127
	.db #0x08	; 8
	.db #0x14	; 20
	.db #0x22	; 34
	.db #0x41	; 65	'A'
	.db #0x7F	; 127
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x7F	; 127
	.db #0x02	; 2
	.db #0x0C	; 12
	.db #0x02	; 2
	.db #0x7F	; 127
	.db #0x7F	; 127
	.db #0x04	; 4
	.db #0x08	; 8
	.db #0x10	; 16
	.db #0x7F	; 127
	.db #0x3E	; 62
	.db #0x41	; 65	'A'
	.db #0x41	; 65	'A'
	.db #0x41	; 65	'A'
	.db #0x3E	; 62
	.db #0x7F	; 127
	.db #0x09	; 9
	.db #0x09	; 9
	.db #0x09	; 9
	.db #0x06	; 6
	.db #0x3E	; 62
	.db #0x41	; 65	'A'
	.db #0x51	; 81	'Q'
	.db #0x21	; 33
	.db #0x5E	; 94
	.db #0x7F	; 127
	.db #0x09	; 9
	.db #0x19	; 25
	.db #0x29	; 41
	.db #0x46	; 70	'F'
	.db #0x46	; 70	'F'
	.db #0x49	; 73	'I'
	.db #0x49	; 73	'I'
	.db #0x49	; 73	'I'
	.db #0x31	; 49	'1'
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x7F	; 127
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x3F	; 63
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x3F	; 63
	.db #0x1F	; 31
	.db #0x20	; 32
	.db #0x40	; 64
	.db #0x20	; 32
	.db #0x1F	; 31
	.db #0x3F	; 63
	.db #0x40	; 64
	.db #0x38	; 56	'8'
	.db #0x40	; 64
	.db #0x3F	; 63
	.db #0x63	; 99	'c'
	.db #0x14	; 20
	.db #0x08	; 8
	.db #0x14	; 20
	.db #0x63	; 99	'c'
	.db #0x07	; 7
	.db #0x08	; 8
	.db #0x70	; 112	'p'
	.db #0x08	; 8
	.db #0x07	; 7
	.db #0x61	; 97	'a'
	.db #0x51	; 81	'Q'
	.db #0x49	; 73	'I'
	.db #0x45	; 69	'E'
	.db #0x43	; 67	'C'
	.db #0x00	; 0
	.db #0x7F	; 127
	.db #0x41	; 65	'A'
	.db #0x41	; 65	'A'
	.db #0x00	; 0
	.db #0x55	; 85	'U'
	.db #0x2A	; 42
	.db #0x55	; 85	'U'
	.db #0x2A	; 42
	.db #0x55	; 85	'U'
	.db #0x00	; 0
	.db #0x41	; 65	'A'
	.db #0x41	; 65	'A'
	.db #0x7F	; 127
	.db #0x00	; 0
	.db #0x04	; 4
	.db #0x02	; 2
	.db #0x01	; 1
	.db #0x02	; 2
	.db #0x04	; 4
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x02	; 2
	.db #0x04	; 4
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x78	; 120	'x'
	.db #0x7F	; 127
	.db #0x48	; 72	'H'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x38	; 56	'8'
	.db #0x38	; 56	'8'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x20	; 32
	.db #0x38	; 56	'8'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x48	; 72	'H'
	.db #0x7F	; 127
	.db #0x38	; 56	'8'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x18	; 24
	.db #0x08	; 8
	.db #0x7E	; 126
	.db #0x09	; 9
	.db #0x01	; 1
	.db #0x02	; 2
	.db #0x0C	; 12
	.db #0x52	; 82	'R'
	.db #0x52	; 82	'R'
	.db #0x52	; 82	'R'
	.db #0x3E	; 62
	.db #0x7F	; 127
	.db #0x08	; 8
	.db #0x04	; 4
	.db #0x04	; 4
	.db #0x78	; 120	'x'
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0x7D	; 125
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x40	; 64
	.db #0x44	; 68	'D'
	.db #0x3D	; 61
	.db #0x00	; 0
	.db #0x7F	; 127
	.db #0x10	; 16
	.db #0x28	; 40
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x41	; 65	'A'
	.db #0x7F	; 127
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x7C	; 124
	.db #0x04	; 4
	.db #0x18	; 24
	.db #0x04	; 4
	.db #0x78	; 120	'x'
	.db #0x7C	; 124
	.db #0x08	; 8
	.db #0x04	; 4
	.db #0x04	; 4
	.db #0x78	; 120	'x'
	.db #0x38	; 56	'8'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x38	; 56	'8'
	.db #0x7C	; 124
	.db #0x14	; 20
	.db #0x14	; 20
	.db #0x14	; 20
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x14	; 20
	.db #0x14	; 20
	.db #0x18	; 24
	.db #0x7C	; 124
	.db #0x7C	; 124
	.db #0x08	; 8
	.db #0x04	; 4
	.db #0x04	; 4
	.db #0x08	; 8
	.db #0x48	; 72	'H'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x20	; 32
	.db #0x04	; 4
	.db #0x3F	; 63
	.db #0x44	; 68	'D'
	.db #0x40	; 64
	.db #0x20	; 32
	.db #0x3C	; 60
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x20	; 32
	.db #0x7C	; 124
	.db #0x1C	; 28
	.db #0x20	; 32
	.db #0x40	; 64
	.db #0x20	; 32
	.db #0x1C	; 28
	.db #0x3C	; 60
	.db #0x40	; 64
	.db #0x30	; 48	'0'
	.db #0x40	; 64
	.db #0x3C	; 60
	.db #0x44	; 68	'D'
	.db #0x28	; 40
	.db #0x10	; 16
	.db #0x28	; 40
	.db #0x44	; 68	'D'
	.db #0x0C	; 12
	.db #0x50	; 80	'P'
	.db #0x50	; 80	'P'
	.db #0x50	; 80	'P'
	.db #0x3C	; 60
	.db #0x44	; 68	'D'
	.db #0x64	; 100	'd'
	.db #0x54	; 84	'T'
	.db #0x4C	; 76	'L'
	.db #0x44	; 68	'D'
	.db #0x3E	; 62
	.db #0x7F	; 127
	.db #0x7F	; 127
	.db #0x3E	; 62
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x09	; 9
	.db #0x09	; 9
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x10	; 16
	.db #0x30	; 48	'0'
	.db #0x7F	; 127
	.db #0x30	; 48	'0'
	.db #0x10	; 16
	.area INITIALIZER
__xinit__wherex:
	.db #0x00	;  0
__xinit__wherey:
	.db #0x00	;  0
__xinit__outmode:
	.db #0x00	; 0
	.area CABS (ABS)
