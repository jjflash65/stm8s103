;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Aug 12 2015) (Linux)
; This file was generated Wed Oct 26 13:45:42 2016
;--------------------------------------------------------
	.module rda5807_7seg
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _tim1_ovf
	.globl _tim1_intinit
	.globl _setnewtune
	.globl _show_tune
	.globl _rda5807_setstereo
	.globl _rda5807_setmono
	.globl _rda5807_setvol
	.globl _rda5807_setfreq
	.globl _rda5807_poweron
	.globl _rda5807_reset
	.globl _rda5807_write
	.globl _rda5807_writereg
	.globl _i2c_startaddr
	.globl _digit4_init
	.globl _digit4_clrdp
	.globl _digit4_setdp
	.globl _digit4_setall
	.globl _digit4_setdez8bit
	.globl _digit4_setdez
	.globl _i2c_write16
	.globl _i2c_write
	.globl _i2c_stop
	.globl _i2c_start
	.globl _i2c_master_init
	.globl _int_enable
	.globl _delay_ms
	.globl _sysclock_init
	.globl _tim1_ticker
	.globl _rda5807_regdef
	.globl _rda5807_adrt
	.globl _rda5807_adrr
	.globl _rda5807_adrs
	.globl _aktmode
	.globl _aktvol
	.globl _aktfreq
	.globl _rda5807_reg
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
_rda5807_reg::
	.ds 32
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
_aktfreq::
	.ds 2
_aktvol::
	.ds 1
_aktmode::
	.ds 1
_rda5807_adrs::
	.ds 1
_rda5807_adrr::
	.ds 1
_rda5807_adrt::
	.ds 1
_rda5807_regdef::
	.ds 20
_tim1_ticker::
	.ds 2
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
	int _tim2_ovf ;int13
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
;	rda5807_7seg.c: 137: void i2c_startaddr(uint8_t addr, uint8_t rwflag)
;	-----------------------------------------
;	 function i2c_startaddr
;	-----------------------------------------
_i2c_startaddr:
;	rda5807_7seg.c: 139: addr = (addr << 1) | rwflag;
	ld	a, (0x03, sp)
	sll	a
	or	a, (0x04, sp)
	ld	(0x03, sp), a
;	rda5807_7seg.c: 141: i2c_start(addr);
	ld	a, (0x03, sp)
	push	a
	call	_i2c_start
	pop	a
	ret
;	rda5807_7seg.c: 150: void rda5807_writereg(char reg)
;	-----------------------------------------
;	 function rda5807_writereg
;	-----------------------------------------
_rda5807_writereg:
	sub	sp, #2
;	rda5807_7seg.c: 152: i2c_startaddr(rda5807_adrr,0);
	push	#0x00
	push	_rda5807_adrr+0
	call	_i2c_startaddr
	addw	sp, #2
;	rda5807_7seg.c: 153: i2c_write(reg);                        // Registernummer schreiben
	ld	a, (0x05, sp)
	push	a
	call	_i2c_write
	pop	a
;	rda5807_7seg.c: 154: i2c_write16(rda5807_reg[reg]);         // 16 Bit Registerinhalt schreiben
	ldw	x, #_rda5807_reg+0
	ldw	(0x01, sp), x
	ld	a, (0x05, sp)
	ld	xl, a
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	xh, a
	sllw	x
	addw	x, (0x01, sp)
	ldw	x, (x)
	pushw	x
	call	_i2c_write16
	addw	sp, #2
;	rda5807_7seg.c: 155: i2c_stop();
	call	_i2c_stop
	addw	sp, #2
	ret
;	rda5807_7seg.c: 163: void rda5807_write(void)
;	-----------------------------------------
;	 function rda5807_write
;	-----------------------------------------
_rda5807_write:
	sub	sp, #2
;	rda5807_7seg.c: 167: i2c_startaddr(rda5807_adrs,0);
	push	#0x00
	push	_rda5807_adrs+0
	call	_i2c_startaddr
	addw	sp, #2
;	rda5807_7seg.c: 168: for (i= 2; i< 7; i++)
	ldw	x, #_rda5807_reg+0
	ldw	(0x01, sp), x
	ld	a, #0x02
00102$:
;	rda5807_7seg.c: 170: i2c_write16(rda5807_reg[i]);
	clrw	x
	ld	xl, a
	sllw	x
	addw	x, (0x01, sp)
	ldw	x, (x)
	push	a
	pushw	x
	call	_i2c_write16
	addw	sp, #2
	pop	a
;	rda5807_7seg.c: 168: for (i= 2; i< 7; i++)
	inc	a
	cp	a, #0x07
	jrc	00102$
;	rda5807_7seg.c: 172: i2c_stop();
	call	_i2c_stop
	addw	sp, #2
	ret
;	rda5807_7seg.c: 178: void rda5807_reset(void)
;	-----------------------------------------
;	 function rda5807_reset
;	-----------------------------------------
_rda5807_reset:
	sub	sp, #8
;	rda5807_7seg.c: 181: for (i= 0; i< 7; i++)
	ldw	x, #_rda5807_reg+0
	ldw	(0x07, sp), x
	ldw	x, #_rda5807_regdef+0
	ldw	(0x05, sp), x
	clr	a
00102$:
;	rda5807_7seg.c: 183: rda5807_reg[i]= rda5807_regdef[i];
	clrw	x
	ld	xl, a
	sllw	x
	ldw	(0x01, sp), x
	ldw	y, (0x07, sp)
	addw	y, (0x01, sp)
	ldw	x, (0x05, sp)
	addw	x, (0x01, sp)
	ldw	x, (x)
	ldw	(y), x
;	rda5807_7seg.c: 181: for (i= 0; i< 7; i++)
	inc	a
	cp	a, #0x07
	jrc	00102$
;	rda5807_7seg.c: 185: rda5807_reg[2]= rda5807_reg[2] | 0x0002;    // Enable SoftReset
	ldw	x, (0x07, sp)
	addw	x, #0x0004
	ldw	(0x03, sp), x
	ldw	x, (0x03, sp)
	ldw	x, (x)
	ld	a, xl
	or	a, #0x02
	ld	xl, a
	ldw	y, (0x03, sp)
	ldw	(y), x
;	rda5807_7seg.c: 186: rda5807_write();
	call	_rda5807_write
;	rda5807_7seg.c: 187: rda5807_reg[2]= rda5807_reg[2] & 0xFFFB;    // Disable SoftReset
	ldw	x, (0x03, sp)
	ldw	x, (x)
	ld	a, xl
	and	a, #0xfb
	ld	xl, a
	ldw	y, (0x03, sp)
	ldw	(y), x
	addw	sp, #8
	ret
;	rda5807_7seg.c: 193: void rda5807_poweron(void)
;	-----------------------------------------
;	 function rda5807_poweron
;	-----------------------------------------
_rda5807_poweron:
	sub	sp, #6
;	rda5807_7seg.c: 195: rda5807_reg[3]= rda5807_reg[3] | 0x010;   // Enable Tuning
	ldw	x, #_rda5807_reg+0
	ldw	(0x05, sp), x
	ldw	x, (0x05, sp)
	addw	x, #0x0006
	ldw	(0x03, sp), x
	ldw	x, (0x03, sp)
	ldw	x, (x)
	ld	a, xl
	or	a, #0x10
	ld	xl, a
	ldw	y, (0x03, sp)
	ldw	(y), x
;	rda5807_7seg.c: 196: rda5807_reg[2]= rda5807_reg[2] | 0x001;   // Enable PowerOn
	ldw	x, (0x05, sp)
	addw	x, #0x0004
	ldw	(0x01, sp), x
	ldw	x, (0x01, sp)
	ldw	x, (x)
	srlw	x
	scf
	rlcw	x
	ldw	y, (0x01, sp)
	ldw	(y), x
;	rda5807_7seg.c: 198: rda5807_write();
	call	_rda5807_write
;	rda5807_7seg.c: 200: rda5807_reg[3]= rda5807_reg[3] & 0xFFEF;  // Disable Tuning
	ldw	x, (0x03, sp)
	ldw	x, (x)
	ld	a, xl
	and	a, #0xef
	ld	xl, a
	ldw	y, (0x03, sp)
	ldw	(y), x
	addw	sp, #6
	ret
;	rda5807_7seg.c: 212: int rda5807_setfreq(uint16_t channel)
;	-----------------------------------------
;	 function rda5807_setfreq
;	-----------------------------------------
_rda5807_setfreq:
	sub	sp, #2
;	rda5807_7seg.c: 215: channel -= fbandmin;
	ldw	x, (0x05, sp)
	subw	x, #0x0366
	ldw	(0x05, sp), x
;	rda5807_7seg.c: 216: channel&= 0x03FF;
	ld	a, (0x06, sp)
	ld	xl, a
	ld	a, (0x05, sp)
	and	a, #0x03
	ld	xh, a
	ldw	(0x05, sp), x
;	rda5807_7seg.c: 217: rda5807_reg[3]= channel * 64 + 0x10;  // Channel + TUNE-Bit + Band=00(87-108) + Space=00(100kHz)
	ldw	x, #_rda5807_reg+6
	ldw	(0x01, sp), x
	ldw	x, (0x05, sp)
	sllw	x
	sllw	x
	sllw	x
	sllw	x
	sllw	x
	sllw	x
	addw	x, #0x0010
	ldw	y, (0x01, sp)
	ldw	(y), x
;	rda5807_7seg.c: 219: i2c_startaddr(rda5807_adrs,0);
	push	#0x00
	push	_rda5807_adrs+0
	call	_i2c_startaddr
	addw	sp, #2
;	rda5807_7seg.c: 220: i2c_write16(0xD009);
	push	#0x09
	push	#0xd0
	call	_i2c_write16
	addw	sp, #2
;	rda5807_7seg.c: 221: i2c_write16(rda5807_reg[3]);
	ldw	x, (0x01, sp)
	ldw	x, (x)
	pushw	x
	call	_i2c_write16
	addw	sp, #2
;	rda5807_7seg.c: 222: i2c_stop();
	call	_i2c_stop
;	rda5807_7seg.c: 224: delay_ms(100);
	push	#0x64
	push	#0x00
	call	_delay_ms
	addw	sp, #2
;	rda5807_7seg.c: 225: return 0;
	clrw	x
	addw	sp, #2
	ret
;	rda5807_7seg.c: 234: void rda5807_setvol(int setvol)
;	-----------------------------------------
;	 function rda5807_setvol
;	-----------------------------------------
_rda5807_setvol:
	sub	sp, #4
;	rda5807_7seg.c: 236: rda5807_reg[5]=(rda5807_reg[5] & 0xFFF0) | setvol;
	ldw	x, #_rda5807_reg+10
	ldw	(0x03, sp), x
	ldw	x, (0x03, sp)
	ldw	x, (x)
	ld	a, xl
	and	a, #0xf0
	ldw	y, (0x07, sp)
	ldw	(0x01, sp), y
	or	a, (0x02, sp)
	rlwa	x
	or	a, (0x01, sp)
	ld	xh, a
	ldw	y, (0x03, sp)
	ldw	(y), x
;	rda5807_7seg.c: 237: rda5807_writereg(5);
	push	#0x05
	call	_rda5807_writereg
	addw	sp, #5
	ret
;	rda5807_7seg.c: 243: void rda5807_setmono(void)
;	-----------------------------------------
;	 function rda5807_setmono
;	-----------------------------------------
_rda5807_setmono:
;	rda5807_7seg.c: 245: rda5807_reg[2]=(rda5807_reg[2] | 0x2000);
	ldw	x, #_rda5807_reg+4
	ld	a, (0x1, x)
	ld	yl, a
	ld	a, (x)
	or	a, #0x20
	ld	yh, a
	ldw	(x), y
;	rda5807_7seg.c: 246: rda5807_writereg(2);
	push	#0x02
	call	_rda5807_writereg
	pop	a
	ret
;	rda5807_7seg.c: 252: void rda5807_setstereo(void)
;	-----------------------------------------
;	 function rda5807_setstereo
;	-----------------------------------------
_rda5807_setstereo:
;	rda5807_7seg.c: 254: rda5807_reg[2]=(rda5807_reg[2] & 0xdfff);
	ldw	x, #_rda5807_reg+4
	ld	a, (0x1, x)
	ld	yl, a
	ld	a, (x)
	and	a, #0xdf
	ld	yh, a
	ldw	(x), y
;	rda5807_7seg.c: 255: rda5807_writereg(2);
	push	#0x02
	call	_rda5807_writereg
	pop	a
	ret
;	rda5807_7seg.c: 266: void show_tune(void)
;	-----------------------------------------
;	 function show_tune
;	-----------------------------------------
_show_tune:
;	rda5807_7seg.c: 268: if (aktmode== 1)
	ld	a, _aktmode+0
	cp	a, #0x01
	jrne	00104$
;	rda5807_7seg.c: 270: digit4_clrdp(1);
	push	#0x01
	call	_digit4_clrdp
	pop	a
;	rda5807_7seg.c: 271: digit4_setall(0xc7, 0xff, 0xff, 0xff);
	push	#0xff
	push	#0xff
	push	#0xff
	push	#0xc7
	call	_digit4_setall
	addw	sp, #4
;	rda5807_7seg.c: 272: digit4_setdez8bit(aktvol,0);
	push	#0x00
	push	_aktvol+0
	call	_digit4_setdez8bit
	addw	sp, #2
	jra	00106$
00104$:
;	rda5807_7seg.c: 276: digit4_setdp(1);
	push	#0x01
	call	_digit4_setdp
	pop	a
;	rda5807_7seg.c: 277: digit4_setdez(aktfreq);
	push	_aktfreq+1
	push	_aktfreq+0
	call	_digit4_setdez
	addw	sp, #2
;	rda5807_7seg.c: 278: if (aktfreq< 1000)  { seg7_4digit[3]= 0xff; }    // fuehrende 0 ausblenden bei F< 100 MHz
	ldw	x, _aktfreq+0
	cpw	x, #0x03e8
	jrnc	00106$
	ldw	x, #_seg7_4digit+3
	ld	a, #0xff
	ld	(x), a
00106$:
	ret
;	rda5807_7seg.c: 288: void setnewtune(uint16_t channel)
;	-----------------------------------------
;	 function setnewtune
;	-----------------------------------------
_setnewtune:
;	rda5807_7seg.c: 290: aktfreq= channel;
	ldw	x, (0x03, sp)
	ldw	_aktfreq+0, x
;	rda5807_7seg.c: 291: rda5807_setfreq(aktfreq);
	push	_aktfreq+1
	push	_aktfreq+0
	call	_rda5807_setfreq
	addw	sp, #2
;	rda5807_7seg.c: 292: show_tune();
	jp	_show_tune
;	rda5807_7seg.c: 300: void tim1_intinit(void)
;	-----------------------------------------
;	 function tim1_intinit
;	-----------------------------------------
_tim1_intinit:
;	rda5807_7seg.c: 305: TIM1_PSCRH= taktteiler >> 8;
	mov	0x5260+0, #0x3e
;	rda5807_7seg.c: 306: TIM1_PSCRL= taktteiler & 0x00ff;
	mov	0x5261+0, #0x7f
;	rda5807_7seg.c: 310: TIM1_ARRH= 0x00;
	mov	0x5262+0, #0x00
;	rda5807_7seg.c: 311: TIM1_ARRL= 0x64;
	mov	0x5263+0, #0x64
;	rda5807_7seg.c: 314: TIM1_IER |= TIM1_IER_UIE;
	bset	0x5254, #0
;	rda5807_7seg.c: 317: TIM1_CR1 |= TIM1_CR1_CEN;     // Timer1 enable ( CEN = ClockENable )
	bset	0x5250, #0
;	rda5807_7seg.c: 318: TIM1_CR1 |= TIM1_CR1_ARPE;    // Timer1 autoreload ( mit Werten in TIM1_ARR )
	bset	0x5250, #7
;	rda5807_7seg.c: 320: int_enable();                 // grundsaetzlich Interrupts zulassen
	jp	_int_enable
;	rda5807_7seg.c: 327: void tim1_ovf(void) __interrupt(11)
;	-----------------------------------------
;	 function tim1_ovf
;	-----------------------------------------
_tim1_ovf:
;	rda5807_7seg.c: 330: tim1_ticker++;
	ldw	x, _tim1_ticker+0
	incw	x
	ldw	_tim1_ticker+0, x
;	rda5807_7seg.c: 332: TIM1_SR1 &= ~TIM1_SR1_UIF;        // Interrupt quittieren
	bres	0x5255, #0
	iret
;	rda5807_7seg.c: 339: int main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	rda5807_7seg.c: 343: sysclock_init(0);
	push	#0x00
	call	_sysclock_init
	pop	a
;	rda5807_7seg.c: 345: delay_ms(500);
	push	#0xf4
	push	#0x01
	call	_delay_ms
	addw	sp, #2
;	rda5807_7seg.c: 346: tim1_intinit();
	call	_tim1_intinit
;	rda5807_7seg.c: 347: i2c_master_init();                    // 2 = ca. 15kHz I2C Clock-Takt
	call	_i2c_master_init
;	rda5807_7seg.c: 348: digit4_init();                        // Modul initialisieren
	call	_digit4_init
;	rda5807_7seg.c: 349: uptast_init();
	ldw	x, #0x500c
	ld	a, (x)
	and	a, #0xf7
	ld	(x), a
	ldw	x, #0x500d
	ld	a, (x)
	or	a, #0x08
	ld	(x), a
;	rda5807_7seg.c: 350: dwntast_init();
	ldw	x, #0x500c
	ld	a, (x)
	and	a, #0xef
	ld	(x), a
	ldw	x, #0x500d
	ld	a, (x)
	or	a, #0x10
	ld	(x), a
;	rda5807_7seg.c: 351: mtast_init();
	ldw	x, #0x500c
	ld	a, (x)
	and	a, #0xdf
	ld	(x), a
	ldw	x, #0x500d
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
;	rda5807_7seg.c: 353: rda5807_reset();
	call	_rda5807_reset
;	rda5807_7seg.c: 354: rda5807_poweron();
	call	_rda5807_poweron
;	rda5807_7seg.c: 355: rda5807_setmono();
	call	_rda5807_setmono
;	rda5807_7seg.c: 356: rda5807_setfreq(aktfreq);
	push	_aktfreq+1
	push	_aktfreq+0
	call	_rda5807_setfreq
	addw	sp, #2
;	rda5807_7seg.c: 357: rda5807_setvol(aktvol);
	clrw	x
	ld	a, _aktvol+0
	ld	xl, a
	pushw	x
	call	_rda5807_setvol
	addw	sp, #2
;	rda5807_7seg.c: 359: show_tune();
	call	_show_tune
;	rda5807_7seg.c: 361: while(1)
00142$:
;	rda5807_7seg.c: 364: if (is_mtast())
	ldw	x, #0x500b
	ld	a, (x)
	and	a, #0x20
	swap	a
	and	a, #0x0f
	srl	a
	tnz	a
	jrne	00105$
;	rda5807_7seg.c: 366: delay_ms(50);
	push	#0x32
	push	#0x00
	call	_delay_ms
	addw	sp, #2
;	rda5807_7seg.c: 367: aktmode++;
	ld	a, _aktmode+0
	inc	a
;	rda5807_7seg.c: 368: aktmode= aktmode % 2;
	ld	_aktmode+0, a
	and	a, #0x01
	ld	_aktmode+0, a
;	rda5807_7seg.c: 369: show_tune();
	call	_show_tune
;	rda5807_7seg.c: 370: while(is_mtast());
00101$:
	ldw	x, #0x500b
	ld	a, (x)
	and	a, #0x20
	swap	a
	and	a, #0x0f
	srl	a
	tnz	a
	jreq	00101$
;	rda5807_7seg.c: 371: delay_ms(50);
	push	#0x32
	push	#0x00
	call	_delay_ms
	addw	sp, #2
;	rda5807_7seg.c: 372: tim1_ticker= 0;
	clrw	x
	ldw	_tim1_ticker+0, x
00105$:
;	rda5807_7seg.c: 374: if ((aktmode> 0) && (tim1_ticker> 35))
	tnz	_aktmode+0
	jreq	00107$
	ldw	x, _tim1_ticker+0
	cpw	x, #0x0023
	jrule	00107$
;	rda5807_7seg.c: 376: aktmode= 0;
	clr	_aktmode+0
;	rda5807_7seg.c: 377: show_tune();
	call	_show_tune
00107$:
;	rda5807_7seg.c: 364: if (is_mtast())
	ldw	x, #0x500b
	ld	a, (x)
	ld	xh, a
;	rda5807_7seg.c: 380: if (aktmode== 0)                                      // Senderwahl
	tnz	_aktmode+0
	jreq	00238$
	jp	00124$
00238$:
;	rda5807_7seg.c: 382: if (is_uptast())
	ld	a, xh
	and	a, #0x08
	srl	a
	srl	a
	srl	a
	tnz	a
	jrne	00115$
;	rda5807_7seg.c: 385: delay_ms(100);
	push	#0x64
	push	#0x00
	call	_delay_ms
	addw	sp, #2
;	rda5807_7seg.c: 386: while(is_uptast())
00111$:
;	rda5807_7seg.c: 364: if (is_mtast())
	ldw	x, #0x500b
	ld	a, (x)
;	rda5807_7seg.c: 386: while(is_uptast())
	ld	xh, a
	and	a, #0x08
	srl	a
	srl	a
	srl	a
	tnz	a
	jrne	00115$
;	rda5807_7seg.c: 388: rda5807_setvol(0);
	clrw	x
	pushw	x
	call	_rda5807_setvol
	addw	sp, #2
;	rda5807_7seg.c: 389: if (aktfreq < fbandmax)
	ldw	x, _aktfreq+0
	cpw	x, #0x0438
	jrnc	00110$
;	rda5807_7seg.c: 391: aktfreq++;
	ldw	x, _aktfreq+0
	incw	x
	ldw	_aktfreq+0, x
;	rda5807_7seg.c: 392: show_tune();
	call	_show_tune
00110$:
;	rda5807_7seg.c: 394: rda5807_setvol(aktvol);
	clrw	x
	ld	a, _aktvol+0
	ld	xl, a
	pushw	x
	call	_rda5807_setvol
	addw	sp, #2
;	rda5807_7seg.c: 395: setnewtune(aktfreq);
	push	_aktfreq+1
	push	_aktfreq+0
	call	_setnewtune
	addw	sp, #2
	jra	00111$
00115$:
;	rda5807_7seg.c: 399: if (is_dwntast())
	ld	a, xh
	and	a, #0x10
	swap	a
	and	a, #0x0f
	tnz	a
	jrne	00124$
;	rda5807_7seg.c: 402: delay_ms(100);
	push	#0x64
	push	#0x00
	call	_delay_ms
	addw	sp, #2
;	rda5807_7seg.c: 403: while(is_dwntast())
00118$:
;	rda5807_7seg.c: 364: if (is_mtast())
	ldw	x, #0x500b
	ld	a, (x)
;	rda5807_7seg.c: 403: while(is_dwntast())
	ld	xh, a
	and	a, #0x10
	swap	a
	and	a, #0x0f
	tnz	a
	jrne	00124$
;	rda5807_7seg.c: 405: rda5807_setvol(0);
	clrw	x
	pushw	x
	call	_rda5807_setvol
	addw	sp, #2
;	rda5807_7seg.c: 406: if (aktfreq > fbandmin)
	ldw	x, _aktfreq+0
	cpw	x, #0x0366
	jrule	00117$
;	rda5807_7seg.c: 408: aktfreq--;
	ldw	x, _aktfreq+0
	decw	x
	ldw	_aktfreq+0, x
;	rda5807_7seg.c: 409: show_tune();
	call	_show_tune
00117$:
;	rda5807_7seg.c: 411: rda5807_setvol(aktvol);
	clrw	x
	ld	a, _aktvol+0
	ld	xl, a
	pushw	x
	call	_rda5807_setvol
	addw	sp, #2
;	rda5807_7seg.c: 412: setnewtune(aktfreq);
	push	_aktfreq+1
	push	_aktfreq+0
	call	_setnewtune
	addw	sp, #2
	jra	00118$
00124$:
;	rda5807_7seg.c: 417: if (aktmode== 1)                                    // Lautstaerkeeinstellung
	ld	a, _aktmode+0
	cp	a, #0x01
	jreq	00247$
	jp	00142$
00247$:
;	rda5807_7seg.c: 419: if (is_uptast())
	ld	a, xh
	and	a, #0x08
	srl	a
	srl	a
	srl	a
	tnz	a
	jrne	00131$
;	rda5807_7seg.c: 421: while(is_uptast())
00127$:
;	rda5807_7seg.c: 364: if (is_mtast())
	ldw	x, #0x500b
	ld	a, (x)
;	rda5807_7seg.c: 421: while(is_uptast())
	ld	xh, a
	and	a, #0x08
	srl	a
	srl	a
	srl	a
	tnz	a
	jrne	00129$
;	rda5807_7seg.c: 423: delay_ms(250);
	push	#0xfa
	push	#0x00
	call	_delay_ms
	addw	sp, #2
;	rda5807_7seg.c: 424: if (aktvol< 15)
	ld	a, _aktvol+0
	cp	a, #0x0f
	jrnc	00127$
;	rda5807_7seg.c: 426: aktvol++;
	ld	a, _aktvol+0
	inc	a
	ld	_aktvol+0, a
;	rda5807_7seg.c: 427: rda5807_setvol(aktvol);
	clrw	x
	ld	a, _aktvol+0
	ld	xl, a
	pushw	x
	call	_rda5807_setvol
	addw	sp, #2
;	rda5807_7seg.c: 428: show_tune();
	call	_show_tune
	jra	00127$
00129$:
;	rda5807_7seg.c: 431: tim1_ticker= 0;
	clr	_tim1_ticker+1
	clr	_tim1_ticker+0
00131$:
;	rda5807_7seg.c: 433: if (is_dwntast())
	ld	a, xh
	and	a, #0x10
	swap	a
	and	a, #0x0f
	tnz	a
	jreq	00251$
	jp	00142$
00251$:
;	rda5807_7seg.c: 435: while(is_dwntast())
00134$:
	ldw	x, #0x500b
	ld	a, (x)
	and	a, #0x10
	swap	a
	and	a, #0x0f
	tnz	a
	jrne	00136$
;	rda5807_7seg.c: 437: delay_ms(250);
	push	#0xfa
	push	#0x00
	call	_delay_ms
	addw	sp, #2
;	rda5807_7seg.c: 438: if (aktvol> 0)
	tnz	_aktvol+0
	jreq	00134$
;	rda5807_7seg.c: 440: aktvol--;
	ld	a, _aktvol+0
	dec	a
	ld	_aktvol+0, a
;	rda5807_7seg.c: 441: rda5807_setvol(aktvol);
	clrw	x
	ld	a, _aktvol+0
	ld	xl, a
	pushw	x
	call	_rda5807_setvol
	addw	sp, #2
;	rda5807_7seg.c: 442: show_tune();
	call	_show_tune
	jra	00134$
00136$:
;	rda5807_7seg.c: 445: tim1_ticker= 0;
	clrw	x
	ldw	_tim1_ticker+0, x
	jp	00142$
	ret
	.area CODE
	.area INITIALIZER
__xinit__aktfreq:
	.dw #0x03FA
__xinit__aktvol:
	.db #0x01	; 1
__xinit__aktmode:
	.db #0x00	; 0
__xinit__rda5807_adrs:
	.db #0x10	; 16
__xinit__rda5807_adrr:
	.db #0x11	; 17
__xinit__rda5807_adrt:
	.db #0x60	; 96
__xinit__rda5807_regdef:
	.dw #0x0758
	.dw #0x0000
	.dw #0xF009
	.dw #0x0000
	.dw #0x1400
	.dw #0x84DF
	.dw #0x4000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
__xinit__tim1_ticker:
	.dw #0x0000
	.area CABS (ABS)
