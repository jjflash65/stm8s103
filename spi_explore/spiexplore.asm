;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Aug 12 2015) (Linux)
; This file was generated Mon May  8 19:29:26 2017
;--------------------------------------------------------
	.module spiexplore
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _cmdinterpret
	.globl _send4cmdbytes
	.globl _send3cmdbytes
	.globl _get4cmdbytes
	.globl _showactclkmode
	.globl _showactrstmode
	.globl _checkcmd
	.globl _crlf
	.globl _readstr
	.globl _gethex16
	.globl _printhex16
	.globl _gethex
	.globl _printhex
	.globl _isp_clrrst
	.globl _isp_setrst
	.globl _spi_read
	.globl _spi_out
	.globl _spi_init
	.globl _uart_putstring
	.globl _uart_init
	.globl _uart_getchar
	.globl _uart_putchar
	.globl _sysclock_init
	.globl _clkinv
	.globl _rinv
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
_rinv::
	.ds 1
_clkinv::
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
;	spiexplore.c: 40: void isp_setrst(void)
;	-----------------------------------------
;	 function isp_setrst
;	-----------------------------------------
_isp_setrst:
;	spiexplore.c: 42: if (rinv) PC3_clr(); else PC3_set();
	ldw	x, #0x500a
	ld	a, (x)
	tnz	_rinv+0
	jreq	00102$
	and	a, #0xf7
	ldw	x, #0x500a
	ld	(x), a
	jra	00104$
00102$:
	or	a, #0x08
	ldw	x, #0x500a
	ld	(x), a
00104$:
	ret
;	spiexplore.c: 45: void isp_clrrst(void)
;	-----------------------------------------
;	 function isp_clrrst
;	-----------------------------------------
_isp_clrrst:
;	spiexplore.c: 47: if (rinv) PC3_set(); else PC3_clr();
	ldw	x, #0x500a
	ld	a, (x)
	tnz	_rinv+0
	jreq	00102$
	or	a, #0x08
	ldw	x, #0x500a
	ld	(x), a
	jra	00104$
00102$:
	and	a, #0xf7
	ldw	x, #0x500a
	ld	(x), a
00104$:
	ret
;	spiexplore.c: 56: void printhex(uint8_t value)
;	-----------------------------------------
;	 function printhex
;	-----------------------------------------
_printhex:
;	spiexplore.c: 60: b= (value >> 4);
	ld	a, (0x03, sp)
	swap	a
	and	a, #0x0f
;	spiexplore.c: 61: if (b< 10) b += '0'; else b += 'A'-10;
	ld	xh, a
	cp	a, #0x0a
	jrnc	00102$
	ld	a, xh
	add	a, #0x30
	jra	00103$
00102$:
	ld	a, xh
	add	a, #0x37
00103$:
;	spiexplore.c: 62: uart_putchar(b);
	push	a
	call	_uart_putchar
	pop	a
;	spiexplore.c: 63: b= value & 0x0f;
	ld	a, (0x03, sp)
	and	a, #0x0f
;	spiexplore.c: 61: if (b< 10) b += '0'; else b += 'A'-10;
	ld	xh, a
;	spiexplore.c: 64: if (b< 10) b += '0'; else b += 'A'-10;
	cp	a, #0x0a
	jrnc	00105$
	ld	a, xh
	add	a, #0x30
	jra	00106$
00105$:
	ld	a, xh
	add	a, #0x37
00106$:
;	spiexplore.c: 65: uart_putchar(b);
	push	a
	call	_uart_putchar
	pop	a
	ret
;	spiexplore.c: 76: uint8_t gethex(char echo)
;	-----------------------------------------
;	 function gethex
;	-----------------------------------------
_gethex:
	push	a
;	spiexplore.c: 81: ch= uart_getchar();
	call	_uart_getchar
;	spiexplore.c: 82: if (echo) uart_putchar(ch);
	tnz	(0x04, sp)
	jreq	00102$
	push	a
	push	a
	call	_uart_putchar
	pop	a
	pop	a
00102$:
;	spiexplore.c: 85: ch= (ch-'a')+10;
	ld	xh, a
;	spiexplore.c: 83: if (ch > 'F')
	cp	a, #0x46
	jrule	00107$
;	spiexplore.c: 85: ch= (ch-'a')+10;
	ld	a, xh
	add	a, #0xa9
	jra	00108$
00107$:
;	spiexplore.c: 89: if (ch> '9') ch= (ch-'A')+10; else ch -= '0';
	cp	a, #0x39
	jrule	00104$
	ld	a, xh
	add	a, #0xc9
	jra	00108$
00104$:
	ld	a, xh
	sub	a, #0x30
00108$:
;	spiexplore.c: 91: value= (ch<< 4);
	swap	a
	and	a, #0xf0
	ld	(0x01, sp), a
;	spiexplore.c: 92: ch= uart_getchar();
	call	_uart_getchar
;	spiexplore.c: 93: if (echo) uart_putchar(ch);
	tnz	(0x04, sp)
	jreq	00110$
	push	a
	push	a
	call	_uart_putchar
	pop	a
	pop	a
00110$:
;	spiexplore.c: 85: ch= (ch-'a')+10;
	ld	xh, a
;	spiexplore.c: 95: if (ch > 'F')
	cp	a, #0x46
	jrule	00115$
;	spiexplore.c: 97: ch= (ch-'a')+10;
	ld	a, xh
	add	a, #0xa9
	jra	00116$
00115$:
;	spiexplore.c: 101: if (ch> '9') ch= (ch-'A')+10; else ch -= '0';
	cp	a, #0x39
	jrule	00112$
	ld	a, xh
	add	a, #0xc9
	jra	00116$
00112$:
	ld	a, xh
	sub	a, #0x30
00116$:
;	spiexplore.c: 103: value |= ch;
	or	a, (0x01, sp)
;	spiexplore.c: 104: return value;
	addw	sp, #1
	ret
;	spiexplore.c: 107: void printhex16(uint16_t value)
;	-----------------------------------------
;	 function printhex16
;	-----------------------------------------
_printhex16:
	pushw	x
;	spiexplore.c: 109: printhex(value >> 8);
	ld	a, (0x05, sp)
	clr	(0x01, sp)
	push	a
	call	_printhex
	pop	a
;	spiexplore.c: 110: printhex(value & 0x00ff);
	ld	a, (0x06, sp)
	ld	xh, a
	clr	a
	ld	a, xh
	push	a
	call	_printhex
	pop	a
	popw	x
	ret
;	spiexplore.c: 113: uint16_t gethex16(char echo)
;	-----------------------------------------
;	 function gethex16
;	-----------------------------------------
_gethex16:
	pushw	x
;	spiexplore.c: 117: i= gethex(0);
	push	#0x00
	call	_gethex
	addw	sp, #1
	ld	xh, a
	clr	a
;	spiexplore.c: 118: i= i & 0x00ff;
	clr	a
	ld	xl, a
;	spiexplore.c: 119: i2= gethex(0);
	pushw	x
	push	#0x00
	call	_gethex
	addw	sp, #1
	ld	yh, a
	popw	x
	clr	a
;	spiexplore.c: 120: i2= i2 & 0x00ff;
	clr	a
;	spiexplore.c: 121: i2= i2 | (i << 8);
	clr	(0x02, sp)
	pushw	x
	or	a, (1, sp)
	popw	x
	ld	xh, a
	ld	a, yh
	or	a, (0x02, sp)
	ld	xl, a
;	spiexplore.c: 122: if (echo) printhex16(i2);
	tnz	(0x05, sp)
	jreq	00102$
	pushw	x
	pushw	x
	call	_printhex16
	popw	x
	popw	x
00102$:
;	spiexplore.c: 123: return i2;
	addw	sp, #2
	ret
;	spiexplore.c: 132: void readstr(char *string, char anz)
;	-----------------------------------------
;	 function readstr
;	-----------------------------------------
_readstr:
	pushw	x
;	spiexplore.c: 136: cnt= 0;
	clr	(0x01, sp)
;	spiexplore.c: 138: *string= 0;
	ldw	x, (0x05, sp)
	clr	(x)
;	spiexplore.c: 139: do
00110$:
;	spiexplore.c: 141: ch= uart_getchar();
	pushw	x
	call	_uart_getchar
	popw	x
;	spiexplore.c: 142: if (ch!= 0x0d)
	cp	a, #0x0d
	jrne	00136$
	push	a
	ld	a, #0x01
	ld	(0x03, sp), a
	pop	a
	jra	00137$
00136$:
	clr	(0x02, sp)
00137$:
	tnz	(0x02, sp)
	jrne	00111$
;	spiexplore.c: 144: if (ch!= 0x08)
	cp	a, #0x08
	jreq	00106$
;	spiexplore.c: 146: if (cnt< anz)
	push	a
	ld	a, (0x02, sp)
	cp	a, (0x08, sp)
	pop	a
	jrsge	00111$
;	spiexplore.c: 148: uart_putchar(ch);
	push	a
	pushw	x
	push	a
	call	_uart_putchar
	pop	a
	popw	x
	pop	a
;	spiexplore.c: 149: *string= ch;
	ld	(x), a
;	spiexplore.c: 150: string++;
	incw	x
	ldw	(0x05, sp), x
;	spiexplore.c: 138: *string= 0;
	ldw	x, (0x05, sp)
;	spiexplore.c: 151: *string= 0;
	clr	(x)
;	spiexplore.c: 152: cnt++;
	ld	a, (0x01, sp)
	inc	a
	ld	(0x01, sp), a
	jra	00111$
00106$:
;	spiexplore.c: 157: if (cnt)
	tnz	(0x01, sp)
	jreq	00111$
;	spiexplore.c: 159: uart_putchar(0x08);
	push	#0x08
	call	_uart_putchar
	pop	a
;	spiexplore.c: 160: string--;
	ldw	x, (0x05, sp)
	decw	x
	ldw	(0x05, sp), x
;	spiexplore.c: 138: *string= 0;
	ldw	x, (0x05, sp)
;	spiexplore.c: 161: *string= 0;
	clr	(x)
;	spiexplore.c: 162: cnt--;
	ld	a, (0x01, sp)
	dec	a
	ld	(0x01, sp), a
00111$:
;	spiexplore.c: 166: } while (ch != 0x0d);
	tnz	(0x02, sp)
	jreq	00110$
	popw	x
	ret
;	spiexplore.c: 175: void crlf(void)
;	-----------------------------------------
;	 function crlf
;	-----------------------------------------
_crlf:
;	spiexplore.c: 177: uart_putchar(0x0d);
	push	#0x0d
	call	_uart_putchar
	pop	a
;	spiexplore.c: 178: uart_putchar(0x0a);
	push	#0x0a
	call	_uart_putchar
	pop	a
	ret
;	spiexplore.c: 182: char checkcmd(char *string)
;	-----------------------------------------
;	 function checkcmd
;	-----------------------------------------
_checkcmd:
	sub	sp, #14
;	spiexplore.c: 188: i= 0;
	clr	(0x0e, sp)
;	spiexplore.c: 189: do
	ldw	x, #_cmds+0
	ldw	(0x0c, sp), x
	clr	(0x03, sp)
	clrw	x
	ldw	(0x0a, sp), x
00109$:
;	spiexplore.c: 191: s= string;
	ldw	y, (0x11, sp)
;	spiexplore.c: 192: match= 1;
	ld	a, #0x01
	ld	(0x01, sp), a
;	spiexplore.c: 194: do
	ldw	x, (0x0c, sp)
	addw	x, (0x0a, sp)
	ldw	(0x08, sp), x
	clr	(0x02, sp)
	ldw	(0x06, sp), y
00104$:
;	spiexplore.c: 196: ch= cmds[i][cp];
	clrw	x
	ld	a, (0x02, sp)
	ld	xl, a
	addw	x, (0x08, sp)
	ld	a, (x)
;	spiexplore.c: 197: if (ch!= *s) match= 0;
	ldw	x, (0x06, sp)
	push	a
	ld	a, (x)
	ld	(0x06, sp), a
	pop	a
	cp	a, (0x05, sp)
	jreq	00102$
	clr	(0x01, sp)
00102$:
;	spiexplore.c: 199: cp++; s++;
	inc	(0x02, sp)
	ldw	x, (0x06, sp)
	incw	x
	ldw	(0x06, sp), x
;	spiexplore.c: 200: }while(ch && match);
	tnz	a
	jreq	00106$
	tnz	(0x01, sp)
	jrne	00104$
00106$:
;	spiexplore.c: 201: if (match) return i+1;
	tnz	(0x01, sp)
	jreq	00108$
	ld	a, (0x0e, sp)
	inc	a
	ld	(0x04, sp), a
	ld	a, (0x04, sp)
	jra	00112$
00108$:
;	spiexplore.c: 202: i++;
	ldw	x, (0x0a, sp)
	addw	x, #0x0009
	ldw	(0x0a, sp), x
	inc	(0x03, sp)
	ld	a, (0x03, sp)
	ld	(0x0e, sp), a
;	spiexplore.c: 203: } while (i < cmdanz);
	ld	a, (0x03, sp)
	cp	a, #0x06
	jrslt	00109$
;	spiexplore.c: 204: return 0;
	clr	a
00112$:
	addw	sp, #14
	ret
;	spiexplore.c: 208: void showactrstmode(void)
;	-----------------------------------------
;	 function showactrstmode
;	-----------------------------------------
_showactrstmode:
;	spiexplore.c: 210: crlf();
	call	_crlf
;	spiexplore.c: 211: uart_prints("actual mode is: ");
	ldw	x, #___str_0+0
	pushw	x
	call	_uart_putstring
	popw	x
;	spiexplore.c: 212: if (rinv) uart_prints("invert "); else uart_prints("not invert ");
	tnz	_rinv+0
	jreq	00102$
	ldw	x, #___str_1+0
	pushw	x
	call	_uart_putstring
	popw	x
	jra	00104$
00102$:
	ldw	x, #___str_2+0
	pushw	x
	call	_uart_putstring
	popw	x
00104$:
	ret
;	spiexplore.c: 215: void showactclkmode(void)
;	-----------------------------------------
;	 function showactclkmode
;	-----------------------------------------
_showactclkmode:
;	spiexplore.c: 217: crlf();
	call	_crlf
;	spiexplore.c: 218: uart_prints("actual mode is: ");
	ldw	x, #___str_0+0
	pushw	x
	call	_uart_putstring
	popw	x
;	spiexplore.c: 219: if (clkinv) uart_prints("invert "); else uart_prints("not invert ");
	tnz	_clkinv+0
	jreq	00102$
	ldw	x, #___str_1+0
	pushw	x
	call	_uart_putstring
	popw	x
	jra	00104$
00102$:
	ldw	x, #___str_2+0
	pushw	x
	call	_uart_putstring
	popw	x
00104$:
	ret
;	spiexplore.c: 223: void get4cmdbytes(uint8_t *v1, uint8_t *v2, uint8_t *v3, uint8_t *v4)
;	-----------------------------------------
;	 function get4cmdbytes
;	-----------------------------------------
_get4cmdbytes:
;	spiexplore.c: 226: crlf();
	call	_crlf
;	spiexplore.c: 227: uart_prints("Enter 4 instruction bytes: ");
	ldw	x, #___str_3+0
	pushw	x
	call	_uart_putstring
	popw	x
;	spiexplore.c: 228: v = gethex(1); uart_putchar(' ');
	push	#0x01
	call	_gethex
	addw	sp, #1
	push	a
	push	#0x20
	call	_uart_putchar
	pop	a
	pop	a
;	spiexplore.c: 229: *v1 = v;
	ldw	x, (0x03, sp)
	ld	(x), a
;	spiexplore.c: 230: v = gethex(1); uart_putchar(' ');
	push	#0x01
	call	_gethex
	addw	sp, #1
	push	a
	push	#0x20
	call	_uart_putchar
	pop	a
	pop	a
;	spiexplore.c: 231: *v2 = v;
	ldw	x, (0x05, sp)
	ld	(x), a
;	spiexplore.c: 232: v = gethex(1); uart_putchar(' ');
	push	#0x01
	call	_gethex
	addw	sp, #1
	push	a
	push	#0x20
	call	_uart_putchar
	pop	a
	pop	a
;	spiexplore.c: 233: *v3 = v;
	ldw	x, (0x07, sp)
	ld	(x), a
;	spiexplore.c: 234: v = gethex(1); uart_putchar(' ');
	push	#0x01
	call	_gethex
	addw	sp, #1
	push	a
	push	#0x20
	call	_uart_putchar
	pop	a
	pop	a
;	spiexplore.c: 235: *v4 = v;
	ldw	x, (0x09, sp)
	ld	(x), a
;	spiexplore.c: 236: crlf();
	jp	_crlf
;	spiexplore.c: 239: void send3cmdbytes(uint8_t v1, uint8_t v2, uint8_t v3)
;	-----------------------------------------
;	 function send3cmdbytes
;	-----------------------------------------
_send3cmdbytes:
;	spiexplore.c: 241: spi_out(v1);
	ld	a, (0x03, sp)
	push	a
	call	_spi_out
	pop	a
;	spiexplore.c: 242: spi_out(v2);
	ld	a, (0x04, sp)
	push	a
	call	_spi_out
	pop	a
;	spiexplore.c: 243: spi_out(v3);
	ld	a, (0x05, sp)
	push	a
	call	_spi_out
	pop	a
	ret
;	spiexplore.c: 246: uint8_t send4cmdbytes(uint8_t v1, uint8_t v2, uint8_t v3, uint8_t v4)
;	-----------------------------------------
;	 function send4cmdbytes
;	-----------------------------------------
_send4cmdbytes:
;	spiexplore.c: 250: spi_out(v1);
	ld	a, (0x03, sp)
	push	a
	call	_spi_out
	pop	a
;	spiexplore.c: 251: spi_out(v2);
	ld	a, (0x04, sp)
	push	a
	call	_spi_out
	pop	a
;	spiexplore.c: 252: spi_out(v3);
	ld	a, (0x05, sp)
	push	a
	call	_spi_out
	pop	a
;	spiexplore.c: 253: spi_out(v4);
	ld	a, (0x06, sp)
	push	a
	call	_spi_out
	pop	a
;	spiexplore.c: 254: value= spi_read();
;	spiexplore.c: 255: return value;
	jp	_spi_read
;	spiexplore.c: 259: void cmdinterpret(void)
;	-----------------------------------------
;	 function cmdinterpret
;	-----------------------------------------
_cmdinterpret:
	sub	sp, #40
;	spiexplore.c: 266: do
	ldw	x, #___str_5+0
	ldw	(0x21, sp), x
	ldw	y, (0x21, sp)
	ldw	(0x1b, sp), y
	ldw	y, (0x21, sp)
	ldw	(0x15, sp), y
	ldw	x, #___str_8+0
	ldw	(0x1d, sp), x
	ldw	x, #___str_7+0
	ldw	(0x1f, sp), x
	ldw	x, #___str_6+0
	ldw	(0x17, sp), x
	ldw	x, #___str_4+0
	ldw	(0x19, sp), x
	ldw	x, sp
	incw	x
	incw	x
	ldw	(0x13, sp), x
	ldw	y, (0x13, sp)
	ldw	(0x27, sp), y
00118$:
;	spiexplore.c: 268: uart_prints("SPI:> ");
	ldw	x, (0x19, sp)
	pushw	x
	call	_uart_putstring
	popw	x
;	spiexplore.c: 269: readstr(&inbuffer[0],8);
	ldw	x, (0x13, sp)
	push	#0x08
	pushw	x
	call	_readstr
	addw	sp, #3
;	spiexplore.c: 270: ch= checkcmd(&inbuffer[0]);
	ldw	x, (0x27, sp)
	pushw	x
	call	_checkcmd
	popw	x
	ld	(0x01, sp), a
;	spiexplore.c: 272: switch(ch)
	ld	a, (0x01, sp)
	cp	a, #0x01
	jreq	00101$
	ld	a, (0x01, sp)
	cp	a, #0x02
	jreq	00105$
	ld	a, (0x01, sp)
	cp	a, #0x03
	jreq	00106$
	ld	a, (0x01, sp)
	cp	a, #0x04
	jreq	00107$
	ld	a, (0x01, sp)
	cp	a, #0x05
	jrne	00176$
	jp	00108$
00176$:
	ld	a, (0x01, sp)
	cp	a, #0x06
	jrne	00179$
	jp	00112$
00179$:
	jp	00116$
;	spiexplore.c: 274: case 1 :                               // Reset-Modus (invertiert oder nicht invertiert)
00101$:
;	spiexplore.c: 276: showactrstmode();
	call	_showactrstmode
;	spiexplore.c: 277: uart_prints("[0/1]: ");
	ldw	x, (0x21, sp)
	pushw	x
	call	_uart_putstring
	popw	x
;	spiexplore.c: 278: ch= uart_getchar();
	call	_uart_getchar
	ld	(0x01, sp), a
;	spiexplore.c: 279: uart_putchar(ch);
	ld	a, (0x01, sp)
	push	a
	call	_uart_putchar
	pop	a
;	spiexplore.c: 280: if (ch== '1') {rinv= 1;} else {rinv= 0;}
	ld	a, (0x01, sp)
	cp	a, #0x31
	jrne	00103$
	mov	_rinv+0, #0x01
	jra	00104$
00103$:
	clr	_rinv+0
00104$:
;	spiexplore.c: 281: showactrstmode();
	call	_showactrstmode
;	spiexplore.c: 282: crlf();
	call	_crlf
;	spiexplore.c: 283: break;
	jp	00119$
;	spiexplore.c: 285: case 2 :                               // send Data-Byte
00105$:
;	spiexplore.c: 287: crlf();
	call	_crlf
;	spiexplore.c: 288: uart_prints("byte to send: ");
	ldw	x, (0x17, sp)
	pushw	x
	call	_uart_putstring
	popw	x
;	spiexplore.c: 289: b= gethex(1);
	push	#0x01
	call	_gethex
	addw	sp, #1
;	spiexplore.c: 290: spi_out(b);
	push	a
	call	_spi_out
	pop	a
;	spiexplore.c: 291: crlf();
	call	_crlf
;	spiexplore.c: 292: break;
	jp	00119$
;	spiexplore.c: 294: case 3 :                               // read Data-Byte
00106$:
;	spiexplore.c: 296: crlf();
	call	_crlf
;	spiexplore.c: 297: uart_prints("readed byte: ");
	ldw	x, (0x1f, sp)
	pushw	x
	call	_uart_putstring
	popw	x
;	spiexplore.c: 298: b= spi_read();
	call	_spi_read
;	spiexplore.c: 299: printhex(b);
	push	a
	call	_printhex
	pop	a
;	spiexplore.c: 300: crlf();
	call	_crlf
;	spiexplore.c: 301: break;
	jp	00119$
;	spiexplore.c: 303: case 4 :                              // send 4-Byte instruction
00107$:
;	spiexplore.c: 305: get4cmdbytes(&v1, &v2, &v3, &v4);
	ldw	y, sp
	addw	y, #15
	ldw	x, sp
	addw	x, #16
	ldw	(0x25, sp), x
	ldw	x, sp
	addw	x, #17
	ldw	(0x23, sp), x
	ldw	x, sp
	addw	x, #18
	pushw	y
	ldw	y, (0x27, sp)
	pushw	y
	ldw	y, (0x27, sp)
	pushw	y
	pushw	x
	call	_get4cmdbytes
	addw	sp, #8
;	spiexplore.c: 306: send4cmdbytes(v1, v2, v3, v4);
	ld	a, (0x0f, sp)
	push	a
	ld	a, (0x11, sp)
	push	a
	ld	a, (0x13, sp)
	push	a
	ld	a, (0x15, sp)
	push	a
	call	_send4cmdbytes
	addw	sp, #4
;	spiexplore.c: 307: break;
	jra	00119$
;	spiexplore.c: 309: case 5 :                               // Clock-Modus (invertiert oder nicht invertiert)
00108$:
;	spiexplore.c: 311: showactclkmode();
	call	_showactclkmode
;	spiexplore.c: 312: uart_prints("[0/1]: ");
	ldw	x, (0x1b, sp)
	pushw	x
	call	_uart_putstring
	popw	x
;	spiexplore.c: 313: ch= uart_getchar();
	call	_uart_getchar
	ld	(0x01, sp), a
;	spiexplore.c: 314: uart_putchar(ch);
	ld	a, (0x01, sp)
	push	a
	call	_uart_putchar
	pop	a
;	spiexplore.c: 315: if (ch== '1') {clkinv= 1;} else {clkinv= 0;}
	ld	a, (0x01, sp)
	cp	a, #0x31
	jrne	00110$
	mov	_clkinv+0, #0x01
	jra	00111$
00110$:
	clr	_clkinv+0
00111$:
;	spiexplore.c: 316: showactclkmode();
	call	_showactclkmode
;	spiexplore.c: 317: crlf();
	call	_crlf
;	spiexplore.c: 318: break;
	jra	00119$
;	spiexplore.c: 320: case 6 :                                // Reset - Leitung
00112$:
;	spiexplore.c: 322: crlf();
	call	_crlf
;	spiexplore.c: 323: uart_prints("[0/1]: ");
	ldw	x, (0x15, sp)
	pushw	x
	call	_uart_putstring
	popw	x
;	spiexplore.c: 324: ch= uart_getchar();
	call	_uart_getchar
	ld	(0x01, sp), a
;	spiexplore.c: 325: uart_putchar(ch);
	ld	a, (0x01, sp)
	push	a
	call	_uart_putchar
	pop	a
;	spiexplore.c: 326: if (ch== '1') { isp_setrst(); } else { isp_clrrst(); }
	ld	a, (0x01, sp)
	cp	a, #0x31
	jrne	00114$
	call	_isp_setrst
	jra	00115$
00114$:
	call	_isp_clrrst
00115$:
;	spiexplore.c: 327: crlf();
	call	_crlf
;	spiexplore.c: 328: break;
	jra	00119$
;	spiexplore.c: 331: default :
00116$:
;	spiexplore.c: 333: uart_putchar(ch);
	ld	a, (0x01, sp)
	push	a
	call	_uart_putchar
	pop	a
;	spiexplore.c: 334: uart_prints("\n\runkown command\n\r");
	ldw	x, (0x1d, sp)
	pushw	x
	call	_uart_putstring
	popw	x
;	spiexplore.c: 337: }
00119$:
;	spiexplore.c: 338: }while(ch != 15);
	ld	a, (0x01, sp)
	cp	a, #0x0f
	jreq	00192$
	jp	00118$
00192$:
	addw	sp, #40
	ret
;	spiexplore.c: 349: int main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	spiexplore.c: 355: sysclock_init(0);
	push	#0x00
	call	_sysclock_init
	pop	a
;	spiexplore.c: 356: uart_init(baudrate);
	push	#0x00
	push	#0x4b
	call	_uart_init
	popw	x
;	spiexplore.c: 357: isp_reset_init();             // Ausgangspin der MCU wird zum Resetpin des Targets
	ldw	x, #0x500c
	ld	a, (x)
	or	a, #0x08
	ld	(x), a
	ldw	x, #0x500d
	ld	a, (x)
	or	a, #0x08
	ld	(x), a
	ldw	x, #0x500e
	ld	a, (x)
	and	a, #0xf7
	ld	(x), a
;	spiexplore.c: 358: spi_init(1,0,0);              // Taktteiler / 2 = 4MHz, keine Taktinvertierung, Phase = 0
	push	#0x00
	push	#0x00
	push	#0x01
	call	_spi_init
	addw	sp, #3
;	spiexplore.c: 360: uart_prints("\n\rSPI-Explorer 0.01\n\r");
	ldw	x, #___str_9+0
	pushw	x
	call	_uart_putstring
	popw	x
;	spiexplore.c: 361: crlf();
	call	_crlf
;	spiexplore.c: 363: clkinv= 0;
	clr	_clkinv+0
;	spiexplore.c: 365: while(1)
00102$:
;	spiexplore.c: 367: cmdinterpret();
	call	_cmdinterpret
	jra	00102$
	ret
	.area CODE
_cmds:
	.ascii "rinv"
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.ascii "send"
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.ascii "read"
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.ascii "cmd4"
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.ascii "clkinv"
	.db 0x00
	.db 0x00
	.db 0x00
	.ascii "reset"
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
___str_0:
	.ascii "actual mode is: "
	.db 0x00
___str_1:
	.ascii "invert "
	.db 0x00
___str_2:
	.ascii "not invert "
	.db 0x00
___str_3:
	.ascii "Enter 4 instruction bytes: "
	.db 0x00
___str_4:
	.ascii "SPI:> "
	.db 0x00
___str_5:
	.ascii "[0/1]: "
	.db 0x00
___str_6:
	.ascii "byte to send: "
	.db 0x00
___str_7:
	.ascii "readed byte: "
	.db 0x00
___str_8:
	.db 0x0A
	.db 0x0D
	.ascii "unkown command"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_9:
	.db 0x0A
	.db 0x0D
	.ascii "SPI-Explorer 0.01"
	.db 0x0A
	.db 0x0D
	.db 0x00
	.area INITIALIZER
__xinit__rinv:
	.db #0x00	;  0
__xinit__clkinv:
	.db #0x00	;  0
	.area CABS (ABS)
