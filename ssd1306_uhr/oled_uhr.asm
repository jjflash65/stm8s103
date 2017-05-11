;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Aug 12 2015) (Linux)
; This file was generated Mon Apr 24 08:50:58 2017
;--------------------------------------------------------
	.module oled_uhr
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _ntc_tab
	.globl _min_zeiger
	.globl _std_zeiger
	.globl _uhr
	.globl _main
	.globl _uhr_show
	.globl _stellen_screen
	.globl _getwtag
	.globl _ntc_calc
	.globl _get_widerstand
	.globl _adc_read
	.globl _tast2_counter
	.globl _putdez2
	.globl _puts
	.globl _putchar
	.globl _analoguhr
	.globl _get_zeiger_value
	.globl _fb_clear
	.globl _fb_init
	.globl _circle
	.globl _line
	.globl _fb_show
	.globl _oled_putchar
	.globl _gotoxy
	.globl _clrscr
	.globl _oled_init
	.globl _tim1_init
	.globl _delay_us
	.globl _delay_ms
	.globl _sysclock_init
	.globl _abs
	.globl _wtag
	.globl _intv_ticker
	.globl _systimer_intervall
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
_intv_ticker::
	.ds 2
_wtag::
	.ds 21
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
;	oled_uhr.c: 175: void get_zeiger_value(int w, const int *tab_ptr, int *x, int *y)
;	-----------------------------------------
;	 function get_zeiger_value
;	-----------------------------------------
_get_zeiger_value:
	sub	sp, #4
;	oled_uhr.c: 179: *x = tab_ptr[w];
	ldw	y, (0x0b, sp)
	ldw	(0x03, sp), y
;	oled_uhr.c: 180: *y = -(tab_ptr[15-w]);
	ldw	y, (0x0d, sp)
	ldw	(0x01, sp), y
;	oled_uhr.c: 177: if (w < 15)
	ldw	x, (0x07, sp)
	cpw	x, #0x000f
	jrsge	00108$
;	oled_uhr.c: 179: *x = tab_ptr[w];
	ldw	x, (0x07, sp)
	sllw	x
	addw	x, (0x09, sp)
	ldw	x, (x)
	ldw	y, (0x03, sp)
	ldw	(y), x
;	oled_uhr.c: 180: *y = -(tab_ptr[15-w]);
	ldw	x, #0x000f
	subw	x, (0x07, sp)
	sllw	x
	addw	x, (0x09, sp)
	ldw	x, (x)
	negw	x
	ldw	y, (0x01, sp)
	ldw	(y), x
	jra	00110$
00108$:
;	oled_uhr.c: 184: if (w < 30)
	ldw	x, (0x07, sp)
	cpw	x, #0x001e
	jrsge	00105$
;	oled_uhr.c: 186: *x = tab_ptr[30-w];
	ldw	x, #0x001e
	subw	x, (0x07, sp)
	sllw	x
	addw	x, (0x09, sp)
	ldw	x, (x)
	ldw	y, (0x03, sp)
	ldw	(y), x
;	oled_uhr.c: 187: *y = tab_ptr[w-15];
	ldw	x, (0x07, sp)
	subw	x, #0x000f
	sllw	x
	addw	x, (0x09, sp)
	ldw	x, (x)
	ldw	y, (0x01, sp)
	ldw	(y), x
	jra	00110$
00105$:
;	oled_uhr.c: 191: if (w < 45)
	ldw	x, (0x07, sp)
	cpw	x, #0x002d
	jrsge	00102$
;	oled_uhr.c: 193: *x = -(tab_ptr[w-30]);
	ldw	x, (0x07, sp)
	subw	x, #0x001e
	sllw	x
	addw	x, (0x09, sp)
	ldw	x, (x)
	negw	x
	ldw	y, (0x03, sp)
	ldw	(y), x
;	oled_uhr.c: 194: *y = tab_ptr[45-w];
	ldw	x, #0x002d
	subw	x, (0x07, sp)
	sllw	x
	addw	x, (0x09, sp)
	ldw	x, (x)
	ldw	y, (0x01, sp)
	ldw	(y), x
	jra	00110$
00102$:
;	oled_uhr.c: 198: *x = -(tab_ptr[60-w]);
	ldw	x, #0x003c
	subw	x, (0x07, sp)
	sllw	x
	addw	x, (0x09, sp)
	ldw	x, (x)
	negw	x
	ldw	y, (0x03, sp)
	ldw	(y), x
;	oled_uhr.c: 199: *y = -(tab_ptr[w-45]);
	ldw	x, (0x07, sp)
	subw	x, #0x002d
	sllw	x
	addw	x, (0x09, sp)
	ldw	x, (x)
	negw	x
	ldw	y, (0x01, sp)
	ldw	(y), x
00110$:
	addw	sp, #4
	ret
;	oled_uhr.c: 209: void analoguhr(int std, int min, int sek, char drawmode)
;	-----------------------------------------
;	 function analoguhr
;	-----------------------------------------
_analoguhr:
	sub	sp, #32
;	oled_uhr.c: 214: while(std> 12) std -= 12;
	ldw	x, (0x23, sp)
00101$:
	cpw	x, #0x000c
	jrsle	00136$
	subw	x, #0x000c
	jra	00101$
;	oled_uhr.c: 215: while(min > 60) min -= 60;
00136$:
	ldw	(0x23, sp), x
	ldw	x, (0x25, sp)
00104$:
	cpw	x, #0x003c
	jrsle	00137$
	subw	x, #0x003c
	jra	00104$
;	oled_uhr.c: 216: while(sek > 60) sek -= 60;
00137$:
	ldw	(0x25, sp), x
	ldw	x, (0x27, sp)
00107$:
	cpw	x, #0x003c
	jrsle	00138$
	subw	x, #0x003c
	jra	00107$
00138$:
	ldw	(0x27, sp), x
;	oled_uhr.c: 218: for(i=0; i<12; i++)
	ldw	x, #_uhr+0
	ldw	(0x13, sp), x
	clrw	x
	ldw	(0x03, sp), x
00120$:
;	oled_uhr.c: 223: uhr_y + uhr[i].y2,
	ldw	x, (0x03, sp)
	sllw	x
	sllw	x
	sllw	x
	addw	x, (0x13, sp)
	ldw	(0x17, sp), x
	ldw	y, (0x17, sp)
	ldw	y, (0x6, y)
	addw	y, #0x0020
;	oled_uhr.c: 222: uhr_x + uhr[i].x2,
	ldw	x, (0x17, sp)
	ldw	x, (0x4, x)
	addw	x, #0x0020
	ldw	(0x19, sp), x
;	oled_uhr.c: 221: uhr_y + uhr[i].y1,
	ldw	x, (0x17, sp)
	ldw	x, (0x2, x)
	addw	x, #0x0020
	ldw	(0x11, sp), x
;	oled_uhr.c: 220: line( uhr_x + uhr[i].x1,
	ldw	x, (0x17, sp)
	ldw	x, (x)
	addw	x, #0x0020
	ld	a, (0x29, sp)
	push	a
	pushw	y
	ldw	y, (0x1c, sp)
	pushw	y
	ldw	y, (0x16, sp)
	pushw	y
	pushw	x
	call	_line
	addw	sp, #9
;	oled_uhr.c: 218: for(i=0; i<12; i++)
	ldw	x, (0x03, sp)
	incw	x
	ldw	(0x03, sp), x
	ldw	x, (0x03, sp)
	cpw	x, #0x000c
	jrslt	00120$
;	oled_uhr.c: 227: get_zeiger_value(min, min_zeiger, &x, &y);
	ldw	x, sp
	incw	x
	ldw	(0x0d, sp), x
	ldw	y, (0x0d, sp)
	ldw	x, sp
	addw	x, #5
	ldw	(0x07, sp), x
	ldw	x, (0x07, sp)
	ldw	(0x1f, sp), x
	ldw	x, #_min_zeiger+0
	ldw	(0x09, sp), x
	ldw	x, (0x09, sp)
	pushw	y
	ldw	y, (0x21, sp)
	pushw	y
	pushw	x
	ldw	x, (0x2b, sp)
	pushw	x
	call	_get_zeiger_value
	addw	sp, #8
;	oled_uhr.c: 228: line(uhr_x, uhr_y, uhr_x+x, uhr_y+y, drawmode);
	ldw	x, (0x01, sp)
	addw	x, #0x0020
	ldw	y, (0x05, sp)
	addw	y, #0x0020
	ld	a, (0x29, sp)
	push	a
	pushw	x
	pushw	y
	push	#0x20
	push	#0x00
	push	#0x20
	push	#0x00
	call	_line
	addw	sp, #9
;	oled_uhr.c: 230: if (abs(x) > abs(y))
	ldw	x, (0x05, sp)
	pushw	x
	call	_abs
	addw	sp, #2
	ldw	(0x1d, sp), x
	ldw	x, (0x01, sp)
	pushw	x
	call	_abs
	addw	sp, #2
	cpw	x, (0x1d, sp)
	jrsge	00112$
;	oled_uhr.c: 232: line(uhr_x, uhr_y+1, uhr_x+x, uhr_y+y+1, drawmode);
	ldw	x, (0x01, sp)
	addw	x, #0x0021
	ldw	y, (0x05, sp)
	addw	y, #0x0020
	ld	a, (0x29, sp)
	push	a
	pushw	x
	pushw	y
	push	#0x21
	push	#0x00
	push	#0x20
	push	#0x00
	call	_line
	addw	sp, #9
	jra	00113$
00112$:
;	oled_uhr.c: 236: line(uhr_x+1, uhr_y, uhr_x+x+1, uhr_y+y, drawmode);
	ldw	x, (0x01, sp)
	addw	x, #0x0020
	ldw	y, (0x05, sp)
	addw	y, #0x0021
	ld	a, (0x29, sp)
	push	a
	pushw	x
	pushw	y
	push	#0x20
	push	#0x00
	push	#0x21
	push	#0x00
	call	_line
	addw	sp, #9
00113$:
;	oled_uhr.c: 239: std = std * 5;
	ldw	x, (0x23, sp)
	pushw	x
	push	#0x05
	push	#0x00
	call	__mulint
	addw	sp, #4
	ldw	(0x23, sp), x
;	oled_uhr.c: 240: while(min >= 12)
	ldw	x, (0x25, sp)
	ldw	y, (0x23, sp)
	ldw	(0x0b, sp), y
00114$:
	cpw	x, #0x000c
	jrslt	00116$
;	oled_uhr.c: 242: min -= 12;
	subw	x, #0x000c
;	oled_uhr.c: 243: std++;
	ldw	y, (0x0b, sp)
	incw	y
	ldw	(0x0b, sp), y
	jra	00114$
00116$:
;	oled_uhr.c: 246: get_zeiger_value(std, std_zeiger, &x, &y);
	ldw	y, (0x0d, sp)
	ldw	x, (0x07, sp)
	ldw	(0x15, sp), x
	ldw	x, #_std_zeiger+0
	pushw	y
	ldw	y, (0x17, sp)
	pushw	y
	pushw	x
	ldw	x, (0x11, sp)
	pushw	x
	call	_get_zeiger_value
	addw	sp, #8
;	oled_uhr.c: 247: line(uhr_x, uhr_y, uhr_x+x, uhr_y+y, drawmode);
	ldw	y, (0x01, sp)
	addw	y, #0x0020
	ldw	x, (0x05, sp)
	addw	x, #0x0020
	ld	a, (0x29, sp)
	push	a
	pushw	y
	pushw	x
	push	#0x20
	push	#0x00
	push	#0x20
	push	#0x00
	call	_line
	addw	sp, #9
;	oled_uhr.c: 249: if (abs(x) > abs(y))
	ldw	x, (0x05, sp)
	pushw	x
	call	_abs
	addw	sp, #2
	ldw	(0x0f, sp), x
	ldw	x, (0x01, sp)
	pushw	x
	call	_abs
	addw	sp, #2
	cpw	x, (0x0f, sp)
	jrsge	00118$
;	oled_uhr.c: 251: line(uhr_x, uhr_y+1, uhr_x+x, uhr_y+y+1, drawmode);
	ldw	y, (0x01, sp)
	addw	y, #0x0021
	ldw	x, (0x05, sp)
	addw	x, #0x0020
	ld	a, (0x29, sp)
	push	a
	pushw	y
	pushw	x
	push	#0x21
	push	#0x00
	push	#0x20
	push	#0x00
	call	_line
	addw	sp, #9
	jra	00119$
00118$:
;	oled_uhr.c: 255: line(uhr_x+1, uhr_y, uhr_x+x+1, uhr_y+y, drawmode);
	ldw	x, (0x01, sp)
	addw	x, #0x0020
	ldw	y, (0x05, sp)
	addw	y, #0x0021
	ld	a, (0x29, sp)
	push	a
	pushw	x
	pushw	y
	push	#0x20
	push	#0x00
	push	#0x21
	push	#0x00
	call	_line
	addw	sp, #9
00119$:
;	oled_uhr.c: 257: get_zeiger_value(sek, min_zeiger, &x, &y);
	ldw	x, (0x0d, sp)
	ldw	y, (0x07, sp)
	ldw	(0x1b, sp), y
	ldw	y, (0x09, sp)
	pushw	x
	ldw	x, (0x1d, sp)
	pushw	x
	pushw	y
	ldw	x, (0x2d, sp)
	pushw	x
	call	_get_zeiger_value
	addw	sp, #8
;	oled_uhr.c: 258: line(uhr_x, uhr_y, uhr_x+x, uhr_y+y, drawmode);
	ldw	y, (0x01, sp)
	addw	y, #0x0020
	ldw	x, (0x05, sp)
	addw	x, #0x0020
	ld	a, (0x29, sp)
	push	a
	pushw	y
	pushw	x
	push	#0x20
	push	#0x00
	push	#0x20
	push	#0x00
	call	_line
	addw	sp, #41
	ret
;	oled_uhr.c: 262: void putchar(uint8_t ch)
;	-----------------------------------------
;	 function putchar
;	-----------------------------------------
_putchar:
;	oled_uhr.c: 264: oled_putchar(ch);
	ld	a, (0x03, sp)
	push	a
	call	_oled_putchar
	pop	a
	ret
;	oled_uhr.c: 274: void puts(char *p)
;	-----------------------------------------
;	 function puts
;	-----------------------------------------
_puts:
;	oled_uhr.c: 276: do
	ldw	x, (0x03, sp)
00101$:
;	oled_uhr.c: 278: putchar( *p );
	ld	a, (x)
	pushw	x
	push	a
	call	_putchar
	pop	a
	popw	x
;	oled_uhr.c: 279: p++;
	incw	x
;	oled_uhr.c: 280: }while(*p);
	ld	a, (x)
	tnz	a
	jrne	00101$
	ret
;	oled_uhr.c: 297: void putdez2(signed char val, uint8_t mode)
;	-----------------------------------------
;	 function putdez2
;	-----------------------------------------
_putdez2:
;	oled_uhr.c: 300: if (val < 0)
	tnz	(0x03, sp)
	jrpl	00102$
;	oled_uhr.c: 302: putchar('-');
	push	#0x2d
	call	_putchar
	pop	a
;	oled_uhr.c: 303: val= -val;
	neg	(0x03, sp)
00102$:
;	oled_uhr.c: 305: b= val / 10;
	push	#0x0a
	ld	a, (0x04, sp)
	push	a
	call	__divuschar
	addw	sp, #2
	ld	a, xl
;	oled_uhr.c: 306: if (b == 0)
	tnz	a
	jrne	00108$
;	oled_uhr.c: 308: switch(mode)
	ld	a, (0x04, sp)
	cp	a, #0x00
	jreq	00103$
	ld	a, (0x04, sp)
	cp	a, #0x01
	jreq	00104$
	jra	00109$
;	oled_uhr.c: 310: case 0 : putchar('0'); break;
00103$:
	push	#0x30
	call	_putchar
	pop	a
	jra	00109$
;	oled_uhr.c: 311: case 1 : putchar(' '); break;
00104$:
	push	#0x20
	call	_putchar
	pop	a
	jra	00109$
;	oled_uhr.c: 313: }
00108$:
;	oled_uhr.c: 316: putchar(b+'0');
	add	a, #0x30
	push	a
	call	_putchar
	pop	a
00109$:
;	oled_uhr.c: 317: b= val % 10;
	push	#0x0a
	ld	a, (0x04, sp)
	push	a
	call	__moduschar
	addw	sp, #2
;	oled_uhr.c: 318: putchar(b+'0');
	ld	a, xl
	add	a, #0x30
	push	a
	call	_putchar
	pop	a
	ret
;	oled_uhr.c: 325: void systimer_intervall(void)
;	-----------------------------------------
;	 function systimer_intervall
;	-----------------------------------------
_systimer_intervall:
;	oled_uhr.c: 327: intv_ticker++;
	ldw	x, _intv_ticker+0
	incw	x
	ldw	_intv_ticker+0, x
;	oled_uhr.c: 328: intv_ticker = intv_ticker % 30000;
	ldw	x, _intv_ticker+0
	ldw	y, #0x7530
	divw	x, y
	ldw	_intv_ticker+0, y
	ret
;	oled_uhr.c: 347: uint8_t tast2_counter(uint8_t outx, uint8_t outy, uint8_t maxcnt, uint8_t cnt, uint8_t addtocnt)
;	-----------------------------------------
;	 function tast2_counter
;	-----------------------------------------
_tast2_counter:
	pushw	x
;	oled_uhr.c: 351: delay_ms(50);
	push	#0x32
	push	#0x00
	call	_delay_ms
	popw	x
;	oled_uhr.c: 352: intv_ticker= 0;
	clrw	x
	ldw	_intv_ticker+0, x
;	oled_uhr.c: 353: cntspeed= tastlospeed;
	ldw	x, #0x0190
	ldw	(0x01, sp), x
;	oled_uhr.c: 354: while(is_tast2())
00103$:
	ldw	x, #0x5010
	ld	a, (x)
	and	a, #0x04
	srl	a
	srl	a
	tnz	a
	jrne	00105$
;	oled_uhr.c: 356: if (intv_ticker> 2000) cntspeed= tasthispeed;
	ldw	x, _intv_ticker+0
	cpw	x, #0x07d0
	jrule	00102$
	ldw	x, #0x0046
	ldw	(0x01, sp), x
00102$:
;	oled_uhr.c: 357: cnt++;
	inc	(0x08, sp)
;	oled_uhr.c: 358: cnt = cnt % maxcnt;
	clrw	x
	ld	a, (0x08, sp)
	ld	xl, a
	ld	a, (0x07, sp)
	div	x, a
	ld	(0x08, sp), a
;	oled_uhr.c: 359: gotoxy(outx,outy);
	ld	a, (0x06, sp)
	push	a
	ld	a, (0x06, sp)
	push	a
	call	_gotoxy
	popw	x
;	oled_uhr.c: 360: putdez2(cnt+addtocnt,2);
	ld	a, (0x08, sp)
	add	a, (0x09, sp)
	push	#0x02
	push	a
	call	_putdez2
	popw	x
;	oled_uhr.c: 361: putchar(' ');
	push	#0x20
	call	_putchar
	pop	a
;	oled_uhr.c: 362: delay_ms(cntspeed);
	ldw	x, (0x01, sp)
	pushw	x
	call	_delay_ms
	popw	x
	jra	00103$
00105$:
;	oled_uhr.c: 364: delay_ms(50);
	push	#0x32
	push	#0x00
	call	_delay_ms
	popw	x
;	oled_uhr.c: 365: return (cnt+addtocnt);
	ld	a, (0x08, sp)
	add	a, (0x09, sp)
	popw	x
	ret
;	oled_uhr.c: 393: uint16_t adc_read(void)
;	-----------------------------------------
;	 function adc_read
;	-----------------------------------------
_adc_read:
	pushw	x
;	oled_uhr.c: 397: ADC_CR1 |= ADC_CR1_ADON;            // AD-Wandlung starten
	bset	0x5401, #0
;	oled_uhr.c: 398: while (!(ADC_CSR & ADC_CSR_EOX));   // warten bis Conversion beendet
00101$:
	ldw	x, #0x5400
	ld	a, (x)
	tnz	a
	jrpl	00101$
;	oled_uhr.c: 399: delay_us(5);                        // Warten bis Wert gelesen werden kann
	push	#0x05
	push	#0x00
	call	_delay_us
	popw	x
;	oled_uhr.c: 401: adcvalue = (ADC_DRH << 2);          // die unteren 2 Bit
	ldw	x, #0x5404
	ld	a, (x)
	clrw	x
	ld	xl, a
	sllw	x
	sllw	x
	ldw	(0x01, sp), x
;	oled_uhr.c: 402: adcvalue += ADC_DRL;                // die oberen 8 Bit
	ldw	x, #0x5405
	ld	a, (x)
	clrw	x
	ld	xl, a
	addw	x, (0x01, sp)
;	oled_uhr.c: 404: return adcvalue;
	addw	sp, #2
	ret
;	oled_uhr.c: 429: uint16_t get_widerstand(char channel)
;	-----------------------------------------
;	 function get_widerstand
;	-----------------------------------------
_get_widerstand:
	sub	sp, #22
;	oled_uhr.c: 434: adc_init(channel);
	ldw	x, #0x5400
	ld	a, (0x19, sp)
	ld	(x), a
	bset	0x5401, #0
;	oled_uhr.c: 435: delay_ms(5);
	push	#0x05
	push	#0x00
	call	_delay_ms
	popw	x
;	oled_uhr.c: 437: rx= adc_read();
	call	_adc_read
;	oled_uhr.c: 438: rx= 0;
	clrw	x
	ldw	(0x05, sp), x
	ldw	(0x03, sp), x
;	oled_uhr.c: 439: for (i= 0; i<  10; i++)                 // Spg. am Widerstand 10 mal messen
	clrw	x
00102$:
;	oled_uhr.c: 441: rx += adc_read();
	pushw	x
	call	_adc_read
	ldw	(0x03, sp), x
	popw	x
	ldw	y, (0x01, sp)
	clr	a
	clr	(0x13, sp)
	addw	y, (0x05, sp)
	adc	a, (0x04, sp)
	ld	(0x10, sp), a
	ld	a, (0x13, sp)
	adc	a, (0x03, sp)
	ldw	(0x05, sp), y
	ld	(0x03, sp), a
	ld	a, (0x10, sp)
	ld	(0x04, sp), a
;	oled_uhr.c: 442: delay_ms(30);
	pushw	x
	push	#0x1e
	push	#0x00
	call	_delay_ms
	popw	x
	popw	x
;	oled_uhr.c: 439: for (i= 0; i<  10; i++)                 // Spg. am Widerstand 10 mal messen
	incw	x
	cpw	x, #0x000a
	jrc	00102$
;	oled_uhr.c: 446: rx= (rx*100) / (10210-(rx/1));         // 10230 "waere" der richtige Wert, durch
	ldw	x, (0x05, sp)
	pushw	x
	ldw	x, (0x05, sp)
	pushw	x
	push	#0x64
	clrw	x
	pushw	x
	push	#0x00
	call	__mullong
	addw	sp, #8
	ldw	(0x0d, sp), x
	ldw	x, #0x27e2
	subw	x, (0x05, sp)
	clr	a
	sbc	a, (0x04, sp)
	ld	(0x08, sp), a
	clr	a
	sbc	a, (0x03, sp)
	ld	(0x07, sp), a
	pushw	x
	ldw	x, (0x09, sp)
	pushw	x
	ldw	x, (0x11, sp)
	pushw	x
	pushw	y
	call	__divslong
;	oled_uhr.c: 450: return rx;
	addw	sp, #30
	ret
;	oled_uhr.c: 479: int ntc_calc(int wid_wert, int firstval, int stepwidth, int *temp_tab)
;	-----------------------------------------
;	 function ntc_calc
;	-----------------------------------------
_ntc_calc:
	sub	sp, #25
;	oled_uhr.c: 487: b= 0; t= firstval;
	ldw	y, (0x1e, sp)
	ldw	(0x18, sp), y
;	oled_uhr.c: 489: while (wid_wert < temp_tab[b])
	clr	(0x01, sp)
00103$:
	ld	a, (0x01, sp)
	ld	(0x17, sp), a
	ld	a, (0x17, sp)
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	(0x16, sp), a
	ldw	x, (0x16, sp)
	sllw	x
	addw	x, (0x22, sp)
	ldw	x, (x)
	ldw	(0x0a, sp), x
	ldw	x, (0x1c, sp)
	cpw	x, (0x0a, sp)
	jrsge	00105$
;	oled_uhr.c: 491: b++;
	inc	(0x01, sp)
;	oled_uhr.c: 492: t= t + stepwidth;
	ldw	x, (0x18, sp)
	addw	x, (0x20, sp)
	ldw	(0x08, sp), x
	ldw	y, (0x08, sp)
	ldw	(0x18, sp), y
;	oled_uhr.c: 493: if (temp_tab[b]== 0) { return 9999; }    // Fehler oder Temp. zu hoch
	ld	a, (0x01, sp)
	ld	(0x07, sp), a
	ld	a, (0x07, sp)
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	(0x06, sp), a
	ldw	x, (0x06, sp)
	sllw	x
	ldw	(0x14, sp), x
	ldw	x, (0x22, sp)
	addw	x, (0x14, sp)
	ldw	(0x12, sp), x
	ldw	x, (0x12, sp)
	ldw	x, (x)
	ldw	(0x10, sp), x
	ldw	x, (0x10, sp)
	jrne	00103$
	ldw	x, #0x270f
	jra	00108$
00105$:
;	oled_uhr.c: 496: t = t * 10;                                // Pseudokomma
	ldw	x, (0x18, sp)
	pushw	x
	push	#0x0a
	push	#0x00
	call	__mulint
	addw	sp, #4
;	oled_uhr.c: 498: if (wid_wert != temp_tab[b])
	pushw	x
	ldw	x, (0x1e, sp)
	cpw	x, (0x0c, sp)
	popw	x
	jreq	00107$
;	oled_uhr.c: 501: t= t - (stepwidth * 10);                   // Gradschritte in der Tabelle, 10 = Pseudokomma
	pushw	x
	ldw	y, (0x22, sp)
	pushw	y
	push	#0x0a
	push	#0x00
	call	__mulint
	addw	sp, #4
	ldw	(0x10, sp), x
	popw	x
	subw	x, (0x0e, sp)
	ldw	(0x04, sp), x
;	oled_uhr.c: 503: tadd= temp_tab[b-1]-temp_tab[b];           // Diff. zwischen 2 Tabellenwerte = 5 Grad
	ldw	x, (0x16, sp)
	decw	x
	sllw	x
	addw	x, (0x22, sp)
	ldw	x, (x)
	ldw	(0x0c, sp), x
	ldw	y, (0x0c, sp)
	subw	y, (0x0a, sp)
	ldw	(0x02, sp), y
;	oled_uhr.c: 505: t2= temp_tab[b-1]- wid_wert;
	ldw	y, (0x0c, sp)
	subw	y, (0x1c, sp)
;	oled_uhr.c: 507: t2= t2 * stepwidth * 10;
	ldw	x, (0x20, sp)
	pushw	x
	pushw	y
	call	__mulint
	addw	sp, #4
	pushw	x
	push	#0x0a
	push	#0x00
	call	__mulint
	addw	sp, #4
;	oled_uhr.c: 509: t2= (t2 / tadd);
	ldw	y, (0x02, sp)
	pushw	y
	pushw	x
	call	__divsint
	addw	sp, #4
;	oled_uhr.c: 510: t= t+t2;
	addw	x, (0x04, sp)
00107$:
;	oled_uhr.c: 513: return t;
00108$:
	addw	sp, #25
	ret
;	oled_uhr.c: 525: char getwtag(int tag, int monat, int jahr)
;	-----------------------------------------
;	 function getwtag
;	-----------------------------------------
_getwtag:
	sub	sp, #8
;	oled_uhr.c: 529: if (monat < 3)
	ldw	x, (0x0d, sp)
	cpw	x, #0x0003
	jrsge	00102$
;	oled_uhr.c: 531: monat = monat + 12;
	ldw	x, (0x0d, sp)
	addw	x, #0x000c
	ldw	(0x0d, sp), x
;	oled_uhr.c: 532: jahr--;
	ldw	x, (0x0f, sp)
	decw	x
	ldw	(0x0f, sp), x
00102$:
;	oled_uhr.c: 534: w_tag = (tag+2*monat + (3*monat+3)/5 + jahr + jahr/4 - jahr/100 + jahr/400 + 1) % 7 ;
	ldw	x, (0x0d, sp)
	sllw	x
	addw	x, (0x0b, sp)
	ldw	(0x05, sp), x
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
	addw	x, (0x05, sp)
	addw	x, (0x0f, sp)
	ldw	(0x01, sp), x
	push	#0x04
	push	#0x00
	ldw	x, (0x11, sp)
	pushw	x
	call	__divsint
	addw	sp, #4
	addw	x, (0x01, sp)
	pushw	x
	push	#0x64
	push	#0x00
	ldw	y, (0x13, sp)
	pushw	y
	call	__divsint
	addw	sp, #4
	ldw	(0x05, sp), x
	popw	x
	subw	x, (0x03, sp)
	ldw	(0x07, sp), x
	push	#0x90
	push	#0x01
	ldw	x, (0x11, sp)
	pushw	x
	call	__divsint
	addw	sp, #4
	addw	x, (0x07, sp)
	incw	x
	push	#0x07
	push	#0x00
	pushw	x
	call	__modsint
	addw	sp, #4
;	oled_uhr.c: 535: return w_tag;
	ld	a, xl
	addw	sp, #8
	ret
;	oled_uhr.c: 542: void stellen_screen(void)
;	-----------------------------------------
;	 function stellen_screen
;	-----------------------------------------
_stellen_screen:
;	oled_uhr.c: 544: clrscr();
	call	_clrscr
;	oled_uhr.c: 545: gotoxy(0,0); puts("Uhr stellen\n\r----------------");
	push	#0x00
	push	#0x00
	call	_gotoxy
	popw	x
	ldw	x, #___str_0+0
	pushw	x
	call	_puts
	popw	x
;	oled_uhr.c: 546: puts("\n\rStunde :");
	ldw	x, #___str_1+0
	pushw	x
	call	_puts
	popw	x
;	oled_uhr.c: 547: puts("\n\rMinute :");
	ldw	x, #___str_2+0
	pushw	x
	call	_puts
	popw	x
;	oled_uhr.c: 548: puts("\n\rJahr   :");
	ldw	x, #___str_3+0
	pushw	x
	call	_puts
	popw	x
;	oled_uhr.c: 549: puts("\n\rMonat  :");
	ldw	x, #___str_4+0
	pushw	x
	call	_puts
	popw	x
;	oled_uhr.c: 550: puts("\n\rTag    :");
	ldw	x, #___str_5+0
	pushw	x
	call	_puts
	popw	x
	ret
;	oled_uhr.c: 556: void uhr_show(void)
;	-----------------------------------------
;	 function uhr_show
;	-----------------------------------------
_uhr_show:
	sub	sp, #6
;	oled_uhr.c: 561: analoguhr(std,min,sek, 1);
	clrw	y
	ld	a, _sek+0
	ld	yl, a
	clrw	x
	ld	a, _min+0
	ld	xl, a
	ld	a, _std+0
	ld	(0x02, sp), a
	clr	(0x01, sp)
	push	#0x01
	pushw	y
	pushw	x
	ldw	x, (0x06, sp)
	pushw	x
	call	_analoguhr
	addw	sp, #7
;	oled_uhr.c: 562: fb_show(64,0);
	push	#0x00
	push	#0x40
	call	_fb_show
	popw	x
;	oled_uhr.c: 563: analoguhr(std,min,sek, 0);
	clrw	y
	ld	a, _sek+0
	ld	yl, a
	clrw	x
	ld	a, _min+0
	ld	xl, a
	ld	a, _std+0
	ld	(0x04, sp), a
	clr	(0x03, sp)
	push	#0x00
	pushw	y
	pushw	x
	ldw	x, (0x08, sp)
	pushw	x
	call	_analoguhr
	addw	sp, #7
;	oled_uhr.c: 565: gotoxy(0,0);
	push	#0x00
	push	#0x00
	call	_gotoxy
	popw	x
;	oled_uhr.c: 566: putdez2(std,1); putchar(':');
	push	#0x01
	push	_std+0
	call	_putdez2
	popw	x
	push	#0x3a
	call	_putchar
	pop	a
;	oled_uhr.c: 567: putdez2(min,0); putchar('.');
	push	#0x00
	push	_min+0
	call	_putdez2
	popw	x
	push	#0x2e
	call	_putchar
	pop	a
;	oled_uhr.c: 568: putdez2(sek,0);
	push	#0x00
	push	_sek+0
	call	_putdez2
	popw	x
;	oled_uhr.c: 570: temp= getwtag(day, month, year);
	clrw	y
	ld	a, _month+0
	ld	yl, a
	clrw	x
	ld	a, _day+0
	ld	xl, a
	push	_year+1
	push	_year+0
	pushw	y
	pushw	x
	call	_getwtag
	addw	sp, #6
;	oled_uhr.c: 571: gotoxy(0,5); puts(wtag[temp]);
	push	a
	push	#0x05
	push	#0x00
	call	_gotoxy
	popw	x
	pop	a
	ldw	x, #_wtag+0
	ldw	(0x05, sp), x
	push	#0x03
	push	a
	call	__muluschar
	addw	sp, #2
	addw	x, (0x05, sp)
	pushw	x
	call	_puts
	popw	x
;	oled_uhr.c: 572: gotoxy(0,6);
	push	#0x06
	push	#0x00
	call	_gotoxy
	popw	x
;	oled_uhr.c: 573: putdez2(day,0); putchar('.');
	push	#0x00
	push	_day+0
	call	_putdez2
	popw	x
	push	#0x2e
	call	_putchar
	pop	a
;	oled_uhr.c: 574: putdez2(month,0); putchar('.');
	push	#0x00
	push	_month+0
	call	_putdez2
	popw	x
	push	#0x2e
	call	_putchar
	pop	a
;	oled_uhr.c: 575: putdez2(year,0);
	ld	a, _year+1
	push	#0x00
	push	a
	call	_putdez2
	popw	x
;	oled_uhr.c: 577: rval= get_widerstand(4);
	push	#0x04
	call	_get_widerstand
	pop	a
;	oled_uhr.c: 578: temp= (ntc_calc(rval, ntc_firstval, tempstep, &ntc_tab[0])) / 10;
	ldw	y, #_ntc_tab+0
	pushw	y
	push	#0x05
	push	#0x00
	push	#0xec
	push	#0xff
	pushw	x
	call	_ntc_calc
	addw	sp, #8
	push	#0x0a
	push	#0x00
	pushw	x
	call	__divsint
	addw	sp, #4
	ld	a, xl
;	oled_uhr.c: 580: gotoxy(2,3);
	push	a
	push	#0x03
	push	#0x02
	call	_gotoxy
	popw	x
	pop	a
;	oled_uhr.c: 581: putdez2(temp,1);
	push	#0x01
	push	a
	call	_putdez2
	popw	x
;	oled_uhr.c: 582: putchar(130);               // hochgestelltes kleines o = Gradzeichen
	push	#0x82
	call	_putchar
	pop	a
;	oled_uhr.c: 583: putchar('C');
	push	#0x43
	call	_putchar
	pop	a
;	oled_uhr.c: 584: putchar(' ');
	push	#0x20
	call	_putchar
	addw	sp, #7
	ret
;	oled_uhr.c: 591: int main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #21
;	oled_uhr.c: 597: sysclock_init(0);                     // zuerst System fuer internen Takt
	push	#0x00
	call	_sysclock_init
	pop	a
;	oled_uhr.c: 598: delay_ms(200);
	push	#0xc8
	push	#0x00
	call	_delay_ms
	popw	x
;	oled_uhr.c: 599: sysclock_init(1);                     // externer Quarz
	push	#0x01
	call	_sysclock_init
	pop	a
;	oled_uhr.c: 600: oled_init();
	call	_oled_init
;	oled_uhr.c: 601: clrscr();
	call	_clrscr
;	oled_uhr.c: 602: fb_init(64,8);
	push	#0x08
	push	#0x40
	call	_fb_init
	popw	x
;	oled_uhr.c: 603: fb_clear();
	call	_fb_clear
;	oled_uhr.c: 604: tim1_init();
	call	_tim1_init
;	oled_uhr.c: 606: year= 17; month= 7; day= 5; std= 0; min= 0; sek= 0;
	ldw	x, #0x0011
	ldw	_year+0, x
	mov	_month+0, #0x07
	mov	_day+0, #0x05
	clr	_std+0
	clr	_min+0
	clr	_sek+0
;	oled_uhr.c: 608: oldsek= 61;
	ld	a, #0x3d
	ld	(0x06, sp), a
;	oled_uhr.c: 609: circle(uhr_x, uhr_y, 31, 1);
	push	#0x01
	push	#0x1f
	push	#0x00
	push	#0x20
	push	#0x00
	push	#0x20
	push	#0x00
	call	_circle
	addw	sp, #7
;	oled_uhr.c: 611: while(1)
00172$:
;	oled_uhr.c: 613: uhr_show();
	call	_uhr_show
;	oled_uhr.c: 615: while(oldsek == sek)
	ldw	x, #___str_6+0
	ldw	(0x14, sp), x
	ldw	y, (0x14, sp)
	ldw	(0x10, sp), y
00168$:
	ld	a, (0x06, sp)
	cp	a, _sek+0
	jreq	00350$
	jp	00170$
00350$:
;	oled_uhr.c: 617: if (is_tast1())
	ldw	x, #0x5006
	ld	a, (x)
	and	a, #0x10
	swap	a
	and	a, #0x0f
	tnz	a
	jrne	00168$
;	oled_uhr.c: 619: stellen_screen();
	call	_stellen_screen
;	oled_uhr.c: 620: my_std= std; my_min= min; my_year= year; my_month= month; my_day= day;
	ld	a, _std+0
	ld	(0x03, sp), a
	ld	a, _min+0
	ld	(0x05, sp), a
	ld	a, _year+1
	ld	(0x0f, sp), a
	ld	a, _month+0
	ld	(0x04, sp), a
	ld	a, _day+0
	ld	(0x01, sp), a
;	oled_uhr.c: 621: gotoxy(10,3); putdez2(my_std,2); putchar(' ');
	push	#0x03
	push	#0x0a
	call	_gotoxy
	popw	x
	push	#0x02
	ld	a, (0x04, sp)
	push	a
	call	_putdez2
	popw	x
	push	#0x20
	call	_putchar
	pop	a
;	oled_uhr.c: 623: delay_ms(50);
	push	#0x32
	push	#0x00
	call	_delay_ms
	popw	x
;	oled_uhr.c: 624: while(is_tast1());
00101$:
	ldw	x, #0x5006
	ld	a, (x)
	and	a, #0x10
	swap	a
	and	a, #0x0f
	tnz	a
	jreq	00101$
;	oled_uhr.c: 625: delay_ms(50);
	push	#0x32
	push	#0x00
	call	_delay_ms
	popw	x
;	oled_uhr.c: 627: while(!is_tast1())
00106$:
	ldw	x, #0x5006
	ld	a, (x)
	and	a, #0x10
	swap	a
	and	a, #0x0f
	tnz	a
	jreq	00108$
;	oled_uhr.c: 629: if (is_tast2())
	ldw	x, #0x5010
	ld	a, (x)
	and	a, #0x04
	srl	a
	srl	a
	tnz	a
	jrne	00106$
;	oled_uhr.c: 631: my_std= tast2_counter(10,3,24, my_std, 0);
	push	#0x00
	ld	a, (0x04, sp)
	push	a
	push	#0x18
	push	#0x03
	push	#0x0a
	call	_tast2_counter
	addw	sp, #5
	ld	(0x03, sp), a
	jra	00106$
00108$:
;	oled_uhr.c: 634: delay_ms(50);
	push	#0x32
	push	#0x00
	call	_delay_ms
	popw	x
;	oled_uhr.c: 635: while(is_tast1());
00109$:
	ldw	x, #0x5006
	ld	a, (x)
	and	a, #0x10
	swap	a
	and	a, #0x0f
	tnz	a
	jreq	00109$
;	oled_uhr.c: 636: delay_ms(50);
	push	#0x32
	push	#0x00
	call	_delay_ms
	popw	x
;	oled_uhr.c: 638: gotoxy(10,4); putdez2(my_min,2); putchar(' ');
	push	#0x04
	push	#0x0a
	call	_gotoxy
	popw	x
	push	#0x02
	ld	a, (0x06, sp)
	push	a
	call	_putdez2
	popw	x
	push	#0x20
	call	_putchar
	pop	a
;	oled_uhr.c: 639: while(!is_tast1())
00114$:
	ldw	x, #0x5006
	ld	a, (x)
	and	a, #0x10
	swap	a
	and	a, #0x0f
	tnz	a
	jreq	00116$
;	oled_uhr.c: 641: if (is_tast2())
	ldw	x, #0x5010
	ld	a, (x)
	and	a, #0x04
	srl	a
	srl	a
	tnz	a
	jrne	00114$
;	oled_uhr.c: 643: my_min= tast2_counter(10,4,60, my_min, 0);
	push	#0x00
	ld	a, (0x06, sp)
	push	a
	push	#0x3c
	push	#0x04
	push	#0x0a
	call	_tast2_counter
	addw	sp, #5
	ld	(0x05, sp), a
	jra	00114$
00116$:
;	oled_uhr.c: 646: delay_ms(50);
	push	#0x32
	push	#0x00
	call	_delay_ms
	popw	x
;	oled_uhr.c: 647: while(is_tast1());
00117$:
	ldw	x, #0x5006
	ld	a, (x)
	and	a, #0x10
	swap	a
	and	a, #0x0f
	tnz	a
	jreq	00117$
;	oled_uhr.c: 648: delay_ms(50);
	push	#0x32
	push	#0x00
	call	_delay_ms
	popw	x
;	oled_uhr.c: 650: z_year= (my_year % 100) / 10;
	clrw	x
	ld	a, (0x0f, sp)
	ld	xl, a
	ld	a, #0x64
	div	x, a
	clrw	x
	ld	xl, a
	ld	a, #0x0a
	div	x, a
	ld	a, xl
	ld	(0x02, sp), a
;	oled_uhr.c: 651: gotoxy(10,5); puts("20");
	push	#0x05
	push	#0x0a
	call	_gotoxy
	popw	x
	ldw	x, (0x14, sp)
	pushw	x
	call	_puts
	popw	x
;	oled_uhr.c: 652: putdez2(z_year,2);
	push	#0x02
	ld	a, (0x03, sp)
	push	a
	call	_putdez2
	popw	x
;	oled_uhr.c: 653: while(!is_tast1())
00122$:
	ldw	x, #0x5006
	ld	a, (x)
	and	a, #0x10
	swap	a
	and	a, #0x0f
	tnz	a
	jreq	00124$
;	oled_uhr.c: 655: if (is_tast2())
	ldw	x, #0x5010
	ld	a, (x)
	and	a, #0x04
	srl	a
	srl	a
	tnz	a
	jrne	00122$
;	oled_uhr.c: 657: z_year= tast2_counter(12,5,10, z_year, 0);
	push	#0x00
	ld	a, (0x03, sp)
	push	a
	push	#0x0a
	push	#0x05
	push	#0x0c
	call	_tast2_counter
	addw	sp, #5
	ld	(0x02, sp), a
	jra	00122$
00124$:
;	oled_uhr.c: 660: delay_ms(50);
	push	#0x32
	push	#0x00
	call	_delay_ms
	popw	x
;	oled_uhr.c: 661: while(is_tast1());
00125$:
	ldw	x, #0x5006
	ld	a, (x)
	and	a, #0x10
	swap	a
	and	a, #0x0f
	tnz	a
	jreq	00125$
;	oled_uhr.c: 662: delay_ms(50);
	push	#0x32
	push	#0x00
	call	_delay_ms
	popw	x
;	oled_uhr.c: 664: e_year= my_year % 10;
	clrw	x
	ld	a, (0x0f, sp)
	ld	xl, a
	ld	a, #0x0a
	div	x, a
	ld	(0x08, sp), a
;	oled_uhr.c: 665: gotoxy(10,5); puts("20");
	push	#0x05
	push	#0x0a
	call	_gotoxy
	popw	x
	ldw	x, (0x10, sp)
	pushw	x
	call	_puts
	popw	x
;	oled_uhr.c: 666: putdez2(z_year,2);
	push	#0x02
	ld	a, (0x03, sp)
	push	a
	call	_putdez2
	popw	x
;	oled_uhr.c: 667: putdez2(e_year,2);
	push	#0x02
	ld	a, (0x09, sp)
	push	a
	call	_putdez2
	popw	x
;	oled_uhr.c: 669: while(!is_tast1())
00130$:
	ldw	x, #0x5006
	ld	a, (x)
	and	a, #0x10
	swap	a
	and	a, #0x0f
	tnz	a
	jreq	00132$
;	oled_uhr.c: 671: if (is_tast2())
	ldw	x, #0x5010
	ld	a, (x)
	and	a, #0x04
	srl	a
	srl	a
	tnz	a
	jrne	00130$
;	oled_uhr.c: 673: e_year= tast2_counter(13,5,10, e_year, 0);
	push	#0x00
	ld	a, (0x09, sp)
	push	a
	push	#0x0a
	push	#0x05
	push	#0x0d
	call	_tast2_counter
	addw	sp, #5
	ld	(0x08, sp), a
	jra	00130$
00132$:
;	oled_uhr.c: 676: my_year= (z_year*10)+e_year;
	ld	a, (0x02, sp)
	ld	xl, a
	ld	a, #0x0a
	mul	x, a
	ld	a, xl
	add	a, (0x08, sp)
	ld	(0x07, sp), a
;	oled_uhr.c: 677: delay_ms(50);
	push	#0x32
	push	#0x00
	call	_delay_ms
	popw	x
;	oled_uhr.c: 678: while(is_tast1());
00133$:
	ldw	x, #0x5006
	ld	a, (x)
	and	a, #0x10
	swap	a
	and	a, #0x0f
	tnz	a
	jreq	00133$
;	oled_uhr.c: 679: delay_ms(50);
	push	#0x32
	push	#0x00
	call	_delay_ms
	popw	x
;	oled_uhr.c: 681: gotoxy(10,6); putdez2(my_month,2); putchar(' ');
	push	#0x06
	push	#0x0a
	call	_gotoxy
	popw	x
	push	#0x02
	ld	a, (0x05, sp)
	push	a
	call	_putdez2
	popw	x
	push	#0x20
	call	_putchar
	pop	a
;	oled_uhr.c: 682: while(!is_tast1())
00138$:
	ldw	x, #0x5006
	ld	a, (x)
	and	a, #0x10
	swap	a
	and	a, #0x0f
	tnz	a
	jreq	00140$
;	oled_uhr.c: 684: if (is_tast2())
	ldw	x, #0x5010
	ld	a, (x)
	and	a, #0x04
	srl	a
	srl	a
	tnz	a
	jrne	00138$
;	oled_uhr.c: 686: my_month= tast2_counter(10,6,12, my_month-1, 1);
	ld	a, (0x04, sp)
	dec	a
	push	#0x01
	push	a
	push	#0x0c
	push	#0x06
	push	#0x0a
	call	_tast2_counter
	addw	sp, #5
	ld	(0x04, sp), a
	jra	00138$
00140$:
;	oled_uhr.c: 689: delay_ms(50);
	push	#0x32
	push	#0x00
	call	_delay_ms
	popw	x
;	oled_uhr.c: 690: while(is_tast1());
00141$:
	ldw	x, #0x5006
	ld	a, (x)
	and	a, #0x10
	swap	a
	and	a, #0x0f
	tnz	a
	jreq	00141$
;	oled_uhr.c: 691: delay_ms(50);
	push	#0x32
	push	#0x00
	call	_delay_ms
	popw	x
;	oled_uhr.c: 693: gotoxy(10,7); putdez2(my_day,2); putchar(' ');
	push	#0x07
	push	#0x0a
	call	_gotoxy
	popw	x
	push	#0x02
	ld	a, (0x02, sp)
	push	a
	call	_putdez2
	popw	x
	push	#0x20
	call	_putchar
	pop	a
;	oled_uhr.c: 694: while(!is_tast1())
	ld	a, (0x04, sp)
	cp	a, #0x02
	jrne	00369$
	ld	a, #0x01
	ld	(0x13, sp), a
	jra	00370$
00369$:
	clr	(0x13, sp)
00370$:
	ld	a, (0x07, sp)
	and	a, #0x03
	ld	(0x12, sp), a
	ld	a, (0x04, sp)
	cp	a, #0x0b
	jrne	00372$
	ld	a, #0x01
	ld	(0x0e, sp), a
	jra	00373$
00372$:
	clr	(0x0e, sp)
00373$:
	ld	a, (0x04, sp)
	cp	a, #0x09
	jrne	00375$
	ld	a, #0x01
	ld	(0x09, sp), a
	jra	00376$
00375$:
	clr	(0x09, sp)
00376$:
	ld	a, (0x04, sp)
	cp	a, #0x06
	jrne	00378$
	ld	a, #0x01
	ld	(0x0a, sp), a
	jra	00379$
00378$:
	clr	(0x0a, sp)
00379$:
	ld	a, (0x04, sp)
	cp	a, #0x04
	jrne	00381$
	ld	a, #0x01
	ld	(0x0b, sp), a
	jra	00382$
00381$:
	clr	(0x0b, sp)
00382$:
00160$:
	ldw	x, #0x5006
	ld	a, (x)
	and	a, #0x10
	swap	a
	and	a, #0x0f
	tnz	a
	jreq	00162$
;	oled_uhr.c: 696: if (is_tast2())
	ldw	x, #0x5010
	ld	a, (x)
	and	a, #0x04
	srl	a
	srl	a
	tnz	a
	jrne	00160$
;	oled_uhr.c: 699: my_day= tast2_counter(10,7,29, my_day-1, 1);
	ld	a, (0x01, sp)
	dec	a
;	oled_uhr.c: 698: if ((my_month == 2) && ((my_year % 4) == 0))           // Februar im Schaltjahr
	tnz	(0x13, sp)
	jreq	00155$
	tnz	(0x12, sp)
	jrne	00155$
;	oled_uhr.c: 699: my_day= tast2_counter(10,7,29, my_day-1, 1);
	push	#0x01
	push	a
	push	#0x1d
	push	#0x07
	push	#0x0a
	call	_tast2_counter
	addw	sp, #5
	ld	(0x01, sp), a
	jra	00160$
00155$:
;	oled_uhr.c: 701: if ((my_month == 2) && ((my_year % 4) > 0))           // Februar im Nichtschaltjahr
	tnz	(0x13, sp)
	jreq	00151$
	tnz	(0x12, sp)
	jreq	00151$
;	oled_uhr.c: 702: my_day= tast2_counter(10,7,28, my_day-1, 1);
	push	#0x01
	push	a
	push	#0x1c
	push	#0x07
	push	#0x0a
	call	_tast2_counter
	addw	sp, #5
	ld	(0x01, sp), a
	jra	00160$
00151$:
;	oled_uhr.c: 704: if ((my_month==4) || (my_month==6) || (my_month==9) || (my_month== 11))
	tnz	(0x0b, sp)
	jrne	00144$
	tnz	(0x0a, sp)
	jrne	00144$
	tnz	(0x09, sp)
	jrne	00144$
	tnz	(0x0e, sp)
	jreq	00145$
00144$:
;	oled_uhr.c: 705: my_day= tast2_counter(10,7,30, my_day-1, 1);
	push	#0x01
	push	a
	push	#0x1e
	push	#0x07
	push	#0x0a
	call	_tast2_counter
	addw	sp, #5
	ld	(0x01, sp), a
	jra	00160$
00145$:
;	oled_uhr.c: 707: my_day= tast2_counter(10,7,31, my_day-1, 1);
	push	#0x01
	push	a
	push	#0x1f
	push	#0x07
	push	#0x0a
	call	_tast2_counter
	addw	sp, #5
	ld	(0x01, sp), a
	jp	00160$
00162$:
;	oled_uhr.c: 710: delay_ms(50);
	push	#0x32
	push	#0x00
	call	_delay_ms
	popw	x
;	oled_uhr.c: 711: while(is_tast1());
00163$:
	ldw	x, #0x5006
	ld	a, (x)
	and	a, #0x10
	swap	a
	and	a, #0x0f
	tnz	a
	jreq	00163$
;	oled_uhr.c: 712: delay_ms(50);
	push	#0x32
	push	#0x00
	call	_delay_ms
	popw	x
;	oled_uhr.c: 715: std= my_std; min= my_min; sek= 0; oldsek= 61;
	ld	a, (0x03, sp)
	ld	_std+0, a
	ld	a, (0x05, sp)
	ld	_min+0, a
	clr	_sek+0
	ld	a, #0x3d
	ld	(0x06, sp), a
;	oled_uhr.c: 716: year= (z_year * 10) + (e_year); month= my_month; day= my_day;
	ld	a, (0x02, sp)
	ld	xl, a
	ld	a, #0x0a
	mul	x, a
	ld	a, (0x08, sp)
	ld	(0x0d, sp), a
	clr	(0x0c, sp)
	addw	x, (0x0c, sp)
	ldw	_year+0, x
	ld	a, (0x04, sp)
	ld	_month+0, a
	ld	a, (0x01, sp)
	ld	_day+0, a
;	oled_uhr.c: 717: clrscr();
	call	_clrscr
;	oled_uhr.c: 719: fb_clear();
	call	_fb_clear
;	oled_uhr.c: 720: circle(uhr_x, uhr_y, 31, 1);
	push	#0x01
	push	#0x1f
	push	#0x00
	push	#0x20
	push	#0x00
	push	#0x20
	push	#0x00
	call	_circle
	addw	sp, #7
	jp	00168$
00170$:
;	oled_uhr.c: 723: oldsek= sek;
	ld	a, _sek+0
	ld	(0x06, sp), a
	jp	00172$
	addw	sp, #21
	ret
	.area CODE
_uhr:
	.dw #0x0000
	.dw #0xFFE5
	.dw #0x0000
	.dw #0xFFE2
	.dw #0x000D
	.dw #0xFFE9
	.dw #0x000F
	.dw #0xFFE7
	.dw #0x0017
	.dw #0xFFF3
	.dw #0x0019
	.dw #0xFFF1
	.dw #0x001B
	.dw #0x0000
	.dw #0x001E
	.dw #0x0000
	.dw #0x0017
	.dw #0x000D
	.dw #0x0019
	.dw #0x000F
	.dw #0x000D
	.dw #0x0017
	.dw #0x000F
	.dw #0x0019
	.dw #0x0000
	.dw #0x001B
	.dw #0x0000
	.dw #0x001E
	.dw #0xFFF1
	.dw #0xFFE7
	.dw #0xFFF3
	.dw #0xFFE9
	.dw #0xFFE7
	.dw #0xFFF1
	.dw #0xFFE9
	.dw #0xFFF3
	.dw #0xFFE2
	.dw #0x0000
	.dw #0xFFE5
	.dw #0x0000
	.dw #0xFFE7
	.dw #0x000F
	.dw #0xFFE9
	.dw #0x000D
	.dw #0xFFF1
	.dw #0x0019
	.dw #0xFFF3
	.dw #0x0017
_std_zeiger:
	.dw #0x0000
	.dw #0x0002
	.dw #0x0004
	.dw #0x0006
	.dw #0x0008
	.dw #0x000A
	.dw #0x000C
	.dw #0x000E
	.dw #0x000F
	.dw #0x0010
	.dw #0x0012
	.dw #0x0013
	.dw #0x0013
	.dw #0x0014
	.dw #0x0014
	.dw #0x0015
_min_zeiger:
	.dw #0x0000
	.dw #0x0002
	.dw #0x0005
	.dw #0x0007
	.dw #0x000A
	.dw #0x000C
	.dw #0x000E
	.dw #0x0010
	.dw #0x0012
	.dw #0x0014
	.dw #0x0015
	.dw #0x0016
	.dw #0x0017
	.dw #0x0018
	.dw #0x0018
	.dw #0x0019
_ntc_tab:
	.dw #0x1221
	.dw #0x0DA2
	.dw #0x0A56
	.dw #0x07E7
	.dw #0x0616
	.dw #0x04B9
	.dw #0x03B1
	.dw #0x02E8
	.dw #0x024D
	.dw #0x01D6
	.dw #0x0179
	.dw #0x0130
	.dw #0x00F7
	.dw #0x00C9
	.dw #0x00A5
	.dw #0x0088
	.dw #0x0071
	.dw #0x005E
	.dw #0x0000
___str_0:
	.ascii "Uhr stellen"
	.db 0x0A
	.db 0x0D
	.ascii "----------------"
	.db 0x00
___str_1:
	.db 0x0A
	.db 0x0D
	.ascii "Stunde :"
	.db 0x00
___str_2:
	.db 0x0A
	.db 0x0D
	.ascii "Minute :"
	.db 0x00
___str_3:
	.db 0x0A
	.db 0x0D
	.ascii "Jahr   :"
	.db 0x00
___str_4:
	.db 0x0A
	.db 0x0D
	.ascii "Monat  :"
	.db 0x00
___str_5:
	.db 0x0A
	.db 0x0D
	.ascii "Tag    :"
	.db 0x00
___str_6:
	.ascii "20"
	.db 0x00
___str_7:
	.ascii "So"
	.db 0x00
___str_8:
	.ascii "Mo"
	.db 0x00
___str_9:
	.ascii "Di"
	.db 0x00
___str_10:
	.ascii "Mi"
	.db 0x00
___str_11:
	.ascii "Do"
	.db 0x00
___str_12:
	.ascii "Fr"
	.db 0x00
___str_13:
	.ascii "Sa"
	.db 0x00
	.area INITIALIZER
__xinit__intv_ticker:
	.dw #0x0000
__xinit__wtag:
	.ascii "So"
	.db 0x00
	.ascii "Mo"
	.db 0x00
	.ascii "Di"
	.db 0x00
	.ascii "Mi"
	.db 0x00
	.ascii "Do"
	.db 0x00
	.ascii "Fr"
	.db 0x00
	.ascii "Sa"
	.db 0x00
	.area CABS (ABS)
