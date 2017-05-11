;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Aug 12 2015) (Linux)
; This file was generated Mon May  8 21:30:38 2017
;--------------------------------------------------------
	.module sw_uhr
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _uhr_stellen
	.globl _tim1_init
	.globl _tim1_ovf
	.globl _uart_readint
	.globl _checkint16
	.globl _dez2bcd
	.globl _getwtag
	.globl _uart_init
	.globl _uart_getchar
	.globl _uart_putchar
	.globl _tm1637_setdez2
	.globl _tm1637_setdez
	.globl _tm1637_clear
	.globl _tm1637_init
	.globl _my_printf
	.globl _int_enable
	.globl _delay_ms
	.globl _sysclock_init
	.globl _year
	.globl _month
	.globl _day
	.globl _sek
	.globl _min
	.globl _std
	.globl _putchar
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
_std::
	.ds 1
_min::
	.ds 1
_sek::
	.ds 1
_day::
	.ds 1
_month::
	.ds 1
_year::
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
	int _tim1_ovf ;int11
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
;	sw_uhr.c: 47: char getwtag(int day, int month, int year)
;	-----------------------------------------
;	 function getwtag
;	-----------------------------------------
_getwtag:
	sub	sp, #8
;	sw_uhr.c: 51: if (month < 3)
	ldw	x, (0x0d, sp)
	cpw	x, #0x0003
	jrsge	00102$
;	sw_uhr.c: 53: month = month + 12;
	ldw	x, (0x0d, sp)
	addw	x, #0x000c
	ldw	(0x0d, sp), x
;	sw_uhr.c: 54: year--;
	ldw	x, (0x0f, sp)
	decw	x
	ldw	(0x0f, sp), x
00102$:
;	sw_uhr.c: 56: w_tag = (day+2*month + (3*month+3)/5 + year + year/4 - year/100 + year/400 + 1) % 7 ;
	ldw	x, (0x0d, sp)
	sllw	x
	addw	x, (0x0b, sp)
	ldw	(0x03, sp), x
	ldw	x, (0x0d, sp)
	pushw	x
	push	#0x03
	push	#0x00
	call	__mulint
	addw	sp, #4
	addw	x, #0x0003
	push	#0x05
	push	#0x00
	pushw	x
	call	__divsint
	addw	sp, #4
	addw	x, (0x03, sp)
	addw	x, (0x0f, sp)
	ldw	(0x07, sp), x
	push	#0x04
	push	#0x00
	ldw	x, (0x11, sp)
	pushw	x
	call	__divsint
	addw	sp, #4
	addw	x, (0x07, sp)
	pushw	x
	push	#0x64
	push	#0x00
	ldw	y, (0x13, sp)
	pushw	y
	call	__divsint
	addw	sp, #4
	ldw	(0x07, sp), x
	popw	x
	subw	x, (0x05, sp)
	ldw	(0x01, sp), x
	push	#0x90
	push	#0x01
	ldw	x, (0x11, sp)
	pushw	x
	call	__divsint
	addw	sp, #4
	addw	x, (0x01, sp)
	incw	x
	push	#0x07
	push	#0x00
	pushw	x
	call	__modsint
	addw	sp, #4
;	sw_uhr.c: 57: return w_tag;
	ld	a, xl
	addw	sp, #8
	ret
;	sw_uhr.c: 67: uint8_t dez2bcd(uint8_t value)
;	-----------------------------------------
;	 function dez2bcd
;	-----------------------------------------
_dez2bcd:
	pushw	x
;	sw_uhr.c: 71: hiz= value / 10;
	clrw	x
	ld	a, (0x05, sp)
	ld	xl, a
	ld	a, #0x0a
	div	x, a
;	sw_uhr.c: 72: loz= (value -(hiz*10));
	pushw	x
	ld	a, #0x0a
	mul	x, a
	exg	a, xl
	ld	(0x04, sp), a
	exg	a, xl
	popw	x
	ld	a, (0x05, sp)
	sub	a, (0x02, sp)
	ld	(0x01, sp), a
;	sw_uhr.c: 73: c= (hiz << 4) | loz;
	ld	a, xl
	swap	a
	and	a, #0xf0
	or	a, (0x01, sp)
;	sw_uhr.c: 74: return c;
	popw	x
	ret
;	sw_uhr.c: 92: int checkint16(char *p, int *myi)
;	-----------------------------------------
;	 function checkint16
;	-----------------------------------------
_checkint16:
	sub	sp, #35
;	sw_uhr.c: 99: if ( *p == 0 )
	ldw	y, (0x26, sp)
	ldw	(0x1d, sp), y
	ldw	x, (0x1d, sp)
	ld	a, (x)
	ld	(0x1f, sp), a
;	sw_uhr.c: 101: *myi= 0;
	ldw	y, (0x28, sp)
	ldw	(0x15, sp), y
;	sw_uhr.c: 99: if ( *p == 0 )
	tnz	(0x1f, sp)
	jrne	00102$
;	sw_uhr.c: 101: *myi= 0;
	ldw	x, (0x15, sp)
	clr	(0x1, x)
	clr	(x)
;	sw_uhr.c: 102: return 1;
	ldw	x, #0x0001
	jp	00117$
00102$:
;	sw_uhr.c: 104: p2= p;
	ldw	y, (0x1d, sp)
	ldw	(0x05, sp), y
;	sw_uhr.c: 106: while ( *p++) { l++; }          // ermittelt die Laenge des Strings
	clr	a
	ldw	x, (0x1d, sp)
00103$:
	push	a
	ld	a, (x)
	ld	(0x15, sp), a
	pop	a
	incw	x
	tnz	(0x14, sp)
	jreq	00131$
	inc	a
	jra	00103$
00131$:
	ld	(0x13, sp), a
;	sw_uhr.c: 107: p= p2;
	ldw	y, (0x05, sp)
	ldw	(0x26, sp), y
;	sw_uhr.c: 108: neg= 0;
	clr	(0x0b, sp)
;	sw_uhr.c: 109: if ( *p == '-')                  // negative Zahl ?
	ldw	x, (0x05, sp)
	push	a
	ld	a, (x)
	ld	xh, a
	cp	a, #0x2d
	pop	a
	jrne	00107$
;	sw_uhr.c: 111: neg= 1;
	push	a
	ld	a, #0x01
	ld	(0x0c, sp), a
	pop	a
;	sw_uhr.c: 112: p2++; p++;                   // Zahlenbereich nach dem Minuszeichen
	ldw	x, (0x05, sp)
	incw	x
	ldw	(0x26, sp), x
;	sw_uhr.c: 113: l--;                         // und Zahl ist eine Stelle kuerzer
	dec	a
	ld	(0x13, sp), a
00107$:
;	sw_uhr.c: 115: p += (l-1);                    // Pointer auf die Einerzahlen setzen
	ld	a, (0x13, sp)
	ld	(0x1c, sp), a
	ld	a, (0x1c, sp)
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	(0x1b, sp), a
	ldw	x, (0x1b, sp)
	decw	x
	ldw	(0x19, sp), x
	ldw	x, (0x26, sp)
	addw	x, (0x19, sp)
	ldw	(0x17, sp), x
	ldw	y, (0x17, sp)
	ldw	(0x26, sp), y
;	sw_uhr.c: 116: z= *p - 48;                    // nach Ziffer umrechnen
	ldw	y, (0x26, sp)
	ldw	(0x11, sp), y
	ldw	x, (0x11, sp)
	ld	a, (x)
	ld	(0x10, sp), a
	ld	a, (0x10, sp)
	ld	(0x0f, sp), a
	ld	a, (0x0f, sp)
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	(0x0e, sp), a
	ldw	x, (0x0e, sp)
	subw	x, #0x0030
	ldw	(0x0c, sp), x
	ldw	y, (0x0c, sp)
	ldw	(0x03, sp), y
	ld	a, (0x03, sp)
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	(0x02, sp), a
	ld	(0x01, sp), a
	ldw	y, (0x02, sp)
	ldw	(0x02, sp), y
;	sw_uhr.c: 117: z2= 1;
	ldw	x, #0x0001
	ldw	(0x09, sp), x
	clrw	x
	ldw	(0x07, sp), x
;	sw_uhr.c: 118: if (l> 1)
	ld	a, (0x13, sp)
	cp	a, #0x01
	jrsle	00112$
;	sw_uhr.c: 120: l--;                         // Laenge "kuerzen" weil 10er Stelle
	ld	a, (0x13, sp)
	dec	a
;	sw_uhr.c: 121: p--;                         // Zeiger auf die 10er Stelle
	ldw	x, (0x11, sp)
	decw	x
	ldw	(0x26, sp), x
;	sw_uhr.c: 122: do
	ldw	y, (0x26, sp)
	ldw	(0x22, sp), y
	ld	(0x21, sp), a
00108$:
;	sw_uhr.c: 124: z2= z2*10;
	ldw	x, (0x09, sp)
	pushw	x
	ldw	x, (0x09, sp)
	pushw	x
	push	#0x0a
	clrw	x
	pushw	x
	push	#0x00
	call	__mullong
	addw	sp, #8
	ldw	(0x09, sp), x
	ldw	(0x07, sp), y
;	sw_uhr.c: 125: z= z+ (z2 * ( *p - 48 ));  // Ziffer * Multiplikator + alten Inhalt von z
	ldw	x, (0x22, sp)
	ld	a, (x)
	ld	xl, a
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	xh, a
	subw	x, #0x0030
	clrw	y
	tnzw	x
	jrpl	00166$
	decw	y
00166$:
	pushw	x
	pushw	y
	ldw	x, (0x0d, sp)
	pushw	x
	ldw	x, (0x0d, sp)
	pushw	x
	call	__mullong
	addw	sp, #8
	exgw	x, y
	addw	y, (0x03, sp)
	ld	a, xl
	adc	a, (0x02, sp)
	rlwa	x
	adc	a, (0x01, sp)
	ld	xh, a
	ldw	(0x03, sp), y
	ldw	(0x01, sp), x
;	sw_uhr.c: 126: p--;
	ldw	x, (0x22, sp)
	decw	x
	ldw	(0x22, sp), x
;	sw_uhr.c: 127: l--;
	dec	(0x21, sp)
;	sw_uhr.c: 128: } while (l);                 // fuer alle Stellen wiederholen
	tnz	(0x21, sp)
	jrne	00108$
00112$:
;	sw_uhr.c: 130: if (((z> 32767) && (!neg)) | (z> 32768))
	ldw	x, #0x7fff
	cpw	x, (0x03, sp)
	clr	a
	sbc	a, (0x02, sp)
	clr	a
	sbc	a, (0x01, sp)
	jrsge	00119$
	tnz	(0x0b, sp)
	jreq	00120$
00119$:
	clr	(0x20, sp)
	jra	00121$
00120$:
	ld	a, #0x01
	ld	(0x20, sp), a
00121$:
	ldw	x, #0x8000
	cpw	x, (0x03, sp)
	clr	a
	sbc	a, (0x02, sp)
	clr	a
	sbc	a, (0x01, sp)
	jrslt	00170$
	clr	a
	jra	00171$
00170$:
	ld	a, #0x01
00171$:
	or	a, (0x20, sp)
	tnz	a
	jreq	00114$
;	sw_uhr.c: 132: *myi= 0;
	ldw	x, (0x15, sp)
	clr	(0x1, x)
	clr	(x)
;	sw_uhr.c: 133: return 0;
	clrw	x
	jra	00117$
00114$:
;	sw_uhr.c: 135: if (neg) { z= z * -1; }
	tnz	(0x0b, sp)
	jreq	00116$
	ldw	y, (0x03, sp)
	negw	y
	clr	a
	sbc	a, (0x02, sp)
	ld	xl, a
	clr	a
	sbc	a, (0x01, sp)
	ld	xh, a
	ldw	(0x03, sp), y
	ldw	(0x01, sp), x
00116$:
;	sw_uhr.c: 137: *myi= z;
	ldw	y, (0x03, sp)
	ldw	x, (0x15, sp)
	ldw	(x), y
;	sw_uhr.c: 138: return 1;
	ldw	x, #0x0001
00117$:
	addw	sp, #35
	ret
;	sw_uhr.c: 148: signed int uart_readint()
;	-----------------------------------------
;	 function uart_readint
;	-----------------------------------------
_uart_readint:
	sub	sp, #19
;	sw_uhr.c: 160: p= &str[0];                  // p zeigt auf die Adresse von str
	ldw	x, sp
	addw	x, #6
	ldw	(0x0d, sp), x
;	sw_uhr.c: 161: pz= p;                       // pz zeigt immer auf erstes Zeichen im String
	ldw	y, (0x0d, sp)
	ldw	(0x0f, sp), y
;	sw_uhr.c: 162: *p = 0;                      // und setzt dort NULL Byte
	ldw	y, (0x0d, sp)
	clr	(y)
;	sw_uhr.c: 163: cnt= 0;
	clr	(0x02, sp)
;	sw_uhr.c: 166: do
	ldw	(0x12, sp), x
00114$:
;	sw_uhr.c: 168: ch= uart_getchar();
	call	_uart_getchar
	ld	(0x03, sp), a
;	sw_uhr.c: 169: if ((ch>= '0') && (ch<= '9'))
	ld	a, (0x03, sp)
	cp	a, #0x30
	jrslt	00104$
	ld	a, (0x03, sp)
	cp	a, #0x39
	jrsgt	00104$
;	sw_uhr.c: 171: if (cnt < maxinlen-1)
	ld	a, (0x02, sp)
	cp	a, #0x06
	jrsge	00104$
;	sw_uhr.c: 173: *p++= ch;              // schreibt Char in den String und erhoeht Pointer
	ldw	x, (0x0d, sp)
	ld	a, (0x03, sp)
	ld	(x), a
	ldw	x, (0x0d, sp)
	incw	x
	ldw	(0x0d, sp), x
;	sw_uhr.c: 174: *p= 0;                 // und schreibt neues NULL (Endekennung)
	ldw	x, (0x0d, sp)
	clr	(x)
;	sw_uhr.c: 175: cnt++;
	inc	(0x02, sp)
;	sw_uhr.c: 176: uart_putchar(ch);      // Echo des eingebenen Zeichens
	ld	a, (0x03, sp)
	push	a
	call	_uart_putchar
	pop	a
00104$:
;	sw_uhr.c: 179: switch (ch)
	ld	a, (0x03, sp)
	cp	a, #0x08
	jreq	00109$
	ld	a, (0x03, sp)
	cp	a, #0x2d
	jrne	00115$
;	sw_uhr.c: 183: if (cnt == 0)
	tnz	(0x02, sp)
	jrne	00115$
;	sw_uhr.c: 185: *p++= ch;
	ldw	x, (0x0d, sp)
	ld	a, (0x03, sp)
	ld	(x), a
	ldw	x, (0x0d, sp)
	incw	x
	ldw	(0x0d, sp), x
;	sw_uhr.c: 186: *p= 0;
	ldw	x, (0x0d, sp)
	clr	(x)
;	sw_uhr.c: 187: cnt++;
	inc	(0x02, sp)
;	sw_uhr.c: 188: uart_putchar(ch);
	ld	a, (0x03, sp)
	push	a
	call	_uart_putchar
	pop	a
;	sw_uhr.c: 190: break;
	jra	00115$
;	sw_uhr.c: 192: case 8   :
00109$:
;	sw_uhr.c: 194: if (cnt> 0)
	ld	a, (0x02, sp)
	cp	a, #0x00
	jrsle	00115$
;	sw_uhr.c: 196: uart_putchar(ch);
	ld	a, (0x03, sp)
	push	a
	call	_uart_putchar
	pop	a
;	sw_uhr.c: 197: p--;
	ldw	x, (0x0d, sp)
	decw	x
	ldw	(0x0d, sp), x
;	sw_uhr.c: 198: *p= 0;
	ldw	x, (0x0d, sp)
	clr	(x)
;	sw_uhr.c: 199: cnt--;
	dec	(0x02, sp)
;	sw_uhr.c: 207: }
00115$:
;	sw_uhr.c: 208: } while (ch != 0x0d);        // wiederholen bis Returnzeichen eintrifft
	ld	a, (0x03, sp)
	cp	a, #0x0d
	jrne	00114$
;	sw_uhr.c: 209: b=  (checkint16( &str[0], &i ));
	ldw	x, sp
	addw	x, #4
	ldw	y, (0x12, sp)
	pushw	x
	pushw	y
	call	_checkint16
	addw	sp, #4
	ld	a, xl
	ld	(0x01, sp), a
	ld	a, (0x01, sp)
	ld	(0x11, sp), a
;	sw_uhr.c: 210: if (!b)
	tnz	(0x01, sp)
	jrne	00121$
;	sw_uhr.c: 212: for (i= cnt; i> 0; i--)
	ld	a, (0x02, sp)
	ld	xl, a
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	xh, a
	ldw	(0x04, sp), x
00124$:
	cpw	x, #0x0000
	jrsle	00141$
;	sw_uhr.c: 214: uart_putchar(8);         // gemachte, fehlerhafte Eingabe durch Backspace
	pushw	x
	push	#0x08
	call	_uart_putchar
	pop	a
	popw	x
;	sw_uhr.c: 212: for (i= cnt; i> 0; i--)
	decw	x
	ldw	(0x04, sp), x
	jra	00124$
00141$:
	ldw	(0x04, sp), x
;	sw_uhr.c: 217: cnt= 0;                    // und Zaehler zuruecksetzen
	clr	(0x02, sp)
;	sw_uhr.c: 218: p= pz;
	ldw	y, (0x0f, sp)
	ldw	(0x0d, sp), y
;	sw_uhr.c: 219: *p= 0;
	ldw	x, (0x0f, sp)
	clr	(x)
00121$:
;	sw_uhr.c: 221: } while (!b);      // Zahl soll im 16 Bit Integerbereich liegen
	tnz	(0x11, sp)
	jrne	00197$
	jp	00114$
00197$:
;	sw_uhr.c: 222: return i;
	ldw	x, (0x04, sp)
	addw	sp, #19
	ret
;	sw_uhr.c: 229: void tim1_ovf(void) __interrupt(11)
;	-----------------------------------------
;	 function tim1_ovf
;	-----------------------------------------
_tim1_ovf:
	pushw	x
;	sw_uhr.c: 233: sek++;
	ld	a, _sek+0
	inc	a
;	sw_uhr.c: 234: if (sek==60)
	ld	_sek+0, a
	cp	a, #0x3c
	jreq	00190$
	jp	00129$
00190$:
;	sw_uhr.c: 236: sek= 0;
	clr	_sek+0
;	sw_uhr.c: 237: min++;
	ld	a, _min+0
	inc	a
;	sw_uhr.c: 238: if (min==60)
	ld	_min+0, a
	cp	a, #0x3c
	jreq	00193$
	jp	00129$
00193$:
;	sw_uhr.c: 240: min= 0;
	clr	_min+0
;	sw_uhr.c: 241: std++;
	ld	a, _std+0
	inc	a
;	sw_uhr.c: 242: if (std==24)
	ld	_std+0, a
	cp	a, #0x18
	jreq	00196$
	jp	00129$
00196$:
;	sw_uhr.c: 244: std= 0;
	clr	_std+0
;	sw_uhr.c: 249: day++;
	ld	a, _day+0
	inc	a
	ld	xh, a
;	sw_uhr.c: 247: if (day< 28)                                            // Monatsende nicht erreicht
	ld	a, _day+0
	cp	a, #0x1c
	jrnc	00102$
;	sw_uhr.c: 249: day++;
	ld	a, xh
	ld	_day+0, a
;	sw_uhr.c: 250: return;
	jp	00130$
00102$:
;	sw_uhr.c: 264: month++;
	ld	a, _month+0
	inc	a
	ld	xl, a
;	sw_uhr.c: 253: if (month== 2)
	ld	a, _month+0
	cp	a, #0x02
	jrne	00110$
;	sw_uhr.c: 255: if ((year % 4)== 0)                                   // Schaltjahr
	pushw	x
	push	#0x04
	push	#0x00
	push	_year+1
	push	_year+0
	call	__modsint
	addw	sp, #4
	ldw	(0x03, sp), x
	popw	x
	ldw	y, (0x01, sp)
	jrne	00107$
;	sw_uhr.c: 257: if (day==28)
	ld	a, _day+0
	cp	a, #0x1c
	jrne	00104$
;	sw_uhr.c: 259: day++;
	ld	a, xh
	ld	_day+0, a
;	sw_uhr.c: 260: return;
	jp	00130$
00104$:
;	sw_uhr.c: 264: month++;
	ld	a, xl
	ld	_month+0, a
;	sw_uhr.c: 265: day= 1;
	mov	_day+0, #0x01
;	sw_uhr.c: 266: return;
	jp	00130$
00107$:
;	sw_uhr.c: 271: month++;
	ld	a, xl
	ld	_month+0, a
;	sw_uhr.c: 272: day= 1;
	mov	_day+0, #0x01
;	sw_uhr.c: 273: return;
	jra	00130$
00110$:
;	sw_uhr.c: 277: if ((month==4) || (month==6) || (month== 9) || (month== 11))     // April, Juni, September, November
	ld	a, _month+0
	cp	a, #0x04
	jreq	00114$
	ld	a, _month+0
	cp	a, #0x06
	jreq	00114$
	ld	a, _month+0
	cp	a, #0x09
	jreq	00114$
	ld	a, _month+0
	cp	a, #0x0b
	jrne	00115$
00114$:
;	sw_uhr.c: 279: if (day< 30)
	ld	a, _day+0
	cp	a, #0x1e
	jrnc	00112$
;	sw_uhr.c: 281: day++;
	ld	a, xh
	ld	_day+0, a
;	sw_uhr.c: 282: return;
	jra	00130$
00112$:
;	sw_uhr.c: 286: day= 1;
	mov	_day+0, #0x01
;	sw_uhr.c: 287: month++;
	ld	a, xl
	ld	_month+0, a
;	sw_uhr.c: 288: return;
	jra	00130$
00115$:
;	sw_uhr.c: 294: if ((month== 12) && (day== 31))                                // Feuerwerk, es ist Sylvester
	ld	a, _month+0
	cp	a, #0x0c
	jrne	00120$
	ld	a, _day+0
	cp	a, #0x1f
	jrne	00120$
;	sw_uhr.c: 296: day= 1;
	mov	_day+0, #0x01
;	sw_uhr.c: 297: month= 1;
	mov	_month+0, #0x01
;	sw_uhr.c: 298: year++;
	ldw	x, _year+0
	incw	x
	ldw	_year+0, x
;	sw_uhr.c: 299: return;
	jra	00130$
00120$:
;	sw_uhr.c: 302: if (day< 31)                                                  // Monatsende nicht erreicht
	ld	a, _day+0
	cp	a, #0x1f
	jrnc	00123$
;	sw_uhr.c: 304: day++;
	ld	a, xh
	ld	_day+0, a
;	sw_uhr.c: 305: return;
	jra	00130$
00123$:
;	sw_uhr.c: 308: day= 1;                                                       // monthsende der Monate mit 31 Tagen
	mov	_day+0, #0x01
;	sw_uhr.c: 309: month++;
	ld	a, xl
	ld	_month+0, a
;	sw_uhr.c: 310: return;
	jra	00130$
00129$:
;	sw_uhr.c: 316: TIM1_SR1 &= ~TIM1_SR1_UIF;        // Interrupt quittieren
	bres	0x5255, #0
00130$:
	popw	x
	iret
;	sw_uhr.c: 334: void tim1_init(void)
;	-----------------------------------------
;	 function tim1_init
;	-----------------------------------------
_tim1_init:
;	sw_uhr.c: 341: TIM1_PSCRH= (uint8_t) (clockdivisor >> 8);
	mov	0x5260+0, #0x3e
;	sw_uhr.c: 342: TIM1_PSCRL= (uint8_t) (clockdivisor & 0x0000ff);
	mov	0x5261+0, #0x7f
;	sw_uhr.c: 345: TIM1_IER |= TIM1_IER_UIE;
	bset	0x5254, #0
;	sw_uhr.c: 348: TIM1_CR1 |= TIM1_CR1_CEN;     // Timer1 enable ( CEN = ClockENable )
	bset	0x5250, #0
;	sw_uhr.c: 349: TIM1_CR1 |= TIM1_CR1_ARPE;    // Timer1 autoreload ( mit Werten in TIM1_ARR )
	bset	0x5250, #7
;	sw_uhr.c: 352: TIM1_ARRH= (uint8_t) (999 >> 8);
	mov	0x5262+0, #0x03
;	sw_uhr.c: 353: TIM1_ARRL= (uint8_t) (999 & 0x00ff);
	mov	0x5263+0, #0xe7
;	sw_uhr.c: 355: int_enable();
	jp	_int_enable
;	sw_uhr.c: 363: void uhr_stellen(void)
;	-----------------------------------------
;	 function uhr_stellen
;	-----------------------------------------
_uhr_stellen:
	sub	sp, #12
;	sw_uhr.c: 367: do
	ldw	x, #___str_0+0
	ldw	(0x09, sp), x
00102$:
;	sw_uhr.c: 369: printf("\n\rTag    : ");
	ldw	x, (0x09, sp)
	pushw	x
	call	_my_printf
	popw	x
;	sw_uhr.c: 370: i= uart_readint();
	call	_uart_readint
;	sw_uhr.c: 371: } while ( !((i > -1) && (i < 32)));
	cpw	x, #0xffff
	jrsle	00102$
	cpw	x, #0x0020
	jrsge	00102$
;	sw_uhr.c: 372: day= i;
	ld	a, xl
	ld	_day+0, a
;	sw_uhr.c: 374: do
	ldw	x, #___str_1+0
	ldw	(0x07, sp), x
00106$:
;	sw_uhr.c: 376: printf("\n\rMonat  : ");
	ldw	x, (0x07, sp)
	pushw	x
	call	_my_printf
	popw	x
;	sw_uhr.c: 377: i= uart_readint();
	call	_uart_readint
;	sw_uhr.c: 378: } while ( !((i > -1) && (i < 13)));
	cpw	x, #0xffff
	jrsle	00106$
	cpw	x, #0x000d
	jrsge	00106$
;	sw_uhr.c: 379: month= i;
	ld	a, xl
	ld	_month+0, a
;	sw_uhr.c: 381: do
	ldw	x, #___str_2+0
	ldw	(0x05, sp), x
00110$:
;	sw_uhr.c: 383: printf("\n\rJahr   : ");
	ldw	x, (0x05, sp)
	pushw	x
	call	_my_printf
	popw	x
;	sw_uhr.c: 384: i= uart_readint();
	call	_uart_readint
;	sw_uhr.c: 385: } while ( !((i > -1) && (i < 100)));
	cpw	x, #0xffff
	jrsle	00110$
	cpw	x, #0x0064
	jrsge	00110$
;	sw_uhr.c: 386: year= 2000+i;
	addw	x, #0x07d0
	ldw	_year+0, x
;	sw_uhr.c: 388: do
	ldw	x, #___str_3+0
	ldw	(0x03, sp), x
00114$:
;	sw_uhr.c: 390: printf("\n\rStunde : ");
	ldw	x, (0x03, sp)
	pushw	x
	call	_my_printf
	popw	x
;	sw_uhr.c: 391: i= uart_readint();
	call	_uart_readint
;	sw_uhr.c: 392: } while ( !((i > -1) && (i < 24)));
	cpw	x, #0xffff
	jrsle	00114$
	cpw	x, #0x0018
	jrsge	00114$
;	sw_uhr.c: 393: std= i;
	ld	a, xl
	ld	_std+0, a
;	sw_uhr.c: 395: do
	ldw	x, #___str_4+0
	ldw	(0x01, sp), x
00118$:
;	sw_uhr.c: 397: printf("\n\rMinute : ");
	ldw	x, (0x01, sp)
	pushw	x
	call	_my_printf
	popw	x
;	sw_uhr.c: 398: i= uart_readint();
	call	_uart_readint
;	sw_uhr.c: 399: } while ( !((i > -1) && (i < 60)));
	cpw	x, #0xffff
	jrsle	00118$
	cpw	x, #0x003c
	jrsge	00118$
;	sw_uhr.c: 400: min= i;
	ld	a, xl
	ld	_min+0, a
;	sw_uhr.c: 402: do
	ldw	x, #___str_5+0
	ldw	(0x0b, sp), x
00122$:
;	sw_uhr.c: 404: printf("\n\rSekunde: ");
	ldw	x, (0x0b, sp)
	pushw	x
	call	_my_printf
	popw	x
;	sw_uhr.c: 405: i= uart_readint();
	call	_uart_readint
;	sw_uhr.c: 406: } while ( !((i > -1) && (i < 60)));
	cpw	x, #0xffff
	jrsle	00122$
	cpw	x, #0x003c
	jrsge	00122$
;	sw_uhr.c: 407: sek= i;
	ld	a, xl
	ld	_sek+0, a
	addw	sp, #12
	ret
;	sw_uhr.c: 421: void putchar(char ch)
;	-----------------------------------------
;	 function putchar
;	-----------------------------------------
_putchar:
;	sw_uhr.c: 423: uart_putchar(ch);
	ld	a, (0x03, sp)
	push	a
	call	_uart_putchar
	pop	a
	ret
;	sw_uhr.c: 431: void main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #40
;	sw_uhr.c: 438: char wtag[][3] = {"So","Mo","Di","Mi","Do","Fr","Sa"};
	ldw	x, sp
	incw	x
	incw	x
	ld	a, #0x53
	ld	(x), a
	ldw	x, sp
	incw	x
	incw	x
	ldw	(0x25, sp), x
	ldw	x, (0x25, sp)
	incw	x
	ld	a, #0x6f
	ld	(x), a
	ldw	x, (0x25, sp)
	incw	x
	incw	x
	clr	(x)
	ldw	x, sp
	incw	x
	incw	x
	ldw	(0x1f, sp), x
	ldw	x, (0x1f, sp)
	ld	a, #0x4d
	ld	(0x0003, x), a
	ldw	x, (0x1f, sp)
	ld	a, #0x6f
	ld	(0x0004, x), a
	ldw	x, (0x1f, sp)
	addw	x, #0x0005
	clr	(x)
	ldw	x, (0x1f, sp)
	ld	a, #0x44
	ld	(0x0006, x), a
	ldw	x, (0x1f, sp)
	ld	a, #0x69
	ld	(0x0007, x), a
	ldw	x, (0x1f, sp)
	addw	x, #0x0008
	clr	(x)
	ldw	x, (0x1f, sp)
	ld	a, #0x4d
	ld	(0x0009, x), a
	ldw	x, (0x1f, sp)
	ld	a, #0x69
	ld	(0x000a, x), a
	ldw	x, (0x1f, sp)
	addw	x, #0x000b
	clr	(x)
	ldw	x, (0x1f, sp)
	ld	a, #0x44
	ld	(0x000c, x), a
	ldw	x, (0x1f, sp)
	ld	a, #0x6f
	ld	(0x000d, x), a
	ldw	x, (0x1f, sp)
	addw	x, #0x000e
	clr	(x)
	ldw	x, (0x1f, sp)
	ld	a, #0x46
	ld	(0x000f, x), a
	ldw	x, (0x1f, sp)
	ld	a, #0x72
	ld	(0x0010, x), a
	ldw	x, (0x1f, sp)
	addw	x, #0x0011
	clr	(x)
	ldw	x, (0x1f, sp)
	ld	a, #0x53
	ld	(0x0012, x), a
	ldw	x, (0x1f, sp)
	ld	a, #0x61
	ld	(0x0013, x), a
	ldw	x, (0x1f, sp)
	addw	x, #0x0014
	clr	(x)
;	sw_uhr.c: 440: sysclock_init(0);             // erstes Initialisieren interner Takt
	push	#0x00
	call	_sysclock_init
	pop	a
;	sw_uhr.c: 441: delay_ms(50);
	push	#0x32
	push	#0x00
	call	_delay_ms
	popw	x
;	sw_uhr.c: 443: delay_ms(50);
	push	#0x32
	push	#0x00
	call	_delay_ms
	popw	x
;	sw_uhr.c: 445: uart_init(19200);             // serielle Schnittstelle
	push	#0x00
	push	#0x4b
	call	_uart_init
	popw	x
;	sw_uhr.c: 446: tim1_init();                  // Timer1 - Interrupt
	call	_tim1_init
;	sw_uhr.c: 447: tm1637_init();                // 7 - Segmentanzeige
	call	_tm1637_init
;	sw_uhr.c: 448: tm1637_clear();
	call	_tm1637_clear
;	sw_uhr.c: 449: tm1637_dp= 1;
	mov	_tm1637_dp+0, #0x01
;	sw_uhr.c: 450: tm1637_setdez(0);
	clrw	x
	pushw	x
	call	_tm1637_setdez
	popw	x
;	sw_uhr.c: 452: std= 0; min= 0; sek= 0; year= 2016; month= 1; day= 1;
	clr	_std+0
	clr	_min+0
	clr	_sek+0
	ldw	x, #0x07e0
	ldw	_year+0, x
	mov	_month+0, #0x01
	mov	_day+0, #0x01
;	sw_uhr.c: 453: printf("\n\n\rSTM8S103F3P6 - Softwareuhr\n\r");
	ldw	x, #___str_13+0
	pushw	x
	call	_my_printf
	popw	x
;	sw_uhr.c: 454: printf(      "---------------------------------\n\r");
	ldw	x, #___str_14+0
	pushw	x
	call	_my_printf
	popw	x
;	sw_uhr.c: 455: printf(      "CPU=16MHz 19200Bd 8N1\n\r");
	ldw	x, #___str_15+0
	pushw	x
	call	_my_printf
	popw	x
;	sw_uhr.c: 456: printf("\n\n\rUhr stellen:\n\r");
	ldw	x, #___str_16+0
	pushw	x
	call	_my_printf
	popw	x
;	sw_uhr.c: 458: uhr_stellen();
	call	_uhr_stellen
;	sw_uhr.c: 460: printf("\n\n\r");
	ldw	x, #___str_17+0
	pushw	x
	call	_my_printf
	popw	x
;	sw_uhr.c: 461: oldsek= sek-1;
	ld	a, _sek+0
	dec	a
	ld	(0x01, sp), a
;	sw_uhr.c: 465: while(sek == oldsek);               // warten bis Sekunde "weiterspringt"
00101$:
	ld	a, (0x01, sp)
	cp	a, _sek+0
	jreq	00101$
;	sw_uhr.c: 467: oldsek= sek;
	ld	a, _sek+0
	ld	(0x01, sp), a
;	sw_uhr.c: 468: wt= getwtag(day, month, year);
	clrw	x
	ld	a, _month+0
	ld	xl, a
	clrw	y
	ld	a, _day+0
	ld	yl, a
	push	_year+1
	push	_year+0
	pushw	x
	pushw	y
	call	_getwtag
	addw	sp, #6
	ld	xl, a
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	xh, a
	ldw	(0x17, sp), x
;	sw_uhr.c: 473: printf(" %s:  %x.%x.%d  %x.%x:%x  \r", wtag[wt],           \
	push	_sek+0
	call	_dez2bcd
	addw	sp, #1
	ld	(0x24, sp), a
	clr	(0x23, sp)
	push	_min+0
	call	_dez2bcd
	addw	sp, #1
	ld	(0x1a, sp), a
	clr	(0x19, sp)
	push	_std+0
	call	_dez2bcd
	addw	sp, #1
	ld	(0x1c, sp), a
	clr	(0x1b, sp)
	push	_month+0
	call	_dez2bcd
	addw	sp, #1
	ld	(0x22, sp), a
	clr	(0x21, sp)
	push	_day+0
	call	_dez2bcd
	addw	sp, #1
	ld	(0x1e, sp), a
	clr	(0x1d, sp)
	ldw	x, (0x17, sp)
	pushw	x
	push	#0x03
	push	#0x00
	call	__mulint
	addw	sp, #4
	addw	x, (0x1f, sp)
	ldw	(0x27, sp), x
	ldw	y, #___str_18+0
	ldw	x, (0x23, sp)
	pushw	x
	ldw	x, (0x1b, sp)
	pushw	x
	ldw	x, (0x1f, sp)
	pushw	x
	ldw	x, _year+0
	pushw	x
	ldw	x, (0x29, sp)
	pushw	x
	ldw	x, (0x27, sp)
	pushw	x
	ldw	x, (0x33, sp)
	pushw	x
	pushw	y
	call	_my_printf
	addw	sp, #16
;	sw_uhr.c: 479: delay_ms(490);
	push	#0xea
	push	#0x01
	call	_delay_ms
	popw	x
;	sw_uhr.c: 480: tm1637_dp= 0;
	clr	_tm1637_dp+0
;	sw_uhr.c: 481: tm1637_setdez2(0,min);
	push	_min+0
	push	#0x00
	call	_tm1637_setdez2
	popw	x
;	sw_uhr.c: 482: tm1637_setdez2(1,std);
	push	_std+0
	push	#0x01
	call	_tm1637_setdez2
	popw	x
;	sw_uhr.c: 483: delay_ms(490);
	push	#0xea
	push	#0x01
	call	_delay_ms
	popw	x
;	sw_uhr.c: 484: tm1637_dp= 1;
	mov	_tm1637_dp+0, #0x01
;	sw_uhr.c: 485: tm1637_setdez2(0,min);
	push	_min+0
	push	#0x00
	call	_tm1637_setdez2
	popw	x
;	sw_uhr.c: 486: tm1637_setdez2(1,std);
	push	_std+0
	push	#0x01
	call	_tm1637_setdez2
	popw	x
	jp	00101$
	addw	sp, #40
	ret
	.area CODE
___str_0:
	.db 0x0A
	.db 0x0D
	.ascii "Tag    : "
	.db 0x00
___str_1:
	.db 0x0A
	.db 0x0D
	.ascii "Monat  : "
	.db 0x00
___str_2:
	.db 0x0A
	.db 0x0D
	.ascii "Jahr   : "
	.db 0x00
___str_3:
	.db 0x0A
	.db 0x0D
	.ascii "Stunde : "
	.db 0x00
___str_4:
	.db 0x0A
	.db 0x0D
	.ascii "Minute : "
	.db 0x00
___str_5:
	.db 0x0A
	.db 0x0D
	.ascii "Sekunde: "
	.db 0x00
___str_13:
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.ascii "STM8S103F3P6 - Softwareuhr"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_14:
	.ascii "---------------------------------"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_15:
	.ascii "CPU=16MHz 19200Bd 8N1"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_16:
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.ascii "Uhr stellen:"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_17:
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_18:
	.ascii " %s:  %x.%x.%d  %x.%x:%x  "
	.db 0x0D
	.db 0x00
	.area INITIALIZER
	.area CABS (ABS)
