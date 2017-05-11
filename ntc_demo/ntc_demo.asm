;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Aug 12 2015) (Linux)
; This file was generated Wed Nov  9 14:24:42 2016
;--------------------------------------------------------
	.module ntc_demo
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _ntc_tab
	.globl _main
	.globl _ntc_calc
	.globl _get_widerstand
	.globl _get_spg
	.globl _adc_read
	.globl _uart_init
	.globl _uart_putchar
	.globl _my_printf
	.globl _delay_us
	.globl _delay_ms
	.globl _sysclock_init
	.globl _putchar
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
;	ntc_demo.c: 98: uint16_t adc_read(void)
;	-----------------------------------------
;	 function adc_read
;	-----------------------------------------
_adc_read:
	pushw	x
;	ntc_demo.c: 102: ADC_CR1 |= ADC_CR1_ADON;            // AD-Wandlung starten
	bset	0x5401, #0
;	ntc_demo.c: 103: while (!(ADC_CSR & ADC_CSR_EOX));   // warten bis Conversion beendet
00101$:
	ldw	x, #0x5400
	ld	a, (x)
	tnz	a
	jrpl	00101$
;	ntc_demo.c: 104: delay_us(5);                        // Warten bis Wert gelesen werden kann
	push	#0x05
	push	#0x00
	call	_delay_us
	popw	x
;	ntc_demo.c: 106: adcvalue = (ADC_DRH << 2);          // die unteren 2 Bit
	ldw	x, #0x5404
	ld	a, (x)
	clrw	x
	ld	xl, a
	sllw	x
	sllw	x
	ldw	(0x01, sp), x
;	ntc_demo.c: 107: adcvalue += ADC_DRL;                // die oberen 8 Bit
	ldw	x, #0x5405
	ld	a, (x)
	clrw	x
	ld	xl, a
	addw	x, (0x01, sp)
;	ntc_demo.c: 109: return adcvalue;
	addw	sp, #2
	ret
;	ntc_demo.c: 126: uint16_t get_spg(char channel)
;	-----------------------------------------
;	 function get_spg
;	-----------------------------------------
_get_spg:
;	ntc_demo.c: 130: adc_init(channel);
	ldw	x, #0x5400
	ld	a, (0x03, sp)
	ld	(x), a
	ldw	x, #0x5401
	ld	a, (x)
	or	a, #0x01
	ld	(x), a
;	ntc_demo.c: 131: l= adc_read();
	call	_adc_read
	clrw	y
;	ntc_demo.c: 133: l= u_ref * l;
	pushw	x
	pushw	y
	push	#0x4b
	push	#0x01
	clrw	x
	pushw	x
	call	__mullong
	addw	sp, #8
;	ntc_demo.c: 134: l= l / 1023;                        // 10 Bit Aufloesung
	push	#0xff
	push	#0x03
	push	#0x00
	push	#0x00
	pushw	x
	pushw	y
	call	__divslong
	addw	sp, #8
;	ntc_demo.c: 135: return (uint16_t) l;
	ret
;	ntc_demo.c: 161: uint16_t get_widerstand(char channel)
;	-----------------------------------------
;	 function get_widerstand
;	-----------------------------------------
_get_widerstand:
	sub	sp, #22
;	ntc_demo.c: 166: adc_init(channel);
	ldw	x, #0x5400
	ld	a, (0x19, sp)
	ld	(x), a
	bset	0x5401, #0
;	ntc_demo.c: 167: delay_ms(5);
	push	#0x05
	push	#0x00
	call	_delay_ms
	popw	x
;	ntc_demo.c: 169: rx= adc_read();
	call	_adc_read
;	ntc_demo.c: 170: rx= 0;
	clrw	x
	ldw	(0x09, sp), x
	ldw	(0x07, sp), x
;	ntc_demo.c: 171: for (i= 0; i<  10; i++)                 // Spg. am Widerstand 10 mal messen
	clrw	x
00102$:
;	ntc_demo.c: 173: rx += adc_read();
	pushw	x
	call	_adc_read
	ldw	(0x07, sp), x
	popw	x
	ldw	y, (0x05, sp)
	clr	a
	clr	(0x01, sp)
	addw	y, (0x09, sp)
	adc	a, (0x08, sp)
	ld	(0x10, sp), a
	ld	a, (0x01, sp)
	adc	a, (0x07, sp)
	ldw	(0x09, sp), y
	ld	(0x07, sp), a
	ld	a, (0x10, sp)
	ld	(0x08, sp), a
;	ntc_demo.c: 174: delay_ms(30);
	pushw	x
	push	#0x1e
	push	#0x00
	call	_delay_ms
	popw	x
	popw	x
;	ntc_demo.c: 171: for (i= 0; i<  10; i++)                 // Spg. am Widerstand 10 mal messen
	incw	x
	cpw	x, #0x000a
	jrc	00102$
;	ntc_demo.c: 178: rx= (rx*100) / (10210-(rx/1));         // 10230 "waere" der richtige Wert, durch
	ldw	x, (0x09, sp)
	pushw	x
	ldw	x, (0x09, sp)
	pushw	x
	push	#0x64
	clrw	x
	pushw	x
	push	#0x00
	call	__mullong
	addw	sp, #8
	ldw	(0x0d, sp), x
	ldw	x, #0x27e2
	subw	x, (0x09, sp)
	clr	a
	sbc	a, (0x08, sp)
	ld	(0x14, sp), a
	clr	a
	sbc	a, (0x07, sp)
	ld	(0x13, sp), a
	pushw	x
	ldw	x, (0x15, sp)
	pushw	x
	ldw	x, (0x11, sp)
	pushw	x
	pushw	y
	call	__divslong
;	ntc_demo.c: 182: return rx;
	addw	sp, #30
	ret
;	ntc_demo.c: 211: int ntc_calc(int wid_wert, int firstval, int stepwidth, int *temp_tab)
;	-----------------------------------------
;	 function ntc_calc
;	-----------------------------------------
_ntc_calc:
	sub	sp, #25
;	ntc_demo.c: 219: b= 0; t= firstval;
	ldw	y, (0x1e, sp)
	ldw	(0x0e, sp), y
;	ntc_demo.c: 221: while (wid_wert < temp_tab[b])
	clr	(0x05, sp)
00103$:
	ld	a, (0x05, sp)
	ld	(0x0d, sp), a
	ld	a, (0x0d, sp)
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	(0x0c, sp), a
	ldw	x, (0x0c, sp)
	sllw	x
	addw	x, (0x22, sp)
	ldw	x, (x)
	ldw	(0x0a, sp), x
	ldw	x, (0x1c, sp)
	cpw	x, (0x0a, sp)
	jrsge	00105$
;	ntc_demo.c: 223: b++;
	inc	(0x05, sp)
;	ntc_demo.c: 224: t= t + stepwidth;
	ldw	x, (0x0e, sp)
	addw	x, (0x20, sp)
	ldw	(0x08, sp), x
	ldw	y, (0x08, sp)
	ldw	(0x0e, sp), y
;	ntc_demo.c: 225: if (temp_tab[b]== 0) { return 9999; }    // Fehler oder Temp. zu hoch
	ld	a, (0x05, sp)
	ld	(0x07, sp), a
	ld	a, (0x07, sp)
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	(0x06, sp), a
	ldw	x, (0x06, sp)
	sllw	x
	ldw	(0x18, sp), x
	ldw	x, (0x22, sp)
	addw	x, (0x18, sp)
	ldw	(0x16, sp), x
	ldw	x, (0x16, sp)
	ldw	x, (x)
	ldw	(0x14, sp), x
	ldw	x, (0x14, sp)
	jrne	00103$
	ldw	x, #0x270f
	jra	00108$
00105$:
;	ntc_demo.c: 228: t = t * 10;                                // Pseudokomma
	ldw	x, (0x0e, sp)
	pushw	x
	push	#0x0a
	push	#0x00
	call	__mulint
	addw	sp, #4
;	ntc_demo.c: 230: if (wid_wert != temp_tab[b])
	pushw	x
	ldw	x, (0x1e, sp)
	cpw	x, (0x0c, sp)
	popw	x
	jreq	00107$
;	ntc_demo.c: 233: t= t - (stepwidth * 10);                   // Gradschritte in der Tabelle, 10 = Pseudokomma
	pushw	x
	ldw	y, (0x22, sp)
	pushw	y
	push	#0x0a
	push	#0x00
	call	__mulint
	addw	sp, #4
	ldw	(0x14, sp), x
	popw	x
	subw	x, (0x12, sp)
	ldw	(0x01, sp), x
;	ntc_demo.c: 235: tadd= temp_tab[b-1]-temp_tab[b];           // Diff. zwischen 2 Tabellenwerte = 5 Grad
	ldw	x, (0x0c, sp)
	decw	x
	sllw	x
	addw	x, (0x22, sp)
	ldw	x, (x)
	ldw	(0x10, sp), x
	ldw	y, (0x10, sp)
	subw	y, (0x0a, sp)
	ldw	(0x03, sp), y
;	ntc_demo.c: 237: t2= temp_tab[b-1]- wid_wert;
	ldw	y, (0x10, sp)
	subw	y, (0x1c, sp)
;	ntc_demo.c: 239: t2= t2 * stepwidth * 10;
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
;	ntc_demo.c: 241: t2= (t2 / tadd);
	ldw	y, (0x03, sp)
	pushw	y
	pushw	x
	call	__divsint
	addw	sp, #4
;	ntc_demo.c: 242: t= t+t2;
	addw	x, (0x01, sp)
00107$:
;	ntc_demo.c: 245: return t;
00108$:
	addw	sp, #25
	ret
;	ntc_demo.c: 255: void putchar(char ch)
;	-----------------------------------------
;	 function putchar
;	-----------------------------------------
_putchar:
;	ntc_demo.c: 257: uart_putchar(ch);
	ld	a, (0x03, sp)
	push	a
	call	_uart_putchar
	pop	a
	ret
;	ntc_demo.c: 264: int main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #6
;	ntc_demo.c: 268: sysclock_init(0);
	push	#0x00
	call	_sysclock_init
	pop	a
;	ntc_demo.c: 269: uart_init(19200);
	push	#0x00
	push	#0x4b
	call	_uart_init
	popw	x
;	ntc_demo.c: 271: printf("\n\n\r--------------------");
	ldw	x, #___str_0+0
	pushw	x
	call	_my_printf
	popw	x
;	ntc_demo.c: 272: printf("\n\rWiderstandserfassung");
	ldw	x, #___str_1+0
	pushw	x
	call	_my_printf
	popw	x
;	ntc_demo.c: 273: printf("\n\rUART 19200 bd 8N1");
	ldw	x, #___str_2+0
	pushw	x
	call	_my_printf
	popw	x
;	ntc_demo.c: 274: printf("\n\r--------------------\n\n\r");
	ldw	x, #___str_3+0
	pushw	x
	call	_my_printf
	popw	x
;	ntc_demo.c: 275: while(1)
00102$:
;	ntc_demo.c: 278: spg_wert= get_spg(4);
	push	#0x04
	call	_get_spg
	pop	a
	ldw	(0x01, sp), x
;	ntc_demo.c: 279: wid_wert= get_widerstand(4);
	push	#0x04
	call	_get_widerstand
	pop	a
	ldw	(0x03, sp), x
;	ntc_demo.c: 280: ntc_temp= ntc_calc(wid_wert, ntc_firstval, tempstep, &ntc_tab[0]);
	ldw	x, #_ntc_tab+0
	pushw	x
	push	#0x05
	push	#0x00
	push	#0xec
	push	#0xff
	ldw	x, (0x09, sp)
	pushw	x
	call	_ntc_calc
	addw	sp, #8
	ldw	(0x05, sp), x
;	ntc_demo.c: 282: printfkomma= 2;                               // zwei Kommastelle bei printf-formater k
	mov	_printfkomma+0, #0x02
;	ntc_demo.c: 283: printf("  U_in= %k V   ", spg_wert);
	ldw	x, #___str_4+0
	ldw	y, (0x01, sp)
	pushw	y
	pushw	x
	call	_my_printf
	addw	sp, #4
;	ntc_demo.c: 285: printfkomma= 1;
	mov	_printfkomma+0, #0x01
;	ntc_demo.c: 286: printf("  R= %k kOhm  T= %k oC   \r", wid_wert, ntc_temp);
	ldw	y, #___str_5+0
	ldw	x, (0x05, sp)
	pushw	x
	ldw	x, (0x05, sp)
	pushw	x
	pushw	y
	call	_my_printf
	addw	sp, #6
;	ntc_demo.c: 288: delay_ms(500);
	push	#0xf4
	push	#0x01
	call	_delay_ms
	popw	x
	jra	00102$
	addw	sp, #6
	ret
	.area CODE
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
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.ascii "--------------------"
	.db 0x00
___str_1:
	.db 0x0A
	.db 0x0D
	.ascii "Widerstandserfassung"
	.db 0x00
___str_2:
	.db 0x0A
	.db 0x0D
	.ascii "UART 19200 bd 8N1"
	.db 0x00
___str_3:
	.db 0x0A
	.db 0x0D
	.ascii "--------------------"
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_4:
	.ascii "  U_in= %k V   "
	.db 0x00
___str_5:
	.ascii "  R= %k kOhm  T= %k oC   "
	.db 0x0D
	.db 0x00
	.area INITIALIZER
	.area CABS (ABS)
