;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Aug 12 2015) (Linux)
; This file was generated Fri Apr 21 07:47:57 2017
;--------------------------------------------------------
	.module serial_sindemo
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _draw_sincurve
	.globl _tiny_sin
	.globl _tiny_pow
	.globl _abs
	.globl _my_printf
	.globl _uart_init
	.globl _uart_ischar
	.globl _uart_getchar
	.globl _uart_putchar
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
;	serial_sindemo.c: 30: float abs(float value)
;	-----------------------------------------
;	 function abs
;	-----------------------------------------
_abs:
;	serial_sindemo.c: 32: if (value< 0.0f) return (value * -(1.0f));
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
;	serial_sindemo.c: 33: else return value;
	ldw	x, (0x05, sp)
	ldw	y, (0x03, sp)
00104$:
	ret
;	serial_sindemo.c: 38: float tiny_pow(int n, float value)
;	-----------------------------------------
;	 function tiny_pow
;	-----------------------------------------
_tiny_pow:
	sub	sp, #8
;	serial_sindemo.c: 43: tmp= value;
	ldw	y, (0x0f, sp)
	ldw	(0x05, sp), y
	ldw	y, (0x0d, sp)
;	serial_sindemo.c: 44: for (i= 0; i < n-1; i++)
	ldw	x, (0x0b, sp)
	decw	x
	ldw	(0x07, sp), x
	clrw	x
	ldw	(0x01, sp), x
00103$:
	ldw	x, (0x01, sp)
	cpw	x, (0x07, sp)
	jrsge	00101$
;	serial_sindemo.c: 46: tmp= tmp*value;
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
;	serial_sindemo.c: 44: for (i= 0; i < n-1; i++)
	ldw	x, (0x01, sp)
	incw	x
	ldw	(0x01, sp), x
	jra	00103$
00101$:
;	serial_sindemo.c: 48: return tmp;
	ldw	x, (0x05, sp)
	addw	sp, #8
	ret
;	serial_sindemo.c: 51: float tiny_sin(float value)
;	-----------------------------------------
;	 function tiny_sin
;	-----------------------------------------
_tiny_sin:
	sub	sp, #30
;	serial_sindemo.c: 60: int   mflag= 0;
	clrw	x
	ldw	(0x01, sp), x
;	serial_sindemo.c: 62: while (value > 360.0f) value -= 360.0f;
00101$:
	clrw	x
	pushw	x
	push	#0xb4
	push	#0x43
	ldw	x, (0x27, sp)
	pushw	x
	ldw	x, (0x27, sp)
	pushw	x
	call	___fsgt
	addw	sp, #8
	tnz	a
	jreq	00103$
	clrw	x
	pushw	x
	push	#0xb4
	push	#0x43
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
;	serial_sindemo.c: 63: if (value > 180.0f)
	clrw	x
	pushw	x
	push	#0x34
	push	#0x43
	ldw	x, (0x27, sp)
	pushw	x
	ldw	x, (0x27, sp)
	pushw	x
	call	___fsgt
	addw	sp, #8
	tnz	a
	jreq	00105$
;	serial_sindemo.c: 65: mflag= - 1;
	ldw	x, #0xffff
	ldw	(0x01, sp), x
;	serial_sindemo.c: 66: value -= 180.0f;
	clrw	x
	pushw	x
	push	#0x34
	push	#0x43
	ldw	x, (0x27, sp)
	pushw	x
	ldw	x, (0x27, sp)
	pushw	x
	call	___fssub
	addw	sp, #8
	ldw	(0x23, sp), x
	ldw	(0x21, sp), y
00105$:
;	serial_sindemo.c: 69: if (value > 90.0f) value = 180.0f - value;
	clrw	x
	pushw	x
	push	#0xb4
	push	#0x42
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
	clrw	x
	pushw	x
	push	#0x34
	push	#0x43
	call	___fssub
	addw	sp, #8
	ldw	(0x23, sp), x
	ldw	(0x21, sp), y
00107$:
;	serial_sindemo.c: 71: degree= (value * M_PI) / 180.0f;
	ldw	x, (0x23, sp)
	pushw	x
	ldw	x, (0x23, sp)
	pushw	x
	push	#0xdb
	push	#0x0f
	push	#0x49
	push	#0x40
	call	___fsmul
	addw	sp, #8
	push	#0x00
	push	#0x00
	push	#0x34
	push	#0x43
	pushw	x
	pushw	y
	call	___fsdiv
	addw	sp, #8
	ldw	(0x15, sp), x
	ldw	(0x13, sp), y
;	serial_sindemo.c: 73: p3 = tiny_pow(3, degree);
	ldw	x, (0x15, sp)
	pushw	x
	ldw	x, (0x15, sp)
	pushw	x
	push	#0x03
	push	#0x00
	call	_tiny_pow
	addw	sp, #6
	ldw	(0x11, sp), x
	ldw	(0x0f, sp), y
;	serial_sindemo.c: 74: p5  = tiny_pow(5, degree);
	ldw	x, (0x15, sp)
	pushw	x
	ldw	x, (0x15, sp)
	pushw	x
	push	#0x05
	push	#0x00
	call	_tiny_pow
	addw	sp, #6
	ldw	(0x0d, sp), x
	ldw	(0x0b, sp), y
;	serial_sindemo.c: 75: p7  = tiny_pow(7, degree);
	ldw	x, (0x15, sp)
	pushw	x
	ldw	x, (0x15, sp)
	pushw	x
	push	#0x07
	push	#0x00
	call	_tiny_pow
	addw	sp, #6
	ldw	(0x09, sp), x
	ldw	(0x07, sp), y
;	serial_sindemo.c: 77: sinx= (degree - (p3/6.0f) + (p5/120.0f) - (p7/5040.0f));
	clrw	x
	pushw	x
	push	#0xc0
	push	#0x40
	ldw	x, (0x15, sp)
	pushw	x
	ldw	x, (0x15, sp)
	pushw	x
	call	___fsdiv
	addw	sp, #8
	pushw	x
	pushw	y
	ldw	x, (0x19, sp)
	pushw	x
	ldw	x, (0x19, sp)
	pushw	x
	call	___fssub
	addw	sp, #8
	ldw	(0x19, sp), x
	ldw	(0x17, sp), y
	clrw	x
	pushw	x
	push	#0xf0
	push	#0x42
	ldw	x, (0x11, sp)
	pushw	x
	ldw	x, (0x11, sp)
	pushw	x
	call	___fsdiv
	addw	sp, #8
	pushw	x
	pushw	y
	ldw	x, (0x1d, sp)
	pushw	x
	ldw	x, (0x1d, sp)
	pushw	x
	call	___fsadd
	addw	sp, #8
	ldw	(0x1d, sp), x
	ldw	(0x1b, sp), y
	push	#0x00
	push	#0x80
	push	#0x9d
	push	#0x45
	ldw	x, (0x0d, sp)
	pushw	x
	ldw	x, (0x0d, sp)
	pushw	x
	call	___fsdiv
	addw	sp, #8
	pushw	x
	pushw	y
	ldw	x, (0x21, sp)
	pushw	x
	ldw	x, (0x21, sp)
	pushw	x
	call	___fssub
	addw	sp, #8
	ldw	(0x05, sp), x
;	serial_sindemo.c: 79: if (mflag) sinx = sinx * (-1);
	ldw	x, (0x01, sp)
	jreq	00109$
	ldw	x, (0x05, sp)
	sllw	y
	ccf
	rrcw	y
	ldw	(0x05, sp), x
00109$:
;	serial_sindemo.c: 80: return sinx;
	ldw	x, (0x05, sp)
	addw	sp, #30
	ret
;	serial_sindemo.c: 84: void draw_sincurve(void)
;	-----------------------------------------
;	 function draw_sincurve
;	-----------------------------------------
_draw_sincurve:
	sub	sp, #6
;	serial_sindemo.c: 87: for (i= 0; i< 361; i += 10)
	ldw	x, #___str_0+0
	ldw	(0x05, sp), x
	clrw	x
	ldw	(0x01, sp), x
00106$:
;	serial_sindemo.c: 89: x2 = (tiny_sin(i) * 24) + 25;
	ldw	x, (0x01, sp)
	pushw	x
	call	___sint2fs
	addw	sp, #2
	pushw	x
	pushw	y
	call	_tiny_sin
	addw	sp, #4
	pushw	x
	pushw	y
	clrw	x
	pushw	x
	push	#0xc0
	push	#0x41
	call	___fsmul
	addw	sp, #8
	push	#0x00
	push	#0x00
	push	#0xc8
	push	#0x41
	pushw	x
	pushw	y
	call	___fsadd
	addw	sp, #8
	pushw	x
	pushw	y
	call	___fs2sint
	addw	sp, #4
	ldw	(0x03, sp), x
;	serial_sindemo.c: 90: for (x= 0; x < x2; x++) uart_putchar(' ');
	clrw	x
00104$:
	cpw	x, (0x03, sp)
	jrsge	00101$
	pushw	x
	push	#0x20
	call	_uart_putchar
	pop	a
	popw	x
	incw	x
	jra	00104$
00101$:
;	serial_sindemo.c: 91: printf("o\n\r");
	ldw	x, (0x05, sp)
	pushw	x
	call	_my_printf
	popw	x
;	serial_sindemo.c: 92: delay_ms(40);
	push	#0x28
	push	#0x00
	call	_delay_ms
	popw	x
;	serial_sindemo.c: 87: for (i= 0; i< 361; i += 10)
	ldw	x, (0x01, sp)
	addw	x, #0x000a
	ldw	(0x01, sp), x
	ldw	x, (0x01, sp)
	cpw	x, #0x0169
	jrslt	00106$
	addw	sp, #6
	ret
;	serial_sindemo.c: 103: void putchar(char ch)
;	-----------------------------------------
;	 function putchar
;	-----------------------------------------
_putchar:
;	serial_sindemo.c: 105: uart_putchar(ch);
	ld	a, (0x03, sp)
	push	a
	call	_uart_putchar
	pop	a
	ret
;	serial_sindemo.c: 109: int main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	pushw	x
;	serial_sindemo.c: 115: uint16_t counter = 0;
	clrw	x
	ldw	(0x01, sp), x
;	serial_sindemo.c: 120: printfkomma= 3;
	mov	_printfkomma+0, #0x03
;	serial_sindemo.c: 122: sysclock_init(0);
	push	#0x00
	call	_sysclock_init
	pop	a
;	serial_sindemo.c: 124: uart_init(baudrate);
	push	#0x00
	push	#0xe1
	call	_uart_init
	popw	x
;	serial_sindemo.c: 126: led_output_init();
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
;	serial_sindemo.c: 127: inp_init();
	ldw	x, #0x5011
	ld	a, (x)
	and	a, #0xf7
	ld	(x), a
	ldw	x, #0x5012
	ld	a, (x)
	or	a, #0x08
	ld	(x), a
;	serial_sindemo.c: 132: printf("\n\r--------------------------------------");
	ldw	x, #___str_1+0
	pushw	x
	call	_my_printf
	popw	x
;	serial_sindemo.c: 133: printf("\n\rSTM8 running at %d MHz\n\r", cnt);
	ldw	x, #___str_2+0
	push	#0x10
	push	#0x00
	pushw	x
	call	_my_printf
	addw	sp, #4
;	serial_sindemo.c: 134: printf("8 kByte Flash;  1 KByte RAM\n\n\r");
	ldw	x, #___str_3+0
	pushw	x
	call	_my_printf
	popw	x
;	serial_sindemo.c: 135: printf("Baudrate: %d0\n\n\r",baudrate/10);
	ldw	x, #___str_4+0
	push	#0x80
	push	#0x16
	pushw	x
	call	_my_printf
	addw	sp, #4
;	serial_sindemo.c: 136: printf("20.04.2017  R. Seelig\n\r");
	ldw	x, #___str_5+0
	pushw	x
	call	_my_printf
	popw	x
;	serial_sindemo.c: 137: printf("--------------------------------------\n\r");
	ldw	x, #___str_6+0
	pushw	x
	call	_my_printf
	popw	x
;	serial_sindemo.c: 138: printf("Taste um Counter anzuhalten bzw. neu zu starten\n\n\r");
	ldw	x, #___str_7+0
	pushw	x
	call	_my_printf
	popw	x
;	serial_sindemo.c: 141: while(uart_ischar()) {ch= uart_getchar(); putchar(ch); }  // eventuell eingegangene Zeichen alle loeschen
00101$:
	call	_uart_ischar
	tnz	a
	jreq	00110$
	call	_uart_getchar
	ld	xh, a
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	a, xh
	push	a
	call	_putchar
	pop	a
	jra	00101$
;	serial_sindemo.c: 143: while (1)
00110$:
;	serial_sindemo.c: 145: led_set();
	ldw	x, #0x5005
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
;	serial_sindemo.c: 146: delay_ms(500);
	push	#0xf4
	push	#0x01
	call	_delay_ms
	popw	x
;	serial_sindemo.c: 147: led_clr();
	ldw	x, #0x5005
	ld	a, (x)
	and	a, #0xdf
	ld	(x), a
;	serial_sindemo.c: 149: wuwert= tiny_sin(counter);
	ldw	x, (0x01, sp)
	pushw	x
	call	___uint2fs
	addw	sp, #2
	pushw	x
	pushw	y
	call	_tiny_sin
	addw	sp, #4
;	serial_sindemo.c: 150: wuwerti= wuwert*1000;
	pushw	x
	pushw	y
	clrw	x
	pushw	x
	push	#0x7a
	push	#0x44
	call	___fsmul
	addw	sp, #8
	pushw	x
	pushw	y
	call	___fs2sint
	addw	sp, #4
;	serial_sindemo.c: 152: printf("  Counter: %xh sin(%d)= %k PD3= ", counter, counter, wuwerti);
	ldw	y, #___str_8+0
	pushw	x
	ldw	x, (0x03, sp)
	pushw	x
	ldw	x, (0x05, sp)
	pushw	x
	pushw	y
	call	_my_printf
	addw	sp, #8
;	serial_sindemo.c: 154: if (is_inp()) printf("1     \r");
	ldw	x, #0x5010
	ld	a, (x)
	and	a, #0x08
	srl	a
	srl	a
	srl	a
	tnz	a
	jreq	00105$
	ldw	x, #___str_9+0
	pushw	x
	call	_my_printf
	popw	x
	jra	00106$
00105$:
;	serial_sindemo.c: 155: else printf("0     \r");
	ldw	x, #___str_10+0
	pushw	x
	call	_my_printf
	popw	x
00106$:
;	serial_sindemo.c: 157: delay_ms(500);
	push	#0xf4
	push	#0x01
	call	_delay_ms
	popw	x
;	serial_sindemo.c: 158: counter++;
	ldw	x, (0x01, sp)
	incw	x
;	serial_sindemo.c: 159: counter = counter % 3600;
	ldw	y, #0x0e10
	divw	x, y
	ldw	(0x01, sp), y
;	serial_sindemo.c: 161: if (uart_ischar())
	call	_uart_ischar
	tnz	a
	jrne	00136$
	jp	00110$
00136$:
;	serial_sindemo.c: 163: ch= uart_getchar();
	call	_uart_getchar
	ld	xl, a
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	xh, a
;	serial_sindemo.c: 164: printf("\n\n\rGedrueckte Taste war: %c\n\r", ch );
	ldw	y, #___str_11+0
	pushw	x
	pushw	y
	call	_my_printf
	addw	sp, #4
;	serial_sindemo.c: 165: printf("Beliebige Taste fuer Counterstart...\n\n\r");
	ldw	x, #___str_12+0
	pushw	x
	call	_my_printf
	popw	x
;	serial_sindemo.c: 166: ch= uart_getchar();
	call	_uart_getchar
;	serial_sindemo.c: 167: draw_sincurve();
	call	_draw_sincurve
	jp	00110$
	addw	sp, #2
	ret
	.area CODE
___str_0:
	.ascii "o"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_1:
	.db 0x0A
	.db 0x0D
	.ascii "--------------------------------------"
	.db 0x00
___str_2:
	.db 0x0A
	.db 0x0D
	.ascii "STM8 running at %d MHz"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_3:
	.ascii "8 kByte Flash;  1 KByte RAM"
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_4:
	.ascii "Baudrate: %d0"
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_5:
	.ascii "20.04.2017  R. Seelig"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_6:
	.ascii "--------------------------------------"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_7:
	.ascii "Taste um Counter anzuhalten bzw. neu zu starten"
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_8:
	.ascii "  Counter: %xh sin(%d)= %k PD3= "
	.db 0x00
___str_9:
	.ascii "1     "
	.db 0x0D
	.db 0x00
___str_10:
	.ascii "0     "
	.db 0x0D
	.db 0x00
___str_11:
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.ascii "Gedrueckte Taste war: %c"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_12:
	.ascii "Beliebige Taste fuer Counterstart..."
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.db 0x00
	.area INITIALIZER
	.area CABS (ABS)
