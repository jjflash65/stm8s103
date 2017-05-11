;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Aug 12 2015) (Linux)
; This file was generated Tue May  9 23:41:32 2017
;--------------------------------------------------------
	.module tetristest
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _tfig01
	.globl _main
	.globl _intro
	.globl _box
	.globl _drawfig
	.globl _drawklotz
	.globl _prints
	.globl _putchar
	.globl _utoa
	.globl _strrev
	.globl _scr_update
	.globl _rectangle
	.globl _putpixel
	.globl _lcd_putchar
	.globl _gotoxy
	.globl _lcd_init
	.globl _strlen
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
;	tetristest.c: 46: void strrev(unsigned char *str)                             // fehlt leider in SDCC
;	-----------------------------------------
;	 function strrev
;	-----------------------------------------
_strrev:
	sub	sp, #5
;	tetristest.c: 53: len = strlen((const char *)str);
	ldw	x, (0x08, sp)
	pushw	x
	call	_strlen
	addw	sp, #2
;	tetristest.c: 54: for (i = 0, j = len - 1; i < j; i++, j--)
	clr	a
	ld	xh, a
	decw	x
	clr	(0x03, sp)
	clr	(0x02, sp)
	ldw	(0x04, sp), x
00103$:
	ldw	x, (0x02, sp)
	cpw	x, (0x04, sp)
	jrsge	00105$
;	tetristest.c: 56: a = str[i];
	ldw	y, (0x08, sp)
	addw	y, (0x02, sp)
	ld	a, (y)
	ld	(0x01, sp), a
;	tetristest.c: 57: str[i] = str[j];
	ldw	x, (0x08, sp)
	addw	x, (0x04, sp)
	ld	a, (x)
	ld	(y), a
;	tetristest.c: 58: str[j] = a;
	ld	a, (0x01, sp)
	ld	(x), a
;	tetristest.c: 54: for (i = 0, j = len - 1; i < j; i++, j--)
	ldw	x, (0x02, sp)
	incw	x
	ldw	(0x02, sp), x
	ldw	x, (0x04, sp)
	decw	x
	ldw	(0x04, sp), x
	jra	00103$
00105$:
	addw	sp, #5
	ret
;	tetristest.c: 62: int utoa(uint16_t num, unsigned char* str, int base)   // fehlt leider auch in SDCC
;	-----------------------------------------
;	 function utoa
;	-----------------------------------------
_utoa:
	sub	sp, #7
;	tetristest.c: 65: int i = 0;
	clrw	x
	ldw	(0x03, sp), x
;	tetristest.c: 68: sum= num;
	ldw	y, (0x0a, sp)
	ldw	(0x01, sp), y
;	tetristest.c: 69: do
00105$:
;	tetristest.c: 71: digit = sum % base;
	ldw	x, (0x0e, sp)
	pushw	x
	ldw	x, (0x03, sp)
	pushw	x
	call	__modsint
	addw	sp, #4
;	tetristest.c: 72: if (digit < 0xA) { str[i++] = '0' + digit; }
	ldw	y, (0x03, sp)
	incw	y
	ldw	(0x06, sp), y
	exg	a, xl
	ld	(0x05, sp), a
	exg	a, xl
	cpw	x, #0x000a
	jrsge	00102$
	ldw	x, (0x03, sp)
	ldw	y, (0x06, sp)
	ldw	(0x03, sp), y
	addw	x, (0x0c, sp)
	ld	a, (0x05, sp)
	add	a, #0x30
	ld	(x), a
	jra	00103$
00102$:
;	tetristest.c: 73: else { str[i++] = 'A' + digit - 0x0a; }
	ldw	x, (0x03, sp)
	ldw	y, (0x06, sp)
	ldw	(0x03, sp), y
	addw	x, (0x0c, sp)
	ld	a, (0x05, sp)
	add	a, #0x37
	ld	(x), a
00103$:
;	tetristest.c: 74: sum /= base;
	ldw	x, (0x0e, sp)
	pushw	x
	ldw	x, (0x03, sp)
	pushw	x
	call	__divsint
	addw	sp, #4
	ldw	(0x01, sp), x
;	tetristest.c: 75: }while (sum && (i < 6));                        // max. 6 Zeichen
	ldw	x, (0x01, sp)
	jreq	00107$
	ldw	x, (0x03, sp)
	cpw	x, #0x0006
	jrslt	00105$
00107$:
;	tetristest.c: 76: if (i == 6 && sum) { return -1; }
	ldw	x, (0x03, sp)
	cpw	x, #0x0006
	jrne	00109$
	ldw	x, (0x01, sp)
	jreq	00109$
	ldw	x, #0xffff
	jra	00111$
00109$:
;	tetristest.c: 77: str[i] = '\0';
	ldw	x, (0x0c, sp)
	addw	x, (0x03, sp)
	clr	(x)
;	tetristest.c: 78: strrev(str);
	ldw	x, (0x0c, sp)
	pushw	x
	call	_strrev
	popw	x
;	tetristest.c: 79: return 0;
	clrw	x
00111$:
	addw	sp, #7
	ret
;	tetristest.c: 83: void putchar(char ch)
;	-----------------------------------------
;	 function putchar
;	-----------------------------------------
_putchar:
;	tetristest.c: 87: lcd_putchar(ch);
	ld	a, (0x03, sp)
	push	a
	call	_lcd_putchar
	pop	a
	ret
;	tetristest.c: 90: void prints(char *c)
;	-----------------------------------------
;	 function prints
;	-----------------------------------------
_prints:
;	tetristest.c: 92: while (*c)
	ldw	x, (0x03, sp)
00101$:
	ld	a, (x)
	tnz	a
	jreq	00104$
;	tetristest.c: 94: lcd_putchar(*c++);
	incw	x
	pushw	x
	push	a
	call	_lcd_putchar
	pop	a
	popw	x
	jra	00101$
00104$:
	ret
;	tetristest.c: 98: void drawklotz(uint8_t x, uint8_t y, uint8_t mode)
;	-----------------------------------------
;	 function drawklotz
;	-----------------------------------------
_drawklotz:
	pushw	x
;	tetristest.c: 105: rectangle(drofsx+(x*4), drofsy+(y*4), drofsx+(x*4)+3, drofsy+(y*4)+3, mode);
	ld	a, (0x06, sp)
	ld	xl, a
	sllw	x
	sllw	x
	ld	a, xl
	add	a, #0x0d
	ld	(0x01, sp), a
	ld	a, (0x05, sp)
	sll	a
	sll	a
	push	a
	ld	a, (1, sp)
	add	a, #0x05
	ld	(0x03, sp), a
	pop	a
	addw	x, #10
	add	a, #0x02
	ld	xh, a
	ld	a, (0x07, sp)
	push	a
	ld	a, (0x02, sp)
	push	a
	ld	a, (0x04, sp)
	push	a
	ld	a, xl
	push	a
	ld	a, xh
	push	a
	call	_rectangle
	addw	sp, #7
	ret
;	tetristest.c: 108: void drawfig(uint8_t x, uint8_t y, uint8_t mode, uint8_t nr, uint8_t pos)
;	-----------------------------------------
;	 function drawfig
;	-----------------------------------------
_drawfig:
	sub	sp, #10
;	tetristest.c: 114: b= 0x8000;
	ldw	x, #0x8000
	ldw	(0x02, sp), x
;	tetristest.c: 115: for (i= 0; i< 16; i++)
	ldw	x, #_tfig01+0
	ldw	(0x04, sp), x
	ld	a, (0x11, sp)
	sll	a
	ld	(0x08, sp), a
	clr	(0x01, sp)
00104$:
;	tetristest.c: 117: if ((tfig01[nr][pos] & b))
	ld	a, (0x10, sp)
	ld	(0x07, sp), a
	clr	(0x06, sp)
	ldw	x, (0x06, sp)
	sllw	x
	sllw	x
	sllw	x
	ldw	(0x09, sp), x
	ldw	x, (0x04, sp)
	addw	x, (0x09, sp)
	ld	a, xl
	add	a, (0x08, sp)
	rlwa	x
	adc	a, #0x00
	ld	xh, a
	ldw	x, (x)
	ld	a, xl
	and	a, (0x03, sp)
	rlwa	x
	and	a, (0x02, sp)
	ld	xh, a
	tnzw	x
	jreq	00102$
;	tetristest.c: 119: drawklotz(x+(i % 4), y+(i / 4), mode);
	ld	a, (0x01, sp)
	srl	a
	srl	a
	add	a, (0x0e, sp)
	ld	xh, a
	ld	a, (0x01, sp)
	and	a, #0x03
	add	a, (0x0d, sp)
	ld	xl, a
	ld	a, (0x0f, sp)
	push	a
	ld	a, xh
	push	a
	ld	a, xl
	push	a
	call	_drawklotz
	addw	sp, #3
00102$:
;	tetristest.c: 121: b= b >> 1;
	ldw	x, (0x02, sp)
	srlw	x
	ldw	(0x02, sp), x
;	tetristest.c: 115: for (i= 0; i< 16; i++)
	inc	(0x01, sp)
	ld	a, (0x01, sp)
	cp	a, #0x10
	jrc	00104$
	addw	sp, #10
	ret
;	tetristest.c: 125: void box(uint8_t x1, uint8_t y1, uint8_t x2, uint8_t y2, uint8_t mode)
;	-----------------------------------------
;	 function box
;	-----------------------------------------
_box:
;	tetristest.c: 129: for (y= y1; y<= y2; y++)
	ld	a, (0x04, sp)
	ld	xl, a
00107$:
	ld	a, xl
	cp	a, (0x06, sp)
	jrugt	00109$
;	tetristest.c: 131: for (x= x1; x<= x2; x++)
	ld	a, (0x03, sp)
	ld	xh, a
00104$:
	ld	a, xh
	cp	a, (0x05, sp)
	jrugt	00108$
;	tetristest.c: 133: putpixel(x,y, mode);
	pushw	x
	ld	a, (0x09, sp)
	push	a
	ld	a, xl
	push	a
	ld	a, xh
	push	a
	call	_putpixel
	addw	sp, #3
	popw	x
;	tetristest.c: 131: for (x= x1; x<= x2; x++)
	addw	x, #256
	jra	00104$
00108$:
;	tetristest.c: 129: for (y= y1; y<= y2; y++)
	incw	x
	jra	00107$
00109$:
	ret
;	tetristest.c: 138: void intro(void)
;	-----------------------------------------
;	 function intro
;	-----------------------------------------
_intro:
	pushw	x
;	tetristest.c: 142: for (y= 0; y < 18; y++)
	clr	(0x01, sp)
;	tetristest.c: 144: for (x= 0; x < 11; x++)
00115$:
	clr	(0x02, sp)
00105$:
;	tetristest.c: 146: drawklotz(x,y,1);
	push	#0x01
	ld	a, (0x02, sp)
	push	a
	ld	a, (0x04, sp)
	push	a
	call	_drawklotz
	addw	sp, #3
;	tetristest.c: 147: scr_update();
	call	_scr_update
;	tetristest.c: 148: delay_ms(5);
	push	#0x05
	push	#0x00
	call	_delay_ms
	popw	x
;	tetristest.c: 144: for (x= 0; x < 11; x++)
	inc	(0x02, sp)
	ld	a, (0x02, sp)
	cp	a, #0x0b
	jrc	00105$
;	tetristest.c: 142: for (y= 0; y < 18; y++)
	inc	(0x01, sp)
	ld	a, (0x01, sp)
	cp	a, #0x12
	jrc	00115$
;	tetristest.c: 152: box(3,38,44,49, 0);
	push	#0x00
	push	#0x31
	push	#0x2c
	push	#0x26
	push	#0x03
	call	_box
	addw	sp, #5
;	tetristest.c: 153: gotoxy(1,5); prints("TETRIS");
	push	#0x05
	push	#0x01
	call	_gotoxy
	popw	x
	ldw	x, #___str_0+0
	pushw	x
	call	_prints
	popw	x
;	tetristest.c: 154: scr_update();
	call	_scr_update
;	tetristest.c: 155: delay_ms(4000);
	push	#0xa0
	push	#0x0f
	call	_delay_ms
	popw	x
;	tetristest.c: 156: scr_update();
	call	_scr_update
;	tetristest.c: 157: for (y= 10; y < 82; y++)
	ld	a, #0x0a
	ld	(0x01, sp), a
;	tetristest.c: 159: for (x= 2; x < 47; x++)
00119$:
	ld	a, #0x02
00109$:
;	tetristest.c: 161: putpixel(x,y, 0);
	push	a
	push	#0x00
	exg	a, xl
	ld	a, (0x03, sp)
	exg	a, xl
	pushw	x
	addw	sp, #1
	push	a
	call	_putpixel
	addw	sp, #3
	pop	a
;	tetristest.c: 159: for (x= 2; x < 47; x++)
	inc	a
	cp	a, #0x2f
	jrc	00109$
;	tetristest.c: 163: scr_update();
	call	_scr_update
;	tetristest.c: 164: delay_ms(15);
	push	#0x0f
	push	#0x00
	call	_delay_ms
	popw	x
;	tetristest.c: 157: for (y= 10; y < 82; y++)
	inc	(0x01, sp)
	ld	a, (0x01, sp)
	cp	a, #0x52
	jrc	00119$
;	tetristest.c: 166: delay_ms(1000);
	push	#0xe8
	push	#0x03
	call	_delay_ms
	addw	sp, #4
	ret
;	tetristest.c: 169: int main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #14
;	tetristest.c: 178: sysclock_init(0);
	push	#0x00
	call	_sysclock_init
	pop	a
;	tetristest.c: 180: lcd_init();
	call	_lcd_init
;	tetristest.c: 181: outmode= 1;
	mov	_outmode+0, #0x01
;	tetristest.c: 182: textsize= 0;
	clr	_textsize+0
;	tetristest.c: 185: rectangle(0,8,47,83,1);
	push	#0x01
	push	#0x53
	push	#0x2f
	push	#0x08
	push	#0x00
	call	_rectangle
	addw	sp, #5
;	tetristest.c: 186: intro();
	call	_intro
;	tetristest.c: 187: gotoxy(0,0); prints("Sc:");
	push	#0x00
	push	#0x00
	call	_gotoxy
	popw	x
	ldw	x, #___str_1+0
	pushw	x
	call	_prints
	popw	x
;	tetristest.c: 189: i= 0; fig= 0;
	clr	(0x0b, sp)
	clr	(0x0a, sp)
;	tetristest.c: 190: while(1)
	clrw	x
	ldw	(0x08, sp), x
00104$:
;	tetristest.c: 192: utoa(score,zstring,10);
	ldw	x, sp
	incw	x
	ldw	(0x0d, sp), x
	ldw	x, (0x0d, sp)
	push	#0x0a
	push	#0x00
	pushw	x
	ldw	x, (0x0c, sp)
	pushw	x
	call	_utoa
	addw	sp, #6
;	tetristest.c: 193: gotoxy(4,0); prints(zstring);
	push	#0x00
	push	#0x04
	call	_gotoxy
	popw	x
	ldw	x, (0x0d, sp)
	pushw	x
	call	_prints
	popw	x
;	tetristest.c: 194: drawfig(3+i, 0+i, 1, fig, i);
	ld	a, (0x0b, sp)
	add	a, #0x03
	ld	(0x0c, sp), a
	ld	a, (0x0b, sp)
	push	a
	ld	a, (0x0b, sp)
	push	a
	push	#0x01
	ld	a, (0x0e, sp)
	push	a
	ld	a, (0x10, sp)
	push	a
	call	_drawfig
	addw	sp, #5
;	tetristest.c: 195: scr_update();
	call	_scr_update
;	tetristest.c: 196: delay_ms(500);
	push	#0xf4
	push	#0x01
	call	_delay_ms
	popw	x
;	tetristest.c: 197: drawfig(3+i, 0+i, 0, fig, i);
	ld	a, (0x0b, sp)
	push	a
	ld	a, (0x0b, sp)
	push	a
	push	#0x00
	ld	a, (0x0e, sp)
	push	a
	ld	a, (0x10, sp)
	push	a
	call	_drawfig
	addw	sp, #5
;	tetristest.c: 198: i++;
	ld	a, (0x0b, sp)
	inc	a
;	tetristest.c: 199: i= i % 4;
	and	a, #0x03
	ld	(0x0b, sp), a
;	tetristest.c: 200: if (!i)
	tnz	(0x0b, sp)
	jrne	00102$
;	tetristest.c: 202: fig++;
	ld	a, (0x0a, sp)
	inc	a
;	tetristest.c: 203: fig= fig % (figanz);
	push	#0x07
	push	a
	call	__moduschar
	addw	sp, #2
	ld	a, xl
	ld	(0x0a, sp), a
00102$:
;	tetristest.c: 205: score++;
	ldw	x, (0x08, sp)
	incw	x
	ldw	(0x08, sp), x
	jra	00104$
;	tetristest.c: 208: while(1);
	addw	sp, #14
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
_tfig01:
	.dw #0xE400
	.dw #0x4C40
	.dw #0x4E00
	.dw #0x4640
	.dw #0xE200
	.dw #0x44C0
	.dw #0x8E00
	.dw #0x6440
	.dw #0xE800
	.dw #0xC440
	.dw #0x2E00
	.dw #0x4460
	.dw #0x6C00
	.dw #0x8C40
	.dw #0x6C00
	.dw #0x8C40
	.dw #0xC600
	.dw #0x4C80
	.dw #0xC600
	.dw #0x4C80
	.dw #0xCC00
	.dw #0xCC00
	.dw #0xCC00
	.dw #0xCC00
	.dw #0xF000
	.dw #0x4444
	.dw #0xF000
	.dw #0x4444
___str_0:
	.ascii "TETRIS"
	.db 0x00
___str_1:
	.ascii "Sc:"
	.db 0x00
	.area INITIALIZER
	.area CABS (ABS)
