;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Aug 12 2015) (Linux)
; This file was generated Tue May  2 02:51:07 2017
;--------------------------------------------------------
	.module tbasic
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _pinmap
	.globl _i_nsb
	.globl _i_nsa
	.globl _main
	.globl _basic
	.globl _error
	.globl _icom
	.globl _inew
	.globl _ilist
	.globl _irun
	.globl _iexe
	.globl _ilet
	.globl _iarray
	.globl _ivar
	.globl _iinput
	.globl _iprint
	.globl _iplus
	.globl _imul
	.globl _ivalue
	.globl _ioutput
	.globl _iioin
	.globl _io_set
	.globl _io_outputinit
	.globl _io_bitset
	.globl _io_inputinit
	.globl _getparam
	.globl _putlist
	.globl _inslist
	.globl _getsize
	.globl _getlp
	.globl _getlineno
	.globl _toktoi
	.globl _getnum
	.globl _putnum
	.globl _uart_getstring
	.globl _uart_readkey
	.globl _c_isalpha
	.globl _c_isdigit
	.globl _c_isspace
	.globl _c_isprint
	.globl _c_toupper
	.globl _loadprog
	.globl _saveprog
	.globl _eeprom_read
	.globl _eeprom_write
	.globl _eeprom_unlock
	.globl _getrnd
	.globl _newline
	.globl _uart_init
	.globl _uart_ischar
	.globl _uart_getchar
	.globl _uart_putstring
	.globl _uart_putchar
	.globl _sysclock_init
	.globl _delay_ms
	.globl _sstyle
	.globl _strcpy
	.globl _rand
	.globl _portddr
	.globl _errmsg
	.globl _kwtbl
	.globl _err
	.globl _lstki
	.globl _lstk
	.globl _gstki
	.globl _gstk
	.globl _cip
	.globl _clp
	.globl _listbuf
	.globl _arr
	.globl _var
	.globl _ibuf
	.globl _lbuf
	.globl _iexp
	.globl _sysfunc
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
_lbuf::
	.ds 50
_ibuf::
	.ds 50
_var::
	.ds 52
_arr::
	.ds 64
_listbuf::
	.ds 512
_clp::
	.ds 2
_cip::
	.ds 2
_gstk::
	.ds 12
_gstki::
	.ds 1
_lstk::
	.ds 30
_lstki::
	.ds 1
_err::
	.ds 1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
_kwtbl::
	.ds 78
_errmsg::
	.ds 50
_portddr::
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
;	tbasic.c: 222: char sstyle(uint8_t code, const uint8_t *table, uint8_t count)
;	-----------------------------------------
;	 function sstyle
;	-----------------------------------------
_sstyle:
	pushw	x
;	tbasic.c: 224: while (count--)
	ld	a, (0x08, sp)
	ld	(0x02, sp), a
00103$:
	ld	a, (0x02, sp)
	dec	(0x02, sp)
	tnz	a
	jreq	00105$
;	tbasic.c: 225: if (code == table[count])
	clrw	x
	ld	a, (0x02, sp)
	ld	xl, a
	addw	x, (0x06, sp)
	ld	a, (x)
	ld	(0x01, sp), a
	ld	a, (0x05, sp)
	cp	a, (0x01, sp)
	jrne	00103$
;	tbasic.c: 226: return 1;
	ld	a, #0x01
;	tbasic.c: 227: return 0;
	.byte 0x21
00105$:
	clr	a
00106$:
	popw	x
	ret
;	tbasic.c: 239: void delay_ms(uint16_t cnt)
;	-----------------------------------------
;	 function delay_ms
;	-----------------------------------------
_delay_ms:
	pushw	x
;	tbasic.c: 243: while (cnt)
	ldw	y, (0x05, sp)
00104$:
	tnzw	y
	jreq	00107$
;	tbasic.c: 245: cnt2= 1435;
	ldw	x, #0x059b
	ldw	(0x01, sp), x
;	tbasic.c: 246: while(cnt2)
00101$:
	ldw	x, (0x01, sp)
	jreq	00103$
;	tbasic.c: 248: cnt2--;
	ldw	x, (0x01, sp)
	decw	x
	ldw	(0x01, sp), x
	jra	00101$
00103$:
;	tbasic.c: 250: cnt--;
	decw	y
	jra	00104$
00107$:
	popw	x
	ret
;	tbasic.c: 262: void sysclock_init(void)
;	-----------------------------------------
;	 function sysclock_init
;	-----------------------------------------
_sysclock_init:
;	tbasic.c: 264: CLK_ICKR = 0;                                  //  Reset Register interner clock
	mov	0x50c0+0, #0x00
;	tbasic.c: 265: CLK_ECKR = 0;                                  //  Reset Register externer clock (ext. clock disable)
	mov	0x50c1+0, #0x00
;	tbasic.c: 267: CLK_ICKR =  HSIEN;                             //  Interner clock enable
	mov	0x50c0+0, #0x01
;	tbasic.c: 268: while ((CLK_ICKR & (HSIRDY)) == 0);            //  warten bis int. Takt eingeschwungen ist
00101$:
	ldw	x, #0x50c0
	ld	a, (x)
	bcp	a, #0x02
	jreq	00101$
;	tbasic.c: 271: CLK_CKDIVR = 0;                                //  Taktteiler auf volle Geschwindigkeit
	mov	0x50c6+0, #0x00
;	tbasic.c: 272: CLK_PCKENR1 = 0xff;                            //  alle Peripherietakte an
	mov	0x50c7+0, #0xff
;	tbasic.c: 273: CLK_PCKENR2 = 0xff;                            //  dto.
	mov	0x50ca+0, #0xff
;	tbasic.c: 275: CLK_CCOR = 0;                                  //  CCO aus
	mov	0x50c9+0, #0x00
;	tbasic.c: 276: CLK_HSITRIMR = 0;                              //  keine Taktjustierung
	mov	0x50cc+0, #0x00
;	tbasic.c: 277: CLK_SWIMCCR = 0;                               //  SWIM = clock / 2.
	mov	0x50cd+0, #0x00
;	tbasic.c: 278: CLK_SWR = 0xe1;                                //  int. Generator als Taktquelle
	mov	0x50c4+0, #0xe1
;	tbasic.c: 279: CLK_SWCR = 0;                                  //  Reset clock switch control register.
	mov	0x50c5+0, #0x00
;	tbasic.c: 280: CLK_SWCR = SWEN;                               //  Enable switching.
	mov	0x50c5+0, #0x02
;	tbasic.c: 281: while ((CLK_SWCR &  SWBSY) != 0);              //  warten bis Peripherietakt stabil
00104$:
	ldw	x, #0x50c5
	ld	a, (x)
	bcp	a, #0x08
	jrne	00104$
;	tbasic.c: 283: delay_ms(50);
	push	#0x32
	push	#0x00
	call	_delay_ms
	popw	x
	ret
;	tbasic.c: 287: void uart_putchar(char ch)
;	-----------------------------------------
;	 function uart_putchar
;	-----------------------------------------
_uart_putchar:
;	tbasic.c: 289: while(!(USART1_SR & USART_SR_TXE));   // warten bis letztes Zeichen gesendet ist
00101$:
	ldw	x, #0x5230
	ld	a, (x)
	tnz	a
	jrpl	00101$
;	tbasic.c: 290: USART1_DR = ch;                       // Zeichen senden
	ldw	x, #0x5231
	ld	a, (0x03, sp)
	ld	(x), a
	ret
;	tbasic.c: 293: void uart_putstring(char *p)
;	-----------------------------------------
;	 function uart_putstring
;	-----------------------------------------
_uart_putstring:
;	tbasic.c: 295: do
	ldw	x, (0x03, sp)
00101$:
;	tbasic.c: 297: uart_putchar( *p );
	ld	a, (x)
	pushw	x
	push	a
	call	_uart_putchar
	pop	a
	popw	x
;	tbasic.c: 298: } while( *p++);
	ld	a, (x)
	incw	x
	tnz	a
	jrne	00101$
	ret
;	tbasic.c: 306: char uart_getchar(void)
;	-----------------------------------------
;	 function uart_getchar
;	-----------------------------------------
_uart_getchar:
;	tbasic.c: 308: while(!(USART1_SR & USART_SR_RXNE));    // solange warten bis ein Zeichen eingetroffen ist
00101$:
	ldw	x, #0x5230
	ld	a, (x)
	bcp	a, #0x20
	jreq	00101$
;	tbasic.c: 309: return USART1_DR;
	ldw	x, #0x5231
	ld	a, (x)
	ret
;	tbasic.c: 318: char uart_ischar(void)
;	-----------------------------------------
;	 function uart_ischar
;	-----------------------------------------
_uart_ischar:
;	tbasic.c: 320: return (USART1_SR & USART_SR_RXNE);
	ldw	x, #0x5230
	ld	a, (x)
	and	a, #0x20
	ret
;	tbasic.c: 331: void uart_init(void)
;	-----------------------------------------
;	 function uart_init
;	-----------------------------------------
_uart_init:
;	tbasic.c: 333: USART1_CR2 |= USART_CR2_TEN;                          // TxD enabled
	ldw	x, #0x5235
	ld	a, (x)
	or	a, #0x08
	ld	(x), a
;	tbasic.c: 334: USART1_CR2 |= USART_CR2_REN;                          // RxD enable
	ldw	x, #0x5235
	ld	a, (x)
	or	a, #0x04
	ld	(x), a
;	tbasic.c: 335: USART1_CR3 &= ~(USART_CR3_STOP1);                     // Stopbit
	ldw	x, #0x5236
	ld	a, (x)
	and	a, #0xef
	ld	(x), a
;	tbasic.c: 350: USART1_BRR1 = 0x11;
	mov	0x5232+0, #0x11
;	tbasic.c: 351: USART1_BRR2 = 0x06;
	mov	0x5233+0, #0x06
	ret
;	tbasic.c: 355: void newline(void)
;	-----------------------------------------
;	 function newline
;	-----------------------------------------
_newline:
;	tbasic.c: 357: uart_putchar(0x0d);
	push	#0x0d
	call	_uart_putchar
	pop	a
;	tbasic.c: 358: uart_putchar(0x0a);
	push	#0x0a
	call	_uart_putchar
	pop	a
	ret
;	tbasic.c: 362: int16_t getrnd(int16_t value)
;	-----------------------------------------
;	 function getrnd
;	-----------------------------------------
_getrnd:
;	tbasic.c: 364: return (rand() % value) + 1;
	call	_rand
	ldw	y, (0x03, sp)
	pushw	y
	pushw	x
	call	__modsint
	addw	sp, #4
	incw	x
	ret
;	tbasic.c: 368: void eeprom_unlock(void)
;	-----------------------------------------
;	 function eeprom_unlock
;	-----------------------------------------
_eeprom_unlock:
;	tbasic.c: 370: if (!(FLASH_IAPSR & FLASH_IAPSR_DUL))
	ldw	x, #0x505f
	ld	a, (x)
	bcp	a, #0x08
	jrne	00102$
;	tbasic.c: 371: FLASH_DUKR= 0xae;
	mov	0x5064+0, #0xae
00102$:
;	tbasic.c: 372: FLASH_DUKR= 0x56;
	mov	0x5064+0, #0x56
	ret
;	tbasic.c: 383: uint8_t eeprom_write(uint16_t addr, uint8_t value)
;	-----------------------------------------
;	 function eeprom_write
;	-----------------------------------------
_eeprom_write:
;	tbasic.c: 385: uint8_t *address = (char *) EEPROM_BASE_ADDR + addr;
	ldw	y, (0x03, sp)
	addw	y, #0x4000
;	tbasic.c: 387: if (addr > 0x027f) return 0;                  // 0x27f = 639 = hoechste verfuegbare
	ldw	x, (0x03, sp)
	cpw	x, #0x027f
	jrule	00102$
	clr	a
	jra	00103$
00102$:
;	tbasic.c: 389: *address = (uint8_t) value;
	ld	a, (0x05, sp)
	ld	(y), a
;	tbasic.c: 390: return 1;
	ld	a, #0x01
00103$:
	ret
;	tbasic.c: 399: uint8_t eeprom_read(uint16_t addr)
;	-----------------------------------------
;	 function eeprom_read
;	-----------------------------------------
_eeprom_read:
;	tbasic.c: 402: uint8_t *address = (char *) EEPROM_BASE_ADDR + addr;
	ldw	y, (0x03, sp)
	addw	y, #0x4000
;	tbasic.c: 404: if (addr > 0x027f) return 0xff;               // 0x27f = 639 = hoechste verfuegbare
	ldw	x, (0x03, sp)
	cpw	x, #0x027f
	jrule	00102$
	ld	a, #0xff
	jra	00103$
00102$:
;	tbasic.c: 406: value= *address;
	ld	a, (y)
;	tbasic.c: 407: return value;
00103$:
	ret
;	tbasic.c: 411: void saveprog(void)
;	-----------------------------------------
;	 function saveprog
;	-----------------------------------------
_saveprog:
	pushw	x
;	tbasic.c: 415: eeprom_unlock();
	call	_eeprom_unlock
;	tbasic.c: 417: for (adr= 0; adr< SIZE_LIST; adr++)
	ldw	x, #_listbuf+0
	ldw	(0x01, sp), x
	clrw	x
00102$:
;	tbasic.c: 419: eeprom_write(adr, listbuf[adr]);
	exg	a, yl
	ld	a, xl
	exg	a, yl
	rlwa	y
	ld	a, xh
	rrwa	y
	addw	y, (0x01, sp)
	ld	a, (y)
	pushw	x
	push	a
	pushw	x
	call	_eeprom_write
	addw	sp, #3
	popw	x
;	tbasic.c: 417: for (adr= 0; adr< SIZE_LIST; adr++)
	incw	x
	cpw	x, #0x0200
	jrc	00102$
;	tbasic.c: 421: eeprom_lock();
	ldw	x, #0x505f
	ld	a, (x)
	and	a, #0xf7
	ld	(x), a
;	tbasic.c: 422: uart_putstring("\n\rDone...");
	ldw	x, #___str_0+0
	pushw	x
	call	_uart_putstring
	addw	sp, #4
	ret
;	tbasic.c: 425: void loadprog(void)
;	-----------------------------------------
;	 function loadprog
;	-----------------------------------------
_loadprog:
	sub	sp, #4
;	tbasic.c: 429: eeprom_unlock();
	call	_eeprom_unlock
;	tbasic.c: 431: for (adr= 0; adr< SIZE_LIST; adr++)
	ldw	x, #_listbuf+0
	ldw	(0x01, sp), x
	clrw	x
00102$:
;	tbasic.c: 433: listbuf[adr]= eeprom_read(adr);
	ld	a, xl
	add	a, (0x02, sp)
	ld	(0x04, sp), a
	ld	a, xh
	adc	a, (0x01, sp)
	ld	(0x03, sp), a
	pushw	x
	pushw	x
	call	_eeprom_read
	popw	x
	popw	x
	ldw	y, (0x03, sp)
	ld	(y), a
;	tbasic.c: 431: for (adr= 0; adr< SIZE_LIST; adr++)
	incw	x
	cpw	x, #0x0200
	jrc	00102$
;	tbasic.c: 435: eeprom_lock();
	ldw	x, #0x505f
	ld	a, (x)
	and	a, #0xf7
	ld	(x), a
;	tbasic.c: 436: uart_putstring("\n\rLoading done...");
	ldw	x, #___str_1+0
	pushw	x
	call	_uart_putstring
	addw	sp, #6
	ret
;	tbasic.c: 439: char c_toupper(char c)
;	-----------------------------------------
;	 function c_toupper
;	-----------------------------------------
_c_toupper:
;	tbasic.c: 442: return(c <= 'z' && c >= 'a' ? c - 32 : c);
	ld	a, (0x03, sp)
	cp	a, #0x7a
	jrsgt	00103$
	ld	a, (0x03, sp)
	cp	a, #0x61
	jrslt	00103$
	ld	a, (0x03, sp)
	sub	a, #0x20
	jra	00104$
00103$:
	ld	a, (0x03, sp)
00104$:
	ret
;	tbasic.c: 445: char c_isprint(char c)
;	-----------------------------------------
;	 function c_isprint
;	-----------------------------------------
_c_isprint:
;	tbasic.c: 447: return(c >= 32 && c <= 126);
	ld	a, (0x03, sp)
	cp	a, #0x20
	jrslt	00103$
	ld	a, (0x03, sp)
	cp	a, #0x7e
	jrsle	00104$
00103$:
	clr	a
	jra	00105$
00104$:
	ld	a, #0x01
00105$:
	ret
;	tbasic.c: 450: char c_isspace(char c)
;	-----------------------------------------
;	 function c_isspace
;	-----------------------------------------
_c_isspace:
;	tbasic.c: 452: return(c == ' ' || (c <= 13 && c >= 9));
	ld	a, (0x03, sp)
	cp	a, #0x20
	jreq	00104$
	ld	a, (0x03, sp)
	cp	a, #0x0d
	jrsgt	00103$
	ld	a, (0x03, sp)
	cp	a, #0x09
	jrsge	00104$
00103$:
	clr	a
	jra	00105$
00104$:
	ld	a, #0x01
00105$:
	ret
;	tbasic.c: 455: char c_isdigit(char c)
;	-----------------------------------------
;	 function c_isdigit
;	-----------------------------------------
_c_isdigit:
;	tbasic.c: 457: return(c <= '9' && c >= '0');
	ld	a, (0x03, sp)
	cp	a, #0x39
	jrsgt	00103$
	ld	a, (0x03, sp)
	cp	a, #0x30
	jrsge	00104$
00103$:
	clr	a
	jra	00105$
00104$:
	ld	a, #0x01
00105$:
	ret
;	tbasic.c: 460: char c_isalpha(char c)
;	-----------------------------------------
;	 function c_isalpha
;	-----------------------------------------
_c_isalpha:
;	tbasic.c: 462: return ((c <= 'z' && c >= 'a') || (c <= 'Z' && c >= 'A'));
	ld	a, (0x03, sp)
	cp	a, #0x7a
	jrsgt	00108$
	ld	a, (0x03, sp)
	cp	a, #0x61
	jrsge	00104$
00108$:
	ld	a, (0x03, sp)
	cp	a, #0x5a
	jrsgt	00103$
	ld	a, (0x03, sp)
	cp	a, #0x41
	jrsge	00104$
00103$:
	clr	a
	jra	00105$
00104$:
	ld	a, #0x01
00105$:
	ret
;	tbasic.c: 465: char uart_readkey()
;	-----------------------------------------
;	 function uart_readkey
;	-----------------------------------------
_uart_readkey:
;	tbasic.c: 469: c= uart_getchar();
	call	_uart_getchar
;	tbasic.c: 470: if (c== return_alt) return return_key;
	cp	a, #0x0a
	jrne	00102$
	ld	a, #0x0d
;	tbasic.c: 471: return c;
00102$:
	ret
;	tbasic.c: 481: void uart_getstring(void)
;	-----------------------------------------
;	 function uart_getstring
;	-----------------------------------------
_uart_getstring:
	sub	sp, #5
;	tbasic.c: 486: len = 0;
	clr	(0x02, sp)
;	tbasic.c: 487: while  ((c = uart_readkey()) != return_key)
	ldw	x, #_lbuf+0
	ldw	(0x04, sp), x
00111$:
	call	_uart_readkey
	ld	(0x01, sp), a
	cp	a, #0x0d
	jreq	00113$
;	tbasic.c: 489: if (c == 9) c = ' ';                                // TAB durch Leerzeichen ersetzen
	ld	a, (0x01, sp)
	cp	a, #0x09
	jrne	00102$
	ld	a, #0x20
	ld	(0x01, sp), a
00102$:
;	tbasic.c: 490: if (((c == 8) || (c == 127)) && (len > 0))          // letztes Zeichen loeschen
	ld	a, (0x01, sp)
	cp	a, #0x08
	jreq	00110$
	ld	a, (0x01, sp)
	cp	a, #0x7f
	jrne	00107$
00110$:
	tnz	(0x02, sp)
	jreq	00107$
;	tbasic.c: 492: len--;
	dec	(0x02, sp)
;	tbasic.c: 493: uart_putchar(8);
	push	#0x08
	call	_uart_putchar
	pop	a
;	tbasic.c: 494: uart_putchar(' ');
	push	#0x20
	call	_uart_putchar
	pop	a
;	tbasic.c: 495: uart_putchar(8);
	push	#0x08
	call	_uart_putchar
	pop	a
	jra	00111$
00107$:
;	tbasic.c: 499: if (c_isprint(c) && (len < (SIZE_LINE - 1)))
	ld	a, (0x01, sp)
	push	a
	call	_c_isprint
	addw	sp, #1
	tnz	a
	jreq	00111$
	ld	a, (0x02, sp)
	cp	a, #0x31
	jrnc	00111$
;	tbasic.c: 501: lbuf[len++] = c;
	ld	a, (0x02, sp)
	ld	xl, a
	inc	(0x02, sp)
	clr	a
	ld	xh, a
	addw	x, (0x04, sp)
	ld	a, (0x01, sp)
	ld	(x), a
;	tbasic.c: 502: uart_putchar(c);
	ld	a, (0x01, sp)
	push	a
	call	_uart_putchar
	pop	a
	jra	00111$
00113$:
;	tbasic.c: 506: newline();
	call	_newline
;	tbasic.c: 507: lbuf[len] = 0;
	clrw	x
	ld	a, (0x02, sp)
	ld	xl, a
	addw	x, (0x04, sp)
	clr	(x)
;	tbasic.c: 508: if (len > 0)
	tnz	(0x02, sp)
	jreq	00119$
;	tbasic.c: 510: while (c_isspace(lbuf[--len]));                    // Leerzeichen uebergehen
	ld	a, (0x02, sp)
	ld	(0x03, sp), a
00114$:
	dec	(0x03, sp)
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	addw	x, (0x04, sp)
	ld	a, (x)
	push	a
	call	_c_isspace
	addw	sp, #1
	tnz	a
	jrne	00114$
;	tbasic.c: 511: lbuf[++len] = 0;
	ld	a, (0x03, sp)
	inc	a
	clrw	x
	ld	xl, a
	addw	x, (0x04, sp)
	clr	(x)
00119$:
	addw	sp, #5
	ret
;	tbasic.c: 515: void putnum(int16_t value, int16_t d)
;	-----------------------------------------
;	 function putnum
;	-----------------------------------------
_putnum:
	sub	sp, #10
;	tbasic.c: 520: if (value < 0)
	tnz	(0x0d, sp)
	jrpl	00102$
;	tbasic.c: 522: sign = 1;
	ld	a, #0x01
	ld	(0x01, sp), a
;	tbasic.c: 523: value = -value;
	ldw	x, (0x0d, sp)
	negw	x
	ldw	(0x0d, sp), x
	jra	00103$
00102$:
;	tbasic.c: 527: sign = 0;
	clr	(0x01, sp)
00103$:
;	tbasic.c: 530: lbuf[6] = 0;
	ldw	x, #_lbuf+0
	ldw	(0x07, sp), x
	ldw	x, (0x07, sp)
	addw	x, #0x0006
	clr	(x)
;	tbasic.c: 532: do
	ld	a, #0x06
	ld	(0x02, sp), a
00104$:
;	tbasic.c: 534: lbuf[--dig] = (value % 10) + '0';
	dec	(0x02, sp)
	clrw	x
	ld	a, (0x02, sp)
	ld	xl, a
	addw	x, (0x07, sp)
	ldw	(0x05, sp), x
	push	#0x0a
	push	#0x00
	ldw	x, (0x0f, sp)
	pushw	x
	call	__modsint
	addw	sp, #4
	ld	a, xl
	add	a, #0x30
	ldw	x, (0x05, sp)
	ld	(x), a
;	tbasic.c: 535: value /= 10;
	push	#0x0a
	push	#0x00
	ldw	x, (0x0f, sp)
	pushw	x
	call	__divsint
	addw	sp, #4
	ldw	(0x0d, sp), x
;	tbasic.c: 536: }while (value > 0);
	ldw	x, (0x0d, sp)
	cpw	x, #0x0000
	jrsgt	00104$
;	tbasic.c: 538: if (sign) lbuf[--dig] = '-';
	ld	a, (0x02, sp)
	tnz	(0x01, sp)
	jreq	00119$
	ld	a, (0x02, sp)
	dec	a
	clrw	x
	ld	xl, a
	addw	x, (0x07, sp)
	push	a
	ld	a, #0x2d
	ld	(x), a
	pop	a
;	tbasic.c: 540: while (6 - dig < d)
00119$:
	ldw	y, (0x0f, sp)
	ldw	(0x03, sp), y
00109$:
	ld	(0x0a, sp), a
	clr	(0x09, sp)
	ldw	x, #0x0006
	subw	x, (0x09, sp)
	cpw	x, (0x03, sp)
	jrsge	00111$
;	tbasic.c: 542: uart_putchar(' ');
	push	a
	push	#0x20
	call	_uart_putchar
	pop	a
	pop	a
;	tbasic.c: 543: d--;
	ldw	x, (0x03, sp)
	decw	x
	ldw	(0x03, sp), x
	jra	00109$
00111$:
;	tbasic.c: 545: uart_putstring(&lbuf[dig]);
	clrw	x
	ld	xl, a
	addw	x, (0x07, sp)
	pushw	x
	call	_uart_putstring
	addw	sp, #12
	ret
;	tbasic.c: 548: int16_t getnum(void)
;	-----------------------------------------
;	 function getnum
;	-----------------------------------------
_getnum:
	sub	sp, #13
;	tbasic.c: 555: len = 0;
	clr	(0x09, sp)
;	tbasic.c: 556: while ((c = uart_readkey()) != return_key)
	ldw	x, #_lbuf+0
	ldw	(0x07, sp), x
00112$:
	call	_uart_readkey
	ld	(0x06, sp), a
	cp	a, #0x0d
	jreq	00114$
;	tbasic.c: 558: if (((c == 8) || (c == 127)) && (len > 0))               // Del-Taste
	ld	a, (0x06, sp)
	cp	a, #0x08
	jreq	00111$
	ld	a, (0x06, sp)
	cp	a, #0x7f
	jrne	00108$
00111$:
	tnz	(0x09, sp)
	jreq	00108$
;	tbasic.c: 560: len--;
	dec	(0x09, sp)
;	tbasic.c: 561: uart_putchar(8);
	push	#0x08
	call	_uart_putchar
	pop	a
;	tbasic.c: 562: uart_putchar(' ');
	push	#0x20
	call	_uart_putchar
	pop	a
;	tbasic.c: 563: uart_putchar(8);
	push	#0x08
	call	_uart_putchar
	pop	a
	jra	00112$
00108$:
;	tbasic.c: 567: if ((len == 0 && (c == '+' || c == '-')) || (len < 6 && c_isdigit(c)))
	tnz	(0x09, sp)
	jrne	00106$
	ld	a, (0x06, sp)
	cp	a, #0x2b
	jreq	00101$
	ld	a, (0x06, sp)
	cp	a, #0x2d
	jreq	00101$
00106$:
	ld	a, (0x09, sp)
	cp	a, #0x06
	jrnc	00112$
	ld	a, (0x06, sp)
	push	a
	call	_c_isdigit
	addw	sp, #1
	tnz	a
	jreq	00112$
00101$:
;	tbasic.c: 569: lbuf[len++] = c;
	ld	a, (0x09, sp)
	ld	xl, a
	inc	(0x09, sp)
	clr	a
	ld	xh, a
	addw	x, (0x07, sp)
	ld	a, (0x06, sp)
	ld	(x), a
;	tbasic.c: 570: uart_putchar(c);
	ld	a, (0x06, sp)
	push	a
	call	_uart_putchar
	pop	a
	jra	00112$
00114$:
;	tbasic.c: 574: newline();
	call	_newline
;	tbasic.c: 575: lbuf[len] = 0;
	clrw	x
	ld	a, (0x09, sp)
	ld	xl, a
	addw	x, (0x07, sp)
	clr	(x)
;	tbasic.c: 577: switch (lbuf[0])
	ldw	x, (0x07, sp)
	ld	a, (x)
	cp	a, #0x2b
	jreq	00116$
	cp	a, #0x2d
	jrne	00117$
;	tbasic.c: 580: sign = 1;
	ld	a, #0x01
	ld	(0x05, sp), a
;	tbasic.c: 581: len = 1;
	ld	a, #0x01
;	tbasic.c: 582: break;
	jra	00118$
;	tbasic.c: 583: case '+':
00116$:
;	tbasic.c: 584: sign = 0;
	clr	(0x05, sp)
;	tbasic.c: 585: len = 1;
	ld	a, #0x01
;	tbasic.c: 586: break;
	jra	00118$
;	tbasic.c: 587: default:
00117$:
;	tbasic.c: 588: sign = 0;
	clr	(0x05, sp)
;	tbasic.c: 589: len = 0;
	clr	a
;	tbasic.c: 591: }
00118$:
;	tbasic.c: 593: value = 0;
	clrw	x
	ldw	(0x03, sp), x
;	tbasic.c: 596: while (lbuf[len])
	ld	(0x0d, sp), a
00121$:
	clrw	x
	ld	a, (0x0d, sp)
	ld	xl, a
	addw	x, (0x07, sp)
	ld	a, (x)
	ld	(0x0c, sp), a
	tnz	(0x0c, sp)
	jreq	00123$
;	tbasic.c: 598: tmp = 10 * value + lbuf[len++] - '0';
	ldw	x, (0x03, sp)
	pushw	x
	push	#0x0a
	push	#0x00
	call	__mulint
	addw	sp, #4
	ldw	(0x0a, sp), x
	ld	a, (0x0d, sp)
	inc	(0x0d, sp)
	clrw	x
	ld	xl, a
	addw	x, (0x07, sp)
	ld	a, (x)
	ld	xl, a
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	xh, a
	addw	x, (0x0a, sp)
	subw	x, #0x0030
	ldw	(0x01, sp), x
;	tbasic.c: 599: if (value > tmp)                            // Werteueberlauf
	ldw	x, (0x03, sp)
	cpw	x, (0x01, sp)
	jrsle	00120$
;	tbasic.c: 601: err = ERR_VOF;
	mov	_err+0, #0x02
00120$:
;	tbasic.c: 603: value = tmp;
	ldw	y, (0x01, sp)
	ldw	(0x03, sp), y
	jra	00121$
00123$:
;	tbasic.c: 606: if (sign) return -value;
	tnz	(0x05, sp)
	jreq	00125$
	ldw	x, (0x03, sp)
	negw	x
	jra	00126$
00125$:
;	tbasic.c: 607: return value;
	ldw	x, (0x03, sp)
00126$:
	addw	sp, #13
	ret
;	tbasic.c: 611: uint8_t toktoi()
;	-----------------------------------------
;	 function toktoi
;	-----------------------------------------
_toktoi:
	sub	sp, #52
;	tbasic.c: 616: uint8_t   len = 0;
	clr	(0x25, sp)
;	tbasic.c: 619: char      *s = lbuf;
	ldw	x, #_lbuf+0
	ldw	(0x32, sp), x
;	tbasic.c: 624: while (*s)
	ldw	x, #_kwtbl+0
	ldw	(0x0b, sp), x
	ldw	x, #_ibuf+0
	ldw	(0x1a, sp), x
00157$:
	ldw	x, (0x32, sp)
	ld	a, (x)
	ld	(0x26, sp), a
	tnz	(0x26, sp)
	jrne	00324$
	jp	00159$
00324$:
;	tbasic.c: 626: while (c_isspace(*s)) s++;                // Leerzeichen ueberlesen
	ldw	x, (0x32, sp)
00101$:
	ld	a, (x)
	pushw	x
	push	a
	call	_c_isspace
	addw	sp, #1
	popw	x
	tnz	a
	jreq	00206$
	incw	x
	jra	00101$
00206$:
	ldw	(0x32, sp), x
;	tbasic.c: 629: for (i = 0; i < SIZE_KWTBL; i++)
	clr	(0x20, sp)
	clr	(0x07, sp)
00160$:
;	tbasic.c: 631: pkw = (char *)kwtbl[i];                  // Schluesselworttabelle
	clrw	x
	ld	a, (0x07, sp)
	ld	xl, a
	sllw	x
	addw	x, (0x0b, sp)
	ldw	x, (x)
;	tbasic.c: 635: while ((*pkw != 0) && (*pkw == c_toupper(*ptok)))
	ldw	(0x15, sp), x
	ldw	y, (0x32, sp)
	ldw	(0x09, sp), y
00105$:
	ldw	x, (0x15, sp)
	ld	a, (x)
	ld	(0x1f, sp), a
	tnz	(0x1f, sp)
	jreq	00207$
	ldw	x, (0x09, sp)
	ld	a, (x)
	push	a
	call	_c_toupper
	addw	sp, #1
	ld	(0x27, sp), a
	ld	a, (0x1f, sp)
	cp	a, (0x27, sp)
	jrne	00207$
;	tbasic.c: 637: pkw++;
	ldw	x, (0x15, sp)
	incw	x
	ldw	(0x15, sp), x
;	tbasic.c: 638: ptok++;
	ldw	x, (0x09, sp)
	incw	x
	ldw	(0x09, sp), x
	jra	00105$
00207$:
	ldw	y, (0x15, sp)
	ldw	(0x01, sp), y
;	tbasic.c: 641: if (*pkw == 0)                           // gefunden
	ldw	x, (0x15, sp)
	ld	a, (x)
	tnz	a
	jrne	00161$
;	tbasic.c: 643: if (len >= SIZE_IBUF - 1)
	ld	a, (0x25, sp)
	cp	a, #0x31
	jrc	00109$
;	tbasic.c: 645: err = ERR_IBUFOF;
	mov	_err+0, #0x04
;	tbasic.c: 646: return 0;
	clr	a
	jp	00169$
00109$:
;	tbasic.c: 650: ibuf[len++] = i;
	ld	a, (0x25, sp)
	ld	xl, a
	inc	(0x25, sp)
	clr	a
	ld	xh, a
	addw	x, (0x1a, sp)
	ld	a, (0x20, sp)
	ld	(x), a
;	tbasic.c: 651: s = ptok;
	ldw	y, (0x09, sp)
	ldw	(0x32, sp), y
;	tbasic.c: 652: break;
	jra	00112$
00161$:
;	tbasic.c: 629: for (i = 0; i < SIZE_KWTBL; i++)
	inc	(0x07, sp)
	ld	a, (0x07, sp)
	ld	(0x20, sp), a
	ld	a, (0x07, sp)
	cp	a, #0x27
	jrc	00160$
00112$:
;	tbasic.c: 650: ibuf[len++] = i;
	ld	a, (0x25, sp)
	inc	a
	ld	(0x2e, sp), a
;	tbasic.c: 662: if (len >= SIZE_IBUF - 2 - i)
	ld	a, (0x25, sp)
	ld	(0x0e, sp), a
	clr	(0x0d, sp)
;	tbasic.c: 657: if (i == I_REM)
	ld	a, (0x20, sp)
	cp	a, #0x08
	jrne	00123$
;	tbasic.c: 659: while (c_isspace(*s)) s++;               // Leerzeichen
	ldw	x, (0x32, sp)
00113$:
	ld	a, (x)
	pushw	x
	push	a
	call	_c_isspace
	addw	sp, #1
	popw	x
	tnz	a
	jreq	00208$
	incw	x
	jra	00113$
00208$:
	ldw	(0x2a, sp), x
;	tbasic.c: 661: for (i = 0; *ptok++; i++);               // Laenge ermitteln
	clr	(0x07, sp)
00163$:
	ld	a, (x)
	ld	(0x24, sp), a
	incw	x
	tnz	(0x24, sp)
	jreq	00116$
	inc	(0x07, sp)
	jra	00163$
00116$:
;	tbasic.c: 662: if (len >= SIZE_IBUF - 2 - i)
	ld	a, (0x07, sp)
	ld	(0x10, sp), a
	clr	(0x0f, sp)
	ld	a, #0x30
	sub	a, (0x10, sp)
	ld	(0x19, sp), a
	clr	a
	sbc	a, (0x0f, sp)
	ld	(0x18, sp), a
	ldw	x, (0x0d, sp)
	cpw	x, (0x18, sp)
	jrslt	00118$
;	tbasic.c: 664: err = ERR_IBUFOF;
	mov	_err+0, #0x04
;	tbasic.c: 665: return 0;
	clr	a
	jp	00169$
00118$:
;	tbasic.c: 667: ibuf[len++] = i;                         // Laenge setzen
	ld	a, (0x25, sp)
	exg	a, yl
	ld	a, (0x2e, sp)
	exg	a, yl
	clrw	x
	ld	xl, a
	addw	x, (0x1a, sp)
	ld	a, (0x07, sp)
	ld	(x), a
;	tbasic.c: 668: while (i--)                              // String kopieren
	exg	a, yl
	ld	(0x34, sp), a
	exg	a, yl
	ldw	y, (0x2a, sp)
00119$:
	ld	a, (0x07, sp)
	dec	(0x07, sp)
	tnz	a
	jrne	00339$
	jp	00210$
00339$:
;	tbasic.c: 670: ibuf[len++] = *s++;
	ld	a, (0x34, sp)
	inc	(0x34, sp)
	clrw	x
	ld	xl, a
	addw	x, (0x1a, sp)
	ld	a, (y)
	incw	y
	ld	(x), a
	jra	00119$
;	tbasic.c: 672: break;
00123$:
;	tbasic.c: 675: if (*pkw == 0) continue;
	ldw	x, (0x01, sp)
	ld	a, (x)
	tnz	a
	jrne	00340$
	jp	00157$
00340$:
;	tbasic.c: 677: ptok = s;
	ldw	y, (0x32, sp)
	ldw	(0x09, sp), y
;	tbasic.c: 680: if (c_isdigit(*ptok))
	ldw	x, (0x32, sp)
	ld	a, (x)
	push	a
	call	_c_isdigit
	addw	sp, #1
	tnz	a
	jrne	00341$
	jp	00155$
00341$:
;	tbasic.c: 682: value = 0;
	clrw	x
	ldw	(0x05, sp), x
;	tbasic.c: 684: do
	ldw	x, (0x32, sp)
00128$:
;	tbasic.c: 686: tmp = 10 * value + *ptok++ - '0';
	pushw	x
	ldw	y, (0x07, sp)
	pushw	y
	push	#0x0a
	push	#0x00
	call	__mulint
	addw	sp, #4
	ldw	(0x2e, sp), x
	popw	x
	ld	a, (x)
	ld	yl, a
	incw	x
	ld	a, yl
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	yh, a
	addw	y, (0x2c, sp)
	subw	y, #0x0030
;	tbasic.c: 687: if (value > tmp)
	exgw	x, y
	cpw	x, (0x05, sp)
	exgw	x, y
	jrsge	00127$
;	tbasic.c: 689: err = ERR_VOF;
	mov	_err+0, #0x02
;	tbasic.c: 690: return 0;
	clr	a
	jp	00169$
00127$:
;	tbasic.c: 692: value = tmp;
	ldw	(0x05, sp), y
;	tbasic.c: 693: } while (c_isdigit(*ptok));
	ld	a, (x)
	pushw	x
	push	a
	call	_c_isdigit
	addw	sp, #1
	popw	x
	tnz	a
	jrne	00128$
;	tbasic.c: 695: if (len >= SIZE_IBUF - 3)
	ld	a, (0x25, sp)
	cp	a, #0x2f
	jrc	00132$
;	tbasic.c: 697: err = ERR_IBUFOF;
	mov	_err+0, #0x04
;	tbasic.c: 698: return 0;
	clr	a
	jp	00169$
00132$:
;	tbasic.c: 700: s = ptok;
	ldw	(0x32, sp), x
;	tbasic.c: 701: ibuf[len++] = I_NUM;
	ld	a, (0x25, sp)
	ld	xl, a
	ld	a, (0x2e, sp)
	rlwa	x
	clr	a
	rrwa	x
	addw	x, (0x1a, sp)
	push	a
	ld	a, #0x27
	ld	(x), a
	pop	a
;	tbasic.c: 702: ibuf[len++] = value & 255;
	ld	xl, a
	inc	a
	ld	(0x31, sp), a
	clr	a
	ld	xh, a
	addw	x, (0x1a, sp)
	ld	a, (0x06, sp)
	push	a
	clr	(0x30, sp)
	pop	a
	ld	(x), a
;	tbasic.c: 703: ibuf[len++] = value >> 8;
	ld	a, (0x31, sp)
	ld	yl, a
	ld	a, (0x31, sp)
	inc	a
	ld	(0x25, sp), a
	clr	a
	ld	yh, a
	addw	y, (0x1a, sp)
	ldw	x, (0x05, sp)
	clr	a
	tnzw	x
	jrpl	00345$
	dec	a
00345$:
	rrwa	x
	ld	a, xl
	ld	(y), a
	jp	00157$
00155$:
;	tbasic.c: 624: while (*s)
	ldw	x, (0x32, sp)
	ld	a, (x)
	ld	(0x17, sp), a
;	tbasic.c: 709: c = *s++;
	ldw	x, (0x32, sp)
	incw	x
	ldw	(0x28, sp), x
;	tbasic.c: 707: if (*s == '\"' || *s == '\'')
	ld	a, (0x17, sp)
	cp	a, #0x22
	jreq	00150$
	ld	a, (0x17, sp)
	cp	a, #0x27
	jreq	00351$
	jp	00151$
00351$:
00150$:
;	tbasic.c: 709: c = *s++;
	ldw	y, (0x28, sp)
	ldw	(0x03, sp), y
	ld	a, (0x17, sp)
	ld	(0x08, sp), a
;	tbasic.c: 711: for (i = 0; (*ptok != c) && c_isprint(*ptok); i++) ptok++;
	ldw	y, (0x03, sp)
	ldw	(0x09, sp), y
	clr	(0x07, sp)
00167$:
	ldw	x, (0x09, sp)
	ld	a, (x)
	cp	a, (0x08, sp)
	jreq	00133$
	push	a
	call	_c_isprint
	addw	sp, #1
	tnz	a
	jreq	00133$
	ldw	x, (0x09, sp)
	incw	x
	ldw	(0x09, sp), x
	inc	(0x07, sp)
	jra	00167$
00133$:
;	tbasic.c: 713: if (len >= SIZE_IBUF - 1 - i)
	ld	a, (0x07, sp)
	ld	(0x14, sp), a
	clr	(0x13, sp)
	ld	a, #0x31
	sub	a, (0x14, sp)
	ld	(0x12, sp), a
	clr	a
	sbc	a, (0x13, sp)
	ld	(0x11, sp), a
	ldw	x, (0x0d, sp)
	cpw	x, (0x11, sp)
	jrslt	00135$
;	tbasic.c: 715: err = ERR_IBUFOF;
	mov	_err+0, #0x04
;	tbasic.c: 716: return 0;
	clr	a
	jp	00169$
00135$:
;	tbasic.c: 719: ibuf[len++] = I_STR;
	ld	a, (0x25, sp)
	ld	xl, a
	ld	a, (0x2e, sp)
	rlwa	x
	clr	a
	rrwa	x
	addw	x, (0x1a, sp)
	push	a
	ld	a, #0x29
	ld	(x), a
	pop	a
;	tbasic.c: 720: ibuf[len++] = i;
	ld	xl, a
	inc	a
	rlwa	x
	clr	a
	rrwa	x
	addw	x, (0x1a, sp)
	push	a
	ld	a, (0x08, sp)
	ld	(x), a
	pop	a
;	tbasic.c: 722: while (i--)
	ldw	y, (0x03, sp)
	ldw	(0x22, sp), y
00136$:
	push	a
	ld	a, (0x08, sp)
	ld	(0x22, sp), a
	pop	a
	dec	(0x07, sp)
;	tbasic.c: 724: ibuf[len++] = *s++;
	ldw	x, (0x22, sp)
	incw	x
	ldw	(0x1d, sp), x
	ldw	x, (0x22, sp)
	push	a
	ld	a, (x)
	ld	(0x1d, sp), a
	pop	a
;	tbasic.c: 722: while (i--)
	tnz	(0x21, sp)
	jreq	00212$
;	tbasic.c: 724: ibuf[len++] = *s++;
	ld	xl, a
	inc	a
	rlwa	x
	clr	a
	rrwa	x
	addw	x, (0x1a, sp)
	ldw	y, (0x1d, sp)
	ldw	(0x22, sp), y
	push	a
	ld	a, (0x1d, sp)
	ld	(x), a
	pop	a
	jra	00136$
00212$:
	ld	(0x25, sp), a
	ldw	y, (0x22, sp)
	ldw	(0x32, sp), y
;	tbasic.c: 726: if (*s == c) s++;
	ld	a, (0x1c, sp)
	cp	a, (0x08, sp)
	jreq	00360$
	jp	00157$
00360$:
	ldw	y, (0x1d, sp)
	ldw	(0x32, sp), y
	jp	00157$
00151$:
;	tbasic.c: 730: if (c_isalpha(*ptok))
	ld	a, (0x17, sp)
	push	a
	call	_c_isalpha
	addw	sp, #1
	tnz	a
	jreq	00148$
;	tbasic.c: 732: if (len >= SIZE_IBUF - 2)
	ld	a, (0x25, sp)
	cp	a, #0x30
	jrc	00142$
;	tbasic.c: 734: err = ERR_IBUFOF;
	mov	_err+0, #0x04
;	tbasic.c: 735: return 0;
	clr	a
	jra	00169$
00142$:
;	tbasic.c: 737: if (len >= 4 && ibuf[len - 2] == I_VAR && ibuf[len - 4] == I_VAR)
	ld	a, (0x25, sp)
	cp	a, #0x04
	jrc	00144$
	ld	a, (0x25, sp)
	sub	a, #0x02
	clrw	x
	ld	xl, a
	addw	x, (0x1a, sp)
	ld	a, (x)
	cp	a, #0x28
	jrne	00144$
	ld	a, (0x25, sp)
	sub	a, #0x04
	clrw	x
	ld	xl, a
	addw	x, (0x1a, sp)
	ld	a, (x)
	cp	a, #0x28
	jrne	00144$
;	tbasic.c: 739: err = ERR_SYNTAX;
	mov	_err+0, #0x14
;	tbasic.c: 740: return 0;
	clr	a
	jra	00169$
00144$:
;	tbasic.c: 742: ibuf[len++] = I_VAR;
	ld	a, (0x25, sp)
	ld	xl, a
	ld	a, (0x2e, sp)
	ld	(0x31, sp), a
	clr	a
	ld	xh, a
	addw	x, (0x1a, sp)
	ld	a, #0x28
	ld	(x), a
;	tbasic.c: 743: ibuf[len++] = c_toupper(*ptok) - 'A';
	ld	a, (0x31, sp)
	ld	xl, a
	ld	a, (0x31, sp)
	inc	a
	ld	(0x25, sp), a
	clr	a
	ld	xh, a
	addw	x, (0x1a, sp)
	ldw	y, (0x09, sp)
	ld	a, (y)
	pushw	x
	push	a
	call	_c_toupper
	addw	sp, #3
	sub	a, #0x41
	ld	(x), a
;	tbasic.c: 744: s++;
	ldw	y, (0x28, sp)
	ldw	(0x32, sp), y
	jp	00157$
00148$:
;	tbasic.c: 748: err = ERR_SYNTAX;
	mov	_err+0, #0x14
;	tbasic.c: 749: return 0;
	clr	a
	jra	00169$
00210$:
	ld	a, (0x34, sp)
	ld	(0x25, sp), a
00159$:
;	tbasic.c: 754: ibuf[len++] = I_EOL;
	ld	a, (0x25, sp)
	ld	xl, a
	ld	a, (0x25, sp)
	inc	a
	rlwa	x
	clr	a
	rrwa	x
	addw	x, (0x1a, sp)
	push	a
	ld	a, #0x2a
	ld	(x), a
	pop	a
;	tbasic.c: 755: return len;
00169$:
	addw	sp, #52
	ret
;	tbasic.c: 758: int16_t getlineno(uint8_t *lp)
;	-----------------------------------------
;	 function getlineno
;	-----------------------------------------
_getlineno:
	sub	sp, #6
;	tbasic.c: 760: if (*lp == 0) return 32767;                      // hoechste Zeilennummer
	ldw	y, (0x09, sp)
	ld	a, (y)
	tnz	a
	jrne	00102$
	ldw	x, #0x7fff
	jra	00103$
00102$:
;	tbasic.c: 761: return *(lp + 1) | *(lp + 2) << 8;
	ldw	x, y
	ld	a, yl
	ld	xl, a
	ld	a, (0x1, x)
	ld	xl, a
	ld	a, (0x2, y)
	clr	(0x03, sp)
	clr	(0x02, sp)
	clr	(0x05, sp)
	or	a, (0x05, sp)
	rrwa	x
	or	a, (0x02, sp)
	ld	xl, a
00103$:
	addw	sp, #6
	ret
;	tbasic.c: 764: uint8_t* getlp(int16_t lineno)
;	-----------------------------------------
;	 function getlp
;	-----------------------------------------
_getlp:
	pushw	x
;	tbasic.c: 769: for (lp = listbuf; *lp; lp += *lp)
	ldw	x, #_listbuf+0
	ldw	(0x01, sp), x
00105$:
	ldw	x, (0x01, sp)
	ld	a, (x)
	tnz	a
	jreq	00103$
;	tbasic.c: 771: if (getlineno(lp) >= lineno) break;
	ldw	x, (0x01, sp)
	pushw	x
	call	_getlineno
	addw	sp, #2
	cpw	x, (0x05, sp)
	jrsge	00103$
;	tbasic.c: 769: for (lp = listbuf; *lp; lp += *lp)
	ldw	x, (0x01, sp)
	ld	a, (x)
	clrw	x
	ld	xl, a
	addw	x, (0x01, sp)
	ldw	(0x01, sp), x
	jra	00105$
00103$:
;	tbasic.c: 773: return lp;
	ldw	x, (0x01, sp)
	addw	sp, #2
	ret
;	tbasic.c: 776: int16_t getsize(void)
;	-----------------------------------------
;	 function getsize
;	-----------------------------------------
_getsize:
	sub	sp, #6
;	tbasic.c: 781: for (lp = listbuf; *lp; lp += *lp);
	ldw	x, #_listbuf+0
	ldw	(0x05, sp), x
	ldw	y, (0x05, sp)
	ldw	(0x01, sp), y
00103$:
	ldw	x, (0x01, sp)
	ld	a, (x)
	tnz	a
	jreq	00101$
	clrw	x
	ld	xl, a
	addw	x, (0x01, sp)
	ldw	(0x01, sp), x
	jra	00103$
00101$:
;	tbasic.c: 782: return (int16_t)(listbuf + SIZE_LIST - lp - 1);
	ldw	y, (0x01, sp)
	ldw	(0x03, sp), y
	ldw	x, #0x01ff
	subw	x, (0x03, sp)
	addw	x, (0x05, sp)
	addw	sp, #6
	ret
;	tbasic.c: 785: void inslist(void)
;	-----------------------------------------
;	 function inslist
;	-----------------------------------------
_inslist:
	sub	sp, #41
;	tbasic.c: 792: if (getsize() < *ibuf)
	call	_getsize
	ldw	y, #_ibuf+0
	ldw	(0x0d, sp), y
	ldw	y, (0x0d, sp)
	ld	a, (y)
	ld	(0x12, sp), a
	clr	(0x11, sp)
	cpw	x, (0x11, sp)
	jrsge	00102$
;	tbasic.c: 794: err = ERR_LBUFOF;                       // List Speicher overflow
	mov	_err+0, #0x05
;	tbasic.c: 795: return;
	jp	00123$
00102$:
;	tbasic.c: 798: insp = getlp(getlineno(ibuf));
	ldw	x, (0x0d, sp)
	pushw	x
	call	_getlineno
	addw	sp, #2
	pushw	x
	call	_getlp
	addw	sp, #2
	ldw	(0x05, sp), x
;	tbasic.c: 800: if (getlineno(insp) == getlineno(ibuf))    // Zeilennummer
	ldw	x, (0x05, sp)
	pushw	x
	call	_getlineno
	addw	sp, #2
	ldw	y, (0x0d, sp)
	pushw	x
	pushw	y
	call	_getlineno
	addw	sp, #2
	ldw	(0x20, sp), x
	popw	x
	cpw	x, (0x1e, sp)
	jrne	00110$
;	tbasic.c: 802: p1 = insp;
	ldw	y, (0x05, sp)
	ldw	(0x28, sp), y
;	tbasic.c: 803: p2 = p1 + *p1;
	ldw	x, (0x05, sp)
	ld	a, (x)
	clrw	x
	ld	xl, a
	addw	x, (0x05, sp)
;	tbasic.c: 804: while ((len = *p2) != 0)
00106$:
	ld	a, (x)
	ld	(0x02, sp), a
	clr	(0x01, sp)
	ldw	y, (0x01, sp)
	ldw	(0x0b, sp), y
	ldw	y, (0x01, sp)
	jreq	00108$
;	tbasic.c: 806: while (len--) *p1++ = *p2++;
	ldw	(0x13, sp), x
	ldw	y, (0x28, sp)
	ldw	(0x24, sp), y
	ldw	y, (0x0b, sp)
	ldw	(0x09, sp), y
00103$:
	ldw	y, (0x09, sp)
	ldw	(0x19, sp), y
	ldw	y, (0x09, sp)
	decw	y
	ldw	(0x09, sp), y
	ldw	y, (0x19, sp)
	jreq	00106$
	ldw	x, (0x13, sp)
	ld	a, (x)
	ldw	x, (0x13, sp)
	incw	x
	ldw	(0x13, sp), x
	ldw	x, (0x13, sp)
	ldw	y, (0x24, sp)
	ld	(y), a
	ldw	y, (0x24, sp)
	incw	y
	ldw	(0x24, sp), y
	ldw	y, (0x24, sp)
	ldw	(0x28, sp), y
	jra	00103$
00108$:
;	tbasic.c: 808: *p1 = 0;
	ldw	x, (0x28, sp)
	clr	(x)
00110$:
;	tbasic.c: 811: if (*ibuf == 4) return;
	ldw	x, (0x0d, sp)
	ld	a, (x)
	ld	(0x1b, sp), a
	ld	a, (0x1b, sp)
	cp	a, #0x04
	jreq	00123$
;	tbasic.c: 814: for (p1 = insp; *p1; p1 += *p1);
	ldw	y, (0x05, sp)
	ldw	(0x03, sp), y
00121$:
	ldw	x, (0x03, sp)
	ld	a, (x)
	ld	xl, a
	tnz	a
	jreq	00113$
	clr	a
	ld	xh, a
	addw	x, (0x03, sp)
	ldw	(0x1c, sp), x
	ldw	y, (0x1c, sp)
	ldw	(0x03, sp), y
	jra	00121$
00113$:
;	tbasic.c: 815: len = p1 - insp + 1;
	ldw	x, (0x03, sp)
	subw	x, (0x05, sp)
	incw	x
	ldw	(0x0f, sp), x
;	tbasic.c: 816: p2 = p1 + *ibuf;
	clrw	x
	ld	a, (0x1b, sp)
	ld	xl, a
	addw	x, (0x03, sp)
;	tbasic.c: 817: while (len--) *p2-- = *p1--;
	ldw	y, (0x03, sp)
	ldw	(0x26, sp), y
	ldw	(0x07, sp), x
	ldw	y, (0x0f, sp)
00114$:
	ldw	(0x20, sp), y
	decw	y
	ldw	x, (0x20, sp)
	jreq	00116$
	ldw	x, (0x26, sp)
	ld	a, (x)
	ldw	x, (0x26, sp)
	decw	x
	ldw	(0x26, sp), x
	ldw	x, (0x07, sp)
	ld	(x), a
	ldw	x, (0x07, sp)
	decw	x
	ldw	(0x07, sp), x
	jra	00114$
00116$:
;	tbasic.c: 820: len = *ibuf;
	ldw	x, (0x0d, sp)
	ld	a, (x)
	clrw	x
	ld	xl, a
;	tbasic.c: 822: p2 = ibuf;
	ldw	y, (0x0d, sp)
;	tbasic.c: 823: while (len--) *p1++ = *p2++;
	ldw	(0x15, sp), y
	ldw	y, (0x05, sp)
	ldw	(0x22, sp), x
00117$:
	ldw	x, (0x22, sp)
	ldw	(0x17, sp), x
	ldw	x, (0x22, sp)
	decw	x
	ldw	(0x22, sp), x
	ldw	x, (0x17, sp)
	jreq	00123$
	ldw	x, (0x15, sp)
	ld	a, (x)
	ldw	x, (0x15, sp)
	incw	x
	ldw	(0x15, sp), x
	ld	(y), a
	incw	y
	jra	00117$
00123$:
	addw	sp, #41
	ret
;	tbasic.c: 826: void putlist(uint8_t* ip)
;	-----------------------------------------
;	 function putlist
;	-----------------------------------------
_putlist:
	sub	sp, #29
;	tbasic.c: 830: while (*ip != I_EOL)
	ldw	x, #_kwtbl+0
	ldw	(0x18, sp), x
	ldw	x, #_i_nsa+0
	ldw	(0x12, sp), x
	ldw	x, #_i_nsb+0
	ldw	(0x10, sp), x
	ldw	y, (0x10, sp)
	ldw	(0x1b, sp), y
00132$:
	ldw	y, (0x20, sp)
	ldw	(0x02, sp), y
	ldw	x, (0x02, sp)
	ld	a, (x)
	ld	(0x0a, sp), a
	ld	a, (0x0a, sp)
	cp	a, #0x2a
	jrne	00215$
	jp	00138$
00215$:
;	tbasic.c: 839: ip++;
	ldw	x, (0x02, sp)
	incw	x
	ldw	(0x04, sp), x
;	tbasic.c: 833: if (*ip < SIZE_KWTBL)
	ld	a, (0x0a, sp)
	cp	a, #0x27
	jrnc	00130$
;	tbasic.c: 835: uart_putstring(kwtbl[*ip]);
	clrw	x
	ld	a, (0x0a, sp)
	ld	xl, a
	sllw	x
	addw	x, (0x18, sp)
	ldw	x, (x)
	pushw	x
	call	_uart_putstring
	popw	x
;	tbasic.c: 836: if (!nospacea(*ip))  uart_putchar(' ');
	ldw	y, (0x12, sp)
	ldw	x, (0x02, sp)
	ld	a, (x)
	push	#0x15
	pushw	y
	push	a
	call	_sstyle
	addw	sp, #4
	tnz	a
	jrne	00102$
	push	#0x20
	call	_uart_putchar
	pop	a
00102$:
;	tbasic.c: 837: if (*ip == I_REM)
	ldw	x, (0x02, sp)
	ld	a, (x)
	cp	a, #0x08
	jrne	00107$
;	tbasic.c: 839: ip++;
	ldw	y, (0x04, sp)
	ldw	(0x20, sp), y
;	tbasic.c: 840: i = *ip++;
	ldw	x, (0x20, sp)
	ld	a, (x)
	incw	x
	ldw	(0x20, sp), x
;	tbasic.c: 841: while (i--)
	ldw	y, (0x20, sp)
	ldw	(0x0e, sp), y
	ld	(0x1a, sp), a
00103$:
	ld	a, (0x1a, sp)
	dec	(0x1a, sp)
	tnz	a
	jrne	00222$
	jp	00138$
00222$:
;	tbasic.c: 843: uart_putchar(*ip++);
	ldw	x, (0x0e, sp)
	ld	a, (x)
	ldw	x, (0x0e, sp)
	incw	x
	ldw	(0x0e, sp), x
	push	a
	call	_uart_putchar
	pop	a
;	tbasic.c: 845: return;
	jra	00103$
00107$:
;	tbasic.c: 847: ip++;
	ldw	y, (0x04, sp)
	ldw	(0x20, sp), y
	jra	00132$
00130$:
;	tbasic.c: 852: if (*ip == I_NUM)
	ld	a, (0x0a, sp)
	cp	a, #0x27
	jrne	00127$
;	tbasic.c: 854: ip++;
	ldw	y, (0x04, sp)
	ldw	(0x20, sp), y
;	tbasic.c: 855: putnum(*ip | *(ip + 1) << 8, 0);
	ldw	y, (0x20, sp)
	ldw	(0x16, sp), y
	ldw	x, (0x16, sp)
	ld	a, (x)
	ld	xl, a
	ldw	y, (0x16, sp)
	ld	a, (0x1, y)
	clr	(0x06, sp)
	clr	(0x15, sp)
	clr	(0x0c, sp)
	or	a, (0x0c, sp)
	rrwa	x
	or	a, (0x15, sp)
	ld	xl, a
	push	#0x00
	push	#0x00
	pushw	x
	call	_putnum
	addw	sp, #4
;	tbasic.c: 856: ip += 2;
	ldw	x, (0x16, sp)
	incw	x
	incw	x
	ldw	(0x20, sp), x
;	tbasic.c: 857: if (!nospaceb(*ip)) uart_putchar(' ');
	ldw	y, (0x10, sp)
	ldw	x, (0x20, sp)
	ld	a, (x)
	push	#0x0f
	pushw	y
	push	a
	call	_sstyle
	addw	sp, #4
	tnz	a
	jreq	00226$
	jp	00132$
00226$:
	push	#0x20
	call	_uart_putchar
	pop	a
	jp	00132$
00127$:
;	tbasic.c: 862: if (*ip == I_VAR)
	ld	a, (0x0a, sp)
	cp	a, #0x28
	jrne	00124$
;	tbasic.c: 864: ip++;
	ldw	y, (0x04, sp)
	ldw	(0x20, sp), y
;	tbasic.c: 865: uart_putchar(*ip++ + 'A');
	ldw	x, (0x20, sp)
	ld	a, (x)
	incw	x
	ldw	(0x20, sp), x
	add	a, #0x41
	push	a
	call	_uart_putchar
	pop	a
;	tbasic.c: 866: if (!nospaceb(*ip)) uart_putchar(' ');
	ldw	y, (0x1b, sp)
	ldw	x, (0x20, sp)
	ld	a, (x)
	push	#0x0f
	pushw	y
	push	a
	call	_sstyle
	addw	sp, #4
	tnz	a
	jreq	00230$
	jp	00132$
00230$:
	push	#0x20
	call	_uart_putchar
	pop	a
	jp	00132$
00124$:
;	tbasic.c: 871: if (*ip == I_STR)
	ld	a, (0x0a, sp)
	cp	a, #0x29
	jrne	00121$
;	tbasic.c: 875: c = '\"';
	ld	a, #0x22
	ld	(0x01, sp), a
;	tbasic.c: 876: ip++;
	ldw	y, (0x04, sp)
	ldw	(0x20, sp), y
;	tbasic.c: 830: while (*ip != I_EOL)
	ldw	y, (0x20, sp)
	ldw	(0x08, sp), y
;	tbasic.c: 877: for (i = *ip; i; i--)
	ldw	x, (0x08, sp)
	ld	a, (x)
	ld	(0x0b, sp), a
00136$:
	tnz	(0x0b, sp)
	jreq	00114$
;	tbasic.c: 879: if (*(ip + i) == '\"')
	clrw	x
	ld	a, (0x0b, sp)
	ld	xl, a
	addw	x, (0x20, sp)
	ld	a, (x)
	cp	a, #0x22
	jrne	00137$
;	tbasic.c: 881: c = '\'';
	ld	a, #0x27
	ld	(0x01, sp), a
;	tbasic.c: 882: break;
	jra	00114$
00137$:
;	tbasic.c: 877: for (i = *ip; i; i--)
	dec	(0x0b, sp)
	jra	00136$
00114$:
;	tbasic.c: 886: uart_putchar(c);
	ld	a, (0x01, sp)
	push	a
	call	_uart_putchar
	pop	a
;	tbasic.c: 887: i = *ip++;
	ldw	x, (0x08, sp)
	ld	a, (x)
	ldw	x, (0x08, sp)
	incw	x
	ldw	(0x20, sp), x
;	tbasic.c: 888: while (i--)
	ldw	x, (0x20, sp)
	ld	(0x1d, sp), a
00115$:
	ld	a, (0x1d, sp)
	dec	(0x1d, sp)
	tnz	a
	jreq	00159$
;	tbasic.c: 890: uart_putchar(*ip++);
	ld	a, (x)
	incw	x
	pushw	x
	push	a
	call	_uart_putchar
	pop	a
	popw	x
	jra	00115$
00159$:
	ldw	(0x20, sp), x
;	tbasic.c: 892: uart_putchar(c);
	pushw	x
	ld	a, (0x03, sp)
	push	a
	call	_uart_putchar
	pop	a
	popw	x
;	tbasic.c: 893: if (*ip == I_VAR) uart_putchar(' ');
	ld	a, (x)
	cp	a, #0x28
	jreq	00241$
	jp	00132$
00241$:
	push	#0x20
	call	_uart_putchar
	pop	a
	jp	00132$
00121$:
;	tbasic.c: 899: err = ERR_SYS;
	mov	_err+0, #0x15
;	tbasic.c: 900: return;
00138$:
	addw	sp, #29
	ret
;	tbasic.c: 908: int16_t getparam(void)
;	-----------------------------------------
;	 function getparam
;	-----------------------------------------
_getparam:
	pushw	x
;	tbasic.c: 913: if (*cip != I_OPEN)
	ldw	x, _cip+0
	ld	a, (x)
	cp	a, #0x13
	jreq	00102$
;	tbasic.c: 915: err = ERR_PAREN;
	mov	_err+0, #0x11
;	tbasic.c: 916: return 0;
	clrw	x
	jra	00107$
00102$:
;	tbasic.c: 918: cip++;
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
;	tbasic.c: 919: value = iexp();
	call	_iexp
	ldw	(0x01, sp), x
;	tbasic.c: 920: if (err) return 0;
	tnz	_err+0
	jreq	00104$
	clrw	x
	jra	00107$
00104$:
;	tbasic.c: 922: if (*cip != I_CLOSE)
	ldw	x, _cip+0
	ld	a, (x)
	cp	a, #0x14
	jreq	00106$
;	tbasic.c: 924: err = ERR_PAREN;
	mov	_err+0, #0x11
;	tbasic.c: 925: return 0;
	clrw	x
	jra	00107$
00106$:
;	tbasic.c: 927: cip++;
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
;	tbasic.c: 929: return value;
	ldw	x, (0x01, sp)
00107$:
	addw	sp, #2
	ret
;	tbasic.c: 936: void io_inputinit(uint8_t ioport, uint8_t iono)
;	-----------------------------------------
;	 function io_inputinit
;	-----------------------------------------
_io_inputinit:
	sub	sp, #4
;	tbasic.c: 941: ioadr+= (ioport*5);
	ld	a, (0x07, sp)
	ld	xl, a
	ld	a, #0x05
	mul	x, a
	addw	x, #0x5000
	ldw	(0x01, sp), x
;	tbasic.c: 943: b= 1 << iono;
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
;	tbasic.c: 944: *(ioadr + P_DDR) &= ~(b);        // Output Register
	ldw	x, (0x01, sp)
	incw	x
	incw	x
	ld	a, (x)
	ld	(0x04, sp), a
	ld	a, (0x03, sp)
	cpl	a
	and	a, (0x04, sp)
	ld	(x), a
;	tbasic.c: 945: *(ioadr + P_CR1) |= b;           // Controll Register 1
	ldw	x, (0x01, sp)
	addw	x, #0x0003
	ld	a, (x)
	or	a, (0x03, sp)
	ld	(x), a
	addw	sp, #4
	ret
;	tbasic.c: 952: uint8_t io_bitset(uint8_t ioport, uint8_t iono)
;	-----------------------------------------
;	 function io_bitset
;	-----------------------------------------
_io_bitset:
	pushw	x
;	tbasic.c: 957: ioadr+= (ioport*5);
	ld	a, (0x05, sp)
	ld	xl, a
	ld	a, #0x05
	mul	x, a
	addw	x, #0x5000
;	tbasic.c: 959: b=  ( *(ioadr + P_IDR) & (1 << iono) ) >> iono;
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
;	tbasic.c: 961: return  b;
	ld	a, xl
	popw	x
	ret
;	tbasic.c: 992: void io_outputinit(uint8_t ioport, uint8_t iono)
;	-----------------------------------------
;	 function io_outputinit
;	-----------------------------------------
_io_outputinit:
	sub	sp, #4
;	tbasic.c: 997: ioadr+= (ioport*5);
	ld	a, (0x07, sp)
	ld	xl, a
	ld	a, #0x05
	mul	x, a
	addw	x, #0x5000
	ldw	(0x01, sp), x
;	tbasic.c: 999: b= 1 << iono;
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
;	tbasic.c: 1000: *(ioadr + P_DDR) |=  b;        // Output Register
	ldw	x, (0x01, sp)
	incw	x
	incw	x
	ld	a, (x)
	or	a, (0x03, sp)
	ld	(x), a
;	tbasic.c: 1001: *(ioadr + P_CR1) |=  b;        // Controll Register 1
	ldw	x, (0x01, sp)
	addw	x, #0x0003
	ld	a, (x)
	or	a, (0x03, sp)
	ld	(x), a
;	tbasic.c: 1002: *(ioadr + P_CR2) &= ~(b);      // Controll Register 2
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
;	tbasic.c: 1016: void io_set(uint8_t ioport, uint8_t iono, uint8_t value)
;	-----------------------------------------
;	 function io_set
;	-----------------------------------------
_io_set:
	push	a
;	tbasic.c: 1021: ioadr+= (ioport*5);
	ld	a, (0x04, sp)
	ld	xl, a
	ld	a, #0x05
	mul	x, a
	addw	x, #0x5000
;	tbasic.c: 1023: b= 1 << iono;
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
;	tbasic.c: 1035: int16_t iioin(int16_t index)
;	-----------------------------------------
;	 function iioin
;	-----------------------------------------
_iioin:
	pushw	x
;	tbasic.c: 1039: gp= 0;
	clr	(0x02, sp)
;	tbasic.c: 1041: if (index>1) gp++;
	ldw	x, (0x05, sp)
	cpw	x, #0x0001
	jrsle	00102$
	ld	a, #0x01
	ld	(0x02, sp), a
00102$:
;	tbasic.c: 1043: if (index>2) gp++;
	ldw	x, (0x05, sp)
	cpw	x, #0x0002
	jrsle	00104$
	ld	a, (0x02, sp)
	inc	a
	ld	(0x02, sp), a
00104$:
;	tbasic.c: 1045: if (index>7) gp++;
	ldw	x, (0x05, sp)
	cpw	x, #0x0007
	jrsle	00106$
	ld	a, (0x02, sp)
	inc	a
	ld	(0x02, sp), a
00106$:
;	tbasic.c: 1047: bitnr= pinmap[index];
	ldw	x, #_pinmap+0
	addw	x, (0x05, sp)
	ld	a, (x)
	ld	(0x01, sp), a
;	tbasic.c: 1052: if (testbit16(portddr, index))
	ldw	y, #0x0001
	ld	a, (0x06, sp)
	jreq	00131$
00130$:
	sllw	y
	dec	a
	jrne	00130$
00131$:
	ldw	x, y
	ld	a, yl
	and	a, _portddr+1
	rlwa	x
	and	a, _portddr+0
	ld	xh, a
	ld	a, (0x06, sp)
	jreq	00133$
00132$:
	srlw	x
	dec	a
	jrne	00132$
00133$:
	tnzw	x
	jreq	00108$
;	tbasic.c: 1054: bitclr16(portddr, index);
	cplw	y
	ld	a, yl
	and	a, _portddr+1
	ld	xl, a
	ld	a, yh
	and	a, _portddr+0
	ld	xh, a
	ldw	_portddr+0, x
;	tbasic.c: 1055: io_inputinit(gp, bitnr);
	ld	a, (0x01, sp)
	push	a
	ld	a, (0x03, sp)
	push	a
	call	_io_inputinit
	popw	x
00108$:
;	tbasic.c: 1058: return io_bitset(gp, bitnr);
	ld	a, (0x01, sp)
	push	a
	ld	a, (0x03, sp)
	push	a
	call	_io_bitset
	popw	x
	clrw	x
	ld	xl, a
	addw	sp, #2
	ret
;	tbasic.c: 1069: void ioutput()
;	-----------------------------------------
;	 function ioutput
;	-----------------------------------------
_ioutput:
	sub	sp, #8
;	tbasic.c: 1078: index = getparam();
	call	_getparam
	ldw	(0x01, sp), x
;	tbasic.c: 1079: if (err) return;
	tnz	_err+0
	jreq	00102$
	jp	00120$
00102$:
;	tbasic.c: 1080: if (index >= IO_MAX)
	ldw	x, (0x01, sp)
	cpw	x, #0x0011
	jrslt	00104$
;	tbasic.c: 1082: err = ERR_NOIO;
	mov	_err+0, #0x17
;	tbasic.c: 1083: return;
	jp	00120$
00104$:
;	tbasic.c: 1085: if (*cip != I_EQ)
	ldw	x, _cip+0
	ld	a, (x)
	cp	a, #0x18
	jreq	00106$
;	tbasic.c: 1087: err = ERR_NOIO;
	mov	_err+0, #0x17
;	tbasic.c: 1088: return;
	jp	00120$
00106$:
;	tbasic.c: 1090: cip++;
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
;	tbasic.c: 1092: value = iexp();
	call	_iexp
	ldw	(0x03, sp), x
;	tbasic.c: 1093: if (err) return;
	tnz	_err+0
	jreq	00108$
	jp	00120$
00108$:
;	tbasic.c: 1110: gp= 0;
	clr	(0x06, sp)
;	tbasic.c: 1112: if (index>0) gp++;
	ldw	x, (0x01, sp)
	cpw	x, #0x0000
	jrsle	00110$
	ld	a, #0x01
	ld	(0x06, sp), a
00110$:
;	tbasic.c: 1114: if (index>2) gp++;
	ldw	x, (0x01, sp)
	cpw	x, #0x0002
	jrsle	00112$
	ld	a, (0x06, sp)
	inc	a
	ld	(0x06, sp), a
00112$:
;	tbasic.c: 1116: if (index>7) gp++;
	ldw	x, (0x01, sp)
	cpw	x, #0x0007
	jrsle	00114$
	ld	a, (0x06, sp)
	inc	a
	ld	(0x06, sp), a
00114$:
;	tbasic.c: 1118: bitnr= pinmap[index];
	ldw	x, #_pinmap+0
	addw	x, (0x01, sp)
	ld	a, (x)
	ld	(0x05, sp), a
;	tbasic.c: 1120: if (!(testbit16(portddr, index)))
	ldw	x, #0x0001
	ld	a, (0x02, sp)
	jreq	00168$
00167$:
	sllw	x
	dec	a
	jrne	00167$
00168$:
	ld	a, xl
	and	a, _portddr+1
	ld	yl, a
	ld	a, xh
	and	a, _portddr+0
	ld	yh, a
	ld	a, (0x02, sp)
	jreq	00170$
00169$:
	srlw	y
	dec	a
	jrne	00169$
00170$:
	ldw	(0x07, sp), y
	ldw	y, (0x07, sp)
	jrne	00116$
;	tbasic.c: 1122: bitset16(portddr, index);
	ld	a, xl
	or	a, _portddr+1
	rlwa	x
	or	a, _portddr+0
	ld	xh, a
	ldw	_portddr+0, x
;	tbasic.c: 1123: io_outputinit(gp, bitnr);
	ld	a, (0x05, sp)
	push	a
	ld	a, (0x07, sp)
	push	a
	call	_io_outputinit
	popw	x
00116$:
;	tbasic.c: 1125: if (value) io_set(gp, bitnr, 1); else io_set(gp, bitnr, 0);
	ldw	x, (0x03, sp)
	jreq	00118$
	push	#0x01
	ld	a, (0x06, sp)
	push	a
	ld	a, (0x08, sp)
	push	a
	call	_io_set
	addw	sp, #3
	jra	00120$
00118$:
	push	#0x00
	ld	a, (0x06, sp)
	push	a
	ld	a, (0x08, sp)
	push	a
	call	_io_set
	addw	sp, #3
00120$:
	addw	sp, #8
	ret
;	tbasic.c: 1128: int16_t ivalue(void)
;	-----------------------------------------
;	 function ivalue
;	-----------------------------------------
_ivalue:
	sub	sp, #13
;	tbasic.c: 1132: switch (*cip)
	ldw	x, _cip+0
	ld	a, (x)
	ld	(0x0d, sp), a
	ld	a, (0x0d, sp)
	cp	a, #0x0f
	jrne	00205$
	jp	00103$
00205$:
	ld	a, (0x0d, sp)
	cp	a, #0x10
	jreq	00102$
	ld	a, (0x0d, sp)
	cp	a, #0x13
	jrne	00211$
	jp	00105$
00211$:
	ld	a, (0x0d, sp)
	cp	a, #0x1b
	jrne	00214$
	jp	00106$
00214$:
	ld	a, (0x0d, sp)
	cp	a, #0x1c
	jrne	00217$
	jp	00116$
00217$:
	ld	a, (0x0d, sp)
	cp	a, #0x1d
	jrne	00220$
	jp	00119$
00220$:
	ld	a, (0x0d, sp)
	cp	a, #0x1e
	jrne	00223$
	jp	00124$
00223$:
	ld	a, (0x0d, sp)
	cp	a, #0x20
	jrne	00226$
	jp	00111$
00226$:
	ld	a, (0x0d, sp)
	cp	a, #0x27
	jreq	00101$
	ld	a, (0x0d, sp)
	cp	a, #0x28
	jreq	00104$
	jp	00128$
;	tbasic.c: 1134: case I_NUM:
00101$:
;	tbasic.c: 1136: cip++;
	ldw	x, _cip+0
	incw	x
;	tbasic.c: 1137: value = *cip | *(cip + 1) << 8;
	ldw	_cip+0, x
	ld	a, (x)
	ld	yh, a
	ldw	x, _cip+0
	ld	a, (0x1, x)
	clr	(0x0b, sp)
	clr	(0x0a, sp)
	clr	(0x07, sp)
	or	a, (0x07, sp)
	ld	xh, a
	ld	a, yh
	or	a, (0x0a, sp)
	ld	xl, a
	ldw	(0x01, sp), x
;	tbasic.c: 1138: cip += 2;
	ldw	x, _cip+0
	incw	x
	incw	x
	ldw	_cip+0, x
;	tbasic.c: 1139: break;
	jp	00129$
;	tbasic.c: 1141: case I_PLUS:
00102$:
;	tbasic.c: 1143: cip++;
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
;	tbasic.c: 1144: value = ivalue();
	call	_ivalue
	ldw	(0x01, sp), x
;	tbasic.c: 1145: break;
	jp	00129$
;	tbasic.c: 1147: case I_MINUS:
00103$:
;	tbasic.c: 1149: cip++;
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
;	tbasic.c: 1150: value = 0 - ivalue();
	call	_ivalue
	negw	x
	ldw	(0x01, sp), x
;	tbasic.c: 1151: break;
	jp	00129$
;	tbasic.c: 1153: case I_VAR:
00104$:
;	tbasic.c: 1155: cip++;
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
;	tbasic.c: 1156: value = var[*cip++];
	ldw	x, #_var+0
	ldw	(0x05, sp), x
	ldw	x, _cip+0
	ld	a, (x)
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
	clrw	x
	ld	xl, a
	sllw	x
	addw	x, (0x05, sp)
	ldw	x, (x)
	ldw	(0x01, sp), x
;	tbasic.c: 1157: break;
	jp	00129$
;	tbasic.c: 1159: case I_OPEN:
00105$:
;	tbasic.c: 1161: value = getparam();
	call	_getparam
	ldw	(0x01, sp), x
;	tbasic.c: 1162: break;
	jp	00129$
;	tbasic.c: 1164: case I_ARRAY:
00106$:
;	tbasic.c: 1166: cip++;
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
;	tbasic.c: 1167: value = getparam();
	call	_getparam
	ldw	(0x01, sp), x
;	tbasic.c: 1168: if (err) break;
	tnz	_err+0
	jreq	00234$
	jp	00129$
00234$:
;	tbasic.c: 1169: if (value >= SIZE_ARRY)
	ldw	x, (0x01, sp)
	cpw	x, #0x0020
	jrslt	00110$
;	tbasic.c: 1171: err = ERR_SOR;
	mov	_err+0, #0x03
;	tbasic.c: 1172: break;
	jp	00129$
00110$:
;	tbasic.c: 1174: value = arr[value];
	ldw	x, #_arr+0
	ldw	(0x03, sp), x
	ldw	x, (0x01, sp)
	sllw	x
	addw	x, (0x03, sp)
	ldw	x, (x)
	ldw	(0x01, sp), x
;	tbasic.c: 1175: break;
	jp	00129$
;	tbasic.c: 1177: case I_IN:
00111$:
;	tbasic.c: 1179: cip++;
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
;	tbasic.c: 1180: value = getparam();
	call	_getparam
	ldw	(0x01, sp), x
;	tbasic.c: 1181: if (err) break;
	tnz	_err+0
	jreq	00236$
	jp	00129$
00236$:
;	tbasic.c: 1182: if (value >= IO_MAX)
	ldw	x, (0x01, sp)
	cpw	x, #0x0011
	jrslt	00115$
;	tbasic.c: 1184: err = ERR_NOIO;
	mov	_err+0, #0x17
;	tbasic.c: 1185: break;
	jra	00129$
00115$:
;	tbasic.c: 1187: value= iioin(value);
	ldw	x, (0x01, sp)
	pushw	x
	call	_iioin
	addw	sp, #2
	ldw	(0x01, sp), x
;	tbasic.c: 1188: break;
	jra	00129$
;	tbasic.c: 1190: case I_RND:
00116$:
;	tbasic.c: 1192: cip++;
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
;	tbasic.c: 1193: value = getparam();
	call	_getparam
	ldw	(0x01, sp), x
;	tbasic.c: 1194: if (err) break;
	tnz	_err+0
	jrne	00129$
;	tbasic.c: 1195: value = getrnd(value);
	ldw	x, (0x01, sp)
	pushw	x
	call	_getrnd
	addw	sp, #2
	ldw	(0x01, sp), x
;	tbasic.c: 1196: break;
	jra	00129$
;	tbasic.c: 1198: case I_ABS:
00119$:
;	tbasic.c: 1200: cip++;
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
;	tbasic.c: 1201: value = getparam();
	call	_getparam
	ldw	(0x01, sp), x
;	tbasic.c: 1202: if (err) break;
	tnz	_err+0
	jrne	00129$
;	tbasic.c: 1203: if (value < 0) value *= -1;
	tnz	(0x01, sp)
	jrpl	00129$
	ldw	x, (0x01, sp)
	negw	x
	ldw	(0x01, sp), x
;	tbasic.c: 1204: break;
	jra	00129$
;	tbasic.c: 1206: case I_SIZE:
00124$:
;	tbasic.c: 1208: cip++;
	ldw	x, _cip+0
	incw	x
;	tbasic.c: 1209: if ((*cip != I_OPEN) || (*(cip + 1) != I_CLOSE))
	ldw	_cip+0, x
	ld	a, (x)
	cp	a, #0x13
	jrne	00125$
	ldw	x, _cip+0
	ld	a, (0x1, x)
	cp	a, #0x14
	jreq	00126$
00125$:
;	tbasic.c: 1211: err = ERR_PAREN;
	mov	_err+0, #0x11
;	tbasic.c: 1212: break;
	jra	00129$
00126$:
;	tbasic.c: 1214: cip += 2;
	ldw	x, _cip+0
	incw	x
	incw	x
	ldw	_cip+0, x
;	tbasic.c: 1215: value = getsize();
	call	_getsize
	ldw	(0x01, sp), x
;	tbasic.c: 1216: break;
	jra	00129$
;	tbasic.c: 1218: default:
00128$:
;	tbasic.c: 1220: err = ERR_SYNTAX;
	mov	_err+0, #0x14
;	tbasic.c: 1223: }
00129$:
;	tbasic.c: 1224: return value;
	ldw	x, (0x01, sp)
	addw	sp, #13
	ret
;	tbasic.c: 1227: int16_t imul()
;	-----------------------------------------
;	 function imul
;	-----------------------------------------
_imul:
	pushw	x
;	tbasic.c: 1232: value = ivalue();
	call	_ivalue
	ldw	(0x01, sp), x
;	tbasic.c: 1233: if (err) return -1;
	tnz	_err+0
	jreq	00110$
	ldw	x, #0xffff
	jra	00112$
;	tbasic.c: 1235: while (1)
00110$:
;	tbasic.c: 1237: switch (*cip)
	ldw	x, _cip+0
	ld	a, (x)
;	tbasic.c: 1241: cip++;
	ldw	x, _cip+0
	incw	x
;	tbasic.c: 1237: switch (*cip)
	cp	a, #0x11
	jreq	00103$
	cp	a, #0x12
	jreq	00104$
	jra	00107$
;	tbasic.c: 1239: case I_MUL:
00103$:
;	tbasic.c: 1241: cip++;
	ldw	_cip+0, x
;	tbasic.c: 1242: tmp = ivalue();
	call	_ivalue
;	tbasic.c: 1243: value *= tmp;
	pushw	x
	ldw	x, (0x03, sp)
	pushw	x
	call	__mulint
	addw	sp, #4
	ldw	(0x01, sp), x
;	tbasic.c: 1244: break;
	jra	00110$
;	tbasic.c: 1246: case I_DIV:
00104$:
;	tbasic.c: 1248: cip++;
	ldw	_cip+0, x
;	tbasic.c: 1249: tmp = ivalue();
	call	_ivalue
;	tbasic.c: 1250: if (tmp == 0)
	tnzw	x
	jrne	00106$
;	tbasic.c: 1252: err = ERR_DIVBY0;
	mov	_err+0, #0x01
;	tbasic.c: 1253: return -1;
	ldw	x, #0xffff
	jra	00112$
00106$:
;	tbasic.c: 1255: value /= tmp;
	pushw	x
	ldw	x, (0x03, sp)
	pushw	x
	call	__divsint
	addw	sp, #4
	ldw	(0x01, sp), x
;	tbasic.c: 1256: break;
	jra	00110$
;	tbasic.c: 1258: default: return value;
00107$:
	ldw	x, (0x01, sp)
;	tbasic.c: 1259: }
00112$:
	addw	sp, #2
	ret
;	tbasic.c: 1263: int16_t iplus()
;	-----------------------------------------
;	 function iplus
;	-----------------------------------------
_iplus:
	sub	sp, #7
;	tbasic.c: 1268: value = imul();
	call	_imul
	ldw	(0x03, sp), x
;	tbasic.c: 1269: if (err) return -1;
	tnz	_err+0
	jreq	00108$
	ldw	x, #0xffff
	jra	00110$
;	tbasic.c: 1271: while (1)
00108$:
;	tbasic.c: 1273: switch (*cip)
	ldw	x, _cip+0
	ld	a, (x)
	ld	(0x05, sp), a
;	tbasic.c: 1277: cip++;
	ldw	x, _cip+0
	incw	x
	ldw	(0x06, sp), x
;	tbasic.c: 1273: switch (*cip)
	ld	a, (0x05, sp)
	cp	a, #0x0f
	jreq	00104$
	ld	a, (0x05, sp)
	cp	a, #0x10
	jrne	00105$
;	tbasic.c: 1277: cip++;
	ld	a, (0x07, sp)
	ld	_cip+1, a
	ld	a, (0x06, sp)
	ld	_cip+0, a
;	tbasic.c: 1278: tmp = imul();
	call	_imul
;	tbasic.c: 1279: value += tmp;
	addw	x, (0x03, sp)
	ldw	(0x03, sp), x
;	tbasic.c: 1280: break;
	jra	00108$
;	tbasic.c: 1282: case I_MINUS:
00104$:
;	tbasic.c: 1284: cip++;
	ld	a, (0x07, sp)
	ld	_cip+1, a
	ld	a, (0x06, sp)
	ld	_cip+0, a
;	tbasic.c: 1285: tmp = imul();
	call	_imul
	ldw	(0x01, sp), x
;	tbasic.c: 1286: value -= tmp;
	ldw	y, (0x03, sp)
	subw	y, (0x01, sp)
	ldw	(0x03, sp), y
;	tbasic.c: 1287: break;
	jra	00108$
;	tbasic.c: 1289: default: return value;
00105$:
	ldw	x, (0x03, sp)
;	tbasic.c: 1290: }
00110$:
	addw	sp, #7
	ret
;	tbasic.c: 1299: int16_t iexp(void)
;	-----------------------------------------
;	 function iexp
;	-----------------------------------------
_iexp:
	sub	sp, #13
;	tbasic.c: 1303: value = iplus();
	call	_iplus
	ldw	(0x01, sp), x
;	tbasic.c: 1304: if (err) return -1;
	tnz	_err+0
	jreq	00112$
	ldw	x, #0xffff
	jp	00114$
;	tbasic.c: 1306: while (1)
00112$:
;	tbasic.c: 1308: switch (*cip)
	ldw	x, _cip+0
	ld	a, (x)
	ld	(0x0d, sp), a
;	tbasic.c: 1312: cip++;
	ldw	x, _cip+0
	incw	x
	ldw	(0x0b, sp), x
;	tbasic.c: 1308: switch (*cip)
	ld	a, (0x0d, sp)
	cp	a, #0x15
	jrne	00150$
	jp	00108$
00150$:
	ld	a, (0x0d, sp)
	cp	a, #0x16
	jreq	00104$
	ld	a, (0x0d, sp)
	cp	a, #0x17
	jrne	00156$
	jp	00107$
00156$:
	ld	a, (0x0d, sp)
	cp	a, #0x18
	jreq	00103$
	ld	a, (0x0d, sp)
	cp	a, #0x19
	jreq	00106$
	ld	a, (0x0d, sp)
	cp	a, #0x1a
	jreq	00105$
	jp	00109$
;	tbasic.c: 1310: case I_EQ:
00103$:
;	tbasic.c: 1312: cip++;
	ld	a, (0x0c, sp)
	ld	_cip+1, a
	ld	a, (0x0b, sp)
	ld	_cip+0, a
;	tbasic.c: 1313: tmp = iplus();
	call	_iplus
	ldw	(0x09, sp), x
;	tbasic.c: 1314: value = (value == tmp);
	ldw	x, (0x01, sp)
	cpw	x, (0x09, sp)
	jrne	00168$
	ld	a, #0x01
	.byte 0x21
00168$:
	clr	a
00169$:
	ld	xl, a
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	xh, a
	ldw	(0x01, sp), x
;	tbasic.c: 1315: break;
	jra	00112$
;	tbasic.c: 1317: case I_SHARP:
00104$:
;	tbasic.c: 1319: cip++;
	ld	a, (0x0c, sp)
	ld	_cip+1, a
	ld	a, (0x0b, sp)
	ld	_cip+0, a
;	tbasic.c: 1320: tmp = iplus();
	call	_iplus
	ldw	(0x07, sp), x
;	tbasic.c: 1321: value = (value != tmp);
	ldw	x, (0x01, sp)
	cpw	x, (0x07, sp)
	jrne	00171$
	ld	a, #0x01
	.byte 0x21
00171$:
	clr	a
00172$:
	sub	a, #0x01
	clr	a
	rlc	a
	ld	xl, a
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	xh, a
	ldw	(0x01, sp), x
;	tbasic.c: 1322: break;
	jp	00112$
;	tbasic.c: 1324: case I_LT:
00105$:
;	tbasic.c: 1326: cip++;
	ld	a, (0x0c, sp)
	ld	_cip+1, a
	ld	a, (0x0b, sp)
	ld	_cip+0, a
;	tbasic.c: 1327: tmp = iplus();
	call	_iplus
	ldw	(0x05, sp), x
;	tbasic.c: 1328: value = (value < tmp);
	ldw	x, (0x01, sp)
	cpw	x, (0x05, sp)
	jrslt	00173$
	clr	a
	jra	00174$
00173$:
	ld	a, #0x01
00174$:
	ld	xl, a
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	xh, a
	ldw	(0x01, sp), x
;	tbasic.c: 1329: break;
	jp	00112$
;	tbasic.c: 1331: case I_LTE:
00106$:
;	tbasic.c: 1333: cip++;
	ld	a, (0x0c, sp)
	ld	_cip+1, a
	ld	a, (0x0b, sp)
	ld	_cip+0, a
;	tbasic.c: 1334: tmp = iplus();
	call	_iplus
;	tbasic.c: 1335: value = (value <= tmp);
	cpw	x, (0x01, sp)
	jrslt	00175$
	clr	a
	jra	00176$
00175$:
	ld	a, #0x01
00176$:
	sub	a, #0x01
	clr	a
	rlc	a
	ld	xl, a
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	xh, a
	ldw	(0x01, sp), x
;	tbasic.c: 1336: break;
	jp	00112$
;	tbasic.c: 1338: case I_GT:
00107$:
;	tbasic.c: 1340: cip++;
	ld	a, (0x0c, sp)
	ld	_cip+1, a
	ld	a, (0x0b, sp)
	ld	_cip+0, a
;	tbasic.c: 1341: tmp = iplus();
	call	_iplus
;	tbasic.c: 1342: value = (value > tmp);
	cpw	x, (0x01, sp)
	jrslt	00177$
	clr	a
	jra	00178$
00177$:
	ld	a, #0x01
00178$:
	ld	xl, a
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	xh, a
	ldw	(0x01, sp), x
;	tbasic.c: 1343: break;
	jp	00112$
;	tbasic.c: 1345: case I_GTE:
00108$:
;	tbasic.c: 1347: cip++;
	ld	a, (0x0c, sp)
	ld	_cip+1, a
	ld	a, (0x0b, sp)
	ld	_cip+0, a
;	tbasic.c: 1348: tmp = iplus();
	call	_iplus
	ldw	(0x03, sp), x
;	tbasic.c: 1349: value = (value >= tmp);
	ldw	x, (0x01, sp)
	cpw	x, (0x03, sp)
	jrslt	00179$
	clr	a
	jra	00180$
00179$:
	ld	a, #0x01
00180$:
	sub	a, #0x01
	clr	a
	rlc	a
	ld	xl, a
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	xh, a
	ldw	(0x01, sp), x
;	tbasic.c: 1350: break;
	jp	00112$
;	tbasic.c: 1352: default: return value;
00109$:
	ldw	x, (0x01, sp)
;	tbasic.c: 1353: }
00114$:
	addw	sp, #13
	ret
;	tbasic.c: 1357: void iprint(void)
;	-----------------------------------------
;	 function iprint
;	-----------------------------------------
_iprint:
	sub	sp, #3
;	tbasic.c: 1363: len = 0;
	clrw	x
	ldw	(0x02, sp), x
;	tbasic.c: 1364: while (*cip != I_SEMI && *cip != I_EOL)
00122$:
	ldw	x, _cip+0
	ld	a, (x)
	cp	a, #0x0e
	jrne	00181$
	jp	00124$
00181$:
	cp	a, #0x2a
	jrne	00184$
	jp	00124$
00184$:
;	tbasic.c: 1370: cip++;
	ldw	x, _cip+0
	incw	x
;	tbasic.c: 1366: switch (*cip)
	cp	a, #0x16
	jreq	00105$
	cp	a, #0x29
	jrne	00108$
;	tbasic.c: 1370: cip++;
;	tbasic.c: 1371: i = *cip++;
	ldw	_cip+0, x
	ld	a, (x)
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
;	tbasic.c: 1372: while (i--) uart_putchar(*cip++);
	ld	(0x01, sp), a
00102$:
	ld	a, (0x01, sp)
	dec	(0x01, sp)
	tnz	a
	jreq	00111$
	ldw	x, _cip+0
	ld	a, (x)
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
	push	a
	call	_uart_putchar
	pop	a
	jra	00102$
;	tbasic.c: 1375: case I_SHARP:
00105$:
;	tbasic.c: 1377: cip++;
	ldw	_cip+0, x
;	tbasic.c: 1378: len = iexp();
	call	_iexp
	ldw	(0x02, sp), x
;	tbasic.c: 1379: if (err) return;
	tnz	_err+0
	jreq	00111$
	jra	00125$
;	tbasic.c: 1382: default:
00108$:
;	tbasic.c: 1384: value = iexp();
	call	_iexp
;	tbasic.c: 1385: if (err) return;
	tnz	_err+0
	jrne	00125$
;	tbasic.c: 1386: putnum(value, len);
	ldw	y, (0x02, sp)
	pushw	y
	pushw	x
	call	_putnum
	addw	sp, #4
;	tbasic.c: 1389: }
00111$:
;	tbasic.c: 1364: while (*cip != I_SEMI && *cip != I_EOL)
	ldw	x, _cip+0
	ld	a, (x)
;	tbasic.c: 1391: if (*cip == I_COMMA)
	cp	a, #0x0d
	jrne	00119$
;	tbasic.c: 1393: cip++;
	ldw	x, _cip+0
	incw	x
;	tbasic.c: 1364: while (*cip != I_SEMI && *cip != I_EOL)
	ldw	_cip+0, x
	ld	a, (x)
;	tbasic.c: 1394: if (*cip == I_SEMI || *cip == I_EOL) return;
	cp	a, #0x0e
	jreq	00125$
	cp	a, #0x2a
	jreq	00125$
	jp	00122$
00119$:
;	tbasic.c: 1398: if (*cip != I_SEMI && *cip != I_EOL)
	cp	a, #0x0e
	jrne	00205$
	jp	00122$
00205$:
	cp	a, #0x2a
	jrne	00208$
	jp	00122$
00208$:
;	tbasic.c: 1400: err = ERR_SYNTAX;
	mov	_err+0, #0x14
;	tbasic.c: 1401: return;
	jra	00125$
00124$:
;	tbasic.c: 1405: newline();
	call	_newline
00125$:
	addw	sp, #3
	ret
;	tbasic.c: 1408: void iinput(void)
;	-----------------------------------------
;	 function iinput
;	-----------------------------------------
_iinput:
	sub	sp, #36
;	tbasic.c: 1415: while (1)
	ldw	x, #___str_2+0
	ldw	(0x20, sp), x
	ldw	x, #___str_3+0
	ldw	(0x06, sp), x
	ldw	x, #___str_4+0
	ldw	(0x1e, sp), x
	ldw	x, #_arr+0
	ldw	(0x0c, sp), x
	ldw	x, #_var+0
	ldw	(0x1a, sp), x
00128$:
;	tbasic.c: 1417: prompt = 1;
	ld	a, #0x01
	ld	(0x03, sp), a
;	tbasic.c: 1419: if (*cip == I_STR)
	ldw	x, _cip+0
	ldw	(0x22, sp), x
	ldw	x, (0x22, sp)
	ld	a, (x)
	ld	(0x08, sp), a
;	tbasic.c: 1421: cip++;
	ldw	x, _cip+0
	incw	x
	ldw	(0x1c, sp), x
;	tbasic.c: 1419: if (*cip == I_STR)
	ld	a, (0x08, sp)
	cp	a, #0x29
	jrne	00105$
;	tbasic.c: 1421: cip++;
	ld	a, (0x1d, sp)
	ld	_cip+1, a
	ld	a, (0x1c, sp)
	ld	_cip+0, a
;	tbasic.c: 1422: i = *cip++;
	ldw	x, _cip+0
	ld	a, (x)
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
;	tbasic.c: 1423: while (i--) uart_putchar(*cip++);
	ld	(0x24, sp), a
00101$:
	ld	a, (0x24, sp)
	dec	(0x24, sp)
;	tbasic.c: 1419: if (*cip == I_STR)
	ldw	x, _cip+0
	ldw	(0x22, sp), x
;	tbasic.c: 1421: cip++;
	ldw	x, _cip+0
	incw	x
	ldw	(0x1c, sp), x
;	tbasic.c: 1419: if (*cip == I_STR)
	ldw	x, (0x22, sp)
	push	a
	ld	a, (x)
	ld	(0x09, sp), a
	pop	a
;	tbasic.c: 1423: while (i--) uart_putchar(*cip++);
	tnz	a
	jreq	00103$
	ld	a, (0x1d, sp)
	ld	_cip+1, a
	ld	a, (0x1c, sp)
	ld	_cip+0, a
	ld	a, (0x08, sp)
	push	a
	call	_uart_putchar
	pop	a
	jra	00101$
00103$:
;	tbasic.c: 1424: prompt = 0;
	clr	(0x03, sp)
00105$:
;	tbasic.c: 1427: switch (*cip)
	ld	a, (0x08, sp)
	cp	a, #0x1b
	jreq	00111$
	ld	a, (0x08, sp)
	cp	a, #0x28
	jreq	00202$
	jp	00120$
00202$:
;	tbasic.c: 1431: cip++;
	ld	a, (0x1d, sp)
	ld	_cip+1, a
	ld	a, (0x1c, sp)
	ld	_cip+0, a
;	tbasic.c: 1432: if (prompt)
	tnz	(0x03, sp)
	jreq	00108$
;	tbasic.c: 1436: uart_putstring(": ");
	ldw	y, (0x20, sp)
	ldw	(0x18, sp), y
	ldw	x, (0x18, sp)
	pushw	x
	call	_uart_putstring
	popw	x
00108$:
;	tbasic.c: 1438: value = getnum();
	call	_getnum
	ldw	(0x01, sp), x
	ldw	y, (0x01, sp)
	ldw	(0x10, sp), y
;	tbasic.c: 1439: if (err) return;
	tnz	_err+0
	jreq	00110$
	jp	00130$
00110$:
;	tbasic.c: 1440: var[*cip++] = value;
	ldw	x, _cip+0
	ldw	(0x16, sp), x
	ldw	x, (0x16, sp)
	ld	a, (x)
	ld	(0x0b, sp), a
	ldw	x, _cip+0
	incw	x
	ldw	(0x0e, sp), x
	ld	a, (0x0f, sp)
	ld	_cip+1, a
	ld	a, (0x0e, sp)
	ld	_cip+0, a
	ld	a, (0x0b, sp)
	ld	(0x13, sp), a
	clr	(0x12, sp)
	ldw	x, (0x12, sp)
	sllw	x
	ldw	(0x14, sp), x
	ldw	x, (0x1a, sp)
	addw	x, (0x14, sp)
	ldw	(0x09, sp), x
	ldw	x, (0x09, sp)
	ldw	y, (0x10, sp)
	ldw	(x), y
;	tbasic.c: 1441: break;
	jra	00121$
;	tbasic.c: 1443: case I_ARRAY:
00111$:
;	tbasic.c: 1445: cip++;
	ld	a, (0x1d, sp)
	ld	_cip+1, a
	ld	a, (0x1c, sp)
	ld	_cip+0, a
;	tbasic.c: 1446: index = getparam();
	call	_getparam
	ldw	(0x04, sp), x
;	tbasic.c: 1447: if (err) return;
	tnz	_err+0
	jrne	00130$
;	tbasic.c: 1448: if (index >= SIZE_ARRY)
	ldw	x, (0x04, sp)
	cpw	x, #0x0020
	jrslt	00115$
;	tbasic.c: 1450: err = ERR_SOR;
	mov	_err+0, #0x03
;	tbasic.c: 1451: return;
	jra	00130$
00115$:
;	tbasic.c: 1453: if (prompt)
	tnz	(0x03, sp)
	jreq	00117$
;	tbasic.c: 1455: uart_putstring("@(");
	ldw	x, (0x06, sp)
	pushw	x
	call	_uart_putstring
	popw	x
;	tbasic.c: 1456: putnum(index, 0);
	clrw	x
	pushw	x
	ldw	x, (0x06, sp)
	pushw	x
	call	_putnum
	addw	sp, #4
;	tbasic.c: 1457: uart_putstring("):");
	ldw	x, (0x1e, sp)
	pushw	x
	call	_uart_putstring
	popw	x
00117$:
;	tbasic.c: 1459: value = getnum();
	call	_getnum
;	tbasic.c: 1460: if (err) return;
	tnz	_err+0
	jrne	00130$
;	tbasic.c: 1461: arr[index] = value;
	ldw	y, (0x04, sp)
	sllw	y
	addw	y, (0x0c, sp)
	ldw	(y), x
;	tbasic.c: 1462: break;
	jra	00121$
;	tbasic.c: 1464: default:
00120$:
;	tbasic.c: 1466: err = ERR_SYNTAX;
	mov	_err+0, #0x14
;	tbasic.c: 1467: return;
	jra	00130$
;	tbasic.c: 1469: }
00121$:
;	tbasic.c: 1471: switch (*cip)
	ldw	x, _cip+0
	ld	a, (x)
	cp	a, #0x0d
	jreq	00122$
	cp	a, #0x0e
	jreq	00130$
	cp	a, #0x2a
	jreq	00130$
	jra	00125$
;	tbasic.c: 1473: case I_COMMA:
00122$:
;	tbasic.c: 1475: cip++;
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
;	tbasic.c: 1476: break;
;	tbasic.c: 1479: case I_EOL:  return;
	jp	00128$
;	tbasic.c: 1480: default:
00125$:
;	tbasic.c: 1482: err = ERR_SYNTAX;
	mov	_err+0, #0x14
;	tbasic.c: 1483: return;
;	tbasic.c: 1485: }
00130$:
	addw	sp, #36
	ret
;	tbasic.c: 1490: void ivar(void)
;	-----------------------------------------
;	 function ivar
;	-----------------------------------------
_ivar:
	sub	sp, #6
;	tbasic.c: 1495: index = *cip++;
	ldw	x, _cip+0
	ld	a, (x)
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
	clrw	x
	ld	xl, a
	ldw	(0x03, sp), x
;	tbasic.c: 1496: if (*cip != I_EQ)
	ldw	x, _cip+0
	ld	a, (x)
	cp	a, #0x18
	jreq	00102$
;	tbasic.c: 1498: err = ERR_VWOEQ;
	mov	_err+0, #0x12
;	tbasic.c: 1499: return;
	jra	00105$
00102$:
;	tbasic.c: 1501: cip++;
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
;	tbasic.c: 1503: value = iexp();
	call	_iexp
	ldw	(0x01, sp), x
;	tbasic.c: 1504: if (err) return;
	tnz	_err+0
	jrne	00105$
;	tbasic.c: 1506: var[index] = value;
	ldw	x, #_var+0
	ldw	(0x05, sp), x
	ldw	x, (0x03, sp)
	sllw	x
	addw	x, (0x05, sp)
	ldw	y, (0x01, sp)
	ldw	(x), y
00105$:
	addw	sp, #6
	ret
;	tbasic.c: 1509: void iarray()
;	-----------------------------------------
;	 function iarray
;	-----------------------------------------
_iarray:
	sub	sp, #4
;	tbasic.c: 1514: index = getparam();
	call	_getparam
	ldw	(0x01, sp), x
;	tbasic.c: 1515: if (err) return;
	tnz	_err+0
	jrne	00109$
;	tbasic.c: 1517: if (index >= SIZE_ARRY)
	ldw	x, (0x01, sp)
	cpw	x, #0x0020
	jrslt	00104$
;	tbasic.c: 1519: err = ERR_SOR;
	mov	_err+0, #0x03
;	tbasic.c: 1520: return;
	jra	00109$
00104$:
;	tbasic.c: 1523: if (*cip != I_EQ)
	ldw	x, _cip+0
	ld	a, (x)
	cp	a, #0x18
	jreq	00106$
;	tbasic.c: 1525: err = ERR_VWOEQ;
	mov	_err+0, #0x12
;	tbasic.c: 1526: return;
	jra	00109$
00106$:
;	tbasic.c: 1528: cip++;
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
;	tbasic.c: 1530: value = iexp();
	call	_iexp
;	tbasic.c: 1531: if (err) return;
	tnz	_err+0
	jrne	00109$
;	tbasic.c: 1533: arr[index] = value;
	ldw	y, #_arr+0
	ldw	(0x03, sp), y
	ldw	y, (0x01, sp)
	sllw	y
	addw	y, (0x03, sp)
	ldw	(y), x
00109$:
	addw	sp, #4
	ret
;	tbasic.c: 1536: void ilet(void)
;	-----------------------------------------
;	 function ilet
;	-----------------------------------------
_ilet:
;	tbasic.c: 1538: switch (*cip)
	ldw	x, _cip+0
	ld	a, (x)
;	tbasic.c: 1542: cip++;
	ldw	x, _cip+0
	incw	x
;	tbasic.c: 1538: switch (*cip)
	cp	a, #0x1b
	jreq	00102$
	cp	a, #0x28
	jrne	00103$
;	tbasic.c: 1542: cip++;
	ldw	_cip+0, x
;	tbasic.c: 1543: ivar();                 // Variable assignment
	call	_ivar
;	tbasic.c: 1544: break;
	jra	00105$
;	tbasic.c: 1546: case I_ARRAY:
00102$:
;	tbasic.c: 1548: cip++;
	ldw	_cip+0, x
;	tbasic.c: 1549: iarray();               // Array assignment
	call	_iarray
;	tbasic.c: 1550: break;
	jra	00105$
;	tbasic.c: 1552: default:
00103$:
;	tbasic.c: 1554: err = ERR_LETWOV;
	mov	_err+0, #0x0e
;	tbasic.c: 1557: }
00105$:
	ret
;	tbasic.c: 1560: uint8_t *iexe(void)
;	-----------------------------------------
;	 function iexe
;	-----------------------------------------
_iexe:
	sub	sp, #36
;	tbasic.c: 1570: while (*cip != I_EOL)
	ldw	x, #_var+0
	ldw	(0x13, sp), x
	ldw	x, #_lstk+0
	ldw	(0x19, sp), x
	ldw	x, #_gstk+0
	ldw	(0x15, sp), x
00188$:
	ldw	x, _cip+0
	ld	a, (x)
	cp	a, #0x2a
	jrne	00402$
	jp	00190$
00402$:
;	tbasic.c: 1572: if (uart_ischar())
	call	_uart_ischar
	tnz	a
	jreq	00104$
;	tbasic.c: 1574: if (uart_readkey() == 27)               // ESC
	call	_uart_readkey
	cp	a, #0x1b
	jrne	00104$
;	tbasic.c: 1576: err = ERR_ESC;
	mov	_err+0, #0x16
;	tbasic.c: 1577: return NULL;
	clrw	x
	jp	00191$
00104$:
;	tbasic.c: 1581: switch (*cip)
	ldw	x, _cip+0
	ld	a, (x)
	ld	xh, a
	push	a
	ld	a, xh
	cp	a, #0x00
	pop	a
	jrne	00409$
	jp	00116$
00409$:
	cp	a, #0x01
	jrne	00412$
	jp	00121$
00412$:
	cp	a, #0x02
	jrne	00415$
	jp	00128$
00415$:
	cp	a, #0x03
	jrne	00418$
	jp	00131$
00418$:
	cp	a, #0x06
	jrne	00421$
	jp	00149$
00421$:
	cp	a, #0x07
	jrne	00424$
	jp	00161$
00424$:
	cp	a, #0x08
	jrne	00427$
	jp	00167$
00427$:
	cp	a, #0x09
	jrne	00430$
	jp	00171$
00430$:
	cp	a, #0x0a
	jrne	00433$
	jp	00179$
00433$:
	cp	a, #0x0b
	jrne	00436$
	jp	00178$
00436$:
	cp	a, #0x0c
	jrne	00439$
	jp	00177$
00439$:
	cp	a, #0x0e
	jrne	00442$
	jp	00183$
00442$:
	cp	a, #0x1b
	jrne	00445$
	jp	00175$
00445$:
	cp	a, #0x1f
	jrne	00448$
	jp	00176$
00448$:
	cp	a, #0x21
	jreq	00105$
	cp	a, #0x22
	jrne	00454$
	jp	00182$
00454$:
	cp	a, #0x23
	jrne	00457$
	jp	00182$
00457$:
	cp	a, #0x24
	jrne	00460$
	jp	00182$
00460$:
	cp	a, #0x28
	jrne	00463$
	jp	00174$
00463$:
	jp	00184$
;	tbasic.c: 1583: case I_SCALL:
00105$:
;	tbasic.c: 1585: cip++;
	ldw	x, _cip+0
	incw	x
;	tbasic.c: 1586: if (*cip != I_NUM)
	ldw	_cip+0, x
	ld	a, (x)
	cp	a, #0x27
	jreq	00107$
;	tbasic.c: 1588: err= ERR_NOVAL;
	mov	_err+0, #0x18
;	tbasic.c: 1589: break;
	jp	00185$
00107$:
;	tbasic.c: 1592: cip++;
	ldw	x, _cip+0
	incw	x
;	tbasic.c: 1593: arg1 = *cip;
	ldw	_cip+0, x
	ld	a, (x)
	clrw	x
	ld	xl, a
	ldw	(0x17, sp), x
;	tbasic.c: 1594: cip++;
	ldw	x, _cip+0
	incw	x
;	tbasic.c: 1595: arg1 += (*cip << 8);
	ldw	_cip+0, x
	ld	a, (x)
	ld	xh, a
	clr	a
	clr	a
	ld	xl, a
	addw	x, (0x17, sp)
	ldw	(0x07, sp), x
;	tbasic.c: 1597: cip++;                      // Komma abfragen
	ldw	x, _cip+0
	incw	x
;	tbasic.c: 1598: if (*cip != I_COMMA)
	ldw	_cip+0, x
	ld	a, (x)
	cp	a, #0x0d
	jreq	00109$
;	tbasic.c: 1600: err= ERR_NOVAL;
	mov	_err+0, #0x18
;	tbasic.c: 1601: break;
	jp	00185$
00109$:
;	tbasic.c: 1604: cip++;
	ldw	x, _cip+0
	incw	x
;	tbasic.c: 1606: if ((*cip != I_NUM) && (*cip != I_VAR))
	ldw	_cip+0, x
	ld	a, (x)
	cp	a, #0x27
	jreq	00111$
	ldw	x, _cip+0
	ld	a, (x)
	cp	a, #0x28
	jreq	00111$
;	tbasic.c: 1608: err= ERR_NOVAL;
	mov	_err+0, #0x18
;	tbasic.c: 1609: break;
	jp	00185$
00111$:
;	tbasic.c: 1612: if (*cip == I_NUM)
	ldw	x, _cip+0
	ld	a, (x)
	cp	a, #0x27
	jrne	00114$
;	tbasic.c: 1614: cip++;
	ldw	x, _cip+0
	incw	x
;	tbasic.c: 1615: arg2= *cip;
	ldw	_cip+0, x
	ld	a, (x)
	clrw	x
	ld	xl, a
	ldw	(0x1f, sp), x
;	tbasic.c: 1616: cip++;
	ldw	x, _cip+0
	incw	x
;	tbasic.c: 1617: arg2 += (*cip << 8);
	ldw	_cip+0, x
	ld	a, (x)
	ld	xh, a
	clr	a
	clr	a
	ld	xl, a
	addw	x, (0x1f, sp)
	ldw	(0x09, sp), x
	jra	00115$
00114$:
;	tbasic.c: 1621: cip++;
	ldw	x, _cip+0
	incw	x
;	tbasic.c: 1622: arg2= var[*cip];
	ldw	_cip+0, x
	ld	a, (x)
	clrw	x
	ld	xl, a
	sllw	x
	addw	x, (0x13, sp)
	ldw	x, (x)
	ldw	(0x09, sp), x
00115$:
;	tbasic.c: 1625: cip++;
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
;	tbasic.c: 1626: sysfunc(arg1, arg2);
	ldw	x, (0x09, sp)
	pushw	x
	ldw	x, (0x09, sp)
	pushw	x
	call	_sysfunc
	addw	sp, #4
;	tbasic.c: 1627: break;
	jp	00185$
;	tbasic.c: 1629: case I_GOTO:
00116$:
;	tbasic.c: 1631: cip++;
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
;	tbasic.c: 1632: lineno = iexp();
	call	_iexp
	ldw	(0x21, sp), x
;	tbasic.c: 1633: if (err) break;
	tnz	_err+0
	jreq	00480$
	jp	00185$
00480$:
;	tbasic.c: 1634: lp = getlp(lineno);                   // Zeilennummer suchen
	ldw	x, (0x21, sp)
	pushw	x
	call	_getlp
	addw	sp, #2
;	tbasic.c: 1635: if (lineno != getlineno(lp))          // wenn nicht gefunden
	pushw	x
	pushw	x
	call	_getlineno
	addw	sp, #2
	ldw	(0x25, sp), x
	ldw	x, (0x23, sp)
	cpw	x, (0x25, sp)
	popw	x
	jreq	00120$
;	tbasic.c: 1637: err = ERR_ULN;
	mov	_err+0, #0x10
;	tbasic.c: 1638: break;
	jp	00185$
00120$:
;	tbasic.c: 1641: clp = lp;
;	tbasic.c: 1642: cip = clp + 3;
	ldw	_clp+0, x
	addw	x, #0x0003
	ldw	_cip+0, x
;	tbasic.c: 1643: break;
	jp	00185$
;	tbasic.c: 1645: case I_GOSUB:
00121$:
;	tbasic.c: 1647: cip++;
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
;	tbasic.c: 1648: lineno = iexp();
	call	_iexp
	ldw	(0x0b, sp), x
;	tbasic.c: 1649: if (err) break;
	tnz	_err+0
	jreq	00484$
	jp	00185$
00484$:
;	tbasic.c: 1650: lp = getlp(lineno);
	ldw	x, (0x0b, sp)
	pushw	x
	call	_getlp
	addw	sp, #2
	ldw	(0x03, sp), x
;	tbasic.c: 1651: if (lineno != getlineno(lp))
	ldw	x, (0x03, sp)
	pushw	x
	call	_getlineno
	addw	sp, #2
	ldw	(0x0f, sp), x
	ldw	x, (0x0b, sp)
	cpw	x, (0x0f, sp)
	jreq	00125$
;	tbasic.c: 1653: err = ERR_ULN;
	mov	_err+0, #0x10
;	tbasic.c: 1654: break;
	jp	00185$
00125$:
;	tbasic.c: 1658: if (gstki > SIZE_GSTK - 2)             // stack overflow ?
	ld	a, _gstki+0
	cp	a, #0x04
	jrule	00127$
;	tbasic.c: 1660: err = ERR_GSTKOF;
	mov	_err+0, #0x06
;	tbasic.c: 1661: break;
	jp	00185$
00127$:
;	tbasic.c: 1663: gstk[gstki++] = clp;
	ld	a, _gstki+0
	ld	xl, a
	inc	_gstki+0
	clr	a
	ld	xh, a
	sllw	x
	addw	x, (0x15, sp)
	ldw	y, _clp+0
	ldw	(x), y
;	tbasic.c: 1664: gstk[gstki++] = cip;
	ld	a, _gstki+0
	ld	xl, a
	inc	_gstki+0
	clr	a
	ld	xh, a
	sllw	x
	addw	x, (0x15, sp)
	ldw	y, _cip+0
	ldw	(x), y
;	tbasic.c: 1666: clp = lp;
	ld	a, (0x04, sp)
	ld	_clp+1, a
	ld	a, (0x03, sp)
	ld	_clp+0, a
;	tbasic.c: 1667: cip = clp + 3;
	ldw	x, _clp+0
	addw	x, #0x0003
	ldw	_cip+0, x
;	tbasic.c: 1668: break;
	jp	00185$
;	tbasic.c: 1670: case I_RETURN:
00128$:
;	tbasic.c: 1672: if (gstki < 2)                         // stack underflow ?
	ld	a, _gstki+0
	cp	a, #0x02
	jrnc	00130$
;	tbasic.c: 1674: err = ERR_GSTKUF;
	mov	_err+0, #0x07
;	tbasic.c: 1675: break;
	jp	00185$
00130$:
;	tbasic.c: 1677: cip = gstk[--gstki];
	dec	_gstki+0
	clrw	x
	ld	a, _gstki+0
	ld	xl, a
	sllw	x
	addw	x, (0x15, sp)
	ldw	x, (x)
	ldw	_cip+0, x
;	tbasic.c: 1678: clp = gstk[--gstki];
	dec	_gstki+0
	clrw	x
	ld	a, _gstki+0
	ld	xl, a
	sllw	x
	addw	x, (0x15, sp)
	ldw	x, (x)
	ldw	_clp+0, x
;	tbasic.c: 1679: break;
	jp	00185$
;	tbasic.c: 1681: case I_FOR:
00131$:
;	tbasic.c: 1683: cip++;
	ldw	x, _cip+0
	incw	x
;	tbasic.c: 1685: if (*cip++ != I_VAR)
	ldw	_cip+0, x
	ld	a, (x)
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
	cp	a, #0x28
	jreq	00133$
;	tbasic.c: 1687: err = ERR_FORWOV;
	mov	_err+0, #0x0c
;	tbasic.c: 1688: break;
	jp	00185$
00133$:
;	tbasic.c: 1691: index = *cip;
	ldw	x, _cip+0
	ld	a, (x)
	clrw	x
	ld	xl, a
	ldw	(0x11, sp), x
;	tbasic.c: 1692: ivar();
	call	_ivar
;	tbasic.c: 1693: if (err) break;
	tnz	_err+0
	jreq	00493$
	jp	00185$
00493$:
;	tbasic.c: 1695: if (*cip == I_TO)
	ldw	x, _cip+0
	ld	a, (x)
	cp	a, #0x04
	jrne	00137$
;	tbasic.c: 1697: cip++;
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
;	tbasic.c: 1698: vto = iexp();
	call	_iexp
	ldw	(0x1b, sp), x
	jra	00138$
00137$:
;	tbasic.c: 1702: err = ERR_FORWOTO;
	mov	_err+0, #0x0d
;	tbasic.c: 1703: break;
	jp	00185$
00138$:
;	tbasic.c: 1706: if (*cip == I_STEP)
	ldw	x, _cip+0
	ld	a, (x)
	cp	a, #0x05
	jrne	00140$
;	tbasic.c: 1708: cip++;
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
;	tbasic.c: 1709: vstep = iexp();
	call	_iexp
	ldw	(0x1d, sp), x
	jra	00141$
00140$:
;	tbasic.c: 1713: vstep = 1;
	ldw	x, #0x0001
	ldw	(0x1d, sp), x
00141$:
;	tbasic.c: 1718: if (((vstep < 0) && (-32767 - vstep > vto)) ||
	tnz	(0x1d, sp)
	jrpl	00146$
	ldw	x, #0x8001
	subw	x, (0x1d, sp)
	cpw	x, (0x1b, sp)
	jrsgt	00142$
00146$:
;	tbasic.c: 1719: ((vstep > 0) && (32767 - vstep < vto)))
	ldw	x, (0x1d, sp)
	cpw	x, #0x0000
	jrsle	00143$
	ldw	x, #0x7fff
	subw	x, (0x1d, sp)
	cpw	x, (0x1b, sp)
	jrsge	00143$
00142$:
;	tbasic.c: 1721: err = ERR_VOF;
	mov	_err+0, #0x02
;	tbasic.c: 1722: break;
	jp	00185$
00143$:
;	tbasic.c: 1726: if (lstki > SIZE_LSTK - 5)                   // stack overflow ?
	ld	a, _lstki+0
	cp	a, #0x0a
	jrule	00148$
;	tbasic.c: 1728: err = ERR_LSTKOF;
	mov	_err+0, #0x08
;	tbasic.c: 1729: break;
	jp	00185$
00148$:
;	tbasic.c: 1731: lstk[lstki++] = clp;
	ld	a, _lstki+0
	ld	xl, a
	inc	_lstki+0
	clr	a
	ld	xh, a
	sllw	x
	addw	x, (0x19, sp)
	ldw	y, _clp+0
	ldw	(x), y
;	tbasic.c: 1732: lstk[lstki++] = cip;
	ld	a, _lstki+0
	ld	xl, a
	inc	_lstki+0
	clr	a
	ld	xh, a
	sllw	x
	addw	x, (0x19, sp)
	ldw	y, _cip+0
	ldw	(x), y
;	tbasic.c: 1734: lstk[lstki++] = (uint8_t*)(uintptr_t)vto;
	ld	a, _lstki+0
	ld	xl, a
	inc	_lstki+0
	clr	a
	ld	xh, a
	sllw	x
	addw	x, (0x19, sp)
	ldw	y, (0x1b, sp)
	ldw	(x), y
;	tbasic.c: 1735: lstk[lstki++] = (uint8_t*)(uintptr_t)vstep;
	ld	a, _lstki+0
	ld	xl, a
	inc	_lstki+0
	clr	a
	ld	xh, a
	sllw	x
	addw	x, (0x19, sp)
	ldw	y, (0x1d, sp)
	ldw	(x), y
;	tbasic.c: 1736: lstk[lstki++] = (uint8_t*)(uintptr_t)index;
	ld	a, _lstki+0
	ld	xl, a
	inc	_lstki+0
	clr	a
	ld	xh, a
	sllw	x
	addw	x, (0x19, sp)
	ldw	y, (0x11, sp)
	ldw	(x), y
;	tbasic.c: 1737: break;
	jp	00185$
;	tbasic.c: 1739: case I_NEXT:
00149$:
;	tbasic.c: 1741: cip++;
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
;	tbasic.c: 1743: if (lstki < 5)                              // leerer Stack
	ld	a, _lstki+0
	cp	a, #0x05
	jrnc	00151$
;	tbasic.c: 1745: err = ERR_LSTKUF;
	mov	_err+0, #0x09
;	tbasic.c: 1746: break;
	jp	00185$
00151$:
;	tbasic.c: 1749: index = (int16_t)(uintptr_t)lstk[lstki - 1];
	ld	a, _lstki+0
	dec	a
	clrw	x
	ld	xl, a
	sllw	x
	addw	x, (0x19, sp)
	ldw	x, (x)
	ldw	(0x0d, sp), x
;	tbasic.c: 1750: if (*cip++ != I_VAR)
	ldw	x, _cip+0
	ld	a, (x)
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
	cp	a, #0x28
	jreq	00153$
;	tbasic.c: 1752: err = ERR_NEXTWOV;
	mov	_err+0, #0x0a
;	tbasic.c: 1753: break;
	jp	00185$
00153$:
;	tbasic.c: 1755: if (*cip++ != index)
	ldw	x, _cip+0
	ld	a, (x)
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
	clrw	x
	ld	xl, a
	cpw	x, (0x0d, sp)
	jreq	00155$
;	tbasic.c: 1757: err = ERR_NEXTUM;
	mov	_err+0, #0x0b
;	tbasic.c: 1758: break;
	jp	00185$
00155$:
;	tbasic.c: 1761: vstep = (int16_t)(uintptr_t)lstk[lstki - 2];
	ld	a, _lstki+0
	sub	a, #0x02
	clrw	x
	ld	xl, a
	sllw	x
	addw	x, (0x19, sp)
	ldw	x, (x)
	ldw	(0x01, sp), x
;	tbasic.c: 1762: var[index] += vstep;
	ldw	x, (0x0d, sp)
	sllw	x
	addw	x, (0x13, sp)
	pushw	x
	ldw	x, (x)
	exgw	x, y
	popw	x
	addw	y, (0x01, sp)
	ldw	(x), y
;	tbasic.c: 1763: vto = (int16_t)(uintptr_t)lstk[lstki - 3];
	ld	a, _lstki+0
	sub	a, #0x03
	clrw	x
	ld	xl, a
	sllw	x
	addw	x, (0x19, sp)
	ldw	x, (x)
	ldw	(0x05, sp), x
;	tbasic.c: 1766: if (((vstep < 0) && (var[index] < vto)) ||
	tnz	(0x01, sp)
	jrpl	00160$
	ldw	x, (0x0d, sp)
	sllw	x
	addw	x, (0x13, sp)
	ldw	x, (x)
	cpw	x, (0x05, sp)
	jrslt	00156$
00160$:
;	tbasic.c: 1767: ((vstep > 0) && (var[index] > vto)))
	ldw	x, (0x01, sp)
	cpw	x, #0x0000
	jrsle	00157$
	ldw	x, (0x0d, sp)
	sllw	x
	addw	x, (0x13, sp)
	ldw	x, (x)
	cpw	x, (0x05, sp)
	jrsle	00157$
00156$:
;	tbasic.c: 1769: lstki -= 5;
	ld	a, _lstki+0
	sub	a, #0x05
	ld	_lstki+0, a
;	tbasic.c: 1770: break;
	jp	00185$
00157$:
;	tbasic.c: 1774: cip = lstk[lstki - 4];
	ld	a, _lstki+0
	sub	a, #0x04
	clrw	x
	ld	xl, a
	sllw	x
	addw	x, (0x19, sp)
	ldw	x, (x)
	ldw	_cip+0, x
;	tbasic.c: 1775: clp = lstk[lstki - 5];
	ld	a, _lstki+0
	sub	a, #0x05
	clrw	x
	ld	xl, a
	sllw	x
	addw	x, (0x19, sp)
	ldw	x, (x)
	ldw	_clp+0, x
;	tbasic.c: 1776: break;
	jp	00185$
;	tbasic.c: 1779: case I_IF:
00161$:
;	tbasic.c: 1781: cip++;
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
;	tbasic.c: 1782: condition = iexp();
	call	_iexp
;	tbasic.c: 1783: if (err)
	tnz	_err+0
	jreq	00163$
;	tbasic.c: 1785: err = ERR_IFWOC;
	mov	_err+0, #0x0f
;	tbasic.c: 1786: break;
	jp	00185$
00163$:
;	tbasic.c: 1788: if (condition) break;
	tnzw	x
	jreq	00517$
	jp	00185$
00517$:
;	tbasic.c: 1792: while (*cip != I_EOL) cip++;
00167$:
	ldw	x, _cip+0
	ld	a, (x)
	cp	a, #0x2a
	jrne	00519$
	jp	00185$
00519$:
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
	jra	00167$
;	tbasic.c: 1797: while (*clp) clp += *clp;
00171$:
	ldw	x, _clp+0
	ld	a, (x)
	tnz	a
	jreq	00173$
	ldw	x, _clp+0
	ld	a, (x)
	clrw	x
	ld	xl, a
	addw	x, _clp+0
	ldw	_clp+0, x
	jra	00171$
00173$:
;	tbasic.c: 1798: return clp;
	ldw	x, _clp+0
	jra	00191$
;	tbasic.c: 1800: case I_VAR:
00174$:
;	tbasic.c: 1802: cip++;
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
;	tbasic.c: 1803: ivar();
	call	_ivar
;	tbasic.c: 1804: break;
	jra	00185$
;	tbasic.c: 1806: case I_ARRAY:
00175$:
;	tbasic.c: 1808: cip++;
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
;	tbasic.c: 1809: iarray();
	call	_iarray
;	tbasic.c: 1810: break;
	jra	00185$
;	tbasic.c: 1812: case I_OUT:
00176$:
;	tbasic.c: 1814: cip++;
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
;	tbasic.c: 1815: ioutput();
	call	_ioutput
;	tbasic.c: 1816: break;
	jra	00185$
;	tbasic.c: 1818: case I_LET:
00177$:
;	tbasic.c: 1820: cip++;
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
;	tbasic.c: 1821: ilet();
	call	_ilet
;	tbasic.c: 1822: break;
	jra	00185$
;	tbasic.c: 1824: case I_PRINT:
00178$:
;	tbasic.c: 1826: cip++;
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
;	tbasic.c: 1827: iprint();
	call	_iprint
;	tbasic.c: 1828: break;
	jra	00185$
;	tbasic.c: 1830: case I_INPUT:
00179$:
;	tbasic.c: 1832: cip++;
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
;	tbasic.c: 1833: iinput();
	call	_iinput
;	tbasic.c: 1834: break;
	jra	00185$
;	tbasic.c: 1838: case I_RUN:
00182$:
;	tbasic.c: 1840: err = ERR_COM;
	mov	_err+0, #0x13
;	tbasic.c: 1841: break;
	jra	00185$
;	tbasic.c: 1843: case I_SEMI:
00183$:
;	tbasic.c: 1845: cip++;
	ldw	x, _cip+0
	incw	x
	ldw	_cip+0, x
;	tbasic.c: 1846: break;
	jra	00185$
;	tbasic.c: 1849: default:
00184$:
;	tbasic.c: 1851: err = ERR_SYNTAX;
	mov	_err+0, #0x14
;	tbasic.c: 1854: }
00185$:
;	tbasic.c: 1856: if (err) return NULL;
	tnz	_err+0
	jrne	00522$
	jp	00188$
00522$:
	clrw	x
	jra	00191$
00190$:
;	tbasic.c: 1858: return clp + *clp;
	ldw	x, _clp+0
	ld	a, (x)
	clrw	x
	ld	xl, a
	addw	x, _clp+0
00191$:
	addw	sp, #36
	ret
;	tbasic.c: 1861: void irun(void)
;	-----------------------------------------
;	 function irun
;	-----------------------------------------
_irun:
;	tbasic.c: 1865: gstki = 0;
	clr	_gstki+0
;	tbasic.c: 1866: lstki = 0;
	clr	_lstki+0
;	tbasic.c: 1867: clp = listbuf;
	ldw	x, #_listbuf+0
	ldw	_clp+0, x
;	tbasic.c: 1869: while (*clp)
00103$:
	ldw	x, _clp+0
	ld	a, (x)
	tnz	a
	jreq	00106$
;	tbasic.c: 1871: cip = clp + 3;
	ldw	x, _clp+0
	addw	x, #0x0003
	ldw	_cip+0, x
;	tbasic.c: 1872: lp = iexe();
	call	_iexe
;	tbasic.c: 1873: if (err) return;
	tnz	_err+0
	jrne	00106$
;	tbasic.c: 1874: clp = lp;
	ldw	_clp+0, x
	jra	00103$
00106$:
	ret
;	tbasic.c: 1878: void ilist(void)
;	-----------------------------------------
;	 function ilist
;	-----------------------------------------
_ilist:
	pushw	x
;	tbasic.c: 1882: lineno = (*cip == I_NUM) ? getlineno(cip) : 0;
	ldw	x, _cip+0
	ld	a, (x)
	cp	a, #0x27
	jrne	00113$
	ldw	x, _cip+0
	pushw	x
	call	_getlineno
	addw	sp, #2
	.byte 0x21
00113$:
	clrw	x
00114$:
	ldw	(0x01, sp), x
;	tbasic.c: 1884: for (clp = listbuf;
	ldw	x, #_listbuf+0
	ldw	_clp+0, x
00109$:
;	tbasic.c: 1885: *clp && (getlineno(clp) < lineno);
	ldw	x, _clp+0
	ld	a, (x)
	tnz	a
	jreq	00104$
	ldw	x, _clp+0
	pushw	x
	call	_getlineno
	addw	sp, #2
	cpw	x, (0x01, sp)
	jrsge	00104$
;	tbasic.c: 1886: clp += *clp);
	ldw	x, _clp+0
	ld	a, (x)
	clrw	x
	ld	xl, a
	addw	x, _clp+0
	ldw	_clp+0, x
	jra	00109$
;	tbasic.c: 1888: while (*clp)
00104$:
	ldw	x, _clp+0
	ld	a, (x)
	tnz	a
	jreq	00111$
;	tbasic.c: 1890: putnum(getlineno(clp), 0);
	ldw	x, _clp+0
	pushw	x
	call	_getlineno
	addw	sp, #2
	push	#0x00
	push	#0x00
	pushw	x
	call	_putnum
	addw	sp, #4
;	tbasic.c: 1891: uart_putchar(' ');
	push	#0x20
	call	_uart_putchar
	pop	a
;	tbasic.c: 1892: putlist(clp + 3);
	ldw	x, _clp+0
	addw	x, #0x0003
	pushw	x
	call	_putlist
	popw	x
;	tbasic.c: 1893: if (err) break;
	tnz	_err+0
	jrne	00111$
;	tbasic.c: 1894: newline();
	call	_newline
;	tbasic.c: 1895: clp += *clp;
	ldw	x, _clp+0
	ld	a, (x)
	clrw	x
	ld	xl, a
	addw	x, _clp+0
	ldw	_clp+0, x
	jra	00104$
00111$:
	popw	x
	ret
;	tbasic.c: 1900: void inew(void)
;	-----------------------------------------
;	 function inew
;	-----------------------------------------
_inew:
	sub	sp, #4
;	tbasic.c: 1904: for (i = 0; i < 26; i++) var[i] = 0;
	ldw	x, #_var+0
	ldw	(0x01, sp), x
	clr	a
00103$:
	clrw	x
	ld	xl, a
	sllw	x
	addw	x, (0x01, sp)
	clr	(0x1, x)
	clr	(x)
	inc	a
	cp	a, #0x1a
	jrc	00103$
;	tbasic.c: 1905: for (i = 0; i < SIZE_ARRY; i++) arr[i] = 0;
	ldw	x, #_arr+0
	ldw	(0x03, sp), x
	clr	a
00105$:
	clrw	x
	ld	xl, a
	sllw	x
	addw	x, (0x03, sp)
	clr	(0x1, x)
	clr	(x)
	inc	a
	cp	a, #0x20
	jrc	00105$
;	tbasic.c: 1906: gstki = 0;
	clr	_gstki+0
;	tbasic.c: 1907: lstki = 0;
	clr	_lstki+0
;	tbasic.c: 1908: *listbuf = 0;
	ldw	x, #_listbuf+0
	clr	(x)
;	tbasic.c: 1909: clp = listbuf;
	ldw	_clp+0, x
	addw	sp, #4
	ret
;	tbasic.c: 1912: void icom(void)
;	-----------------------------------------
;	 function icom
;	-----------------------------------------
_icom:
	push	a
;	tbasic.c: 1916: cip = ibuf;
	ldw	x, #_ibuf+0
;	tbasic.c: 1917: switch (*cip)
	ldw	_cip+0, x
	ld	a, (x)
	ld	(0x01, sp), a
;	tbasic.c: 1932: cip++;
	ldw	x, _cip+0
	incw	x
;	tbasic.c: 1917: switch (*cip)
	ld	a, (0x01, sp)
	cp	a, #0x22
	jreq	00107$
	ld	a, (0x01, sp)
	cp	a, #0x23
	jreq	00112$
	ld	a, (0x01, sp)
	cp	a, #0x24
	jreq	00103$
	ld	a, (0x01, sp)
	cp	a, #0x25
	jreq	00101$
	ld	a, (0x01, sp)
	cp	a, #0x26
	jreq	00102$
	jra	00113$
;	tbasic.c: 1919: case I_SAVE:
00101$:
;	tbasic.c: 1921: saveprog();
	call	_saveprog
;	tbasic.c: 1922: break;
	jra	00115$
;	tbasic.c: 1924: case I_LOAD:
00102$:
;	tbasic.c: 1926: loadprog();
	call	_loadprog
;	tbasic.c: 1927: break;
	jra	00115$
;	tbasic.c: 1930: case I_NEW:
00103$:
;	tbasic.c: 1932: cip++;
;	tbasic.c: 1933: if (*cip == I_EOL)
	ldw	_cip+0, x
	ld	a, (x)
	cp	a, #0x2a
	jrne	00105$
;	tbasic.c: 1934: inew();
	call	_inew
	jra	00115$
00105$:
;	tbasic.c: 1936: err = ERR_SYNTAX;
	mov	_err+0, #0x14
;	tbasic.c: 1937: break;
	jra	00115$
;	tbasic.c: 1939: case I_LIST:
00107$:
;	tbasic.c: 1941: cip++;
;	tbasic.c: 1942: if (*cip == I_EOL || *(cip + 3) == I_EOL)
	ldw	_cip+0, x
	ld	a, (x)
	cp	a, #0x2a
	jreq	00108$
	ldw	x, _cip+0
	ld	a, (0x3, x)
	cp	a, #0x2a
	jrne	00109$
00108$:
;	tbasic.c: 1943: ilist();
	call	_ilist
	jra	00115$
00109$:
;	tbasic.c: 1945: err = ERR_SYNTAX;
	mov	_err+0, #0x14
;	tbasic.c: 1946: break;
	jra	00115$
;	tbasic.c: 1948: case I_RUN:
00112$:
;	tbasic.c: 1950: cip++;
	ldw	_cip+0, x
;	tbasic.c: 1951: irun();
	call	_irun
;	tbasic.c: 1952: break;
	jra	00115$
;	tbasic.c: 1954: default:
00113$:
;	tbasic.c: 1956: iexe();
	call	_iexe
;	tbasic.c: 1959: }
00115$:
	pop	a
	ret
;	tbasic.c: 1962: void error()
;	-----------------------------------------
;	 function error
;	-----------------------------------------
_error:
	sub	sp, #6
;	tbasic.c: 1965: if (err)
	tnz	_err+0
	jreq	00107$
;	tbasic.c: 1967: if (cip >= listbuf && cip < listbuf + SIZE_LIST && *clp)
	ldw	y, #_listbuf+0
	ldw	(0x05, sp), y
	ldw	x, (0x05, sp)
	cpw	x, _cip+0
	jrugt	00102$
	addw	y, #0x0200
	ldw	(0x03, sp), y
	ldw	x, (0x03, sp)
	cpw	x, _cip+0
	jrule	00102$
	ldw	x, _clp+0
	ld	a, (x)
	tnz	a
	jreq	00102$
;	tbasic.c: 1969: newline();
	call	_newline
;	tbasic.c: 1970: uart_putstring("LINE:");
	ldw	x, #___str_5+0
	pushw	x
	call	_uart_putstring
	popw	x
;	tbasic.c: 1971: putnum(getlineno(clp), 0);
	ldw	x, _clp+0
	pushw	x
	call	_getlineno
	addw	sp, #2
	push	#0x00
	push	#0x00
	pushw	x
	call	_putnum
	addw	sp, #4
;	tbasic.c: 1972: uart_putchar(' ');
	push	#0x20
	call	_uart_putchar
	pop	a
;	tbasic.c: 1973: putlist(clp + 3);
	ldw	x, _clp+0
	addw	x, #0x0003
	pushw	x
	call	_putlist
	popw	x
	jra	00107$
00102$:
;	tbasic.c: 1977: newline();
	call	_newline
;	tbasic.c: 1978: uart_putstring("YOU TYPE: ");
	ldw	x, #___str_6+0
	pushw	x
	call	_uart_putstring
	popw	x
;	tbasic.c: 1979: uart_putstring(lbuf);
	ldw	x, #_lbuf+0
	pushw	x
	call	_uart_putstring
	popw	x
00107$:
;	tbasic.c: 1982: newline();
	call	_newline
;	tbasic.c: 1983: uart_putstring(errmsg[err]);
	ldw	x, #_errmsg+0
	ldw	(0x01, sp), x
	clrw	x
	ld	a, _err+0
	ld	xl, a
	sllw	x
	addw	x, (0x01, sp)
	ldw	x, (x)
	pushw	x
	call	_uart_putstring
	popw	x
;	tbasic.c: 1984: newline();
	call	_newline
;	tbasic.c: 1985: err = 0;
	clr	_err+0
	addw	sp, #6
	ret
;	tbasic.c: 1994: void basic()
;	-----------------------------------------
;	 function basic
;	-----------------------------------------
_basic:
	push	a
;	tbasic.c: 2001: uart_putstring("\n\STM8S103F3P6 -- TBasic -- 57600Bd 8n1\n\r");
	ldw	x, #___str_7+0
	pushw	x
	call	_uart_putstring
	popw	x
;	tbasic.c: 2002: strcpy(lbuf,"print \"  \",size(),\" Bytes free\"");
	ldw	x, #___str_8+0
	ldw	y, #_lbuf+0
	pushw	x
	pushw	y
	call	_strcpy
	addw	sp, #4
;	tbasic.c: 2003: len = toktoi();  
	call	_toktoi
;	tbasic.c: 2004: icom();
	call	_icom
;	tbasic.c: 2006: error();                              // Fehlerflag loeschen, OK als Prompt
	call	_error
;	tbasic.c: 2010: while (1)
00108$:
;	tbasic.c: 2012: uart_putstring("> ");
	ldw	x, #___str_9+0
	pushw	x
	call	_uart_putstring
	popw	x
;	tbasic.c: 2013: uart_getstring();
	call	_uart_getstring
;	tbasic.c: 2015: len = toktoi();
	call	_toktoi
	ld	(0x01, sp), a
;	tbasic.c: 2016: if (err)
	tnz	_err+0
	jreq	00102$
;	tbasic.c: 2018: error();
	call	_error
;	tbasic.c: 2019: continue;
	jra	00108$
00102$:
;	tbasic.c: 2022: if (*ibuf == I_NUM)
	ldw	x, #_ibuf+0
	ld	a, (x)
	cp	a, #0x27
	jrne	00106$
;	tbasic.c: 2024: *ibuf = len;
	ld	a, (0x01, sp)
	ld	(x), a
;	tbasic.c: 2025: inslist();
	call	_inslist
;	tbasic.c: 2026: if (err)  error();
	tnz	_err+0
	jreq	00108$
	call	_error
;	tbasic.c: 2027: continue;
	jra	00108$
00106$:
;	tbasic.c: 2030: icom();                     // direkte Kommandoausfuehrung
	call	_icom
;	tbasic.c: 2031: error();                    // Fehler loeschen, OK ausgeben
	call	_error
	jra	00108$
	pop	a
	ret
;	tbasic.c: 2107: void sysfunc(int16_t v1, int16_t v2)
;	-----------------------------------------
;	 function sysfunc
;	-----------------------------------------
_sysfunc:
;	tbasic.c: 2109: switch (v1)
	ldw	x, (0x03, sp)
	cpw	x, #0x0001
	jrne	00104$
;	tbasic.c: 2113: uart_putchar(v2 & 0xff);
	ld	a, (0x06, sp)
	ld	xh, a
	clr	a
	ld	a, xh
	push	a
	call	_uart_putchar
	pop	a
;	tbasic.c: 2129: }
00104$:
	ret
;	tbasic.c: 2136: int main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	tbasic.c: 2139: sysclock_init();
	call	_sysclock_init
;	tbasic.c: 2140: uart_init();
	call	_uart_init
;	tbasic.c: 2142: inew();
	call	_inew
;	tbasic.c: 2144: basic();
	call	_basic
;	tbasic.c: 2145: return 0;
	clrw	x
	ret
	.area CODE
_i_nsa:
	.db #0x02	; 2
	.db #0x09	; 9
	.db #0x0D	; 13
	.db #0x0F	; 15
	.db #0x10	; 16
	.db #0x11	; 17
	.db #0x12	; 18
	.db #0x13	; 19
	.db #0x14	; 20
	.db #0x15	; 21
	.db #0x16	; 22
	.db #0x17	; 23
	.db #0x18	; 24
	.db #0x19	; 25
	.db #0x1A	; 26
	.db #0x1B	; 27
	.db #0x1C	; 28
	.db #0x1D	; 29
	.db #0x1E	; 30
	.db #0x1F	; 31
	.db #0x20	; 32
_i_nsb:
	.db #0x0F	; 15
	.db #0x10	; 16
	.db #0x11	; 17
	.db #0x12	; 18
	.db #0x13	; 19
	.db #0x14	; 20
	.db #0x15	; 21
	.db #0x16	; 22
	.db #0x17	; 23
	.db #0x18	; 24
	.db #0x19	; 25
	.db #0x1A	; 26
	.db #0x0D	; 13
	.db #0x0E	; 14
	.db #0x2A	; 42
_pinmap:
	.db #0x03	; 3
	.db #0x04	; 4
	.db #0x05	; 5
	.db #0x03	; 3
	.db #0x04	; 4
	.db #0x05	; 5
	.db #0x06	; 6
	.db #0x07	; 7
	.db #0x03	; 3
	.db #0x04	; 4
___str_0:
	.db 0x0A
	.db 0x0D
	.ascii "Done..."
	.db 0x00
___str_1:
	.db 0x0A
	.db 0x0D
	.ascii "Loading done..."
	.db 0x00
___str_2:
	.ascii ": "
	.db 0x00
___str_3:
	.ascii "@("
	.db 0x00
___str_4:
	.ascii "):"
	.db 0x00
___str_5:
	.ascii "LINE:"
	.db 0x00
___str_6:
	.ascii "YOU TYPE: "
	.db 0x00
___str_7:
	.db 0x0A
	.ascii "STM8S103F3P6 -- TBasic -- 57600Bd 8n1"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_8:
	.ascii "print "
	.db 0x22
	.ascii "  "
	.db 0x22
	.ascii ",size(),"
	.db 0x22
	.ascii " Bytes free"
	.db 0x22
	.db 0x00
___str_9:
	.ascii "> "
	.db 0x00
___str_10:
	.ascii "GOTO"
	.db 0x00
___str_11:
	.ascii "GOSUB"
	.db 0x00
___str_12:
	.ascii "RETURN"
	.db 0x00
___str_13:
	.ascii "FOR"
	.db 0x00
___str_14:
	.ascii "TO"
	.db 0x00
___str_15:
	.ascii "STEP"
	.db 0x00
___str_16:
	.ascii "NEXT"
	.db 0x00
___str_17:
	.ascii "IF"
	.db 0x00
___str_18:
	.ascii "REM"
	.db 0x00
___str_19:
	.ascii "STOP"
	.db 0x00
___str_20:
	.ascii "INPUT"
	.db 0x00
___str_21:
	.ascii "PRINT"
	.db 0x00
___str_22:
	.ascii "LET"
	.db 0x00
___str_23:
	.ascii ","
	.db 0x00
___str_24:
	.ascii ";"
	.db 0x00
___str_25:
	.ascii "-"
	.db 0x00
___str_26:
	.ascii "+"
	.db 0x00
___str_27:
	.ascii "*"
	.db 0x00
___str_28:
	.ascii "/"
	.db 0x00
___str_29:
	.ascii "("
	.db 0x00
___str_30:
	.ascii ")"
	.db 0x00
___str_31:
	.ascii ">="
	.db 0x00
___str_32:
	.ascii "#"
	.db 0x00
___str_33:
	.ascii ">"
	.db 0x00
___str_34:
	.ascii "="
	.db 0x00
___str_35:
	.ascii "<="
	.db 0x00
___str_36:
	.ascii "<"
	.db 0x00
___str_37:
	.ascii "@"
	.db 0x00
___str_38:
	.ascii "RND"
	.db 0x00
___str_39:
	.ascii "ABS"
	.db 0x00
___str_40:
	.ascii "SIZE"
	.db 0x00
___str_41:
	.ascii "OUT"
	.db 0x00
___str_42:
	.ascii "IN"
	.db 0x00
___str_43:
	.ascii "SCALL"
	.db 0x00
___str_44:
	.ascii "LIST"
	.db 0x00
___str_45:
	.ascii "RUN"
	.db 0x00
___str_46:
	.ascii "NEW"
	.db 0x00
___str_47:
	.ascii "SAVE"
	.db 0x00
___str_48:
	.ascii "LOAD"
	.db 0x00
___str_49:
	.ascii "OK"
	.db 0x00
___str_50:
	.ascii "Div by zero"
	.db 0x00
___str_51:
	.ascii "O-flow"
	.db 0x00
___str_52:
	.ascii "Out of range"
	.db 0x00
___str_53:
	.ascii "Buffer full"
	.db 0x00
___str_54:
	.ascii "List full"
	.db 0x00
___str_55:
	.ascii "GOSUB too deep"
	.db 0x00
___str_56:
	.ascii "Stack underflow"
	.db 0x00
___str_57:
	.ascii "FOR too deep"
	.db 0x00
___str_58:
	.ascii "NEXT no FOR"
	.db 0x00
___str_59:
	.ascii "NEXT no counter"
	.db 0x00
___str_60:
	.ascii "NEXT mismatch FOR"
	.db 0x00
___str_61:
	.ascii "FOR no var"
	.db 0x00
___str_62:
	.ascii "FOR no TO"
	.db 0x00
___str_63:
	.ascii "LET no var"
	.db 0x00
___str_64:
	.ascii "IF no condition"
	.db 0x00
___str_65:
	.ascii "Undef line no."
	.db 0x00
___str_66:
	.ascii "'(' or ')' expected"
	.db 0x00
___str_67:
	.ascii "'=' expected"
	.db 0x00
___str_68:
	.ascii "Illegal command"
	.db 0x00
___str_69:
	.ascii "Syntax error"
	.db 0x00
___str_70:
	.ascii "Break"
	.db 0x00
___str_71:
	.ascii "ESC-Break"
	.db 0x00
___str_72:
	.ascii "No I/O number"
	.db 0x00
___str_73:
	.ascii "Value expected"
	.db 0x00
	.area INITIALIZER
__xinit__kwtbl:
	.dw ___str_10
	.dw ___str_11
	.dw ___str_12
	.dw ___str_13
	.dw ___str_14
	.dw ___str_15
	.dw ___str_16
	.dw ___str_17
	.dw ___str_18
	.dw ___str_19
	.dw ___str_20
	.dw ___str_21
	.dw ___str_22
	.dw ___str_23
	.dw ___str_24
	.dw ___str_25
	.dw ___str_26
	.dw ___str_27
	.dw ___str_28
	.dw ___str_29
	.dw ___str_30
	.dw ___str_31
	.dw ___str_32
	.dw ___str_33
	.dw ___str_34
	.dw ___str_35
	.dw ___str_36
	.dw ___str_37
	.dw ___str_38
	.dw ___str_39
	.dw ___str_40
	.dw ___str_41
	.dw ___str_42
	.dw ___str_43
	.dw ___str_44
	.dw ___str_45
	.dw ___str_46
	.dw ___str_47
	.dw ___str_48
__xinit__errmsg:
	.dw ___str_49
	.dw ___str_50
	.dw ___str_51
	.dw ___str_52
	.dw ___str_53
	.dw ___str_54
	.dw ___str_55
	.dw ___str_56
	.dw ___str_57
	.dw ___str_58
	.dw ___str_59
	.dw ___str_60
	.dw ___str_61
	.dw ___str_62
	.dw ___str_63
	.dw ___str_64
	.dw ___str_65
	.dw ___str_66
	.dw ___str_67
	.dw ___str_68
	.dw ___str_69
	.dw ___str_70
	.dw ___str_71
	.dw ___str_72
	.dw ___str_73
__xinit__portddr:
	.dw #0x0000
	.area CABS (ABS)
