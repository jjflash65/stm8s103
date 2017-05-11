;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Aug 12 2015) (Linux)
; This file was generated Fri Apr 21 07:36:57 2017
;--------------------------------------------------------
	.module spiro
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _spiro_generate
	.globl _clrscr_frame
	.globl _scr_update
	.globl _turtle_lineto
	.globl _turtle_moveto
	.globl _line
	.globl _putpixel
	.globl _tiny_cos
	.globl _tiny_sin
	.globl _tiny_pow
	.globl _abs
	.globl _lcd_putchar_d
	.globl _gotoxy
	.globl _clrscr
	.globl _wrdata
	.globl _lcd_init
	.globl _wrcmd
	.globl _my_printf
	.globl _delay_ms
	.globl _sysclock_init
	.globl _memset
	.globl _t_lasty
	.globl _t_lastx
	.globl _LcdFrame
	.globl _putchar
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
_LcdFrame::
	.ds 518
_t_lastx::
	.ds 2
_t_lasty::
	.ds 2
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
;	spiro.c: 46: void putchar(char ch)
;	-----------------------------------------
;	 function putchar
;	-----------------------------------------
_putchar:
;	spiro.c: 48: lcd_putchar_d(ch);
	ld	a, (0x03, sp)
	push	a
	call	_lcd_putchar_d
	pop	a
	ret
;	spiro.c: 52: float abs(float value)
;	-----------------------------------------
;	 function abs
;	-----------------------------------------
_abs:
;	spiro.c: 54: if (value< 0.0f) return (value * -(1.0f));
	clrw	x
	pushw	x
	clrw	x
	pushw	x
	ldw	x, (0x09, sp)
	pushw	x
	ldw	x, (0x09, sp)
	pushw	x
	call	___fslt
	addw	sp, #8
	tnz	a
	jreq	00102$
	ldw	y, (0x05, sp)
	ldw	x, (0x03, sp)
	sllw	x
	ccf
	rrcw	x
	exgw	x, y
	jra	00104$
00102$:
;	spiro.c: 55: else return value;
	ldw	x, (0x05, sp)
	ldw	y, (0x03, sp)
00104$:
	ret
;	spiro.c: 60: float tiny_pow(int n, float value)
;	-----------------------------------------
;	 function tiny_pow
;	-----------------------------------------
_tiny_pow:
	sub	sp, #8
;	spiro.c: 65: tmp= value;
	ldw	y, (0x0f, sp)
	ldw	(0x03, sp), y
	ldw	y, (0x0d, sp)
;	spiro.c: 66: for (i= 0; i < n-1; i++)
	ldw	x, (0x0b, sp)
	decw	x
	ldw	(0x07, sp), x
	clrw	x
	ldw	(0x05, sp), x
00103$:
	ldw	x, (0x05, sp)
	cpw	x, (0x07, sp)
	jrsge	00101$
;	spiro.c: 68: tmp= tmp*value;
	ldw	x, (0x0f, sp)
	pushw	x
	ldw	x, (0x0f, sp)
	pushw	x
	ldw	x, (0x07, sp)
	pushw	x
	pushw	y
	call	___fsmul
	addw	sp, #8
	ldw	(0x03, sp), x
;	spiro.c: 66: for (i= 0; i < n-1; i++)
	ldw	x, (0x05, sp)
	incw	x
	ldw	(0x05, sp), x
	jra	00103$
00101$:
;	spiro.c: 70: return tmp;
	ldw	x, (0x03, sp)
	addw	sp, #8
	ret
;	spiro.c: 73: float tiny_sin(float value)
;	-----------------------------------------
;	 function tiny_sin
;	-----------------------------------------
_tiny_sin:
	sub	sp, #30
;	spiro.c: 81: int   mflag= 0;
	clrw	x
	ldw	(0x15, sp), x
;	spiro.c: 83: while (value > (2*MY_PI)) value -= (2*MY_PI);
00101$:
	push	#0xdb
	push	#0x0f
	push	#0xc9
	push	#0x40
	ldw	x, (0x27, sp)
	pushw	x
	ldw	x, (0x27, sp)
	pushw	x
	call	___fsgt
	addw	sp, #8
	tnz	a
	jreq	00103$
	push	#0xdb
	push	#0x0f
	push	#0xc9
	push	#0x40
	ldw	x, (0x27, sp)
	pushw	x
	ldw	x, (0x27, sp)
	pushw	x
	call	___fssub
	addw	sp, #8
	ldw	(0x23, sp), x
	ldw	(0x21, sp), y
	jra	00101$
00103$:
;	spiro.c: 84: if (value > MY_PI)
	push	#0xdb
	push	#0x0f
	push	#0x49
	push	#0x40
	ldw	x, (0x27, sp)
	pushw	x
	ldw	x, (0x27, sp)
	pushw	x
	call	___fsgt
	addw	sp, #8
	tnz	a
	jreq	00105$
;	spiro.c: 86: mflag= - 1;
	ldw	x, #0xffff
	ldw	(0x15, sp), x
;	spiro.c: 87: value -= MY_PI;
	push	#0xdb
	push	#0x0f
	push	#0x49
	push	#0x40
	ldw	x, (0x27, sp)
	pushw	x
	ldw	x, (0x27, sp)
	pushw	x
	call	___fssub
	addw	sp, #8
	ldw	(0x23, sp), x
	ldw	(0x21, sp), y
00105$:
;	spiro.c: 90: if (value > (MY_PI /2)) value = MY_PI - value;
	push	#0xdb
	push	#0x0f
	push	#0xc9
	push	#0x3f
	ldw	x, (0x27, sp)
	pushw	x
	ldw	x, (0x27, sp)
	pushw	x
	call	___fsgt
	addw	sp, #8
	tnz	a
	jreq	00107$
	ldw	x, (0x23, sp)
	pushw	x
	ldw	x, (0x23, sp)
	pushw	x
	push	#0xdb
	push	#0x0f
	push	#0x49
	push	#0x40
	call	___fssub
	addw	sp, #8
	ldw	(0x23, sp), x
	ldw	(0x21, sp), y
00107$:
;	spiro.c: 92: degree= value;
	ldw	y, (0x23, sp)
	ldw	(0x13, sp), y
	ldw	y, (0x21, sp)
	ldw	(0x11, sp), y
;	spiro.c: 94: p3 = tiny_pow(3, degree);
	ldw	x, (0x13, sp)
	pushw	x
	ldw	x, (0x13, sp)
	pushw	x
	push	#0x03
	push	#0x00
	call	_tiny_pow
	addw	sp, #6
	ldw	(0x0f, sp), x
	ldw	(0x0d, sp), y
;	spiro.c: 95: p5  = tiny_pow(5, degree);
	ldw	x, (0x13, sp)
	pushw	x
	ldw	x, (0x13, sp)
	pushw	x
	push	#0x05
	push	#0x00
	call	_tiny_pow
	addw	sp, #6
	ldw	(0x0b, sp), x
	ldw	(0x09, sp), y
;	spiro.c: 96: p7  = tiny_pow(7, degree);
	ldw	x, (0x13, sp)
	pushw	x
	ldw	x, (0x13, sp)
	pushw	x
	push	#0x07
	push	#0x00
	call	_tiny_pow
	addw	sp, #6
	ldw	(0x07, sp), x
	ldw	(0x05, sp), y
;	spiro.c: 100: sinx= (degree - (p3/6.0f) + (p5/120.0f) - (p7/5040.0f));
	clrw	x
	pushw	x
	push	#0xc0
	push	#0x40
	ldw	x, (0x13, sp)
	pushw	x
	ldw	x, (0x13, sp)
	pushw	x
	call	___fsdiv
	addw	sp, #8
	pushw	x
	pushw	y
	ldw	x, (0x17, sp)
	pushw	x
	ldw	x, (0x17, sp)
	pushw	x
	call	___fssub
	addw	sp, #8
	ldw	(0x1d, sp), x
	ldw	(0x1b, sp), y
	clrw	x
	pushw	x
	push	#0xf0
	push	#0x42
	ldw	x, (0x0f, sp)
	pushw	x
	ldw	x, (0x0f, sp)
	pushw	x
	call	___fsdiv
	addw	sp, #8
	pushw	x
	pushw	y
	ldw	x, (0x21, sp)
	pushw	x
	ldw	x, (0x21, sp)
	pushw	x
	call	___fsadd
	addw	sp, #8
	ldw	(0x19, sp), x
	ldw	(0x17, sp), y
	push	#0x00
	push	#0x80
	push	#0x9d
	push	#0x45
	ldw	x, (0x0b, sp)
	pushw	x
	ldw	x, (0x0b, sp)
	pushw	x
	call	___fsdiv
	addw	sp, #8
	pushw	x
	pushw	y
	ldw	x, (0x1d, sp)
	pushw	x
	ldw	x, (0x1d, sp)
	pushw	x
	call	___fssub
	addw	sp, #8
	ldw	(0x03, sp), x
;	spiro.c: 102: if (mflag) sinx = sinx * (-1);
	ldw	x, (0x15, sp)
	jreq	00109$
	ldw	x, (0x03, sp)
	sllw	y
	ccf
	rrcw	y
	ldw	(0x03, sp), x
00109$:
;	spiro.c: 104: return sinx;
	ldw	x, (0x03, sp)
	addw	sp, #30
	ret
;	spiro.c: 107: float tiny_cos(float value)
;	-----------------------------------------
;	 function tiny_cos
;	-----------------------------------------
_tiny_cos:
;	spiro.c: 109: return tiny_sin(value - (MY_PI / 2.0f)) * -1.0f;
	push	#0xdb
	push	#0x0f
	push	#0xc9
	push	#0x3f
	ldw	x, (0x09, sp)
	pushw	x
	ldw	x, (0x09, sp)
	pushw	x
	call	___fssub
	addw	sp, #8
	pushw	x
	pushw	y
	call	_tiny_sin
	addw	sp, #4
	exgw	x, y
	sllw	x
	ccf
	rrcw	x
	exgw	x, y
	ret
;	spiro.c: 122: void putpixel(unsigned char x, unsigned char y, uint8_t mode )
;	-----------------------------------------
;	 function putpixel
;	-----------------------------------------
_putpixel:
	sub	sp, #8
;	spiro.c: 128: index=((y/8)*LCD_VISIBLE_X_RES)+x;
	ld	a, (0x0c, sp)
	srl	a
	srl	a
	srl	a
	push	a
	exg	a, xl
	ld	a, #0x54
	exg	a, xl
	mul	x, a
	ldw	(0x08, sp), x
	pop	a
	clrw	x
	exg	a, xl
	ld	a, (0x0b, sp)
	exg	a, xl
	addw	x, (0x07, sp)
	ldw	(0x02, sp), x
;	spiro.c: 129: offset=y-((y/8)*8);
	sll	a
	sll	a
	sll	a
	ld	(0x06, sp), a
	ld	a, (0x0c, sp)
	sub	a, (0x06, sp)
	ld	(0x01, sp), a
;	spiro.c: 133: data=LcdFrame[index];
	ldw	x, #_LcdFrame+0
	addw	x, (0x02, sp)
	ld	a, (x)
;	spiro.c: 134: if (mode== 1) data |= (0x01<<offset);                          // Pixel setzen
	push	a
	ld	a, #0x01
	ld	(0x06, sp), a
	ld	a, (0x02, sp)
	jreq	00124$
00123$:
	sll	(0x06, sp)
	dec	a
	jrne	00123$
00124$:
	ld	a, (0x0e, sp)
	cp	a, #0x01
	pop	a
	jrne	00107$
	or	a, (0x05, sp)
	jra	00108$
00107$:
;	spiro.c: 135: else if (mode== 0) data &= (~(0x01<<offset));                 // Pixel loeschen
	tnz	(0x0d, sp)
	jrne	00104$
	push	a
	ld	a, (0x06, sp)
	cpl	a
	ld	(0x05, sp), a
	pop	a
	and	a, (0x04, sp)
	jra	00108$
00104$:
;	spiro.c: 136: else if (mode== 2) data ^= (0x01<<offset);                    // Pixel im XOR-Mode setzen
	push	a
	ld	a, (0x0e, sp)
	cp	a, #0x02
	pop	a
	jrne	00108$
	xor	a, (0x05, sp)
00108$:
;	spiro.c: 137: LcdFrame[index]=data;
	ld	(x), a
	addw	sp, #8
	ret
;	spiro.c: 155: void line(int x0, int y0, int x1, int y1, uint8_t mode)
;	-----------------------------------------
;	 function line
;	-----------------------------------------
_line:
	sub	sp, #10
;	spiro.c: 161: int dx =  abs(x1-x0), sx = x0<x1 ? 1 : -1;
	ldw	x, (0x11, sp)
	subw	x, (0x0d, sp)
	pushw	x
	call	___sint2fs
	addw	sp, #2
	pushw	x
	pushw	y
	call	_abs
	addw	sp, #4
	pushw	x
	pushw	y
	call	___fs2sint
	addw	sp, #4
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
	ldw	(0x01, sp), x
;	spiro.c: 162: int dy = -abs(y1-y0), sy = y0<y1 ? 1 : -1;
	ldw	x, (0x13, sp)
	subw	x, (0x0f, sp)
	pushw	x
	call	___sint2fs
	addw	sp, #2
	pushw	x
	pushw	y
	call	_abs
	addw	sp, #4
	exgw	x, y
	sllw	x
	ccf
	rrcw	x
	pushw	y
	pushw	x
	call	___fs2sint
	addw	sp, #4
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
;	spiro.c: 163: int err = dx+dy, e2;
	ldw	y, (0x07, sp)
	addw	y, (0x09, sp)
	ldw	(0x05, sp), y
00109$:
;	spiro.c: 167: putpixel(x0,y0, mode);
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
;	spiro.c: 168: if (x0==x1 && y0==y1) break;
	ldw	x, (0x0d, sp)
	cpw	x, (0x11, sp)
	jrne	00102$
	ldw	x, (0x0f, sp)
	cpw	x, (0x13, sp)
	jreq	00111$
00102$:
;	spiro.c: 169: e2 = 2*err;
	ldw	x, (0x05, sp)
	sllw	x
;	spiro.c: 170: if (e2 > dy) { err += dy; x0 += sx; }
	cpw	x, (0x09, sp)
	jrsle	00105$
	ldw	y, (0x05, sp)
	addw	y, (0x09, sp)
	ldw	(0x05, sp), y
	ldw	y, (0x0d, sp)
	addw	y, (0x01, sp)
	ldw	(0x0d, sp), y
00105$:
;	spiro.c: 171: if (e2 < dx) { err += dx; y0 += sy; }
	cpw	x, (0x07, sp)
	jrsge	00109$
	ldw	y, (0x05, sp)
	addw	y, (0x07, sp)
	ldw	(0x05, sp), y
	ldw	y, (0x0f, sp)
	addw	y, (0x03, sp)
	ldw	(0x0f, sp), y
	jra	00109$
00111$:
	addw	sp, #10
	ret
;	spiro.c: 177: void turtle_moveto(int x, int y)
;	-----------------------------------------
;	 function turtle_moveto
;	-----------------------------------------
_turtle_moveto:
;	spiro.c: 179: t_lastx= x; t_lasty= y;
	ldw	x, (0x03, sp)
	ldw	_t_lastx+0, x
	ldw	x, (0x05, sp)
	ldw	_t_lasty+0, x
	ret
;	spiro.c: 182: void turtle_lineto(int x, int y, uint8_t col)
;	-----------------------------------------
;	 function turtle_lineto
;	-----------------------------------------
_turtle_lineto:
;	spiro.c: 184: line(x,y, t_lastx, t_lasty, col);
	ld	a, (0x07, sp)
	push	a
	ldw	x, _t_lasty+0
	pushw	x
	ldw	x, _t_lastx+0
	pushw	x
	ldw	x, (0x0a, sp)
	pushw	x
	ldw	x, (0x0a, sp)
	pushw	x
	call	_line
	addw	sp, #9
;	spiro.c: 185: turtle_moveto(x,y);
	ldw	x, (0x05, sp)
	pushw	x
	ldw	x, (0x05, sp)
	pushw	x
	call	_turtle_moveto
	addw	sp, #4
	ret
;	spiro.c: 196: void scr_update(void)
;	-----------------------------------------
;	 function scr_update
;	-----------------------------------------
_scr_update:
	sub	sp, #8
;	spiro.c: 198: unsigned int i=0;
	clrw	x
	ldw	(0x02, sp), x
;	spiro.c: 202: for (row=0; row<(LCD_VISIBLE_Y_RES / 8); row++)
	ldw	x, #_LcdFrame+0
	ldw	(0x07, sp), x
	clr	(0x04, sp)
00105$:
;	spiro.c: 204: wrcmd( 0x80);
	push	#0x80
	call	_wrcmd
	pop	a
;	spiro.c: 205: wrcmd( 0x40 | row);
	ld	a, (0x04, sp)
	or	a, #0x40
	push	a
	call	_wrcmd
	pop	a
;	spiro.c: 206: for (col=0; col<LCD_VISIBLE_X_RES; col++) wrdata(LcdFrame[i++]);
	ldw	x, (0x02, sp)
	clr	(0x01, sp)
00103$:
	ldw	(0x05, sp), x
	incw	x
	ldw	y, (0x07, sp)
	addw	y, (0x05, sp)
	ld	a, (y)
	pushw	x
	push	a
	call	_wrdata
	pop	a
	popw	x
	inc	(0x01, sp)
	ld	a, (0x01, sp)
	cp	a, #0x54
	jrc	00103$
;	spiro.c: 202: for (row=0; row<(LCD_VISIBLE_Y_RES / 8); row++)
	ldw	(0x02, sp), x
	inc	(0x04, sp)
	ld	a, (0x04, sp)
	cp	a, #0x06
	jrc	00105$
	addw	sp, #8
	ret
;	spiro.c: 216: void clrscr_frame(void)
;	-----------------------------------------
;	 function clrscr_frame
;	-----------------------------------------
_clrscr_frame:
;	spiro.c: 220: memset(LcdFrame,0x00,LCD_FRAME_SIZE);              // LCD FRAME loeschen
	ldw	y, #_LcdFrame+0
	push	#0x06
	push	#0x02
	clrw	x
	pushw	x
	pushw	y
	call	_memset
	addw	sp, #6
	ret
;	spiro.c: 224: void spiro_generate(int inner, int outer, int evol, int resol, uint16_t col)
;	-----------------------------------------
;	 function spiro_generate
;	-----------------------------------------
_spiro_generate:
	sub	sp, #43
;	spiro.c: 234: inner_ypos = (c_height / 2.0f) + inner;
	ldw	x, (0x2e, sp)
	pushw	x
	call	___sint2fs
	addw	sp, #2
	ldw	(0x19, sp), x
	ldw	(0x17, sp), y
	ldw	x, (0x19, sp)
	pushw	x
	ldw	x, (0x19, sp)
	pushw	x
	clrw	x
	pushw	x
	push	#0xc0
	push	#0x41
	call	___fsadd
	addw	sp, #8
	ldw	(0x1f, sp), x
	ldw	(0x1d, sp), y
;	spiro.c: 237: outer_ypos= inner_ypos + outer;
	ldw	x, (0x30, sp)
	pushw	x
	call	___sint2fs
	addw	sp, #2
	ldw	(0x24, sp), x
	ldw	(0x22, sp), y
	ldw	x, (0x24, sp)
	pushw	x
	ldw	x, (0x24, sp)
	pushw	x
	ldw	x, (0x23, sp)
	pushw	x
	ldw	x, (0x23, sp)
	pushw	x
	call	___fsadd
	addw	sp, #8
;	spiro.c: 238: turtle_moveto(outer_xpos, outer_ypos);
	pushw	x
	pushw	y
	call	___fs2sint
	addw	sp, #4
	pushw	x
	push	#0x2a
	push	#0x00
	call	_turtle_moveto
	addw	sp, #4
;	spiro.c: 240: for (i= 0; i< resol + 1; i++)
	ldw	x, (0x34, sp)
	incw	x
	ldw	(0x26, sp), x
	clrw	x
	ldw	(0x15, sp), x
00103$:
	ldw	x, (0x15, sp)
	cpw	x, (0x26, sp)
	jrslt	00116$
	jp	00105$
00116$:
;	spiro.c: 242: j= ((float)i / resol) * (2.0f * MY_PI);
	ldw	x, (0x15, sp)
	pushw	x
	call	___sint2fs
	addw	sp, #2
	ldw	(0x2a, sp), x
	ldw	(0x28, sp), y
	ldw	x, (0x34, sp)
	pushw	x
	call	___sint2fs
	addw	sp, #2
	pushw	x
	pushw	y
	ldw	x, (0x2e, sp)
	pushw	x
	ldw	x, (0x2e, sp)
	pushw	x
	call	___fsdiv
	addw	sp, #8
	pushw	x
	pushw	y
	push	#0xdb
	push	#0x0f
	push	#0xc9
	push	#0x40
	call	___fsmul
	addw	sp, #8
	ldw	(0x0b, sp), x
	ldw	(0x09, sp), y
;	spiro.c: 243: inner_xpos = (c_width / 2.0f) + (inner * tiny_sin(j));
	ldw	x, (0x0b, sp)
	pushw	x
	ldw	x, (0x0b, sp)
	pushw	x
	call	_tiny_sin
	addw	sp, #4
	pushw	x
	pushw	y
	ldw	x, (0x1d, sp)
	pushw	x
	ldw	x, (0x1d, sp)
	pushw	x
	call	___fsmul
	addw	sp, #8
	pushw	x
	pushw	y
	clrw	x
	pushw	x
	push	#0x28
	push	#0x42
	call	___fsadd
	addw	sp, #8
	ldw	(0x13, sp), x
	ldw	(0x11, sp), y
;	spiro.c: 244: inner_ypos = (c_height / 2.0f) + (inner * tiny_cos(j));
	ldw	x, (0x0b, sp)
	pushw	x
	ldw	x, (0x0b, sp)
	pushw	x
	call	_tiny_cos
	addw	sp, #4
	pushw	x
	pushw	y
	ldw	x, (0x1d, sp)
	pushw	x
	ldw	x, (0x1d, sp)
	pushw	x
	call	___fsmul
	addw	sp, #8
	pushw	x
	pushw	y
	clrw	x
	pushw	x
	push	#0xc0
	push	#0x41
	call	___fsadd
	addw	sp, #8
	ldw	(0x0f, sp), x
	ldw	(0x0d, sp), y
;	spiro.c: 246: k= j * ((float)evol / 10.0f);
	ldw	x, (0x32, sp)
	pushw	x
	call	___sint2fs
	addw	sp, #2
	push	#0x00
	push	#0x00
	push	#0x20
	push	#0x41
	pushw	x
	pushw	y
	call	___fsdiv
	addw	sp, #8
	pushw	x
	pushw	y
	ldw	x, (0x0f, sp)
	pushw	x
	ldw	x, (0x0f, sp)
	pushw	x
	call	___fsmul
	addw	sp, #8
	ldw	(0x07, sp), x
	ldw	(0x05, sp), y
;	spiro.c: 248: outer_xpos= inner_xpos + (outer * tiny_sin(k));
	ldw	x, (0x07, sp)
	pushw	x
	ldw	x, (0x07, sp)
	pushw	x
	call	_tiny_sin
	addw	sp, #4
	pushw	x
	pushw	y
	ldw	x, (0x28, sp)
	pushw	x
	ldw	x, (0x28, sp)
	pushw	x
	call	___fsmul
	addw	sp, #8
	pushw	x
	pushw	y
	ldw	x, (0x17, sp)
	pushw	x
	ldw	x, (0x17, sp)
	pushw	x
	call	___fsadd
	addw	sp, #8
	ldw	(0x03, sp), x
	ldw	(0x01, sp), y
;	spiro.c: 249: outer_ypos= inner_ypos + (outer * tiny_cos(k));
	ldw	x, (0x07, sp)
	pushw	x
	ldw	x, (0x07, sp)
	pushw	x
	call	_tiny_cos
	addw	sp, #4
	pushw	x
	pushw	y
	ldw	x, (0x28, sp)
	pushw	x
	ldw	x, (0x28, sp)
	pushw	x
	call	___fsmul
	addw	sp, #8
	pushw	x
	pushw	y
	ldw	x, (0x13, sp)
	pushw	x
	ldw	x, (0x13, sp)
	pushw	x
	call	___fsadd
	addw	sp, #8
;	spiro.c: 251: turtle_lineto(outer_xpos, outer_ypos, col);
	ld	a, (0x37, sp)
	ld	(0x21, sp), a
	pushw	x
	pushw	y
	call	___fs2sint
	addw	sp, #4
	ldw	(0x1b, sp), x
	ldw	x, (0x03, sp)
	pushw	x
	ldw	x, (0x03, sp)
	pushw	x
	call	___fs2sint
	addw	sp, #4
	ld	a, (0x21, sp)
	push	a
	ldw	y, (0x1c, sp)
	pushw	y
	pushw	x
	call	_turtle_lineto
	addw	sp, #5
;	spiro.c: 252: scr_update();
	call	_scr_update
;	spiro.c: 240: for (i= 0; i< resol + 1; i++)
	ldw	x, (0x15, sp)
	incw	x
	ldw	(0x15, sp), x
	jp	00103$
00105$:
	addw	sp, #43
	ret
;	spiro.c: 258: int main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	spiro.c: 266: sysclock_init(0);
	push	#0x00
	call	_sysclock_init
	pop	a
;	spiro.c: 268: bled_output_init();
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
;	spiro.c: 269: exled_output_init();
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
;	spiro.c: 270: button_input_init();
	ldw	x, #0x5011
	ld	a, (x)
	and	a, #0xf7
	ld	(x), a
	ldw	x, #0x5012
	ld	a, (x)
	or	a, #0x08
	ld	(x), a
;	spiro.c: 272: printfkomma= 2;
	mov	_printfkomma+0, #0x02
;	spiro.c: 274: lcd_init();
	call	_lcd_init
;	spiro.c: 275: clrscr();
	call	_clrscr
;	spiro.c: 276: while(1)
00102$:
;	spiro.c: 278: gotoxy(0,2);
	push	#0x02
	push	#0x00
	call	_gotoxy
	popw	x
;	spiro.c: 279: printf("  Spirograph\n\r");
	ldw	x, #___str_0+0
	pushw	x
	call	_my_printf
	popw	x
;	spiro.c: 280: delay_ms(2000);
	push	#0xd0
	push	#0x07
	call	_delay_ms
	popw	x
;	spiro.c: 281: spiro_generate(11, 12, 80, 200, 1);
	push	#0x01
	push	#0x00
	push	#0xc8
	push	#0x00
	push	#0x50
	push	#0x00
	push	#0x0c
	push	#0x00
	push	#0x0b
	push	#0x00
	call	_spiro_generate
	addw	sp, #10
;	spiro.c: 282: scr_update();
	call	_scr_update
;	spiro.c: 283: delay_ms(2000);
	push	#0xd0
	push	#0x07
	call	_delay_ms
	popw	x
;	spiro.c: 284: spiro_generate(11, 12, 80, 200, 0);
	clrw	x
	pushw	x
	push	#0xc8
	push	#0x00
	push	#0x50
	push	#0x00
	push	#0x0c
	push	#0x00
	push	#0x0b
	push	#0x00
	call	_spiro_generate
	addw	sp, #10
;	spiro.c: 285: scr_update();
	call	_scr_update
	jra	00102$
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
	.db #0x00	; 0
	.db #0x1D	; 29
	.db #0x15	; 21
	.db #0x17	; 23
	.db #0x00	; 0
___str_0:
	.ascii "  Spirograph"
	.db 0x0A
	.db 0x0D
	.db 0x00
	.area INITIALIZER
	.area CABS (ABS)
