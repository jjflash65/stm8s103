;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Aug 12 2015) (Linux)
; This file was generated Mon Apr 24 08:48:30 2017
;--------------------------------------------------------
	.module oled_spiro
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _oled_putstring
	.globl _spiro_generate
	.globl _turtle_lineto
	.globl _turtle_moveto
	.globl _tiny_cos
	.globl _tiny_sin
	.globl _tiny_pow
	.globl _fb_clear
	.globl _fb_init
	.globl _line
	.globl _fb_show
	.globl _oled_putchar
	.globl _gotoxy
	.globl _clrscr
	.globl _oled_init
	.globl _delay_ms
	.globl _sysclock_init
	.globl _t_lasty
	.globl _t_lastx
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
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
;	oled_spiro.c: 28: float tiny_pow(int n, float value)
;	-----------------------------------------
;	 function tiny_pow
;	-----------------------------------------
_tiny_pow:
	sub	sp, #8
;	oled_spiro.c: 33: tmp= value;
	ldw	y, (0x0f, sp)
	ldw	(0x05, sp), y
	ldw	y, (0x0d, sp)
;	oled_spiro.c: 34: for (i= 0; i < n-1; i++)
	ldw	x, (0x0b, sp)
	decw	x
	ldw	(0x07, sp), x
	clrw	x
	ldw	(0x01, sp), x
00103$:
	ldw	x, (0x01, sp)
	cpw	x, (0x07, sp)
	jrsge	00101$
;	oled_spiro.c: 36: tmp= tmp*value;
	ldw	x, (0x0f, sp)
	pushw	x
	ldw	x, (0x0f, sp)
	pushw	x
	ldw	x, (0x09, sp)
	pushw	x
	pushw	y
	call	___fsmul
	addw	sp, #8
	ldw	(0x05, sp), x
;	oled_spiro.c: 34: for (i= 0; i < n-1; i++)
	ldw	x, (0x01, sp)
	incw	x
	ldw	(0x01, sp), x
	jra	00103$
00101$:
;	oled_spiro.c: 38: return tmp;
	ldw	x, (0x05, sp)
	addw	sp, #8
	ret
;	oled_spiro.c: 41: float tiny_sin(float value)
;	-----------------------------------------
;	 function tiny_sin
;	-----------------------------------------
_tiny_sin:
	sub	sp, #30
;	oled_spiro.c: 49: int   mflag= 0;
	clrw	x
	ldw	(0x11, sp), x
;	oled_spiro.c: 51: while (value > (2*MY_PI)) value -= (2*MY_PI);
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
;	oled_spiro.c: 52: if (value > MY_PI)
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
;	oled_spiro.c: 54: mflag= - 1;
	ldw	x, #0xffff
	ldw	(0x11, sp), x
;	oled_spiro.c: 55: value -= MY_PI;
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
;	oled_spiro.c: 58: if (value > (MY_PI /2)) value = MY_PI - value;
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
;	oled_spiro.c: 60: degree= value;
	ldw	y, (0x23, sp)
	ldw	(0x0f, sp), y
	ldw	y, (0x21, sp)
	ldw	(0x0d, sp), y
;	oled_spiro.c: 62: p3 = tiny_pow(3, degree);
	ldw	x, (0x0f, sp)
	pushw	x
	ldw	x, (0x0f, sp)
	pushw	x
	push	#0x03
	push	#0x00
	call	_tiny_pow
	addw	sp, #6
	ldw	(0x03, sp), x
	ldw	(0x01, sp), y
;	oled_spiro.c: 63: p5  = tiny_pow(5, degree);
	ldw	x, (0x0f, sp)
	pushw	x
	ldw	x, (0x0f, sp)
	pushw	x
	push	#0x05
	push	#0x00
	call	_tiny_pow
	addw	sp, #6
	ldw	(0x15, sp), x
	ldw	(0x13, sp), y
;	oled_spiro.c: 64: p7  = tiny_pow(7, degree);
	ldw	x, (0x0f, sp)
	pushw	x
	ldw	x, (0x0f, sp)
	pushw	x
	push	#0x07
	push	#0x00
	call	_tiny_pow
	addw	sp, #6
	ldw	(0x0b, sp), x
	ldw	(0x09, sp), y
;	oled_spiro.c: 68: sinx= (degree - (p3/6.0f) + (p5/120.0f) - (p7/5040.0f));
	clrw	x
	pushw	x
	push	#0xc0
	push	#0x40
	ldw	x, (0x07, sp)
	pushw	x
	ldw	x, (0x07, sp)
	pushw	x
	call	___fsdiv
	addw	sp, #8
	pushw	x
	pushw	y
	ldw	x, (0x13, sp)
	pushw	x
	ldw	x, (0x13, sp)
	pushw	x
	call	___fssub
	addw	sp, #8
	ldw	(0x1d, sp), x
	ldw	(0x1b, sp), y
	clrw	x
	pushw	x
	push	#0xf0
	push	#0x42
	ldw	x, (0x19, sp)
	pushw	x
	ldw	x, (0x19, sp)
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
	ldw	x, (0x0f, sp)
	pushw	x
	ldw	x, (0x0f, sp)
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
	ldw	(0x07, sp), x
;	oled_spiro.c: 70: if (mflag) sinx = sinx * (-1);
	ldw	x, (0x11, sp)
	jreq	00109$
	ldw	x, (0x07, sp)
	sllw	y
	ccf
	rrcw	y
	ldw	(0x07, sp), x
00109$:
;	oled_spiro.c: 72: return sinx;
	ldw	x, (0x07, sp)
	addw	sp, #30
	ret
;	oled_spiro.c: 75: float tiny_cos(float value)
;	-----------------------------------------
;	 function tiny_cos
;	-----------------------------------------
_tiny_cos:
;	oled_spiro.c: 77: return tiny_sin(value - (MY_PI / 2.0f)) * -1.0f;
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
;	oled_spiro.c: 81: void turtle_moveto(int x, int y)
;	-----------------------------------------
;	 function turtle_moveto
;	-----------------------------------------
_turtle_moveto:
;	oled_spiro.c: 83: t_lastx= x; t_lasty= y;
	ldw	x, (0x03, sp)
	ldw	_t_lastx+0, x
	ldw	x, (0x05, sp)
	ldw	_t_lasty+0, x
	ret
;	oled_spiro.c: 86: void turtle_lineto(int x, int y, uint8_t col)
;	-----------------------------------------
;	 function turtle_lineto
;	-----------------------------------------
_turtle_lineto:
;	oled_spiro.c: 88: line(x,y, t_lastx, t_lasty, col);
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
;	oled_spiro.c: 89: turtle_moveto(x,y);
	ldw	x, (0x05, sp)
	pushw	x
	ldw	x, (0x05, sp)
	pushw	x
	call	_turtle_moveto
	addw	sp, #4
	ret
;	oled_spiro.c: 94: void spiro_generate(int inner, int outer, int evol, int resol, uint16_t col)
;	-----------------------------------------
;	 function spiro_generate
;	-----------------------------------------
_spiro_generate:
	sub	sp, #43
;	oled_spiro.c: 104: inner_ypos = (c_height / 2.0f) + inner;
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
	push	#0x00
	push	#0x42
	call	___fsadd
	addw	sp, #8
	ldw	(0x2a, sp), x
	ldw	(0x28, sp), y
;	oled_spiro.c: 107: outer_ypos= inner_ypos + outer;
	ldw	x, (0x30, sp)
	pushw	x
	call	___sint2fs
	addw	sp, #2
	ldw	(0x1d, sp), x
	ldw	(0x1b, sp), y
	ldw	x, (0x1d, sp)
	pushw	x
	ldw	x, (0x1d, sp)
	pushw	x
	ldw	x, (0x2e, sp)
	pushw	x
	ldw	x, (0x2e, sp)
	pushw	x
	call	___fsadd
	addw	sp, #8
;	oled_spiro.c: 108: turtle_moveto(outer_xpos, outer_ypos);
	pushw	x
	pushw	y
	call	___fs2sint
	addw	sp, #4
	pushw	x
	push	#0x20
	push	#0x00
	call	_turtle_moveto
	addw	sp, #4
;	oled_spiro.c: 110: for (i= 0; i< resol + 1; i++)
	ldw	x, (0x34, sp)
	incw	x
	ldw	(0x26, sp), x
	clrw	x
	ldw	(0x01, sp), x
00103$:
	ldw	x, (0x01, sp)
	cpw	x, (0x26, sp)
	jrslt	00116$
	jp	00105$
00116$:
;	oled_spiro.c: 112: j= ((float)i / resol) * (2.0f * MY_PI);
	ldw	x, (0x01, sp)
	pushw	x
	call	___sint2fs
	addw	sp, #2
	ldw	(0x24, sp), x
	ldw	(0x22, sp), y
	ldw	x, (0x34, sp)
	pushw	x
	call	___sint2fs
	addw	sp, #2
	pushw	x
	pushw	y
	ldw	x, (0x28, sp)
	pushw	x
	ldw	x, (0x28, sp)
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
	ldw	(0x09, sp), x
	ldw	(0x07, sp), y
;	oled_spiro.c: 113: inner_xpos = (c_width / 2.0f) + (inner * tiny_sin(j));
	ldw	x, (0x09, sp)
	pushw	x
	ldw	x, (0x09, sp)
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
	push	#0x00
	push	#0x42
	call	___fsadd
	addw	sp, #8
	ldw	(0x15, sp), x
	ldw	(0x13, sp), y
;	oled_spiro.c: 114: inner_ypos = (c_height / 2.0f) + (inner * tiny_cos(j));
	ldw	x, (0x09, sp)
	pushw	x
	ldw	x, (0x09, sp)
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
	push	#0x00
	push	#0x42
	call	___fsadd
	addw	sp, #8
	ldw	(0x11, sp), x
	ldw	(0x0f, sp), y
;	oled_spiro.c: 116: k= j * ((float)evol / 10.0f);
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
	ldw	x, (0x0d, sp)
	pushw	x
	ldw	x, (0x0d, sp)
	pushw	x
	call	___fsmul
	addw	sp, #8
	ldw	(0x05, sp), x
	ldw	(0x03, sp), y
;	oled_spiro.c: 118: outer_xpos= inner_xpos + (outer * tiny_sin(k));
	ldw	x, (0x05, sp)
	pushw	x
	ldw	x, (0x05, sp)
	pushw	x
	call	_tiny_sin
	addw	sp, #4
	pushw	x
	pushw	y
	ldw	x, (0x21, sp)
	pushw	x
	ldw	x, (0x21, sp)
	pushw	x
	call	___fsmul
	addw	sp, #8
	pushw	x
	pushw	y
	ldw	x, (0x19, sp)
	pushw	x
	ldw	x, (0x19, sp)
	pushw	x
	call	___fsadd
	addw	sp, #8
	ldw	(0x0d, sp), x
	ldw	(0x0b, sp), y
;	oled_spiro.c: 119: outer_ypos= inner_ypos + (outer * tiny_cos(k));
	ldw	x, (0x05, sp)
	pushw	x
	ldw	x, (0x05, sp)
	pushw	x
	call	_tiny_cos
	addw	sp, #4
	pushw	x
	pushw	y
	ldw	x, (0x21, sp)
	pushw	x
	ldw	x, (0x21, sp)
	pushw	x
	call	___fsmul
	addw	sp, #8
	pushw	x
	pushw	y
	ldw	x, (0x15, sp)
	pushw	x
	ldw	x, (0x15, sp)
	pushw	x
	call	___fsadd
	addw	sp, #8
;	oled_spiro.c: 121: turtle_lineto(outer_xpos, outer_ypos, col);
	ld	a, (0x37, sp)
	ld	(0x21, sp), a
	pushw	x
	pushw	y
	call	___fs2sint
	addw	sp, #4
	ldw	(0x1f, sp), x
	ldw	x, (0x0d, sp)
	pushw	x
	ldw	x, (0x0d, sp)
	pushw	x
	call	___fs2sint
	addw	sp, #4
	ld	a, (0x21, sp)
	push	a
	ldw	y, (0x20, sp)
	pushw	y
	pushw	x
	call	_turtle_lineto
	addw	sp, #5
;	oled_spiro.c: 110: for (i= 0; i< resol + 1; i++)
	ldw	x, (0x01, sp)
	incw	x
	ldw	(0x01, sp), x
	jp	00103$
00105$:
	addw	sp, #43
	ret
;	oled_spiro.c: 126: void oled_putstring(char *p)
;	-----------------------------------------
;	 function oled_putstring
;	-----------------------------------------
_oled_putstring:
;	oled_spiro.c: 128: do
	ldw	x, (0x03, sp)
00103$:
;	oled_spiro.c: 130: if (*p)
	ld	a, (x)
	tnz	a
	jreq	00104$
;	oled_spiro.c: 132: oled_putchar( *p );
	pushw	x
	push	a
	call	_oled_putchar
	pop	a
	popw	x
00104$:
;	oled_spiro.c: 134: } while( *p++);
	ld	a, (x)
	incw	x
	tnz	a
	jrne	00103$
	ret
;	oled_spiro.c: 140: int main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	push	a
;	oled_spiro.c: 144: sysclock_init(0);                     // zuerst System fuer internen Takt
	push	#0x00
	call	_sysclock_init
	pop	a
;	oled_spiro.c: 146: oled_init();
	call	_oled_init
;	oled_spiro.c: 147: clrscr();
	call	_clrscr
;	oled_spiro.c: 148: fb_init(65,8);
	push	#0x08
	push	#0x41
	call	_fb_init
	popw	x
;	oled_spiro.c: 149: fb_clear();
	call	_fb_clear
;	oled_spiro.c: 150: gotoxy(0,0);
	push	#0x00
	push	#0x00
	call	_gotoxy
	popw	x
;	oled_spiro.c: 151: oled_putstring("Grafik erzeugen");
	ldw	x, #___str_0+0
	pushw	x
	call	_oled_putstring
	popw	x
;	oled_spiro.c: 152: spiro_generate(8, 16, 60, 100, 1);
	push	#0x01
	push	#0x00
	push	#0x64
	push	#0x00
	push	#0x3c
	push	#0x00
	push	#0x10
	push	#0x00
	push	#0x08
	push	#0x00
	call	_spiro_generate
	addw	sp, #10
;	oled_spiro.c: 163: while(1)
	ld	a, #0x01
	ld	(0x01, sp), a
00102$:
;	oled_spiro.c: 165: fb_show(cnt, 0);
	push	#0x00
	ld	a, (0x02, sp)
	push	a
	call	_fb_show
	popw	x
;	oled_spiro.c: 166: delay_ms(1000);
	push	#0xe8
	push	#0x03
	call	_delay_ms
	popw	x
;	oled_spiro.c: 167: clrscr();
	call	_clrscr
;	oled_spiro.c: 168: cnt++;
	inc	(0x01, sp)
	jra	00102$
	pop	a
	ret
	.area CODE
___str_0:
	.ascii "Grafik erzeugen"
	.db 0x00
	.area INITIALIZER
	.area CABS (ABS)
