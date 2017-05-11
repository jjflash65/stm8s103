;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Aug 12 2015) (Linux)
; This file was generated Tue Mar 28 00:25:14 2017
;--------------------------------------------------------
	.module tiny32_printf
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _my_printf
	.globl _putstring
	.globl _puthex
	.globl _hexnibbleout
	.globl _putint
	.globl _lcd_putchar_d
	.globl _gotoxy
	.globl _clrscr
	.globl _lcd_init
	.globl _sysclock_init
	.globl _printfkomma
	.globl _my_putchar
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
_putint_zz_1_16:
	.ds 28
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
_printfkomma::
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
;	tiny32_printf.c: 51: static uint32_t zz[]  = { 10000000, 1000000, 100000, 10000, 1000, 100, 10 };
	ldw	x, #_putint_zz_1_16+0
	ldw	y, x
	ld	a, xl
	rlwa	x
	ld	a, yh
	rrwa	x
	push	a
	ld	a, #0x80
	ld	(0x3, x), a
	ld	a, #0x96
	ld	(0x2, x), a
	ld	a, #0x98
	ld	(0x1, x), a
	clr	(x)
	pop	a
	ld	xl, a
	rlwa	x
	ld	a, yh
	rrwa	x
	addw	x, #0x0004
	push	a
	ld	a, #0x40
	ld	(0x3, x), a
	ld	a, #0x42
	ld	(0x2, x), a
	ld	a, #0x0f
	ld	(0x1, x), a
	clr	(x)
	pop	a
	ld	xl, a
	rlwa	x
	ld	a, yh
	rrwa	x
	addw	x, #0x0008
	push	a
	ld	a, #0xa0
	ld	(0x3, x), a
	ld	a, #0x86
	ld	(0x2, x), a
	ld	a, #0x01
	ld	(0x1, x), a
	clr	(x)
	pop	a
	ld	xl, a
	rlwa	x
	ld	a, yh
	rrwa	x
	addw	x, #0x000c
	push	a
	ld	a, #0x10
	ld	(0x3, x), a
	ld	a, #0x27
	ld	(0x2, x), a
	clr	(0x1, x)
	clr	(x)
	pop	a
	ld	xl, a
	rlwa	x
	ld	a, yh
	rrwa	x
	addw	x, #0x0010
	push	a
	ld	a, #0xe8
	ld	(0x3, x), a
	ld	a, #0x03
	ld	(0x2, x), a
	clr	(0x1, x)
	clr	(x)
	pop	a
	ld	xl, a
	rlwa	x
	ld	a, yh
	rrwa	x
	addw	x, #0x0014
	push	a
	ld	a, #0x64
	ld	(0x3, x), a
	clr	(0x2, x)
	clr	(0x1, x)
	clr	(x)
	pop	a
	ld	xl, a
	rlwa	x
	ld	a, yh
	rrwa	x
	addw	x, #0x0018
	ldw	y, #0x000a
	ldw	(0x2, x), y
	clr	(0x1, x)
	clr	(x)
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
;	tiny32_printf.c: 47: void putint(int32_t i, char komma)
;	-----------------------------------------
;	 function putint
;	-----------------------------------------
_putint:
	sub	sp, #32
;	tiny32_printf.c: 52: bool_t not_first = FALSE;
	clr	(0x0a, sp)
;	tiny32_printf.c: 57: komma= 8-komma;
	ld	a, #0x08
	sub	a, (0x27, sp)
	ld	(0x27, sp), a
;	tiny32_printf.c: 59: if (!i)
	ldw	x, (0x25, sp)
	jrne	00115$
	ldw	x, (0x23, sp)
	jrne	00115$
;	tiny32_printf.c: 61: my_putchar('0');
	push	#0x30
	call	_my_putchar
	pop	a
	jp	00119$
00115$:
;	tiny32_printf.c: 65: if(i < 0)
	tnz	(0x23, sp)
	jrpl	00128$
;	tiny32_printf.c: 67: my_putchar('-');
	push	#0x2d
	call	_my_putchar
	pop	a
;	tiny32_printf.c: 68: i = -i;
	ldw	y, (0x25, sp)
	negw	y
	clr	a
	sbc	a, (0x24, sp)
	ld	xl, a
	clr	a
	sbc	a, (0x23, sp)
	ld	xh, a
	ldw	(0x25, sp), y
	ldw	(0x23, sp), x
;	tiny32_printf.c: 71: for(zi = 0; zi < 7; zi++)
00128$:
	ldw	x, #_putint_zz_1_16+0
	ldw	(0x1f, sp), x
	clr	(0x09, sp)
00117$:
;	tiny32_printf.c: 73: z = 0;
	clrw	x
	ldw	(0x07, sp), x
	ldw	(0x05, sp), x
;	tiny32_printf.c: 76: while(z + zz[zi] <= i)
	clrw	x
	ldw	(0x03, sp), x
	ldw	(0x01, sp), x
00103$:
	ld	a, (0x09, sp)
	ld	(0x14, sp), a
	clr	(0x13, sp)
	ldw	x, (0x13, sp)
	sllw	x
	sllw	x
	addw	x, (0x1f, sp)
	pushw	x
	ldw	x, (0x2, x)
	exgw	x, y
	popw	x
	ldw	x, (x)
	addw	y, (0x07, sp)
	ldw	(0x11, sp), y
	ld	a, xl
	adc	a, (0x06, sp)
	ld	(0x10, sp), a
	ld	a, xh
	adc	a, (0x05, sp)
	ld	(0x0f, sp), a
	ldw	y, (0x25, sp)
	ldw	(0x17, sp), y
	ldw	y, (0x23, sp)
	ldw	(0x15, sp), y
	ldw	x, (0x17, sp)
	cpw	x, (0x11, sp)
	ld	a, (0x16, sp)
	sbc	a, (0x10, sp)
	ld	a, (0x15, sp)
	sbc	a, (0x0f, sp)
	jrc	00130$
;	tiny32_printf.c: 78: b++;
	ldw	x, (0x03, sp)
	addw	x, #0x0001
	ldw	(0x03, sp), x
	ld	a, (0x02, sp)
	adc	a, #0x00
	ld	(0x02, sp), a
	ld	a, (0x01, sp)
	adc	a, #0x00
	ld	(0x01, sp), a
;	tiny32_printf.c: 79: z += zz[zi];
	ldw	y, (0x11, sp)
	ldw	x, (0x0f, sp)
	ldw	(0x07, sp), y
	ldw	(0x05, sp), x
	jra	00103$
00130$:
	ldw	y, (0x03, sp)
	ldw	(0x0d, sp), y
	ldw	y, (0x01, sp)
	ldw	(0x0b, sp), y
;	tiny32_printf.c: 82: if(b || not_first)
	ldw	x, (0x03, sp)
	jrne	00106$
	ldw	x, (0x01, sp)
	jrne	00106$
	tnz	(0x0a, sp)
	jreq	00107$
00106$:
;	tiny32_printf.c: 84: my_putchar('0' + b);
	ld	a, (0x0e, sp)
	add	a, #0x30
	push	a
	call	_my_putchar
	pop	a
;	tiny32_printf.c: 85: not_first = TRUE;
	ld	a, #0x01
	ld	(0x0a, sp), a
00107$:
;	tiny32_printf.c: 88: if (zi+1 == komma)
	ldw	x, (0x13, sp)
	incw	x
	ld	a, (0x27, sp)
	ld	(0x1a, sp), a
	ld	a, (0x1a, sp)
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	(0x19, sp), a
	cpw	x, (0x19, sp)
	jrne	00112$
;	tiny32_printf.c: 90: if (!not_first) my_putchar('0');
	tnz	(0x0a, sp)
	jrne	00110$
	push	#0x30
	call	_my_putchar
	pop	a
00110$:
;	tiny32_printf.c: 91: my_putchar('.');
	push	#0x2e
	call	_my_putchar
	pop	a
;	tiny32_printf.c: 92: not_first= TRUE;
	ld	a, #0x01
	ld	(0x0a, sp), a
00112$:
;	tiny32_printf.c: 95: i -= z;
	ldw	x, (0x17, sp)
	subw	x, (0x07, sp)
	ldw	(0x1d, sp), x
	ld	a, (0x16, sp)
	sbc	a, (0x06, sp)
	ld	(0x1c, sp), a
	ld	a, (0x15, sp)
	sbc	a, (0x05, sp)
	ld	(0x1b, sp), a
	ldw	y, (0x1d, sp)
	ldw	(0x25, sp), y
	ldw	y, (0x1b, sp)
	ldw	(0x23, sp), y
;	tiny32_printf.c: 71: for(zi = 0; zi < 7; zi++)
	inc	(0x09, sp)
	ld	a, (0x09, sp)
	cp	a, #0x07
	jrnc	00170$
	jp	00117$
00170$:
;	tiny32_printf.c: 97: my_putchar('0' + i);
	ld	a, (0x26, sp)
	add	a, #0x30
	push	a
	call	_my_putchar
	pop	a
00119$:
	addw	sp, #32
	ret
;	tiny32_printf.c: 107: void hexnibbleout(uint8_t b)
;	-----------------------------------------
;	 function hexnibbleout
;	-----------------------------------------
_hexnibbleout:
;	tiny32_printf.c: 109: if (b< 10) b+= '0'; else b+= 55;
	ld	a, (0x03, sp)
	cp	a, #0x0a
	jrnc	00102$
	ld	a, (0x03, sp)
	add	a, #0x30
	ld	(0x03, sp), a
	jra	00103$
00102$:
	ld	a, (0x03, sp)
	add	a, #0x37
	ld	(0x03, sp), a
00103$:
;	tiny32_printf.c: 110: my_putchar(b);
	ld	a, (0x03, sp)
	push	a
	call	_my_putchar
	pop	a
	ret
;	tiny32_printf.c: 121: void puthex(uint16_t h, char out16)
;	-----------------------------------------
;	 function puthex
;	-----------------------------------------
_puthex:
	sub	sp, #4
;	tiny32_printf.c: 125: if ((h> 0xff) || out16)                    // 16 Bit-Wert
	tnz	(0x07, sp)
	jrne	00101$
	tnz	(0x09, sp)
	jreq	00102$
00101$:
;	tiny32_printf.c: 127: b= (h >> 12);
	ld	a, (0x07, sp)
	clr	(0x01, sp)
	swap	a
	and	a, #0x0f
;	tiny32_printf.c: 128: hexnibbleout(b);
	push	a
	call	_hexnibbleout
	pop	a
;	tiny32_printf.c: 129: b= (h >> 8) & 0x0f;
	ld	a, (0x07, sp)
	clr	(0x03, sp)
	and	a, #0x0f
	ld	xh, a
	clr	a
;	tiny32_printf.c: 130: hexnibbleout(b);
	ld	a, xh
	push	a
	call	_hexnibbleout
	pop	a
00102$:
;	tiny32_printf.c: 133: b= (h >> 4) & 0x0f;
	ldw	x, (0x07, sp)
	ld	a, #0x10
	div	x, a
	ld	a, xl
	and	a, #0x0f
	ld	xl, a
	clr	a
;	tiny32_printf.c: 134: hexnibbleout(b);
	ld	a, xl
	push	a
	call	_hexnibbleout
	pop	a
;	tiny32_printf.c: 135: b= h & 0x0f;
	ld	a, (0x08, sp)
	and	a, #0x0f
	ld	xh, a
	clr	a
;	tiny32_printf.c: 136: hexnibbleout(b);
	ld	a, xh
	push	a
	call	_hexnibbleout
	addw	sp, #5
	ret
;	tiny32_printf.c: 140: void putstring(char *p)
;	-----------------------------------------
;	 function putstring
;	-----------------------------------------
_putstring:
;	tiny32_printf.c: 142: while(*p)
	ldw	x, (0x03, sp)
00101$:
	ld	a, (x)
	tnz	a
	jreq	00104$
;	tiny32_printf.c: 144: my_putchar( *p );
	pushw	x
	push	a
	call	_my_putchar
	pop	a
	popw	x
;	tiny32_printf.c: 145: p++;
	incw	x
	jra	00101$
00104$:
	ret
;	tiny32_printf.c: 173: void my_printf(const char *s,...)
;	-----------------------------------------
;	 function my_printf
;	-----------------------------------------
_my_printf:
	sub	sp, #14
;	tiny32_printf.c: 182: va_start(ap,s);
	ldw	x, sp
	addw	x, #17
	incw	x
	incw	x
	ldw	(0x06, sp), x
;	tiny32_printf.c: 183: do
00116$:
;	tiny32_printf.c: 185: ch= *s;
	ldw	x, (0x11, sp)
	ld	a, (x)
	ld	(0x01, sp), a
;	tiny32_printf.c: 186: if(ch== 0) return;
	tnz	(0x01, sp)
	jrne	00102$
	jp	00119$
00102$:
;	tiny32_printf.c: 188: if(ch=='%')            // Platzhalterzeichen
	ld	a, (0x01, sp)
	cp	a, #0x25
	jreq	00164$
	jp	00114$
00164$:
;	tiny32_printf.c: 190: s++;
	incw	x
	ldw	(0x11, sp), x
;	tiny32_printf.c: 191: token= *s;
	ldw	x, (0x11, sp)
	ld	a, (x)
;	tiny32_printf.c: 192: switch(token)
	ld	(0x0a, sp), a
	push	a
	ld	a, (0x0b, sp)
	cp	a, #0x25
	pop	a
	jrne	00166$
	jp	00110$
00166$:
;	tiny32_printf.c: 223: arg1= va_arg(ap,int);
	ldw	y, (0x06, sp)
	addw	y, #0x0002
	exg	a, xl
	ld	a, yl
	exg	a, xl
	rlwa	x
	ld	a, yh
	rrwa	x
	decw	x
	decw	x
;	tiny32_printf.c: 192: switch(token)
	ld	a, (0x0a, sp)
	cp	a, #0x63
	jrne	00169$
	jp	00109$
00169$:
;	tiny32_printf.c: 196: arg1= va_arg(ap,int32_t);
	ld	a, (0x07, sp)
	add	a, #0x04
	ld	(0x09, sp), a
	ld	a, (0x06, sp)
	adc	a, #0x00
	ld	(0x08, sp), a
	ld	a, (0x09, sp)
	sub	a, #0x04
	ld	(0x0e, sp), a
	ld	a, (0x08, sp)
	sbc	a, #0x00
	ld	(0x0d, sp), a
	ld	a, (0x0d, sp)
	ld	(0x0b, sp), a
	ld	a, (0x0e, sp)
	ld	(0x0c, sp), a
;	tiny32_printf.c: 192: switch(token)
	ld	a, (0x0a, sp)
	cp	a, #0x64
	jreq	00103$
	ld	a, (0x0a, sp)
	cp	a, #0x6b
	jreq	00108$
	ld	a, (0x0a, sp)
	cp	a, #0x73
	jrne	00178$
	jp	00111$
00178$:
	ld	a, (0x0a, sp)
	cp	a, #0x78
	jreq	00104$
	jp	00115$
;	tiny32_printf.c: 194: case 'd':          // dezimale Ausgabe
00103$:
;	tiny32_printf.c: 196: arg1= va_arg(ap,int32_t);
	ldw	y, (0x08, sp)
	ldw	(0x06, sp), y
	ldw	x, (0x0b, sp)
	pushw	x
	ldw	x, (0x2, x)
	exgw	x, y
	popw	x
	ldw	x, (x)
;	tiny32_printf.c: 197: putint(arg1,0);
	push	#0x00
	pushw	y
	pushw	x
	call	_putint
	addw	sp, #5
;	tiny32_printf.c: 198: break;
	jp	00115$
;	tiny32_printf.c: 200: case 'x':          // hexadezimale Ausgabe
00104$:
;	tiny32_printf.c: 202: xarg1= va_arg(ap,uint32_t);
	ldw	y, (0x08, sp)
	ldw	(0x06, sp), y
	ldw	x, (0x0d, sp)
	pushw	x
	ldw	x, (0x2, x)
	exgw	x, y
	popw	x
	ldw	x, (x)
	ldw	(0x04, sp), y
	ldw	(0x02, sp), x
;	tiny32_printf.c: 203: if (xarg1 <= 0xFFFF)
	ldw	x, (0x02, sp)
	tnzw	x
	jrne	00106$
;	tiny32_printf.c: 205: puthex(xarg1, 0);
	ldw	x, (0x04, sp)
	push	#0x00
	pushw	x
	call	_puthex
	addw	sp, #3
	jra	00115$
00106$:
;	tiny32_printf.c: 209: puthex(xarg1 >> 16,0);
	ldw	y, (0x02, sp)
	clrw	x
	push	#0x00
	pushw	y
	call	_puthex
	addw	sp, #3
;	tiny32_printf.c: 210: puthex(xarg1 & 0xffff,1);
	ldw	x, (0x04, sp)
	clrw	y
	push	#0x01
	pushw	x
	call	_puthex
	addw	sp, #3
;	tiny32_printf.c: 213: break;
	jra	00115$
;	tiny32_printf.c: 215: case 'k':
00108$:
;	tiny32_printf.c: 217: arg1= va_arg(ap,int32_t);
	ldw	y, (0x08, sp)
	ldw	(0x06, sp), y
	ldw	x, (0x0b, sp)
	pushw	x
	ldw	x, (0x2, x)
	exgw	x, y
	popw	x
	ldw	x, (x)
;	tiny32_printf.c: 218: putint(arg1,printfkomma);     // Integerausgabe mit Komma: 12896 zeigt 12.896 an
	push	_printfkomma+0
	pushw	y
	pushw	x
	call	_putint
	addw	sp, #5
;	tiny32_printf.c: 219: break;
	jra	00115$
;	tiny32_printf.c: 221: case 'c':          // Zeichenausgabe
00109$:
;	tiny32_printf.c: 223: arg1= va_arg(ap,int);
	ldw	(0x06, sp), y
	ldw	x, (x)
	clrw	y
	tnzw	x
	jrpl	00184$
	decw	y
00184$:
	ld	a, xl
;	tiny32_printf.c: 224: my_putchar(arg1);
	push	a
	call	_my_putchar
	pop	a
;	tiny32_printf.c: 225: break;
	jra	00115$
;	tiny32_printf.c: 227: case '%':
00110$:
;	tiny32_printf.c: 229: my_putchar(token);
	push	a
	call	_my_putchar
	pop	a
;	tiny32_printf.c: 230: break;
	jra	00115$
;	tiny32_printf.c: 232: case 's':
00111$:
;	tiny32_printf.c: 234: arg2= va_arg(ap,char *);
	ldw	(0x06, sp), y
	ldw	x, (x)
;	tiny32_printf.c: 235: putstring(arg2);
	pushw	x
	call	_putstring
	popw	x
;	tiny32_printf.c: 238: }
	jra	00115$
00114$:
;	tiny32_printf.c: 242: my_putchar(ch);
	ld	a, (0x01, sp)
	push	a
	call	_my_putchar
	pop	a
00115$:
;	tiny32_printf.c: 244: s++;
	ldw	x, (0x11, sp)
	incw	x
	ldw	(0x11, sp), x
;	tiny32_printf.c: 245: }while (ch != '\0');
	tnz	(0x01, sp)
	jreq	00185$
	jp	00116$
00185$:
00119$:
	addw	sp, #14
	ret
;	tiny32_printf.c: 255: void my_putchar(char ch)
;	-----------------------------------------
;	 function my_putchar
;	-----------------------------------------
_my_putchar:
;	tiny32_printf.c: 257: lcd_putchar_d(ch);
	ld	a, (0x03, sp)
	push	a
	call	_lcd_putchar_d
	pop	a
	ret
;	tiny32_printf.c: 263: int main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #11
;	tiny32_printf.c: 265: char mystring[] = "R.Seelig";
	ldw	x, sp
	incw	x
	ldw	(0x0a, sp), x
	ldw	x, (0x0a, sp)
	ld	a, #0x52
	ld	(x), a
	ldw	x, (0x0a, sp)
	incw	x
	ld	a, #0x2e
	ld	(x), a
	ldw	x, (0x0a, sp)
	incw	x
	incw	x
	ld	a, #0x53
	ld	(x), a
	ldw	x, (0x0a, sp)
	ld	a, #0x65
	ld	(0x0003, x), a
	ldw	x, (0x0a, sp)
	ld	a, #0x65
	ld	(0x0004, x), a
	ldw	x, (0x0a, sp)
	ld	a, #0x6c
	ld	(0x0005, x), a
	ldw	x, (0x0a, sp)
	ld	a, #0x69
	ld	(0x0006, x), a
	ldw	x, (0x0a, sp)
	ld	a, #0x67
	ld	(0x0007, x), a
	ldw	x, (0x0a, sp)
	addw	x, #0x0008
	clr	(x)
;	tiny32_printf.c: 271: sysclock_init(0);
	push	#0x00
	call	_sysclock_init
	pop	a
;	tiny32_printf.c: 273: printfkomma= 4;
	mov	_printfkomma+0, #0x04
;	tiny32_printf.c: 275: lcd_init();
	call	_lcd_init
;	tiny32_printf.c: 276: clrscr();
	call	_clrscr
;	tiny32_printf.c: 278: gotoxy(0,0);
	push	#0x00
	push	#0x00
	call	_gotoxy
	popw	x
;	tiny32_printf.c: 279: printf("Text: %s",mystring);
	ldw	y, (0x0a, sp)
	ldw	x, #___str_1+0
	pushw	y
	pushw	x
	call	_my_printf
	addw	sp, #4
;	tiny32_printf.c: 280: printf("\n\rHex: %x",hexwert);
	ldw	x, #___str_2+0
	push	#0xa4
	push	#0x03
	push	#0x4a
	push	#0x00
	pushw	x
	call	_my_printf
	addw	sp, #6
;	tiny32_printf.c: 281: printf("\n\rDez: %d", dezwert);
	ldw	x, #___str_3+0
	push	#0xe1
	push	#0xc5
	push	#0x04
	push	#0x00
	pushw	x
	call	_my_printf
	addw	sp, #6
;	tiny32_printf.c: 282: printf("\n\r%k", pseudokomma);
	ldw	x, #___str_4+0
	push	#0x4b
	push	#0xc5
	push	#0x67
	push	#0xff
	pushw	x
	call	_my_printf
	addw	sp, #6
;	tiny32_printf.c: 283: printf("\n\r");
	ldw	x, #___str_5+0
	pushw	x
	call	_my_printf
	popw	x
;	tiny32_printf.c: 285: while(1);
00102$:
	jra	00102$
	addw	sp, #11
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
___str_1:
	.ascii "Text: %s"
	.db 0x00
___str_2:
	.db 0x0A
	.db 0x0D
	.ascii "Hex: %x"
	.db 0x00
___str_3:
	.db 0x0A
	.db 0x0D
	.ascii "Dez: %d"
	.db 0x00
___str_4:
	.db 0x0A
	.db 0x0D
	.ascii "%k"
	.db 0x00
___str_5:
	.db 0x0A
	.db 0x0D
	.db 0x00
	.area INITIALIZER
__xinit__printfkomma:
	.db #0x04	;  4
	.area CABS (ABS)
