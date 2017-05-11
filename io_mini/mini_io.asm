;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Aug 12 2015) (Linux)
; This file was generated Fri Nov 18 00:42:27 2016
;--------------------------------------------------------
	.module mini_io
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _io_bitset
	.globl _io_inputinit
	.globl _io_set
	.globl _io_outputinit
	.globl _sysclock_init
	.globl _delay_ms
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
;	mini_io.c: 105: void delay_ms(uint16_t cnt)
;	-----------------------------------------
;	 function delay_ms
;	-----------------------------------------
_delay_ms:
	pushw	x
;	mini_io.c: 109: while (cnt)
	ldw	y, (0x05, sp)
00104$:
	tnzw	y
	jreq	00107$
;	mini_io.c: 111: cnt2= 1435;
	ldw	x, #0x059b
	ldw	(0x01, sp), x
;	mini_io.c: 112: while(cnt2)
00101$:
	ldw	x, (0x01, sp)
	jreq	00103$
;	mini_io.c: 114: cnt2--;
	ldw	x, (0x01, sp)
	decw	x
	ldw	(0x01, sp), x
	jra	00101$
00103$:
;	mini_io.c: 116: cnt--;
	decw	y
	jra	00104$
00107$:
	popw	x
	ret
;	mini_io.c: 128: void sysclock_init(void)
;	-----------------------------------------
;	 function sysclock_init
;	-----------------------------------------
_sysclock_init:
;	mini_io.c: 130: CLK_ICKR = 0;                                  //  Reset Register interner clock
	mov	0x50c0+0, #0x00
;	mini_io.c: 131: CLK_ECKR = 0;                                  //  Reset Register externer clock (ext. clock disable)
	mov	0x50c1+0, #0x00
;	mini_io.c: 133: CLK_ICKR =  HSIEN;                             //  Interner clock enable
	mov	0x50c0+0, #0x01
;	mini_io.c: 134: while ((CLK_ICKR & (HSIRDY)) == 0);            //  warten bis int. Takt eingeschwungen ist
00101$:
	ldw	x, #0x50c0
	ld	a, (x)
	bcp	a, #0x02
	jreq	00101$
;	mini_io.c: 137: CLK_CKDIVR = 0;                                //  Taktteiler auf volle Geschwindigkeit
	mov	0x50c6+0, #0x00
;	mini_io.c: 138: CLK_PCKENR1 = 0xff;                            //  alle Peripherietakte an
	mov	0x50c7+0, #0xff
;	mini_io.c: 139: CLK_PCKENR2 = 0xff;                            //  dto.
	mov	0x50ca+0, #0xff
;	mini_io.c: 141: CLK_CCOR = 0;                                  //  CCO aus
	mov	0x50c9+0, #0x00
;	mini_io.c: 142: CLK_HSITRIMR = 0;                              //  keine Taktjustierung
	mov	0x50cc+0, #0x00
;	mini_io.c: 143: CLK_SWIMCCR = 0;                               //  SWIM = clock / 2.
	mov	0x50cd+0, #0x00
;	mini_io.c: 144: CLK_SWR = 0xe1;                                //  int. Generator als Taktquelle
	mov	0x50c4+0, #0xe1
;	mini_io.c: 145: CLK_SWCR = 0;                                  //  Reset clock switch control register.
	mov	0x50c5+0, #0x00
;	mini_io.c: 146: CLK_SWCR = SWEN;                               //  Enable switching.
	mov	0x50c5+0, #0x02
;	mini_io.c: 147: while ((CLK_SWCR &  SWBSY) != 0);              //  warten bis Peripherietakt stabil
00104$:
	ldw	x, #0x50c5
	ld	a, (x)
	bcp	a, #0x08
	jrne	00104$
;	mini_io.c: 149: delay_ms(50);
	push	#0x32
	push	#0x00
	call	_delay_ms
	popw	x
	ret
;	mini_io.c: 183: void io_outputinit(uint8_t ioport, uint8_t iono)
;	-----------------------------------------
;	 function io_outputinit
;	-----------------------------------------
_io_outputinit:
	sub	sp, #4
;	mini_io.c: 188: ioadr+= (ioport*5);
	ld	a, (0x07, sp)
	ld	xl, a
	ld	a, #0x05
	mul	x, a
	addw	x, #0x5000
	ldw	(0x01, sp), x
;	mini_io.c: 190: b= 1 << iono;
	ld	a, #0x01
	push	a
	ld	a, (0x09, sp)
	jreq	00104$
00103$:
	sll	(1, sp)
	dec	a
	jrne	00103$
00104$:
	pop	a
	ld	(0x03, sp), a
;	mini_io.c: 191: *(ioadr + P_DDR) |=  b;        // Output Register
	ldw	x, (0x01, sp)
	incw	x
	incw	x
	ld	a, (x)
	or	a, (0x03, sp)
	ld	(x), a
;	mini_io.c: 192: *(ioadr + P_CR1) |=  b;        // Controll Register 1
	ldw	x, (0x01, sp)
	addw	x, #0x0003
	ld	a, (x)
	or	a, (0x03, sp)
	ld	(x), a
;	mini_io.c: 193: *(ioadr + P_CR2) &= ~(b);      // Controll Register 2
	ldw	x, (0x01, sp)
	addw	x, #0x0004
	ld	a, (x)
	ld	(0x04, sp), a
	ld	a, (0x03, sp)
	cpl	a
	and	a, (0x04, sp)
	ld	(x), a
	addw	sp, #4
	ret
;	mini_io.c: 207: void io_set(uint8_t ioport, uint8_t iono, uint8_t value)
;	-----------------------------------------
;	 function io_set
;	-----------------------------------------
_io_set:
	push	a
;	mini_io.c: 212: ioadr+= (ioport*5);
	ld	a, (0x04, sp)
	ld	xl, a
	ld	a, #0x05
	mul	x, a
	addw	x, #0x5000
;	mini_io.c: 214: b= 1 << iono;
	ld	a, #0x01
	push	a
	ld	a, (0x06, sp)
	jreq	00111$
00110$:
	sll	(1, sp)
	dec	a
	jrne	00110$
00111$:
	ld	a, (x)
	ld	(0x02, sp), a
	pop	a
	tnz	(0x06, sp)
	jreq	00102$
	or	a, (0x01, sp)
	ld	(x), a
	jra	00104$
00102$:
	cpl	a
	and	a, (0x01, sp)
	ld	(x), a
00104$:
	pop	a
	ret
;	mini_io.c: 223: void io_inputinit(uint8_t ioport, uint8_t iono)
;	-----------------------------------------
;	 function io_inputinit
;	-----------------------------------------
_io_inputinit:
	sub	sp, #4
;	mini_io.c: 228: ioadr+= (ioport*5);
	ld	a, (0x07, sp)
	ld	xl, a
	ld	a, #0x05
	mul	x, a
	addw	x, #0x5000
	ldw	(0x01, sp), x
;	mini_io.c: 230: b= 1 << iono;
	ld	a, #0x01
	push	a
	ld	a, (0x09, sp)
	jreq	00104$
00103$:
	sll	(1, sp)
	dec	a
	jrne	00103$
00104$:
	pop	a
	ld	(0x03, sp), a
;	mini_io.c: 231: *(ioadr + P_DDR) &= ~(b);        // Output Register
	ldw	x, (0x01, sp)
	incw	x
	incw	x
	ld	a, (x)
	ld	(0x04, sp), a
	ld	a, (0x03, sp)
	cpl	a
	and	a, (0x04, sp)
	ld	(x), a
;	mini_io.c: 232: *(ioadr + P_CR1) |= b;           // Controll Register 1
	ldw	x, (0x01, sp)
	addw	x, #0x0003
	ld	a, (x)
	or	a, (0x03, sp)
	ld	(x), a
	addw	sp, #4
	ret
;	mini_io.c: 239: uint8_t io_bitset(uint8_t ioport, uint8_t iono)
;	-----------------------------------------
;	 function io_bitset
;	-----------------------------------------
_io_bitset:
	pushw	x
;	mini_io.c: 244: ioadr+= (ioport*5);
	ld	a, (0x05, sp)
	ld	xl, a
	ld	a, #0x05
	mul	x, a
	addw	x, #0x5000
;	mini_io.c: 246: b=  ( *(ioadr + P_IDR) & (1 << iono) ) >> iono;
	ld	a, (0x1, x)
	push	a
	ldw	x, #0x0001
	ld	a, (0x07, sp)
	jreq	00104$
00103$:
	sllw	x
	dec	a
	jrne	00103$
00104$:
	pop	a
	ld	(0x02, sp), a
	clr	(0x01, sp)
	ld	a, xl
	and	a, (0x02, sp)
	rlwa	x
	and	a, (0x01, sp)
	ld	xh, a
	ld	a, (0x06, sp)
	jreq	00106$
00105$:
	sraw	x
	dec	a
	jrne	00105$
00106$:
;	mini_io.c: 248: return  b;
	ld	a, xl
	popw	x
	ret
;	mini_io.c: 252: int main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	mini_io.c: 254: sysclock_init();
	call	_sysclock_init
;	mini_io.c: 255: io_outputinit(1,5);                   // PB5 = Ausgang
	push	#0x05
	push	#0x01
	call	_io_outputinit
	popw	x
;	mini_io.c: 256: io_inputinit(1,4);                    // PB4 = Eingang
	push	#0x04
	push	#0x01
	call	_io_inputinit
	popw	x
;	mini_io.c: 257: while(1)
00108$:
;	mini_io.c: 259: io_set(1,5,1);                      // PB5
	push	#0x01
	push	#0x05
	push	#0x01
	call	_io_set
	addw	sp, #3
;	mini_io.c: 260: if (io_bitset(1,4))
	push	#0x04
	push	#0x01
	call	_io_bitset
	popw	x
	tnz	a
	jreq	00102$
;	mini_io.c: 261: delay_ms(countspeed1);
	push	#0xc8
	push	#0x00
	call	_delay_ms
	popw	x
	jra	00103$
00102$:
;	mini_io.c: 263: delay_ms(countspeed2);
	push	#0x64
	push	#0x00
	call	_delay_ms
	popw	x
00103$:
;	mini_io.c: 264: io_set(1,5,0);
	push	#0x00
	push	#0x05
	push	#0x01
	call	_io_set
	addw	sp, #3
;	mini_io.c: 265: if (io_bitset(1,4))
	push	#0x04
	push	#0x01
	call	_io_bitset
	popw	x
	tnz	a
	jreq	00105$
;	mini_io.c: 266: delay_ms(countspeed1);
	push	#0xc8
	push	#0x00
	call	_delay_ms
	popw	x
	jra	00108$
00105$:
;	mini_io.c: 268: delay_ms(countspeed2);
	push	#0x64
	push	#0x00
	call	_delay_ms
	popw	x
	jra	00108$
	ret
	.area CODE
	.area INITIALIZER
	.area CABS (ABS)
