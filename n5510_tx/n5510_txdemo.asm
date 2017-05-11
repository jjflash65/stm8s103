;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Aug 12 2015) (Linux)
; This file was generated Tue Mar 28 00:00:55 2017
;--------------------------------------------------------
	.module n5510_txdemo
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _lcd_putdoublechar
	.globl _lcd_putchar_d
	.globl _gotoxy
	.globl _clrscr
	.globl _wrdata
	.globl _lcd_init
	.globl _my_printf
	.globl _delay_ms
	.globl _sysclock_init
	.globl _doublechar
	.globl _putchar
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
_doublechar::
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
;	n5510_txdemo.c: 46: void lcd_putdoublechar(uint8_t ch)
;	-----------------------------------------
;	 function lcd_putdoublechar
;	-----------------------------------------
_lcd_putdoublechar:
	sub	sp, #19
;	n5510_txdemo.c: 52: x= wherex; y= wherey;
	ld	a, _wherex+0
	ld	(0x02, sp), a
	ld	a, _wherey+0
	ld	(0x01, sp), a
;	n5510_txdemo.c: 53: if ((ch<0x20)||(ch>lastascii)) ch = 92;               // nicht anzeigbares Zeichen durch Ascii 92 ersetzen
	ld	a, (0x16, sp)
	cp	a, #0x20
	jrc	00101$
	ld	a, (0x16, sp)
	cp	a, #0x7e
	jrule	00131$
00101$:
	ld	a, #0x5c
	ld	(0x16, sp), a
;	n5510_txdemo.c: 57: for (b= 0;b<5;b++)
00131$:
	ldw	x, #_fonttab+0
	ldw	(0x0f, sp), x
	clrw	x
	ldw	(0x07, sp), x
00118$:
;	n5510_txdemo.c: 59: rb= fonttab[ch-32][b];
	clrw	x
	ld	a, (0x16, sp)
	ld	xl, a
	subw	x, #0x0020
	pushw	x
	push	#0x05
	push	#0x00
	call	__mulint
	addw	sp, #4
	addw	x, (0x0f, sp)
	ldw	(0x11, sp), x
	ldw	x, (0x11, sp)
	addw	x, (0x07, sp)
	ld	a, (x)
	clrw	x
	ld	xl, a
	ldw	(0x0c, sp), x
;	n5510_txdemo.c: 60: dbch= 0;
	clr	(0x0e, sp)
;	n5510_txdemo.c: 61: for (d= 0; d< 4; d++)
	clr	(0x04, sp)
00116$:
;	n5510_txdemo.c: 63: if (rb & (1 << d))
	ldw	x, #0x0001
	ld	a, (0x04, sp)
	jreq	00185$
00184$:
	sllw	x
	dec	a
	jrne	00184$
00185$:
	ld	a, xl
	and	a, (0x0d, sp)
	ld	(0x0b, sp), a
	ld	a, xh
	and	a, (0x0c, sp)
	ld	(0x0a, sp), a
	ldw	x, (0x0a, sp)
	jreq	00117$
;	n5510_txdemo.c: 65: dbch |= (1 << (d*2)) | (1 << ((d*2)+1));
	ld	a, (0x04, sp)
	ld	xl, a
	sllw	x
	ld	a, #0x01
	ld	(0x09, sp), a
	ld	a, xl
	tnz	a
	jreq	00188$
00187$:
	sll	(0x09, sp)
	dec	a
	jrne	00187$
00188$:
	incw	x
	ld	a, #0x01
	push	a
	ld	a, xl
	tnz	a
	jreq	00190$
00189$:
	sll	(1, sp)
	dec	a
	jrne	00189$
00190$:
	pop	a
	or	a, (0x09, sp)
	or	a, (0x0e, sp)
	ld	(0x0e, sp), a
00117$:
;	n5510_txdemo.c: 61: for (d= 0; d< 4; d++)
	inc	(0x04, sp)
	ld	a, (0x04, sp)
	cp	a, #0x04
	jrc	00116$
;	n5510_txdemo.c: 68: rb= dbch;
	clrw	x
	ld	a, (0x0e, sp)
	ld	xl, a
;	n5510_txdemo.c: 69: if (invchar) {rb= ~rb;}
	tnz	_invchar+0
	jreq	00108$
	ld	xl, a
	cplw	x
	ld	a, xl
00108$:
;	n5510_txdemo.c: 70: wrdata(rb);
	push	a
	push	a
	call	_wrdata
	pop	a
	call	_wrdata
	pop	a
;	n5510_txdemo.c: 57: for (b= 0;b<5;b++)
	ldw	x, (0x07, sp)
	incw	x
	ldw	(0x07, sp), x
	ldw	x, (0x07, sp)
	cpw	x, #0x0005
	jrsge	00193$
	jp	00118$
00193$:
;	n5510_txdemo.c: 73: gotoxy(x,y+1);
	ld	a, (0x01, sp)
	inc	a
	push	a
	ld	a, (0x03, sp)
	push	a
	call	_gotoxy
	popw	x
;	n5510_txdemo.c: 74: for (b= 0;b<5;b++)
	clrw	x
	ldw	(0x07, sp), x
00122$:
;	n5510_txdemo.c: 76: rb= fonttab[ch-32][b];
	ldw	x, (0x11, sp)
	addw	x, (0x07, sp)
	ld	a, (x)
	clrw	x
	ld	xl, a
	ldw	(0x05, sp), x
;	n5510_txdemo.c: 77: dbch= 0;
	clr	(0x03, sp)
;	n5510_txdemo.c: 78: for (d= 4; d< 8; d++)
	ld	a, #0x04
	ld	(0x04, sp), a
00120$:
;	n5510_txdemo.c: 80: if (rb & (1 << d))
	ldw	x, #0x0001
	ld	a, (0x04, sp)
	jreq	00195$
00194$:
	sllw	x
	dec	a
	jrne	00194$
00195$:
	ld	a, xl
	and	a, (0x06, sp)
	rlwa	x
	and	a, (0x05, sp)
	ld	xh, a
	tnzw	x
	jreq	00121$
;	n5510_txdemo.c: 82: dbch |= (1 << ((d-4)*2)) | (1 << (((d-4)*2)+1));
	ld	a, (0x04, sp)
	sub	a, #0x04
	sll	a
	ld	xl, a
	ld	a, #0x01
	ld	(0x13, sp), a
	ld	a, xl
	tnz	a
	jreq	00198$
00197$:
	sll	(0x13, sp)
	dec	a
	jrne	00197$
00198$:
	incw	x
	ld	a, #0x01
	push	a
	ld	a, xl
	tnz	a
	jreq	00200$
00199$:
	sll	(1, sp)
	dec	a
	jrne	00199$
00200$:
	pop	a
	or	a, (0x13, sp)
	or	a, (0x03, sp)
	ld	(0x03, sp), a
00121$:
;	n5510_txdemo.c: 78: for (d= 4; d< 8; d++)
	inc	(0x04, sp)
	ld	a, (0x04, sp)
	cp	a, #0x08
	jrc	00120$
;	n5510_txdemo.c: 85: rb= dbch;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
;	n5510_txdemo.c: 86: if (invchar) {rb= ~rb;}
	tnz	_invchar+0
	jreq	00114$
	cplw	x
00114$:
;	n5510_txdemo.c: 87: wrdata(rb);
	ld	a, xl
	push	a
	push	a
	call	_wrdata
	pop	a
	call	_wrdata
	pop	a
;	n5510_txdemo.c: 74: for (b= 0;b<5;b++)
	ldw	x, (0x07, sp)
	incw	x
	ldw	(0x07, sp), x
	ldw	x, (0x07, sp)
	cpw	x, #0x0005
	jrslt	00122$
;	n5510_txdemo.c: 90: gotoxy(x+2,y);
	ld	a, (0x02, sp)
	add	a, #0x02
	ld	xh, a
	ld	a, (0x01, sp)
	push	a
	ld	a, xh
	push	a
	call	_gotoxy
	addw	sp, #21
	ret
;	n5510_txdemo.c: 101: void putchar(char ch)
;	-----------------------------------------
;	 function putchar
;	-----------------------------------------
_putchar:
;	n5510_txdemo.c: 103: if (doublechar)
	tnz	_doublechar+0
	jreq	00102$
;	n5510_txdemo.c: 105: lcd_putdoublechar(ch);
	ld	a, (0x03, sp)
	push	a
	call	_lcd_putdoublechar
	pop	a
	jra	00104$
00102$:
;	n5510_txdemo.c: 109: lcd_putchar_d(ch);
	ld	a, (0x03, sp)
	push	a
	call	_lcd_putchar_d
	pop	a
00104$:
	ret
;	n5510_txdemo.c: 113: int main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #6
;	n5510_txdemo.c: 117: sysclock_init(0);
	push	#0x00
	call	_sysclock_init
	pop	a
;	n5510_txdemo.c: 119: bled_output_init();
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
;	n5510_txdemo.c: 120: exled_output_init();
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
;	n5510_txdemo.c: 121: button_input_init();
	ldw	x, #0x5011
	ld	a, (x)
	and	a, #0xfb
	ld	(x), a
	ldw	x, #0x5012
	ld	a, (x)
	or	a, #0x04
	ld	(x), a
;	n5510_txdemo.c: 123: printfkomma= 2;
	mov	_printfkomma+0, #0x02
;	n5510_txdemo.c: 125: lcd_init();
	call	_lcd_init
;	n5510_txdemo.c: 126: clrscr();
	call	_clrscr
;	n5510_txdemo.c: 127: gotoxy(0,0);
	push	#0x00
	push	#0x00
	call	_gotoxy
	popw	x
;	n5510_txdemo.c: 128: printf(" STM8S103F3P6\n\r");
	ldw	x, #___str_0+0
	ldw	(0x03, sp), x
	ldw	x, (0x03, sp)
	pushw	x
	call	_my_printf
	popw	x
;	n5510_txdemo.c: 129: printf(" doppelt gross\n\r");
	ldw	x, #___str_1+0
	pushw	x
	call	_my_printf
	popw	x
;	n5510_txdemo.c: 130: printf("--------------\n\r");
	ldw	x, #___str_2+0
	ldw	(0x01, sp), x
	ldw	x, (0x01, sp)
	pushw	x
	call	_my_printf
	popw	x
;	n5510_txdemo.c: 131: printf("88  93  98 103 108");
	ldw	x, #___str_3+0
	pushw	x
	call	_my_printf
	popw	x
;	n5510_txdemo.c: 133: gotoxy(0,4);
	push	#0x04
	push	#0x00
	call	_gotoxy
	popw	x
;	n5510_txdemo.c: 134: doublechar=1;
	mov	_doublechar+0, #0x01
;	n5510_txdemo.c: 135: printf("STM8S");
	ldw	x, #___str_4+0
	pushw	x
	call	_my_printf
	popw	x
;	n5510_txdemo.c: 136: doublechar=0;
	clr	_doublechar+0
;	n5510_txdemo.c: 138: while(is_button());
00101$:
	ldw	x, #0x5010
	ld	a, (x)
	and	a, #0x04
	srl	a
	srl	a
	tnz	a
	jrne	00101$
;	n5510_txdemo.c: 139: delay_ms(100);
	push	#0x64
	push	#0x00
	call	_delay_ms
	popw	x
;	n5510_txdemo.c: 141: clrscr();
	call	_clrscr
;	n5510_txdemo.c: 142: gotoxy(0,0);
	push	#0x00
	push	#0x00
	call	_gotoxy
	popw	x
;	n5510_txdemo.c: 144: printf(" STM8S103F3P6\n\r");
	ldw	x, (0x03, sp)
	pushw	x
	call	_my_printf
	popw	x
;	n5510_txdemo.c: 145: printf("    16MHz\n\r");
	ldw	x, #___str_5+0
	pushw	x
	call	_my_printf
	popw	x
;	n5510_txdemo.c: 146: printf("--------------\n\r");
	ldw	x, (0x01, sp)
	pushw	x
	call	_my_printf
	popw	x
;	n5510_txdemo.c: 147: printf("by R.Seelig");
	ldw	x, #___str_6+0
	pushw	x
	call	_my_printf
	popw	x
;	n5510_txdemo.c: 149: cnt= 0;
	clrw	x
	ldw	(0x05, sp), x
;	n5510_txdemo.c: 150: while(1)
00113$:
;	n5510_txdemo.c: 153: gotoxy(0,5);
	push	#0x05
	push	#0x00
	call	_gotoxy
	popw	x
;	n5510_txdemo.c: 154: printf("%d^%d= %d",cnt,cnt,cnt*cnt);
	ldw	x, (0x05, sp)
	pushw	x
	ldw	x, (0x07, sp)
	pushw	x
	call	__mulint
	addw	sp, #4
	ldw	y, #___str_7+0
	pushw	x
	ldw	x, (0x07, sp)
	pushw	x
	ldw	x, (0x09, sp)
	pushw	x
	pushw	y
	call	_my_printf
	addw	sp, #8
;	n5510_txdemo.c: 156: bled_set();
	ldw	x, #0x5005
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
;	n5510_txdemo.c: 157: delay_ms(countspeed);
	push	#0x5e
	push	#0x01
	call	_delay_ms
	popw	x
;	n5510_txdemo.c: 158: bled_clr();
	ldw	x, #0x5005
	ld	a, (x)
	and	a, #0xdf
	ld	(x), a
;	n5510_txdemo.c: 159: delay_ms(countspeed);
	push	#0x5e
	push	#0x01
	call	_delay_ms
	popw	x
;	n5510_txdemo.c: 161: if (cnt & 1) { exled_set(); } else { exled_clr(); }
	ldw	x, #0x500f
	ld	a, (x)
	push	a
	ld	a, (0x07, sp)
	srl	a
	pop	a
	jrnc	00105$
	or	a, #0x10
	ldw	x, #0x500f
	ld	(x), a
	jra	00106$
00105$:
	and	a, #0xef
	ldw	x, #0x500f
	ld	(x), a
00106$:
;	n5510_txdemo.c: 166: gotoxy(0,4);
	push	#0x04
	push	#0x00
	call	_gotoxy
	popw	x
;	n5510_txdemo.c: 168: if (is_button() ) printf("Button: - 1 -");
	ldw	x, #0x5010
	ld	a, (x)
	and	a, #0x04
	srl	a
	srl	a
	tnz	a
	jreq	00108$
	ldw	x, #___str_8+0
	pushw	x
	call	_my_printf
	popw	x
	jra	00109$
00108$:
;	n5510_txdemo.c: 169: else printf("Button: - 0 -");
	ldw	x, #___str_9+0
	pushw	x
	call	_my_printf
	popw	x
00109$:
;	n5510_txdemo.c: 171: cnt++;
	ldw	x, (0x05, sp)
	incw	x
;	n5510_txdemo.c: 172: cnt= cnt % 101;
	push	#0x65
	push	#0x00
	pushw	x
	call	__modsint
	addw	sp, #4
	ldw	(0x05, sp), x
;	n5510_txdemo.c: 173: if (!(cnt))
	ldw	x, (0x05, sp)
	jreq	00144$
	jp	00113$
00144$:
;	n5510_txdemo.c: 175: gotoxy(0,5);
	push	#0x05
	push	#0x00
	call	_gotoxy
	popw	x
;	n5510_txdemo.c: 176: printf("              ");
	ldw	x, #___str_10+0
	pushw	x
	call	_my_printf
	popw	x
	jp	00113$
	addw	sp, #6
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
	.ascii " STM8S103F3P6"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_1:
	.ascii " doppelt gross"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_2:
	.ascii "--------------"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_3:
	.ascii "88  93  98 103 108"
	.db 0x00
___str_4:
	.ascii "STM8S"
	.db 0x00
___str_5:
	.ascii "    16MHz"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_6:
	.ascii "by R.Seelig"
	.db 0x00
___str_7:
	.ascii "%d^%d= %d"
	.db 0x00
___str_8:
	.ascii "Button: - 1 -"
	.db 0x00
___str_9:
	.ascii "Button: - 0 -"
	.db 0x00
___str_10:
	.ascii "              "
	.db 0x00
	.area INITIALIZER
__xinit__doublechar:
	.db #0x00	;  0
	.area CABS (ABS)
