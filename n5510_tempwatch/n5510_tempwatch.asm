;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Aug 12 2015) (Linux)
; This file was generated Thu Apr 20 22:16:22 2017
;--------------------------------------------------------
	.module n5510_tempwatch
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _ntc_tab
	.globl _main
	.globl _show_time
	.globl _show_tempbar
	.globl _fillbar
	.globl _ntc_calc
	.globl _get_widerstand
	.globl _get_spg
	.globl _adc_read
	.globl _uart_init
	.globl _uart_putchar
	.globl _scr_update
	.globl _showimage
	.globl _rectangle
	.globl _putpixel
	.globl _lcd_putchar
	.globl _gotoxy
	.globl _clrscr
	.globl _lcd_init
	.globl _my_printf
	.globl _tim1_init
	.globl _int_disable
	.globl _int_enable
	.globl _delay_us
	.globl _delay_ms
	.globl _sysclock_init
	.globl _outchannel
	.globl _systimer_intervall
	.globl _putchar
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
_outchannel::
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
;	n5510_tempwatch.c: 170: void systimer_intervall()
;	-----------------------------------------
;	 function systimer_intervall
;	-----------------------------------------
_systimer_intervall:
;	n5510_tempwatch.c: 172: if (millisek == 500) { sekled_clr(); sekled2_set(); }
	ldw	x, _millisek+0
	cpw	x, #0x01f4
	jrne	00102$
	ldw	x, #0x5005
	ld	a, (x)
	and	a, #0xdf
	ld	(x), a
	ldw	x, #0x500f
	ld	a, (x)
	or	a, #0x02
	ld	(x), a
00102$:
;	n5510_tempwatch.c: 173: if (millisek == 0) { sekled_set(); sekled2_clr(); }
	ldw	x, _millisek+0
	jrne	00105$
	ldw	x, #0x5005
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
	ldw	x, #0x500f
	ld	a, (x)
	and	a, #0xfd
	ld	(x), a
00105$:
	ret
;	n5510_tempwatch.c: 205: uint16_t adc_read(void)
;	-----------------------------------------
;	 function adc_read
;	-----------------------------------------
_adc_read:
	pushw	x
;	n5510_tempwatch.c: 209: ADC_CR1 |= ADC_CR1_ADON;            // AD-Wandlung starten
	bset	0x5401, #0
;	n5510_tempwatch.c: 210: while (!(ADC_CSR & ADC_CSR_EOX));   // warten bis Conversion beendet
00101$:
	ldw	x, #0x5400
	ld	a, (x)
	tnz	a
	jrpl	00101$
;	n5510_tempwatch.c: 211: delay_us(5);                        // Warten bis Wert gelesen werden kann
	push	#0x05
	push	#0x00
	call	_delay_us
	popw	x
;	n5510_tempwatch.c: 213: adcvalue = (ADC_DRH << 2);          // die unteren 2 Bit
	ldw	x, #0x5404
	ld	a, (x)
	clrw	x
	ld	xl, a
	sllw	x
	sllw	x
	ldw	(0x01, sp), x
;	n5510_tempwatch.c: 214: adcvalue += ADC_DRL;                // die oberen 8 Bit
	ldw	x, #0x5405
	ld	a, (x)
	clrw	x
	ld	xl, a
	addw	x, (0x01, sp)
;	n5510_tempwatch.c: 216: return adcvalue;
	addw	sp, #2
	ret
;	n5510_tempwatch.c: 233: uint16_t get_spg(char channel)
;	-----------------------------------------
;	 function get_spg
;	-----------------------------------------
_get_spg:
;	n5510_tempwatch.c: 237: adc_init(channel);
	ldw	x, #0x5400
	ld	a, (0x03, sp)
	ld	(x), a
	ldw	x, #0x5401
	ld	a, (x)
	or	a, #0x01
	ld	(x), a
;	n5510_tempwatch.c: 238: l= adc_read();
	call	_adc_read
	clrw	y
;	n5510_tempwatch.c: 240: l= u_ref * l;
	pushw	x
	pushw	y
	push	#0x4b
	push	#0x01
	clrw	x
	pushw	x
	call	__mullong
	addw	sp, #8
;	n5510_tempwatch.c: 241: l= l / 1023;                        // 10 Bit Aufloesung
	push	#0xff
	push	#0x03
	push	#0x00
	push	#0x00
	pushw	x
	pushw	y
	call	__divslong
	addw	sp, #8
;	n5510_tempwatch.c: 242: return (uint16_t) l;
	ret
;	n5510_tempwatch.c: 268: uint16_t get_widerstand(char channel)
;	-----------------------------------------
;	 function get_widerstand
;	-----------------------------------------
_get_widerstand:
	sub	sp, #22
;	n5510_tempwatch.c: 273: adc_init(channel);
	ldw	x, #0x5400
	ld	a, (0x19, sp)
	ld	(x), a
	bset	0x5401, #0
;	n5510_tempwatch.c: 274: delay_ms(5);
	push	#0x05
	push	#0x00
	call	_delay_ms
	popw	x
;	n5510_tempwatch.c: 276: rx= adc_read();
	call	_adc_read
;	n5510_tempwatch.c: 277: rx= 0;
	clrw	x
	ldw	(0x11, sp), x
	ldw	(0x0f, sp), x
;	n5510_tempwatch.c: 278: for (i= 0; i<  10; i++)                 // Spg. am Widerstand 10 mal messen
	clrw	x
00102$:
;	n5510_tempwatch.c: 280: rx += adc_read();
	pushw	x
	call	_adc_read
	ldw	(0x0f, sp), x
	popw	x
	ldw	y, (0x0d, sp)
	clr	a
	clr	(0x09, sp)
	addw	y, (0x11, sp)
	adc	a, (0x10, sp)
	ld	(0x14, sp), a
	ld	a, (0x09, sp)
	adc	a, (0x0f, sp)
	ldw	(0x11, sp), y
	ld	(0x0f, sp), a
	ld	a, (0x14, sp)
	ld	(0x10, sp), a
;	n5510_tempwatch.c: 281: delay_ms(30);
	pushw	x
	push	#0x1e
	push	#0x00
	call	_delay_ms
	popw	x
	popw	x
;	n5510_tempwatch.c: 278: for (i= 0; i<  10; i++)                 // Spg. am Widerstand 10 mal messen
	incw	x
	cpw	x, #0x000a
	jrc	00102$
;	n5510_tempwatch.c: 285: rx= (rx*100) / (10210-(rx/1));         // 10230 "waere" der richtige Wert, durch
	ldw	x, (0x11, sp)
	pushw	x
	ldw	x, (0x11, sp)
	pushw	x
	push	#0x64
	clrw	x
	pushw	x
	push	#0x00
	call	__mullong
	addw	sp, #8
	ldw	(0x07, sp), x
	ldw	x, #0x27e2
	subw	x, (0x11, sp)
	clr	a
	sbc	a, (0x10, sp)
	ld	(0x02, sp), a
	clr	a
	sbc	a, (0x0f, sp)
	ld	(0x01, sp), a
	pushw	x
	ldw	x, (0x03, sp)
	pushw	x
	ldw	x, (0x0b, sp)
	pushw	x
	pushw	y
	call	__divslong
;	n5510_tempwatch.c: 289: return rx;
	addw	sp, #30
	ret
;	n5510_tempwatch.c: 322: int ntc_calc(int wid_wert, int firstval, int stepwidth, int *temp_tab)
;	-----------------------------------------
;	 function ntc_calc
;	-----------------------------------------
_ntc_calc:
	sub	sp, #25
;	n5510_tempwatch.c: 330: b= 0; t= firstval;
	ldw	y, (0x1e, sp)
	ldw	(0x06, sp), y
;	n5510_tempwatch.c: 332: while (wid_wert < temp_tab[b])
	clr	(0x01, sp)
00103$:
	ld	a, (0x01, sp)
	ld	(0x19, sp), a
	ld	a, (0x19, sp)
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	(0x18, sp), a
	ldw	x, (0x18, sp)
	sllw	x
	addw	x, (0x22, sp)
	ldw	x, (x)
	ldw	(0x16, sp), x
	ldw	x, (0x1c, sp)
	cpw	x, (0x16, sp)
	jrsge	00105$
;	n5510_tempwatch.c: 334: b++;
	inc	(0x01, sp)
;	n5510_tempwatch.c: 335: t= t + stepwidth;
	ldw	x, (0x06, sp)
	addw	x, (0x20, sp)
	ldw	(0x14, sp), x
	ldw	y, (0x14, sp)
	ldw	(0x06, sp), y
;	n5510_tempwatch.c: 336: if (temp_tab[b]== 0) { return 9999; }    // Fehler oder Temp. zu hoch
	ld	a, (0x01, sp)
	ld	(0x13, sp), a
	ld	a, (0x13, sp)
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	(0x12, sp), a
	ldw	x, (0x12, sp)
	sllw	x
	ldw	(0x10, sp), x
	ldw	x, (0x22, sp)
	addw	x, (0x10, sp)
	ldw	(0x0e, sp), x
	ldw	x, (0x0e, sp)
	ldw	x, (x)
	ldw	(0x0c, sp), x
	ldw	x, (0x0c, sp)
	jrne	00103$
	ldw	x, #0x270f
	jra	00108$
00105$:
;	n5510_tempwatch.c: 339: t = t * 10;                                // Pseudokomma
	ldw	x, (0x06, sp)
	pushw	x
	push	#0x0a
	push	#0x00
	call	__mulint
	addw	sp, #4
;	n5510_tempwatch.c: 341: if (wid_wert != temp_tab[b])
	pushw	x
	ldw	x, (0x1e, sp)
	cpw	x, (0x18, sp)
	popw	x
	jreq	00107$
;	n5510_tempwatch.c: 344: t= t - (stepwidth * 10);                   // Gradschritte in der Tabelle, 10 = Pseudokomma
	pushw	x
	ldw	y, (0x22, sp)
	pushw	y
	push	#0x0a
	push	#0x00
	call	__mulint
	addw	sp, #4
	ldw	(0x0c, sp), x
	popw	x
	subw	x, (0x0a, sp)
	ldw	(0x02, sp), x
;	n5510_tempwatch.c: 346: tadd= temp_tab[b-1]-temp_tab[b];           // Diff. zwischen 2 Tabellenwerte = 5 Grad
	ldw	x, (0x18, sp)
	decw	x
	sllw	x
	addw	x, (0x22, sp)
	ldw	x, (x)
	ldw	(0x08, sp), x
	ldw	y, (0x08, sp)
	subw	y, (0x16, sp)
	ldw	(0x04, sp), y
;	n5510_tempwatch.c: 348: t2= temp_tab[b-1]- wid_wert;
	ldw	y, (0x08, sp)
	subw	y, (0x1c, sp)
;	n5510_tempwatch.c: 350: t2= t2 * stepwidth * 10;
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
;	n5510_tempwatch.c: 352: t2= (t2 / tadd);
	ldw	y, (0x04, sp)
	pushw	y
	pushw	x
	call	__divsint
	addw	sp, #4
;	n5510_tempwatch.c: 353: t= t+t2;
	addw	x, (0x02, sp)
00107$:
;	n5510_tempwatch.c: 356: return t;
00108$:
	addw	sp, #25
	ret
;	n5510_tempwatch.c: 368: void fillbar(char x1, char y1, char x2, char y2, char f)
;	-----------------------------------------
;	 function fillbar
;	-----------------------------------------
_fillbar:
	sub	sp, #6
;	n5510_tempwatch.c: 371: for (y= y1; y< y2+1; y++)
	ld	a, (0x0a, sp)
	ld	(0x03, sp), a
00107$:
	ld	a, (0x0c, sp)
	ld	xl, a
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	xh, a
	incw	x
	ldw	(0x01, sp), x
	ld	a, (0x03, sp)
	ld	xl, a
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	xh, a
	cpw	x, (0x01, sp)
	jrsge	00109$
;	n5510_tempwatch.c: 372: for (x= x1; x< x2+1; x++)
	ld	a, (0x09, sp)
	ld	(0x06, sp), a
00104$:
	ld	a, (0x0b, sp)
	ld	xl, a
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	xh, a
	incw	x
	ldw	(0x04, sp), x
	ld	a, (0x06, sp)
	ld	xl, a
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	xh, a
	cpw	x, (0x04, sp)
	jrsge	00108$
;	n5510_tempwatch.c: 373: putpixel(x,y,f);
	ld	a, (0x0d, sp)
	push	a
	ld	a, (0x04, sp)
	push	a
	ld	a, (0x08, sp)
	push	a
	call	_putpixel
	addw	sp, #3
;	n5510_tempwatch.c: 372: for (x= x1; x< x2+1; x++)
	inc	(0x06, sp)
	jra	00104$
00108$:
;	n5510_tempwatch.c: 371: for (y= y1; y< y2+1; y++)
	inc	(0x03, sp)
	jra	00107$
00109$:
	addw	sp, #6
	ret
;	n5510_tempwatch.c: 390: void show_tempbar(int temp)
;	-----------------------------------------
;	 function show_tempbar
;	-----------------------------------------
_show_tempbar:
	push	a
;	n5510_tempwatch.c: 395: if (temp> 500) temp= 500;
	ldw	x, (0x04, sp)
	cpw	x, #0x01f4
	jrsle	00102$
	ldw	x, #0x01f4
	ldw	(0x04, sp), x
00102$:
;	n5510_tempwatch.c: 396: ypix= temp / 20;
	push	#0x14
	push	#0x00
	ldw	x, (0x06, sp)
	pushw	x
	call	__divsint
	addw	sp, #4
	ld	a, xl
	ld	(0x01, sp), a
;	n5510_tempwatch.c: 397: fillbar(tem_xpos+6, 2, tem_xpos+10, 32, 0);           // alte Anzeige loeschen
	push	#0x00
	push	#0x20
	push	#0x0d
	push	#0x02
	push	#0x09
	call	_fillbar
	addw	sp, #5
;	n5510_tempwatch.c: 398: fillbar(tem_xpos+6, 27- ypix, tem_xpos+10, 32, 1);
	ld	a, #0x1b
	sub	a, (0x01, sp)
	push	#0x01
	push	#0x20
	push	#0x0d
	push	a
	push	#0x09
	call	_fillbar
	addw	sp, #6
	ret
;	n5510_tempwatch.c: 406: void show_time(void)
;	-----------------------------------------
;	 function show_time
;	-----------------------------------------
_show_time:
;	n5510_tempwatch.c: 408: if (std < 10) printf("0");
	ld	a, _std+0
	cp	a, #0x0a
	jrnc	00102$
	ldw	x, #___str_0+0
	pushw	x
	call	_my_printf
	popw	x
00102$:
;	n5510_tempwatch.c: 409: printf("%d:",std);
	clrw	x
	ld	a, _std+0
	ld	xl, a
	ldw	y, #___str_1+0
	pushw	x
	pushw	y
	call	_my_printf
	addw	sp, #4
;	n5510_tempwatch.c: 411: if (min < 10) printf("0");
	ld	a, _min+0
	cp	a, #0x0a
	jrnc	00104$
	ldw	x, #___str_0+0
	pushw	x
	call	_my_printf
	popw	x
00104$:
;	n5510_tempwatch.c: 412: printf("%d.",min);
	clrw	x
	ld	a, _min+0
	ld	xl, a
	ldw	y, #___str_2+0
	pushw	x
	pushw	y
	call	_my_printf
	addw	sp, #4
;	n5510_tempwatch.c: 414: if (sek < 10) printf("0");
	ld	a, _sek+0
	cp	a, #0x0a
	jrnc	00106$
	ldw	x, #___str_0+0
	pushw	x
	call	_my_printf
	popw	x
00106$:
;	n5510_tempwatch.c: 415: printf("%d",sek);
	clrw	x
	ld	a, _sek+0
	ld	xl, a
	ldw	y, #___str_3+0
	pushw	x
	pushw	y
	call	_my_printf
	addw	sp, #4
	ret
;	n5510_tempwatch.c: 425: void putchar(char ch)
;	-----------------------------------------
;	 function putchar
;	-----------------------------------------
_putchar:
;	n5510_tempwatch.c: 427: switch(outchannel)
	ld	a, _outchannel+0
	cp	a, #0x00
	jreq	00101$
	ld	a, _outchannel+0
	cp	a, #0x01
	jreq	00102$
	jra	00105$
;	n5510_tempwatch.c: 429: case 0  : { lcd_putchar(ch); break; }
00101$:
	ld	a, (0x03, sp)
	push	a
	call	_lcd_putchar
	pop	a
	jra	00105$
;	n5510_tempwatch.c: 430: case 1  : { uart_putchar(ch); break; }
00102$:
	ld	a, (0x03, sp)
	push	a
	call	_uart_putchar
	pop	a
;	n5510_tempwatch.c: 432: }
00105$:
	ret
;	n5510_tempwatch.c: 440: int main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #5
;	n5510_tempwatch.c: 445: sysclock_init(0);
	push	#0x00
	call	_sysclock_init
	pop	a
;	n5510_tempwatch.c: 446: delay_ms(50);
	push	#0x32
	push	#0x00
	call	_delay_ms
	popw	x
;	n5510_tempwatch.c: 447: sysclock_init(1);                              // mit externem Quarz (auch als Zeitbasis)
	push	#0x01
	call	_sysclock_init
	pop	a
;	n5510_tempwatch.c: 449: tim1_init();                                   // Timer1 - Interrupt = Uhr starten
	call	_tim1_init
;	n5510_tempwatch.c: 450: uart_init(19200);
	push	#0x00
	push	#0x4b
	call	_uart_init
	popw	x
;	n5510_tempwatch.c: 452: lcd_init();
	call	_lcd_init
;	n5510_tempwatch.c: 454: sekled_init();
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
;	n5510_tempwatch.c: 455: sekled2_init();
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
;	n5510_tempwatch.c: 456: setbutton_init();
	ldw	x, #0x5007
	ld	a, (x)
	and	a, #0xef
	ld	(x), a
	ldw	x, #0x5008
	ld	a, (x)
	or	a, #0x10
	ld	(x), a
;	n5510_tempwatch.c: 457: retbutton_init();
	ldw	x, #0x5011
	ld	a, (x)
	and	a, #0xfb
	ld	(x), a
	ldw	x, #0x5012
	ld	a, (x)
	or	a, #0x04
	ld	(x), a
;	n5510_tempwatch.c: 459: std= 9; min= 9; sek= 57; year= 2016; month= 1; day= 1;
	mov	_std+0, #0x09
	mov	_min+0, #0x09
	mov	_sek+0, #0x39
	ldw	x, #0x07e0
	ldw	_year+0, x
	mov	_month+0, #0x01
	mov	_day+0, #0x01
;	n5510_tempwatch.c: 460: directwrite= 0;
	clr	_directwrite+0
;	n5510_tempwatch.c: 461: printfkomma= 1;                               // Kommaausgaben mittels my_printf mit einer Kommastelle
	mov	_printfkomma+0, #0x01
;	n5510_tempwatch.c: 463: showimage(0, 0, &watchbmp[0],1);
	ldw	x, #_watchbmp+0
	push	#0x01
	pushw	x
	push	#0x00
	push	#0x00
	call	_showimage
	addw	sp, #5
;	n5510_tempwatch.c: 464: scr_update();
	call	_scr_update
;	n5510_tempwatch.c: 465: delay_ms(2500);
	push	#0xc4
	push	#0x09
	call	_delay_ms
	popw	x
;	n5510_tempwatch.c: 466: clrscr();
	call	_clrscr
;	n5510_tempwatch.c: 467: showimage(tem_xpos, 0, &thermo84[0],1);
	ldw	x, #_thermo84+0
	push	#0x01
	pushw	x
	push	#0x00
	push	#0x03
	call	_showimage
	addw	sp, #5
;	n5510_tempwatch.c: 468: rectangle(38, 14, 80, 26, 1);
	push	#0x01
	push	#0x1a
	push	#0x50
	push	#0x0e
	push	#0x26
	call	_rectangle
	addw	sp, #5
;	n5510_tempwatch.c: 469: gotoxy(6,4);
	push	#0x04
	push	#0x06
	call	_gotoxy
	popw	x
;	n5510_tempwatch.c: 470: scr_update();
	call	_scr_update
;	n5510_tempwatch.c: 471: outchannel= 1;
	mov	_outchannel+0, #0x01
;	n5510_tempwatch.c: 473: printf("\n\n\r  --------------------");
	ldw	x, #___str_4+0
	pushw	x
	call	_my_printf
	popw	x
;	n5510_tempwatch.c: 474: printf("\n\r  STM8S103F3P6");
	ldw	x, #___str_5+0
	pushw	x
	call	_my_printf
	popw	x
;	n5510_tempwatch.c: 475: printf("\n\r  NTC 0,2 4,7K");
	ldw	x, #___str_6+0
	pushw	x
	call	_my_printf
	popw	x
;	n5510_tempwatch.c: 476: printf("\n\r  --------------------\n\n\r");
	ldw	x, #___str_7+0
	pushw	x
	call	_my_printf
	popw	x
;	n5510_tempwatch.c: 477: oldsek= sek + 1;
	ld	a, _sek+0
	inc	a
	ld	(0x01, sp), a
;	n5510_tempwatch.c: 478: while(1)
00124$:
;	n5510_tempwatch.c: 481: if (oldsek != sek)
	ld	a, (0x01, sp)
	ld	xl, a
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	xh, a
	ld	a, _sek+0
	ld	(0x05, sp), a
	clr	(0x04, sp)
	cpw	x, (0x04, sp)
	jrne	00181$
	jp	00105$
00181$:
;	n5510_tempwatch.c: 483: oldsek= sek;
	ld	a, _sek+0
	ld	(0x01, sp), a
;	n5510_tempwatch.c: 484: spg_wert= get_spg(4);
	push	#0x04
	call	_get_spg
	pop	a
;	n5510_tempwatch.c: 485: wid_wert= get_widerstand(4);
	push	#0x04
	call	_get_widerstand
	pop	a
;	n5510_tempwatch.c: 486: ntc_temp= ntc_calc(wid_wert, ntc_firstval, tempstep, &ntc_tab[0]);
	ldw	y, #_ntc_tab+0
	pushw	y
	push	#0x05
	push	#0x00
	push	#0xec
	push	#0xff
	pushw	x
	call	_ntc_calc
	addw	sp, #8
	ldw	(0x02, sp), x
;	n5510_tempwatch.c: 488: outchannel= 1;                                // Ausgabe auf RS232
	mov	_outchannel+0, #0x01
;	n5510_tempwatch.c: 490: printf("  ");
	ldw	x, #___str_8+0
	pushw	x
	call	_my_printf
	popw	x
;	n5510_tempwatch.c: 491: show_time();
	call	_show_time
;	n5510_tempwatch.c: 492: printf(" T= %k oC   \r", ntc_temp);
	ldw	x, #___str_9+0
	ldw	y, (0x02, sp)
	pushw	y
	pushw	x
	call	_my_printf
	addw	sp, #4
;	n5510_tempwatch.c: 494: outchannel= 0;                                // Ausgabe auf LCD
	clr	_outchannel+0
;	n5510_tempwatch.c: 496: show_tempbar(ntc_temp);
	ldw	x, (0x02, sp)
	pushw	x
	call	_show_tempbar
	popw	x
;	n5510_tempwatch.c: 497: gotoxy(7,2);
	push	#0x02
	push	#0x07
	call	_gotoxy
	popw	x
;	n5510_tempwatch.c: 498: if (ntc_temp< 1000)                           // nur bis 99.9 Grad anzeigen
	ldw	x, (0x02, sp)
	cpw	x, #0x03e8
	jrsge	00102$
;	n5510_tempwatch.c: 499: printf("%k%cC",ntc_temp, 124);              // 124 = hochgestelltes kleines o
	ldw	x, #___str_10+0
	push	#0x7c
	push	#0x00
	ldw	y, (0x04, sp)
	pushw	y
	pushw	x
	call	_my_printf
	addw	sp, #6
	jra	00103$
00102$:
;	n5510_tempwatch.c: 501: printf("------");
	ldw	x, #___str_11+0
	pushw	x
	call	_my_printf
	popw	x
00103$:
;	n5510_tempwatch.c: 503: gotoxy(6,5); show_time();
	push	#0x05
	push	#0x06
	call	_gotoxy
	popw	x
	call	_show_time
;	n5510_tempwatch.c: 505: scr_update();
	call	_scr_update
00105$:
;	n5510_tempwatch.c: 508: if ( is_setbutton() )                           // wenn Set Button gedrueckt
	ldw	x, #0x5006
	ld	a, (x)
	and	a, #0x10
	swap	a
	and	a, #0x0f
	tnz	a
	jreq	00184$
	jp	00124$
00184$:
;	n5510_tempwatch.c: 510: int_disable();
	call	_int_disable
;	n5510_tempwatch.c: 511: delay_ms(tastdelay);
	push	#0xb4
	push	#0x00
	call	_delay_ms
	popw	x
;	n5510_tempwatch.c: 512: outchannel= 0;                                // Ausgabe auf LCD
	clr	_outchannel+0
;	n5510_tempwatch.c: 514: gotoxy(7,4); putchar(126);
	push	#0x04
	push	#0x07
	call	_gotoxy
	popw	x
	push	#0x7e
	call	_putchar
	pop	a
;	n5510_tempwatch.c: 515: scr_update();
	call	_scr_update
;	n5510_tempwatch.c: 517: while ( !is_retbutton() )                     // solange keine Return Taste
00108$:
	ldw	x, #0x5010
	ld	a, (x)
	and	a, #0x04
	srl	a
	srl	a
	tnz	a
	jreq	00110$
;	n5510_tempwatch.c: 519: if ( is_setbutton() )
	ldw	x, #0x5006
	ld	a, (x)
	and	a, #0x10
	swap	a
	and	a, #0x0f
	tnz	a
	jrne	00108$
;	n5510_tempwatch.c: 521: std++;
	inc	_std+0
;	n5510_tempwatch.c: 522: std= std % 24;
	clrw	x
	ld	a, _std+0
	ld	xl, a
	ld	a, #0x18
	div	x, a
	ld	_std+0, a
;	n5510_tempwatch.c: 523: gotoxy(6,5); show_time();
	push	#0x05
	push	#0x06
	call	_gotoxy
	popw	x
	call	_show_time
;	n5510_tempwatch.c: 524: delay_ms(stelldelay);
	push	#0xfa
	push	#0x00
	call	_delay_ms
	popw	x
;	n5510_tempwatch.c: 525: scr_update();
	call	_scr_update
	jra	00108$
00110$:
;	n5510_tempwatch.c: 528: delay_ms(tastdelay);
	push	#0xb4
	push	#0x00
	call	_delay_ms
	popw	x
;	n5510_tempwatch.c: 529: gotoxy(7,4); putchar(' ');
	push	#0x04
	push	#0x07
	call	_gotoxy
	popw	x
	push	#0x20
	call	_putchar
	pop	a
;	n5510_tempwatch.c: 530: gotoxy(10,4); putchar(126);
	push	#0x04
	push	#0x0a
	call	_gotoxy
	popw	x
	push	#0x7e
	call	_putchar
	pop	a
;	n5510_tempwatch.c: 531: scr_update();
	call	_scr_update
;	n5510_tempwatch.c: 533: while ( !is_retbutton() )                     // solange keine Return Taste
00113$:
	ldw	x, #0x5010
	ld	a, (x)
	and	a, #0x04
	srl	a
	srl	a
	tnz	a
	jreq	00115$
;	n5510_tempwatch.c: 535: if ( is_setbutton() )
	ldw	x, #0x5006
	ld	a, (x)
	and	a, #0x10
	swap	a
	and	a, #0x0f
	tnz	a
	jrne	00113$
;	n5510_tempwatch.c: 537: min++;
	inc	_min+0
;	n5510_tempwatch.c: 538: min= min % 60;
	clrw	x
	ld	a, _min+0
	ld	xl, a
	ld	a, #0x3c
	div	x, a
	ld	_min+0, a
;	n5510_tempwatch.c: 539: gotoxy(6,5); show_time();
	push	#0x05
	push	#0x06
	call	_gotoxy
	popw	x
	call	_show_time
;	n5510_tempwatch.c: 540: delay_ms(stelldelay);
	push	#0xfa
	push	#0x00
	call	_delay_ms
	popw	x
;	n5510_tempwatch.c: 541: scr_update();
	call	_scr_update
	jra	00113$
00115$:
;	n5510_tempwatch.c: 544: delay_ms(tastdelay);
	push	#0xb4
	push	#0x00
	call	_delay_ms
	popw	x
;	n5510_tempwatch.c: 545: gotoxy(10,4); putchar(' ');
	push	#0x04
	push	#0x0a
	call	_gotoxy
	popw	x
	push	#0x20
	call	_putchar
	pop	a
;	n5510_tempwatch.c: 546: gotoxy(13,4); putchar(126);
	push	#0x04
	push	#0x0d
	call	_gotoxy
	popw	x
	push	#0x7e
	call	_putchar
	pop	a
;	n5510_tempwatch.c: 547: scr_update();
	call	_scr_update
;	n5510_tempwatch.c: 549: while ( !is_retbutton() )                     // solange keine Return Taste
00118$:
	ldw	x, #0x5010
	ld	a, (x)
	and	a, #0x04
	srl	a
	srl	a
	tnz	a
	jreq	00120$
;	n5510_tempwatch.c: 551: if ( is_setbutton() )
	ldw	x, #0x5006
	ld	a, (x)
	and	a, #0x10
	swap	a
	and	a, #0x0f
	tnz	a
	jrne	00118$
;	n5510_tempwatch.c: 553: sek++;
	inc	_sek+0
;	n5510_tempwatch.c: 554: sek= sek % 60;
	clrw	x
	ld	a, _sek+0
	ld	xl, a
	ld	a, #0x3c
	div	x, a
	ld	_sek+0, a
;	n5510_tempwatch.c: 555: gotoxy(6,5); show_time();
	push	#0x05
	push	#0x06
	call	_gotoxy
	popw	x
	call	_show_time
;	n5510_tempwatch.c: 556: delay_ms(stelldelay);
	push	#0xfa
	push	#0x00
	call	_delay_ms
	popw	x
;	n5510_tempwatch.c: 557: scr_update();
	call	_scr_update
	jra	00118$
00120$:
;	n5510_tempwatch.c: 560: delay_ms(tastdelay);
	push	#0xb4
	push	#0x00
	call	_delay_ms
	popw	x
;	n5510_tempwatch.c: 561: gotoxy(13,4); putchar(' ');
	push	#0x04
	push	#0x0d
	call	_gotoxy
	popw	x
	push	#0x20
	call	_putchar
	pop	a
;	n5510_tempwatch.c: 562: scr_update();
	call	_scr_update
;	n5510_tempwatch.c: 563: millisek= 0;
	clrw	x
	ldw	_millisek+0, x
;	n5510_tempwatch.c: 565: int_enable();
	call	_int_enable
	jp	00124$
	addw	sp, #5
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
_thermo84:
	.db #0x1E	; 30
	.db #0x30	; 48	'0'
	.db #0x03	; 3
	.db #0xE0	; 224
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x04	; 4
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x0B	; 11
	.db #0xC0	; 192
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x0A	; 10
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x0A	; 10
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x0A	; 10
	.db #0x04	; 4
	.db #0xBC	; 188
	.db #0x08	; 8
	.db #0x0A	; 10
	.db #0x04	; 4
	.db #0xA4	; 164
	.db #0x08	; 8
	.db #0x0B	; 11
	.db #0xC7	; 199
	.db #0xA4	; 164
	.db #0x08	; 8
	.db #0x0A	; 10
	.db #0x00	; 0
	.db #0xA4	; 164
	.db #0x08	; 8
	.db #0x0A	; 10
	.db #0x00	; 0
	.db #0xBC	; 188
	.db #0x08	; 8
	.db #0x0A	; 10
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x0A	; 10
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x0B	; 11
	.db #0xC0	; 192
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x0A	; 10
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x0A	; 10
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x0A	; 10
	.db #0x07	; 7
	.db #0xBC	; 188
	.db #0x08	; 8
	.db #0x0A	; 10
	.db #0x00	; 0
	.db #0xA4	; 164
	.db #0x08	; 8
	.db #0x0B	; 11
	.db #0xC7	; 199
	.db #0xA4	; 164
	.db #0x08	; 8
	.db #0x0A	; 10
	.db #0x04	; 4
	.db #0x24	; 36
	.db #0x08	; 8
	.db #0x0A	; 10
	.db #0x07	; 7
	.db #0xBC	; 188
	.db #0x08	; 8
	.db #0x0A	; 10
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x0A	; 10
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x0B	; 11
	.db #0xC0	; 192
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x0A	; 10
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x0A	; 10
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x0A	; 10
	.db #0x01	; 1
	.db #0xE0	; 224
	.db #0x08	; 8
	.db #0x0A	; 10
	.db #0x01	; 1
	.db #0x20	; 32
	.db #0x08	; 8
	.db #0x0B	; 11
	.db #0xC1	; 193
	.db #0x20	; 32
	.db #0x08	; 8
	.db #0x0A	; 10
	.db #0x01	; 1
	.db #0x20	; 32
	.db #0x08	; 8
	.db #0x0A	; 10
	.db #0x01	; 1
	.db #0xE0	; 224
	.db #0x08	; 8
	.db #0x0A	; 10
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x0A	; 10
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x0B	; 11
	.db #0xC0	; 192
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x0B	; 11
	.db #0xE8	; 232
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x0B	; 11
	.db #0xE8	; 232
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x13	; 19
	.db #0xE4	; 228
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x2F	; 47
	.db #0xFA	; 250
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x5F	; 95
	.db #0xFD	; 253
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x5F	; 95
	.db #0xFD	; 253
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x5F	; 95
	.db #0xFD	; 253
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x5F	; 95
	.db #0xFD	; 253
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x2F	; 47
	.db #0xFA	; 250
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x13	; 19
	.db #0xE4	; 228
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x0C	; 12
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0xE0	; 224
	.db #0x00	; 0
	.db #0x00	; 0
_watchbmp:
	.db #0x54	; 84	'T'
	.db #0x30	; 48	'0'
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
	.db #0x0C	; 12
	.db #0xFC	; 252
	.db #0x10	; 16
	.db #0xC0	; 192
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x12	; 18
	.db #0x26	; 38
	.db #0x31	; 49	'1'
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x26	; 38
	.db #0x31	; 49	'1'
	.db #0x20	; 32
	.db #0x07	; 7
	.db #0xF0	; 240
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x0C	; 12
	.db #0x25	; 37
	.db #0x50	; 80	'P'
	.db #0xC0	; 192
	.db #0x3D	; 61
	.db #0x5F	; 95
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x02	; 2
	.db #0x25	; 37
	.db #0x51	; 81	'Q'
	.db #0x20	; 32
	.db #0xDF	; 223
	.db #0xFF	; 255
	.db #0xE0	; 224
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x12	; 18
	.db #0x25	; 37
	.db #0x51	; 81	'Q'
	.db #0x23	; 35
	.db #0x71	; 113	'q'
	.db #0x43	; 67	'C'
	.db #0xD8	; 216
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x0C	; 12
	.db #0x24	; 36
	.db #0x90	; 144
	.db #0xCD	; 205
	.db #0xFF	; 255
	.db #0xF9	; 249
	.db #0x74	; 116	't'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x13	; 19
	.db #0xCB	; 203
	.db #0xF9	; 249
	.db #0xFA	; 250
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3F	; 63
	.db #0xBF	; 191
	.db #0xFF	; 255
	.db #0x7D	; 125
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x5D	; 93
	.db #0x78	; 120	'x'
	.db #0x03	; 3
	.db #0xD6	; 214
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xB1	; 177
	.db #0xC1	; 193
	.db #0x60	; 96
	.db #0x7B	; 123
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0xE3	; 227
	.db #0x01	; 1
	.db #0x20	; 32
	.db #0x1F	; 31
	.db #0xB0	; 176
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x02	; 2
	.db #0x5E	; 94
	.db #0x41	; 65	'A'
	.db #0xE0	; 224
	.db #0x8F	; 143
	.db #0xF8	; 248
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0xFC	; 252
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0xC7	; 199
	.db #0xFC	; 252
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x0D	; 13
	.db #0xF0	; 240
	.db #0x43	; 67	'C'
	.db #0xF0	; 240
	.db #0x83	; 131
	.db #0xF7	; 247
	.db #0xF8	; 248
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x07	; 7
	.db #0xFB	; 251
	.db #0xF0	; 240
	.db #0x0F	; 15
	.db #0xFE	; 254
	.db #0x05	; 5
	.db #0xBF	; 191
	.db #0xF8	; 248
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x0F	; 15
	.db #0xE7	; 231
	.db #0xE0	; 224
	.db #0xBF	; 191
	.db #0xFF	; 255
	.db #0x1E	; 30
	.db #0xFE	; 254
	.db #0xC0	; 192
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0xEF	; 239
	.db #0xC7	; 199
	.db #0xFF	; 255
	.db #0xFF	; 255
	.db #0xFA	; 250
	.db #0xF3	; 243
	.db #0xE0	; 224
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x9F	; 159
	.db #0xD2	; 210
	.db #0xBF	; 191
	.db #0xFF	; 255
	.db #0x94	; 148
	.db #0x40	; 64
	.db #0xFF	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x7F	; 127
	.db #0x96	; 150
	.db #0x8F	; 143
	.db #0xFE	; 254
	.db #0x27	; 39
	.db #0x6F	; 111	'o'
	.db #0xC7	; 199
	.db #0xFF	; 255
	.db #0xE0	; 224
	.db #0x05	; 5
	.db #0xFF	; 255
	.db #0xF1	; 241
	.db #0x91	; 145
	.db #0xD7	; 215
	.db #0xF9	; 249
	.db #0x60	; 96
	.db #0x7F	; 127
	.db #0xEC	; 236
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x7F	; 127
	.db #0xEF	; 239
	.db #0xCF	; 207
	.db #0x81	; 129
	.db #0xDB	; 219
	.db #0xF6	; 246
	.db #0xF0	; 240
	.db #0x3F	; 63
	.db #0xFC	; 252
	.db #0x7F	; 127
	.db #0xC0	; 192
	.db #0xE8	; 232
	.db #0x3F	; 63
	.db #0xFF	; 255
	.db #0x81	; 129
	.db #0xED	; 237
	.db #0xEC	; 236
	.db #0xF0	; 240
	.db #0x3F	; 63
	.db #0xFD	; 253
	.db #0xFF	; 255
	.db #0x00	; 0
	.db #0x3F	; 63
	.db #0xBF	; 191
	.db #0xFF	; 255
	.db #0x03	; 3
	.db #0xF5	; 245
	.db #0xD9	; 217
	.db #0xF0	; 240
	.db #0x30	; 48	'0'
	.db #0x39	; 57	'9'
	.db #0xEF	; 239
	.db #0x00	; 0
	.db #0x3D	; 61
	.db #0xBF	; 191
	.db #0xA3	; 163
	.db #0x3B	; 59
	.db #0xF9	; 249
	.db #0xC3	; 195
	.db #0xF3	; 243
	.db #0x3F	; 63
	.db #0xFB	; 251
	.db #0xEF	; 239
	.db #0x00	; 0
	.db #0x1D	; 29
	.db #0xFE	; 254
	.db #0xFF	; 255
	.db #0x3B	; 59
	.db #0xFF	; 255
	.db #0x1F	; 31
	.db #0xF3	; 243
	.db #0xBA	; 186
	.db #0x3B	; 59
	.db #0xCF	; 207
	.db #0x00	; 0
	.db #0x39	; 57	'9'
	.db #0xDD	; 221
	.db #0xFF	; 255
	.db #0x13	; 19
	.db #0xFF	; 255
	.db #0x7F	; 127
	.db #0xF0	; 240
	.db #0xB4	; 180
	.db #0xDF	; 223
	.db #0xCF	; 207
	.db #0x00	; 0
	.db #0x19	; 25
	.db #0xEC	; 236
	.db #0x27	; 39
	.db #0x33	; 51	'3'
	.db #0xFF	; 255
	.db #0xFF	; 255
	.db #0xF3	; 243
	.db #0x3F	; 63
	.db #0xFF	; 255
	.db #0xCF	; 207
	.db #0x00	; 0
	.db #0x19	; 25
	.db #0xE8	; 232
	.db #0x03	; 3
	.db #0x81	; 129
	.db #0xFF	; 255
	.db #0xFF	; 255
	.db #0xF0	; 240
	.db #0x3F	; 63
	.db #0xBB	; 187
	.db #0xCF	; 207
	.db #0x00	; 0
	.db #0x19	; 25
	.db #0xFF	; 255
	.db #0xFF	; 255
	.db #0x81	; 129
	.db #0xFF	; 255
	.db #0xFF	; 255
	.db #0xF0	; 240
	.db #0x38	; 56	'8'
	.db #0x05	; 5
	.db #0xCE	; 206
	.db #0x00	; 0
	.db #0x19	; 25
	.db #0xEC	; 236
	.db #0x9B	; 155
	.db #0x81	; 129
	.db #0xFF	; 255
	.db #0xFB	; 251
	.db #0xE0	; 224
	.db #0x79	; 121	'y'
	.db #0xF7	; 247
	.db #0xCE	; 206
	.db #0x00	; 0
	.db #0x19	; 25
	.db #0x9D	; 157
	.db #0xFF	; 255
	.db #0x8C	; 140
	.db #0xFE	; 254
	.db #0xFF	; 255
	.db #0xEC	; 236
	.db #0x7F	; 127
	.db #0xAF	; 175
	.db #0xCE	; 206
	.db #0x00	; 0
	.db #0x19	; 25
	.db #0xF3	; 243
	.db #0xDF	; 223
	.db #0xCC	; 204
	.db #0xFB	; 251
	.db #0xFF	; 255
	.db #0xEC	; 236
	.db #0x7F	; 127
	.db #0x03	; 3
	.db #0xCF	; 207
	.db #0x00	; 0
	.db #0x19	; 25
	.db #0xE7	; 231
	.db #0xFB	; 251
	.db #0xCC	; 204
	.db #0x7F	; 127
	.db #0xDB	; 219
	.db #0xCC	; 204
	.db #0xED	; 237
	.db #0x07	; 7
	.db #0xC6	; 198
	.db #0x00	; 0
	.db #0x1D	; 29
	.db #0xC0	; 192
	.db #0x7F	; 127
	.db #0xEC	; 236
	.db #0x3F	; 63
	.db #0xFF	; 255
	.db #0x84	; 132
	.db #0xFF	; 255
	.db #0xFF	; 255
	.db #0xCE	; 206
	.db #0x00	; 0
	.db #0x19	; 25
	.db #0xFF	; 255
	.db #0x25	; 37
	.db #0xE0	; 224
	.db #0x0F	; 15
	.db #0xFE	; 254
	.db #0x01	; 1
	.db #0xBB	; 187
	.db #0xFF	; 255
	.db #0xC6	; 198
	.db #0x00	; 0
	.db #0x1D	; 29
	.db #0xFC	; 252
	.db #0xBF	; 191
	.db #0xF0	; 240
	.db #0x33	; 51	'3'
	.db #0xF9	; 249
	.db #0xC3	; 195
	.db #0xFF	; 255
	.db #0x4B	; 75	'K'
	.db #0xCE	; 206
	.db #0x00	; 0
	.db #0x1D	; 29
	.db #0xFE	; 254
	.db #0xFA	; 250
	.db #0x18	; 24
	.db #0x10	; 16
	.db #0x01	; 1
	.db #0xC3	; 195
	.db #0xD6	; 214
	.db #0xAF	; 175
	.db #0xC6	; 198
	.db #0x00	; 0
	.db #0x19	; 25
	.db #0xFE	; 254
	.db #0x00	; 0
	.db #0x0C	; 12
	.db #0x30	; 48	'0'
	.db #0x40	; 64
	.db #0x47	; 71	'G'
	.db #0x70	; 112	'p'
	.db #0x3F	; 63
	.db #0xC6	; 198
	.db #0x00	; 0
	.db #0x19	; 25
	.db #0xFC	; 252
	.db #0x0E	; 14
	.db #0xEE	; 238
	.db #0x20	; 32
	.db #0xE0	; 224
	.db #0x8D	; 141
	.db #0x97	; 151
	.db #0x38	; 56	'8'
	.db #0xC6	; 198
	.db #0x00	; 0
	.db #0x19	; 25
	.db #0xC2	; 194
	.db #0x32	; 50	'2'
	.db #0xF7	; 247
	.db #0x80	; 128
	.db #0xA0	; 160
	.db #0x3F	; 63
	.db #0x73	; 115	's'
	.db #0x9F	; 159
	.db #0xC7	; 199
	.db #0x00	; 0
	.db #0x1D	; 29
	.db #0xF8	; 248
	.db #0xFD	; 253
	.db #0xFF	; 255
	.db #0xE0	; 224
	.db #0x61	; 97	'a'
	.db #0xFA	; 250
	.db #0x7E	; 126
	.db #0x6F	; 111	'o'
	.db #0xC6	; 198
	.db #0x00	; 0
	.db #0x1C	; 28
	.db #0x79	; 121	'y'
	.db #0xAE	; 174
	.db #0x99	; 153
	.db #0xFF	; 255
	.db #0x5F	; 95
	.db #0xFF	; 255
	.db #0xFB	; 251
	.db #0x67	; 103	'g'
	.db #0xE6	; 230
	.db #0x00	; 0
	.db #0x1D	; 29
	.db #0xB9	; 185
	.db #0xF7	; 247
	.db #0xFF	; 255
	.db #0xFF	; 255
	.db #0xFF	; 255
	.db #0xFF	; 255
	.db #0xFB	; 251
	.db #0x4D	; 77	'M'
	.db #0xC7	; 199
	.db #0x00	; 0
	.db #0x1C	; 28
	.db #0xBD	; 189
	.db #0xD7	; 215
	.db #0xEF	; 239
	.db #0xF7	; 247
	.db #0xD9	; 217
	.db #0xDF	; 223
	.db #0xFB	; 251
	.db #0xDD	; 221
	.db #0xE6	; 230
	.db #0x00	; 0
	.db #0x1D	; 29
	.db #0xDC	; 220
	.db #0x27	; 39
	.db #0xBF	; 191
	.db #0xFA	; 250
	.db #0x3F	; 63
	.db #0xFF	; 255
	.db #0xFB	; 251
	.db #0xF3	; 243
	.db #0xC7	; 199
	.db #0x00	; 0
	.db #0x1D	; 29
	.db #0xEF	; 239
	.db #0xCF	; 207
	.db #0xF5	; 245
	.db #0xD1	; 209
	.db #0x7F	; 127
	.db #0xEF	; 239
	.db #0xFD	; 253
	.db #0xC7	; 199
	.db #0xE7	; 231
	.db #0x00	; 0
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
	.ascii "0"
	.db 0x00
___str_1:
	.ascii "%d:"
	.db 0x00
___str_2:
	.ascii "%d."
	.db 0x00
___str_3:
	.ascii "%d"
	.db 0x00
___str_4:
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.ascii "  --------------------"
	.db 0x00
___str_5:
	.db 0x0A
	.db 0x0D
	.ascii "  STM8S103F3P6"
	.db 0x00
___str_6:
	.db 0x0A
	.db 0x0D
	.ascii "  NTC 0,2 4,7K"
	.db 0x00
___str_7:
	.db 0x0A
	.db 0x0D
	.ascii "  --------------------"
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_8:
	.ascii "  "
	.db 0x00
___str_9:
	.ascii " T= %k oC   "
	.db 0x0D
	.db 0x00
___str_10:
	.ascii "%k%cC"
	.db 0x00
___str_11:
	.ascii "------"
	.db 0x00
	.area INITIALIZER
__xinit__outchannel:
	.db #0x01	;  1
	.area CABS (ABS)
