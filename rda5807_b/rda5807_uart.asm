;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Aug 12 2015) (Linux)
; This file was generated Wed Oct 26 14:53:04 2016
;--------------------------------------------------------
	.module rda5807_uart
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _festfreq
	.globl _main
	.globl _rda5807_scanup
	.globl _rda5807_scandown
	.globl _rda5807_getsig
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
	.globl _i2c_read
	.globl _i2c_write16
	.globl _i2c_write
	.globl _i2c_stop
	.globl _i2c_start
	.globl _i2c_master_init
	.globl _uart_init
	.globl _uart_ischar
	.globl _uart_getchar
	.globl _uart_putchar
	.globl _my_printf
	.globl _delay_ms
	.globl _sysclock_init
	.globl _rda5807_regdef
	.globl _rda5807_adrt
	.globl _rda5807_adrr
	.globl _rda5807_adrs
	.globl _aktvol
	.globl _aktfreq
	.globl _rda5807_reg
	.globl _putchar
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
_rda5807_reg::
	.ds 32
_rda5807_getsig_b_1_57:
	.ds 1
_rda5807_getsig_b2_1_57:
	.ds 1
_rda5807_getsig_i_1_57:
	.ds 1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
_aktfreq::
	.ds 2
_aktvol::
	.ds 1
_rda5807_adrs::
	.ds 1
_rda5807_adrr::
	.ds 1
_rda5807_adrt::
	.ds 1
_rda5807_regdef::
	.ds 20
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
;	rda5807_uart.c: 78: void putchar(char ch)
;	-----------------------------------------
;	 function putchar
;	-----------------------------------------
_putchar:
;	rda5807_uart.c: 80: uart_putchar(ch);
	ld	a, (0x03, sp)
	push	a
	call	_uart_putchar
	pop	a
	ret
;	rda5807_uart.c: 90: void i2c_startaddr(uint8_t addr, uint8_t rwflag)
;	-----------------------------------------
;	 function i2c_startaddr
;	-----------------------------------------
_i2c_startaddr:
;	rda5807_uart.c: 92: addr = (addr << 1) | rwflag;
	ld	a, (0x03, sp)
	sll	a
	or	a, (0x04, sp)
	ld	(0x03, sp), a
;	rda5807_uart.c: 94: i2c_start(addr);
	ld	a, (0x03, sp)
	push	a
	call	_i2c_start
	pop	a
	ret
;	rda5807_uart.c: 102: void rda5807_writereg(char reg)
;	-----------------------------------------
;	 function rda5807_writereg
;	-----------------------------------------
_rda5807_writereg:
	sub	sp, #2
;	rda5807_uart.c: 104: i2c_startaddr(rda5807_adrr,0);
	push	#0x00
	push	_rda5807_adrr+0
	call	_i2c_startaddr
	addw	sp, #2
;	rda5807_uart.c: 105: i2c_write(reg);                        // Registernummer schreiben
	ld	a, (0x05, sp)
	push	a
	call	_i2c_write
	pop	a
;	rda5807_uart.c: 106: i2c_write16(rda5807_reg[reg]);         // 16 Bit Registerinhalt schreiben
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
;	rda5807_uart.c: 107: i2c_stop();
	call	_i2c_stop
	addw	sp, #2
	ret
;	rda5807_uart.c: 115: void rda5807_write(void)
;	-----------------------------------------
;	 function rda5807_write
;	-----------------------------------------
_rda5807_write:
	sub	sp, #2
;	rda5807_uart.c: 119: i2c_startaddr(rda5807_adrs,0);
	push	#0x00
	push	_rda5807_adrs+0
	call	_i2c_startaddr
	addw	sp, #2
;	rda5807_uart.c: 120: for (i= 2; i< 7; i++)
	ldw	x, #_rda5807_reg+0
	ldw	(0x01, sp), x
	ld	a, #0x02
00102$:
;	rda5807_uart.c: 122: i2c_write16(rda5807_reg[i]);
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
;	rda5807_uart.c: 120: for (i= 2; i< 7; i++)
	inc	a
	cp	a, #0x07
	jrc	00102$
;	rda5807_uart.c: 124: i2c_stop();
	call	_i2c_stop
	addw	sp, #2
	ret
;	rda5807_uart.c: 130: void rda5807_reset(void)
;	-----------------------------------------
;	 function rda5807_reset
;	-----------------------------------------
_rda5807_reset:
	sub	sp, #8
;	rda5807_uart.c: 133: for (i= 0; i< 7; i++)
	ldw	x, #_rda5807_reg+0
	ldw	(0x01, sp), x
	ldw	x, #_rda5807_regdef+0
	ldw	(0x07, sp), x
	clr	a
00102$:
;	rda5807_uart.c: 135: rda5807_reg[i]= rda5807_regdef[i];
	clrw	x
	ld	xl, a
	sllw	x
	ldw	(0x05, sp), x
	ldw	y, (0x01, sp)
	addw	y, (0x05, sp)
	ldw	x, (0x07, sp)
	addw	x, (0x05, sp)
	ldw	x, (x)
	ldw	(y), x
;	rda5807_uart.c: 133: for (i= 0; i< 7; i++)
	inc	a
	cp	a, #0x07
	jrc	00102$
;	rda5807_uart.c: 137: rda5807_reg[2]= rda5807_reg[2] | 0x0002;    // Enable SoftReset
	ldw	x, (0x01, sp)
	addw	x, #0x0004
	ldw	(0x03, sp), x
	ldw	x, (0x03, sp)
	ldw	x, (x)
	ld	a, xl
	or	a, #0x02
	ld	xl, a
	ldw	y, (0x03, sp)
	ldw	(y), x
;	rda5807_uart.c: 138: rda5807_write();
	call	_rda5807_write
;	rda5807_uart.c: 139: rda5807_reg[2]= rda5807_reg[2] & 0xFFFB;    // Disable SoftReset
	ldw	x, (0x03, sp)
	ldw	x, (x)
	ld	a, xl
	and	a, #0xfb
	ld	xl, a
	ldw	y, (0x03, sp)
	ldw	(y), x
	addw	sp, #8
	ret
;	rda5807_uart.c: 145: void rda5807_poweron(void)
;	-----------------------------------------
;	 function rda5807_poweron
;	-----------------------------------------
_rda5807_poweron:
	sub	sp, #6
;	rda5807_uart.c: 147: rda5807_reg[3]= rda5807_reg[3] | 0x010;   // Enable Tuning
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
;	rda5807_uart.c: 148: rda5807_reg[2]= rda5807_reg[2] | 0x001;   // Enable PowerOn
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
;	rda5807_uart.c: 150: rda5807_write();
	call	_rda5807_write
;	rda5807_uart.c: 152: rda5807_reg[3]= rda5807_reg[3] & 0xFFEF;  // Disable Tuning
	ldw	x, (0x03, sp)
	ldw	x, (x)
	ld	a, xl
	and	a, #0xef
	ld	xl, a
	ldw	y, (0x03, sp)
	ldw	(y), x
	addw	sp, #6
	ret
;	rda5807_uart.c: 164: int rda5807_setfreq(uint16_t channel)
;	-----------------------------------------
;	 function rda5807_setfreq
;	-----------------------------------------
_rda5807_setfreq:
	sub	sp, #2
;	rda5807_uart.c: 167: channel -= fbandmin;
	ldw	x, (0x05, sp)
	subw	x, #0x0366
	ldw	(0x05, sp), x
;	rda5807_uart.c: 168: channel&= 0x03FF;
	ld	a, (0x06, sp)
	ld	xl, a
	ld	a, (0x05, sp)
	and	a, #0x03
	ld	xh, a
	ldw	(0x05, sp), x
;	rda5807_uart.c: 169: rda5807_reg[3]= channel * 64 + 0x10;  // Channel + TUNE-Bit + Band=00(87-108) + Space=00(100kHz)
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
;	rda5807_uart.c: 171: i2c_startaddr(rda5807_adrs,0);
	push	#0x00
	push	_rda5807_adrs+0
	call	_i2c_startaddr
	addw	sp, #2
;	rda5807_uart.c: 172: i2c_write16(0xD009);
	push	#0x09
	push	#0xd0
	call	_i2c_write16
	addw	sp, #2
;	rda5807_uart.c: 173: i2c_write16(rda5807_reg[3]);
	ldw	x, (0x01, sp)
	ldw	x, (x)
	pushw	x
	call	_i2c_write16
	addw	sp, #2
;	rda5807_uart.c: 174: i2c_stop();
	call	_i2c_stop
;	rda5807_uart.c: 176: delay_ms(100);
	push	#0x64
	push	#0x00
	call	_delay_ms
	addw	sp, #2
;	rda5807_uart.c: 177: return 0;
	clrw	x
	addw	sp, #2
	ret
;	rda5807_uart.c: 186: void rda5807_setvol(int setvol)
;	-----------------------------------------
;	 function rda5807_setvol
;	-----------------------------------------
_rda5807_setvol:
	sub	sp, #4
;	rda5807_uart.c: 188: rda5807_reg[5]=(rda5807_reg[5] & 0xFFF0) | setvol;
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
;	rda5807_uart.c: 189: rda5807_writereg(5);
	push	#0x05
	call	_rda5807_writereg
	addw	sp, #5
	ret
;	rda5807_uart.c: 195: void rda5807_setmono(void)
;	-----------------------------------------
;	 function rda5807_setmono
;	-----------------------------------------
_rda5807_setmono:
;	rda5807_uart.c: 197: rda5807_reg[2]=(rda5807_reg[2] | 0x2000);
	ldw	x, #_rda5807_reg+4
	ld	a, (0x1, x)
	ld	yl, a
	ld	a, (x)
	or	a, #0x20
	ld	yh, a
	ldw	(x), y
;	rda5807_uart.c: 198: rda5807_writereg(2);
	push	#0x02
	call	_rda5807_writereg
	pop	a
	ret
;	rda5807_uart.c: 204: void rda5807_setstereo(void)
;	-----------------------------------------
;	 function rda5807_setstereo
;	-----------------------------------------
_rda5807_setstereo:
;	rda5807_uart.c: 206: rda5807_reg[2]=(rda5807_reg[2] & 0xdfff);
	ldw	x, #_rda5807_reg+4
	ld	a, (0x1, x)
	ld	yl, a
	ld	a, (x)
	and	a, #0xdf
	ld	yh, a
	ldw	(x), y
;	rda5807_uart.c: 207: rda5807_writereg(2);
	push	#0x02
	call	_rda5807_writereg
	pop	a
	ret
;	rda5807_uart.c: 217: void show_tune(void)
;	-----------------------------------------
;	 function show_tune
;	-----------------------------------------
_show_tune:
	sub	sp, #3
;	rda5807_uart.c: 221: if (aktfreq < 1000) { putchar(' '); }
	ldw	x, _aktfreq+0
	cpw	x, #0x03e8
	jrnc	00102$
	push	#0x20
	call	_putchar
	pop	a
00102$:
;	rda5807_uart.c: 222: printf("  %k MHz  |  Volume: ",aktfreq);
	ldw	x, #___str_0+0
	push	_aktfreq+1
	push	_aktfreq+0
	pushw	x
	call	_my_printf
	addw	sp, #4
;	rda5807_uart.c: 224: if (aktvol)
	tnz	_aktvol+0
	jreq	00108$
;	rda5807_uart.c: 226: putchar('0');
	push	#0x30
	call	_putchar
	pop	a
;	rda5807_uart.c: 227: for (i= 0; i< aktvol-1; i++) { putchar('-'); }
	clr	(0x01, sp)
00111$:
	clrw	x
	ld	a, _aktvol+0
	ld	xl, a
	decw	x
	ldw	(0x02, sp), x
	ld	a, (0x01, sp)
	ld	xl, a
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	xh, a
	cpw	x, (0x02, sp)
	jrsge	00103$
	push	#0x2d
	call	_putchar
	pop	a
	inc	(0x01, sp)
	jra	00111$
00103$:
;	rda5807_uart.c: 228: putchar('x');
	push	#0x78
	call	_putchar
	pop	a
;	rda5807_uart.c: 229: i= aktvol;
	ld	a, _aktvol+0
;	rda5807_uart.c: 230: while (i< 15)
00104$:
	cp	a, #0x0f
	jrsge	00109$
;	rda5807_uart.c: 232: putchar('-');
	push	a
	push	#0x2d
	call	_putchar
	pop	a
	pop	a
;	rda5807_uart.c: 233: i++;
	inc	a
	jra	00104$
00108$:
;	rda5807_uart.c: 238: printf("x--------------");
	ldw	x, #___str_1+0
	pushw	x
	call	_my_printf
	addw	sp, #2
00109$:
;	rda5807_uart.c: 240: printf("  \r");
	ldw	x, #___str_2+0
	pushw	x
	call	_my_printf
	addw	sp, #5
	ret
;	rda5807_uart.c: 249: void setnewtune(uint16_t channel)
;	-----------------------------------------
;	 function setnewtune
;	-----------------------------------------
_setnewtune:
;	rda5807_uart.c: 251: aktfreq= channel;
	ldw	x, (0x03, sp)
	ldw	_aktfreq+0, x
;	rda5807_uart.c: 252: rda5807_setfreq(aktfreq);
	push	_aktfreq+1
	push	_aktfreq+0
	call	_rda5807_setfreq
	addw	sp, #2
;	rda5807_uart.c: 253: show_tune();
	jp	_show_tune
;	rda5807_uart.c: 256: uint8_t rda5807_getsig(void)
;	-----------------------------------------
;	 function rda5807_getsig
;	-----------------------------------------
_rda5807_getsig:
;	rda5807_uart.c: 261: delay_ms(100);
	push	#0x64
	push	#0x00
	call	_delay_ms
	addw	sp, #2
;	rda5807_uart.c: 262: i2c_startaddr(rda5807_adrs,1);
	push	#0x01
	push	_rda5807_adrs+0
	call	_i2c_startaddr
	addw	sp, #2
;	rda5807_uart.c: 263: for (i= 0; i < 3; i++)
	clr	_rda5807_getsig_i_1_57+0
00104$:
;	rda5807_uart.c: 265: b= i2c_read_ack();
	push	#0x01
	call	_i2c_read
	addw	sp, #1
	ld	_rda5807_getsig_b_1_57+0, a
;	rda5807_uart.c: 266: delay_ms(5);
	push	#0x05
	push	#0x00
	call	_delay_ms
	addw	sp, #2
;	rda5807_uart.c: 267: if (i == 2)
	ld	a, _rda5807_getsig_i_1_57+0
	cp	a, #0x02
	jrne	00105$
;	rda5807_uart.c: 269: b2= b;
	ld	a, _rda5807_getsig_b_1_57+0
	ld	_rda5807_getsig_b2_1_57+0, a
00105$:
;	rda5807_uart.c: 263: for (i= 0; i < 3; i++)
	ld	a, _rda5807_getsig_i_1_57+0
	inc	a
	ld	_rda5807_getsig_i_1_57+0, a
	cp	a, #0x03
	jrc	00104$
;	rda5807_uart.c: 272: b= i2c_read_nack();
	push	#0x00
	call	_i2c_read
	addw	sp, #1
	ld	_rda5807_getsig_b_1_57+0, a
;	rda5807_uart.c: 274: i2c_stop();
	call	_i2c_stop
;	rda5807_uart.c: 275: return b2;
	ld	a, _rda5807_getsig_b2_1_57+0
	ret
;	rda5807_uart.c: 278: void rda5807_scandown(void)
;	-----------------------------------------
;	 function rda5807_scandown
;	-----------------------------------------
_rda5807_scandown:
	sub	sp, #5
;	rda5807_uart.c: 282: rda5807_setvol(0);
	clrw	x
	pushw	x
	call	_rda5807_setvol
	addw	sp, #2
;	rda5807_uart.c: 284: if (aktfreq== fbandmin) { aktfreq= fbandmax; }
	ldw	x, _aktfreq+0
	cpw	x, #0x0366
	jrne	00114$
	ldw	x, #0x0438
	ldw	_aktfreq+0, x
;	rda5807_uart.c: 285: do
00114$:
	ldw	x, #___str_3+0
	ldw	(0x04, sp), x
	ldw	x, #___str_4+0
	ldw	(0x02, sp), x
00106$:
;	rda5807_uart.c: 287: aktfreq--;
	ldw	x, _aktfreq+0
	decw	x
	ldw	_aktfreq+0, x
;	rda5807_uart.c: 288: setnewtune(aktfreq);
	push	_aktfreq+1
	push	_aktfreq+0
	call	_setnewtune
	addw	sp, #2
;	rda5807_uart.c: 289: siglev= rda5807_getsig();
	call	_rda5807_getsig
	ld	(0x01, sp), a
;	rda5807_uart.c: 290: if (aktfreq < 1000) { printf(" "); }
	ldw	x, _aktfreq+0
	cpw	x, #0x03e8
	jrnc	00104$
	ldw	x, (0x04, sp)
	pushw	x
	call	_my_printf
	addw	sp, #2
00104$:
;	rda5807_uart.c: 291: printf("  %k MHz  \r",aktfreq, siglev);
	clrw	x
	ld	a, (0x01, sp)
	ld	xl, a
	ldw	y, (0x02, sp)
	pushw	x
	push	_aktfreq+1
	push	_aktfreq+0
	pushw	y
	call	_my_printf
	addw	sp, #6
;	rda5807_uart.c: 292: }while ((siglev < sigschwelle) && (aktfreq > fbandmin));
	ld	a, (0x01, sp)
	cp	a, #0x47
	jrnc	00108$
	ldw	x, _aktfreq+0
	cpw	x, #0x0366
	jrugt	00106$
00108$:
;	rda5807_uart.c: 294: rda5807_setvol(aktvol);
	clrw	x
	ld	a, _aktvol+0
	ld	xl, a
	pushw	x
	call	_rda5807_setvol
	addw	sp, #7
	ret
;	rda5807_uart.c: 299: void rda5807_scanup(void)
;	-----------------------------------------
;	 function rda5807_scanup
;	-----------------------------------------
_rda5807_scanup:
	sub	sp, #5
;	rda5807_uart.c: 303: rda5807_setvol(0);
	clrw	x
	pushw	x
	call	_rda5807_setvol
	addw	sp, #2
;	rda5807_uart.c: 305: if (aktfreq== fbandmax) { aktfreq= fbandmin; }
	ldw	x, _aktfreq+0
	cpw	x, #0x0438
	jrne	00114$
	ldw	x, #0x0366
	ldw	_aktfreq+0, x
;	rda5807_uart.c: 306: do
00114$:
	ldw	x, #___str_3+0
	ldw	(0x02, sp), x
	ldw	x, #___str_4+0
	ldw	(0x04, sp), x
00106$:
;	rda5807_uart.c: 308: aktfreq++;
	ldw	x, _aktfreq+0
	incw	x
	ldw	_aktfreq+0, x
;	rda5807_uart.c: 309: setnewtune(aktfreq);
	push	_aktfreq+1
	push	_aktfreq+0
	call	_setnewtune
	addw	sp, #2
;	rda5807_uart.c: 310: siglev= rda5807_getsig();
	call	_rda5807_getsig
	ld	(0x01, sp), a
;	rda5807_uart.c: 311: if (aktfreq < 1000) { printf(" "); }
	ldw	x, _aktfreq+0
	cpw	x, #0x03e8
	jrnc	00104$
	ldw	x, (0x02, sp)
	pushw	x
	call	_my_printf
	addw	sp, #2
00104$:
;	rda5807_uart.c: 312: printf("  %k MHz  \r",aktfreq, siglev);
	clrw	x
	ld	a, (0x01, sp)
	ld	xl, a
	ldw	y, (0x04, sp)
	pushw	x
	push	_aktfreq+1
	push	_aktfreq+0
	pushw	y
	call	_my_printf
	addw	sp, #6
;	rda5807_uart.c: 313: }while ((siglev < sigschwelle) && (aktfreq < fbandmax));
	ld	a, (0x01, sp)
	cp	a, #0x47
	jrnc	00108$
	ldw	x, _aktfreq+0
	cpw	x, #0x0438
	jrc	00106$
00108$:
;	rda5807_uart.c: 315: rda5807_setvol(aktvol);
	clrw	x
	ld	a, _aktvol+0
	ld	xl, a
	pushw	x
	call	_rda5807_setvol
	addw	sp, #7
	ret
;	rda5807_uart.c: 323: int main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #3
;	rda5807_uart.c: 327: sysclock_init(0);
	push	#0x00
	call	_sysclock_init
	pop	a
;	rda5807_uart.c: 329: printfkomma= 1;                       // my_printf verwendet mit Formatter %k eine Kommastelle
	mov	_printfkomma+0, #0x01
;	rda5807_uart.c: 331: i2c_master_init();                    // 2 = ca. 15kHz I2C Clock-Takt
	call	_i2c_master_init
;	rda5807_uart.c: 332: uart_init(19200);
	push	#0x00
	push	#0x4b
	call	_uart_init
	addw	sp, #2
;	rda5807_uart.c: 334: printf("\n\n\r  ----------------------------------\n\r");
	ldw	x, #___str_5+0
	pushw	x
	call	_my_printf
	addw	sp, #2
;	rda5807_uart.c: 335: printf(      "    UKW-Radio mit I2C-Chip RDA5807\n\r");
	ldw	x, #___str_6+0
	pushw	x
	call	_my_printf
	addw	sp, #2
;	rda5807_uart.c: 336: printf(      "  ----------------------------------\n\n\r");
	ldw	x, #___str_7+0
	pushw	x
	call	_my_printf
	addw	sp, #2
;	rda5807_uart.c: 337: printf(      "      (+)     Volume+\n\r");
	ldw	x, #___str_8+0
	pushw	x
	call	_my_printf
	addw	sp, #2
;	rda5807_uart.c: 338: printf(      "      (-)     Volume-\n\n\r");
	ldw	x, #___str_9+0
	pushw	x
	call	_my_printf
	addw	sp, #2
;	rda5807_uart.c: 339: printf(      "      (u)     Empfangsfrequenz hoch\n\r");
	ldw	x, #___str_10+0
	pushw	x
	call	_my_printf
	addw	sp, #2
;	rda5807_uart.c: 340: printf(      "      (d)     Empfangsfrequenz runter\n\n\r");
	ldw	x, #___str_11+0
	pushw	x
	call	_my_printf
	addw	sp, #2
;	rda5807_uart.c: 341: printf(      "      (a)     Sendersuchlauf hoch\n\r");
	ldw	x, #___str_12+0
	pushw	x
	call	_my_printf
	addw	sp, #2
;	rda5807_uart.c: 342: printf(      "      (s)     Sendersuchlauf runter\n\n\r");
	ldw	x, #___str_13+0
	pushw	x
	call	_my_printf
	addw	sp, #2
;	rda5807_uart.c: 343: printf(      "      (1..6)  Stationstaste\n\n\r");
	ldw	x, #___str_14+0
	pushw	x
	call	_my_printf
	addw	sp, #2
;	rda5807_uart.c: 345: rda5807_reset();
	call	_rda5807_reset
;	rda5807_uart.c: 346: rda5807_poweron();
	call	_rda5807_poweron
;	rda5807_uart.c: 347: rda5807_setmono();
	call	_rda5807_setmono
;	rda5807_uart.c: 348: rda5807_setfreq(aktfreq);
	push	_aktfreq+1
	push	_aktfreq+0
	call	_rda5807_setfreq
	addw	sp, #2
;	rda5807_uart.c: 349: rda5807_setvol(aktvol);
	clrw	x
	ld	a, _aktvol+0
	ld	xl, a
	pushw	x
	call	_rda5807_setvol
	addw	sp, #2
;	rda5807_uart.c: 351: show_tune();
	call	_show_tune
;	rda5807_uart.c: 352: while (uart_ischar()) { ch = uart_getchar(); }
00101$:
	call	_uart_ischar
	tnz	a
	jreq	00124$
	call	_uart_getchar
	jra	00101$
;	rda5807_uart.c: 354: while(1)
00124$:
;	rda5807_uart.c: 357: ch= uart_getchar();
	call	_uart_getchar
	ld	(0x01, sp), a
;	rda5807_uart.c: 358: switch (ch)
	ld	a, (0x01, sp)
	cp	a, #0x2b
	jreq	00104$
	ld	a, (0x01, sp)
	cp	a, #0x2d
	jreq	00107$
	ld	a, (0x01, sp)
	cp	a, #0x61
	jrne	00196$
	jp	00117$
00196$:
	ld	a, (0x01, sp)
	cp	a, #0x64
	jreq	00110$
	ld	a, (0x01, sp)
	cp	a, #0x73
	jrne	00202$
	jp	00116$
00202$:
	ld	a, (0x01, sp)
	cp	a, #0x75
	jreq	00113$
	jp	00119$
;	rda5807_uart.c: 360: case '+' :                            // Volume erhoehen
00104$:
;	rda5807_uart.c: 362: if (aktvol< 15)
	ld	a, _aktvol+0
	cp	a, #0x0f
	jrc	00207$
	jp	00119$
00207$:
;	rda5807_uart.c: 364: aktvol++;
	ld	a, _aktvol+0
	inc	a
	ld	_aktvol+0, a
;	rda5807_uart.c: 365: rda5807_setvol(aktvol);
	clrw	x
	ld	a, _aktvol+0
	ld	xl, a
	pushw	x
	call	_rda5807_setvol
	addw	sp, #2
;	rda5807_uart.c: 366: putchar('\r');
	push	#0x0d
	call	_putchar
	pop	a
;	rda5807_uart.c: 367: show_tune();
	call	_show_tune
;	rda5807_uart.c: 369: break;
	jra	00119$
;	rda5807_uart.c: 372: case '-' :
00107$:
;	rda5807_uart.c: 374: if (aktvol> 0)                      // Volume verringern
	tnz	_aktvol+0
	jreq	00119$
;	rda5807_uart.c: 376: aktvol--;
	ld	a, _aktvol+0
	dec	a
	ld	_aktvol+0, a
;	rda5807_uart.c: 377: rda5807_setvol(aktvol);
	clrw	x
	ld	a, _aktvol+0
	ld	xl, a
	pushw	x
	call	_rda5807_setvol
	addw	sp, #2
;	rda5807_uart.c: 378: putchar('\r');
	push	#0x0d
	call	_putchar
	pop	a
;	rda5807_uart.c: 379: show_tune();
	call	_show_tune
;	rda5807_uart.c: 381: break;
	jra	00119$
;	rda5807_uart.c: 384: case 'd' :                           // Empfangsfrequenz nach unten
00110$:
;	rda5807_uart.c: 386: if (aktfreq > fbandmin)
	ldw	x, _aktfreq+0
	cpw	x, #0x0366
	jrule	00119$
;	rda5807_uart.c: 388: aktfreq--;
	ldw	x, _aktfreq+0
	decw	x
	ldw	_aktfreq+0, x
;	rda5807_uart.c: 389: setnewtune(aktfreq);
	push	_aktfreq+1
	push	_aktfreq+0
	call	_setnewtune
	addw	sp, #2
;	rda5807_uart.c: 390: show_tune();
	call	_show_tune
;	rda5807_uart.c: 392: break;
	jra	00119$
;	rda5807_uart.c: 394: case 'u' :                           // Empfangsfrequenz nach oben
00113$:
;	rda5807_uart.c: 396: if (aktfreq < fbandmax)
	ldw	x, _aktfreq+0
	cpw	x, #0x0438
	jrnc	00119$
;	rda5807_uart.c: 398: aktfreq++;
	ldw	x, _aktfreq+0
	incw	x
	ldw	_aktfreq+0, x
;	rda5807_uart.c: 399: setnewtune(aktfreq);
	push	_aktfreq+1
	push	_aktfreq+0
	call	_setnewtune
	addw	sp, #2
;	rda5807_uart.c: 400: show_tune();
	call	_show_tune
;	rda5807_uart.c: 402: break;
	jra	00119$
;	rda5807_uart.c: 405: case 's' :                           // Suchlauf nach unten
00116$:
;	rda5807_uart.c: 407: rda5807_scandown();
	call	_rda5807_scandown
;	rda5807_uart.c: 408: show_tune();
	call	_show_tune
;	rda5807_uart.c: 410: break;
	jra	00119$
;	rda5807_uart.c: 413: case 'a' :                         // Suchlauf nach oben
00117$:
;	rda5807_uart.c: 415: rda5807_scanup();
	call	_rda5807_scanup
;	rda5807_uart.c: 416: show_tune();
	call	_show_tune
;	rda5807_uart.c: 422: }
00119$:
;	rda5807_uart.c: 424: if ((ch >= '1') && (ch <= '6'))
	ld	a, (0x01, sp)
	cp	a, #0x31
	jrsge	00211$
	jp	00124$
00211$:
	ld	a, (0x01, sp)
	cp	a, #0x36
	jrsle	00212$
	jp	00124$
00212$:
;	rda5807_uart.c: 426: setnewtune(festfreq[ch-'0'-1]);
	ldw	x, #_festfreq+0
	ldw	(0x02, sp), x
	ld	a, (0x01, sp)
	sub	a, #0x31
	ld	xl, a
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	xh, a
	sllw	x
	addw	x, (0x02, sp)
	ldw	x, (x)
	pushw	x
	call	_setnewtune
	addw	sp, #2
;	rda5807_uart.c: 427: show_tune();
	call	_show_tune
	jp	00124$
	addw	sp, #3
	ret
	.area CODE
_festfreq:
	.dw #0x03FA
	.dw #0x0418
	.dw #0x0378
	.dw #0x03CA
	.dw #0x03D2
	.dw #0x03E7
___str_0:
	.ascii "  %k MHz  |  Volume: "
	.db 0x00
___str_1:
	.ascii "x--------------"
	.db 0x00
___str_2:
	.ascii "  "
	.db 0x0D
	.db 0x00
___str_3:
	.ascii " "
	.db 0x00
___str_4:
	.ascii "  %k MHz  "
	.db 0x0D
	.db 0x00
___str_5:
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.ascii "  ----------------------------------"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_6:
	.ascii "    UKW-Radio mit I2C-Chip RDA5807"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_7:
	.ascii "  ----------------------------------"
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_8:
	.ascii "      (+)     Volume+"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_9:
	.ascii "      (-)     Volume-"
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_10:
	.ascii "      (u)     Empfangsfrequenz hoch"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_11:
	.ascii "      (d)     Empfangsfrequenz runter"
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_12:
	.ascii "      (a)     Sendersuchlauf hoch"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_13:
	.ascii "      (s)     Sendersuchlauf runter"
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_14:
	.ascii "      (1..6)  Stationstaste"
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.db 0x00
	.area INITIALIZER
__xinit__aktfreq:
	.dw #0x03FA
__xinit__aktvol:
	.db #0x02	; 2
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
	.area CABS (ABS)
