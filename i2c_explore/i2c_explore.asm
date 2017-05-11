;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Aug 12 2015) (Linux)
; This file was generated Fri Dec 16 01:10:59 2016
;--------------------------------------------------------
	.module i2c_explore
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _rtc_showtime
	.globl _rtc_write
	.globl _rtc_read
	.globl _dez2bcd
	.globl _i2c_scan
	.globl _lm75_read
	.globl _gethex
	.globl _printhex
	.globl _crlf
	.globl _checkcmd
	.globl _readstr
	.globl _i2c_read_nack
	.globl _i2c_read
	.globl _i2c_write
	.globl _i2c_stop
	.globl _i2c_start
	.globl _i2c_init
	.globl _uart_putstring
	.globl _uart_init
	.globl _uart_getchar
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
;	i2c_explore.c: 48: void putchar(char ch)
;	-----------------------------------------
;	 function putchar
;	-----------------------------------------
_putchar:
;	i2c_explore.c: 50: uart_putchar(ch);
	ld	a, (0x03, sp)
	push	a
	call	_uart_putchar
	pop	a
	ret
;	i2c_explore.c: 61: void readstr(char *string, char anz)
;	-----------------------------------------
;	 function readstr
;	-----------------------------------------
_readstr:
	pushw	x
;	i2c_explore.c: 65: cnt= 0;
	clr	(0x01, sp)
;	i2c_explore.c: 67: *string= 0;
	ldw	x, (0x05, sp)
	clr	(x)
;	i2c_explore.c: 68: do
00110$:
;	i2c_explore.c: 70: ch= uart_getchar();
	pushw	x
	call	_uart_getchar
	popw	x
;	i2c_explore.c: 71: if (ch!= 0x0d)
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
;	i2c_explore.c: 73: if (ch!= 0x08)
	cp	a, #0x08
	jreq	00106$
;	i2c_explore.c: 75: if (cnt< anz)
	push	a
	ld	a, (0x02, sp)
	cp	a, (0x08, sp)
	pop	a
	jrsge	00111$
;	i2c_explore.c: 77: uart_putchar(ch);
	push	a
	pushw	x
	push	a
	call	_uart_putchar
	pop	a
	popw	x
	pop	a
;	i2c_explore.c: 78: *string= ch;
	ld	(x), a
;	i2c_explore.c: 79: string++;
	incw	x
	ldw	(0x05, sp), x
;	i2c_explore.c: 67: *string= 0;
	ldw	x, (0x05, sp)
;	i2c_explore.c: 80: *string= 0;
	clr	(x)
;	i2c_explore.c: 81: cnt++;
	ld	a, (0x01, sp)
	inc	a
	ld	(0x01, sp), a
	jra	00111$
00106$:
;	i2c_explore.c: 86: if (cnt)
	tnz	(0x01, sp)
	jreq	00111$
;	i2c_explore.c: 88: uart_putchar(0x08);
	push	#0x08
	call	_uart_putchar
	pop	a
;	i2c_explore.c: 89: string--;
	ldw	x, (0x05, sp)
	decw	x
	ldw	(0x05, sp), x
;	i2c_explore.c: 67: *string= 0;
	ldw	x, (0x05, sp)
;	i2c_explore.c: 90: *string= 0;
	clr	(x)
;	i2c_explore.c: 91: cnt--;
	ld	a, (0x01, sp)
	dec	a
	ld	(0x01, sp), a
00111$:
;	i2c_explore.c: 95: } while (ch != 0x0d);
	tnz	(0x02, sp)
	jreq	00110$
	popw	x
	ret
;	i2c_explore.c: 108: char checkcmd(char *string)
;	-----------------------------------------
;	 function checkcmd
;	-----------------------------------------
_checkcmd:
	sub	sp, #14
;	i2c_explore.c: 114: i= 0;
	clr	(0x0e, sp)
;	i2c_explore.c: 115: do
	ldw	x, #_cmds+0
	ldw	(0x06, sp), x
	clr	(0x02, sp)
	clrw	x
	ldw	(0x04, sp), x
00109$:
;	i2c_explore.c: 117: s= string;
	ldw	y, (0x11, sp)
;	i2c_explore.c: 118: match= 1;
	ld	a, #0x01
	ld	(0x03, sp), a
;	i2c_explore.c: 120: do
	ldw	x, (0x06, sp)
	addw	x, (0x04, sp)
	ldw	(0x08, sp), x
	clr	(0x01, sp)
	ldw	(0x0c, sp), y
00104$:
;	i2c_explore.c: 122: ch= cmds[i][cp];
	clrw	x
	ld	a, (0x01, sp)
	ld	xl, a
	addw	x, (0x08, sp)
	ld	a, (x)
;	i2c_explore.c: 123: if (ch!= *s) match= 0;
	ldw	x, (0x0c, sp)
	push	a
	ld	a, (x)
	ld	(0x0c, sp), a
	pop	a
	cp	a, (0x0b, sp)
	jreq	00102$
	clr	(0x03, sp)
00102$:
;	i2c_explore.c: 126: cp++; s++;
	inc	(0x01, sp)
	ldw	x, (0x0c, sp)
	incw	x
	ldw	(0x0c, sp), x
;	i2c_explore.c: 127: }while(ch && match);
	tnz	a
	jreq	00106$
	tnz	(0x03, sp)
	jrne	00104$
00106$:
;	i2c_explore.c: 128: if (match) return i+1;
	tnz	(0x03, sp)
	jreq	00108$
	ld	a, (0x0e, sp)
	inc	a
	ld	(0x0a, sp), a
	ld	a, (0x0a, sp)
	jra	00112$
00108$:
;	i2c_explore.c: 129: i++;
	ldw	x, (0x04, sp)
	addw	x, #0x0009
	ldw	(0x04, sp), x
	inc	(0x02, sp)
	ld	a, (0x02, sp)
	ld	(0x0e, sp), a
;	i2c_explore.c: 130: } while (i < cmdanz);
	ld	a, (0x02, sp)
	cp	a, #0x0a
	jrslt	00109$
;	i2c_explore.c: 131: return 0;
	clr	a
00112$:
	addw	sp, #14
	ret
;	i2c_explore.c: 134: void crlf(void)
;	-----------------------------------------
;	 function crlf
;	-----------------------------------------
_crlf:
;	i2c_explore.c: 136: uart_putchar(0x0d);
	push	#0x0d
	call	_uart_putchar
	pop	a
;	i2c_explore.c: 137: uart_putchar(0x0a);
	push	#0x0a
	call	_uart_putchar
	pop	a
	ret
;	i2c_explore.c: 145: void printhex(uint8_t value)
;	-----------------------------------------
;	 function printhex
;	-----------------------------------------
_printhex:
;	i2c_explore.c: 149: b= (value >> 4);
	ld	a, (0x03, sp)
	swap	a
	and	a, #0x0f
;	i2c_explore.c: 150: if (b< 10) b += '0'; else b += 'A'-10;
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
;	i2c_explore.c: 151: uart_putchar(b);
	push	a
	call	_uart_putchar
	pop	a
;	i2c_explore.c: 152: b= value & 0x0f;
	ld	a, (0x03, sp)
	and	a, #0x0f
;	i2c_explore.c: 150: if (b< 10) b += '0'; else b += 'A'-10;
	ld	xh, a
;	i2c_explore.c: 153: if (b< 10) b += '0'; else b += 'A'-10;
	cp	a, #0x0a
	jrnc	00105$
	ld	a, xh
	add	a, #0x30
	jra	00106$
00105$:
	ld	a, xh
	add	a, #0x37
00106$:
;	i2c_explore.c: 154: uart_putchar(b);
	push	a
	call	_uart_putchar
	pop	a
	ret
;	i2c_explore.c: 165: uint8_t gethex(char echo)
;	-----------------------------------------
;	 function gethex
;	-----------------------------------------
_gethex:
	sub	sp, #3
;	i2c_explore.c: 171: do
00104$:
;	i2c_explore.c: 173: ch= uart_getchar();
	call	_uart_getchar
;	i2c_explore.c: 174: } while (!( ((ch>= '0') && (ch<= '9')) || ((ch>= 'a') && (ch<= 'f')) ));
	cp	a, #0x39
	jrugt	00179$
	clr	(0x02, sp)
	jra	00180$
00179$:
	push	a
	ld	a, #0x01
	ld	(0x03, sp), a
	pop	a
00180$:
	cp	a, #0x30
	jrc	00103$
	tnz	(0x02, sp)
	jreq	00106$
00103$:
	cp	a, #0x61
	jrc	00104$
	cp	a, #0x66
	jrugt	00104$
00106$:
;	i2c_explore.c: 175: if (echo) uart_putchar(ch);
	tnz	(0x06, sp)
	jreq	00108$
	push	a
	push	a
	call	_uart_putchar
	pop	a
	pop	a
00108$:
;	i2c_explore.c: 179: ch= (ch-'a')+10;
	ld	xh, a
;	i2c_explore.c: 177: if (ch > 'F')
	cp	a, #0x46
	jrule	00113$
;	i2c_explore.c: 179: ch= (ch-'a')+10;
	ld	a, xh
	add	a, #0xa9
	jra	00114$
00113$:
;	i2c_explore.c: 183: if (ch> '9') ch= (ch-'A')+10; else ch -= '0';
	tnz	(0x02, sp)
	jreq	00110$
	ld	a, xh
	add	a, #0xc9
	jra	00114$
00110$:
	ld	a, xh
	sub	a, #0x30
00114$:
;	i2c_explore.c: 185: value= (ch<< 4);
	swap	a
	and	a, #0xf0
	ld	(0x03, sp), a
;	i2c_explore.c: 187: do
00118$:
;	i2c_explore.c: 189: ch= uart_getchar();
	call	_uart_getchar
;	i2c_explore.c: 174: } while (!( ((ch>= '0') && (ch<= '9')) || ((ch>= 'a') && (ch<= 'f')) ));
	cp	a, #0x39
	jrugt	00188$
	clr	(0x01, sp)
	jra	00189$
00188$:
	push	a
	ld	a, #0x01
	ld	(0x02, sp), a
	pop	a
00189$:
;	i2c_explore.c: 190: } while (!( ((ch>= '0') && (ch<= '9')) || ((ch>= 'a') && (ch<= 'f')) ));
	cp	a, #0x30
	jrc	00117$
	tnz	(0x01, sp)
	jreq	00120$
00117$:
	cp	a, #0x61
	jrc	00118$
	cp	a, #0x66
	jrugt	00118$
00120$:
;	i2c_explore.c: 191: if (echo) uart_putchar(ch);
	tnz	(0x06, sp)
	jreq	00122$
	push	a
	push	a
	call	_uart_putchar
	pop	a
	pop	a
00122$:
;	i2c_explore.c: 179: ch= (ch-'a')+10;
	ld	xh, a
;	i2c_explore.c: 193: if (ch > 'F')
	cp	a, #0x46
	jrule	00127$
;	i2c_explore.c: 195: ch= (ch-'a')+10;
	ld	a, xh
	add	a, #0xa9
	jra	00128$
00127$:
;	i2c_explore.c: 199: if (ch> '9') ch= (ch-'A')+10; else ch -= '0';
	tnz	(0x01, sp)
	jreq	00124$
	ld	a, xh
	add	a, #0xc9
	jra	00128$
00124$:
	ld	a, xh
	sub	a, #0x30
00128$:
;	i2c_explore.c: 201: value |= ch;
	or	a, (0x03, sp)
;	i2c_explore.c: 202: return value;
	addw	sp, #3
	ret
;	i2c_explore.c: 215: int lm75_read(void)
;	-----------------------------------------
;	 function lm75_read
;	-----------------------------------------
_lm75_read:
	sub	sp, #3
;	i2c_explore.c: 222: i2c_start();
	call	_i2c_start
;	i2c_explore.c: 224: ack= i2c_write(lm75_addr);                // LM75 Basisadresse
	push	#0x90
	call	_i2c_write
	addw	sp, #1
	ld	(0x01, sp), a
;	i2c_explore.c: 225: if (ack)
	tnz	(0x01, sp)
	jreq	00102$
;	i2c_explore.c: 228: i2c_write(0x00);                        // LM75 Registerselect: Temp. auslesen
	push	#0x00
	call	_i2c_write
	pop	a
;	i2c_explore.c: 229: i2c_write(0x00);
	push	#0x00
	call	_i2c_write
	pop	a
;	i2c_explore.c: 231: i2c_stop();
	call	_i2c_stop
;	i2c_explore.c: 232: delay_us(200);
	push	#0xc8
	push	#0x00
	call	_delay_us
	popw	x
;	i2c_explore.c: 233: i2c_start();
	call	_i2c_start
;	i2c_explore.c: 235: i2c_write(lm75_addr | 1);               // LM75 zum Lesen anwaehlen
	push	#0x91
	call	_i2c_write
	pop	a
;	i2c_explore.c: 236: delay_ms(1);                            // Reaktionszeit LM75
	push	#0x01
	push	#0x00
	call	_delay_ms
	popw	x
;	i2c_explore.c: 238: t1= i2c_read();                         // hoeherwertigen 8 Bit
	call	_i2c_read
	ld	(0x03, sp), a
;	i2c_explore.c: 239: delay_ms(1);
	push	#0x01
	push	#0x00
	call	_delay_ms
	popw	x
;	i2c_explore.c: 240: t2= i2c_read_nack();                    // niederwertiges Bit (repraesentiert 0.5 Grad)
	call	_i2c_read_nack
	ld	(0x02, sp), a
;	i2c_explore.c: 241: i2c_stop();
	call	_i2c_stop
	jra	00103$
00102$:
;	i2c_explore.c: 246: i2c_stop();
	call	_i2c_stop
;	i2c_explore.c: 247: return -127;                            // Abbruch, Chip nicht gefunden
	ldw	x, #0xff81
	jra	00106$
00103$:
;	i2c_explore.c: 250: lm75temp= t1;
	ld	a, (0x03, sp)
	ld	xl, a
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	xh, a
;	i2c_explore.c: 251: lm75temp = lm75temp*10;
	pushw	x
	push	#0x0a
	push	#0x00
	call	__mulint
	addw	sp, #4
;	i2c_explore.c: 252: if (t2 & 0x80) lm75temp += 5;             // wenn niederwertiges Bit gesetzt, sind das 0.5 Grad
	tnz	(0x02, sp)
	jrpl	00105$
	addw	x, #0x0005
00105$:
;	i2c_explore.c: 253: return lm75temp;
00106$:
	addw	sp, #3
	ret
;	i2c_explore.c: 263: void i2c_scan(void)
;	-----------------------------------------
;	 function i2c_scan
;	-----------------------------------------
_i2c_scan:
	sub	sp, #143
;	i2c_explore.c: 270: for (i= 0x00; i< 0xfe; i +=2)
	ldw	x, #___str_1+0
	ldw	(0x87, sp), x
	ldw	x, sp
	incw	x
	incw	x
	ldw	(0x83, sp), x
	ldw	x, #___str_2+0
	ldw	(0x85, sp), x
	ldw	x, #___str_0+0
	ldw	(0x8b, sp), x
	clr	(0x01, sp)
	clr	(0x81, sp)
00108$:
;	i2c_explore.c: 272: printf(" Bus-Scan: %xh \r",i);
	ld	a, (0x81, sp)
	ld	(0x8a, sp), a
	clr	(0x89, sp)
	ldw	y, (0x8b, sp)
	ldw	x, (0x89, sp)
	pushw	x
	pushw	y
	call	_my_printf
	addw	sp, #4
;	i2c_explore.c: 273: i2c_start();
	call	_i2c_start
;	i2c_explore.c: 274: delay_ms(1);
	push	#0x01
	push	#0x00
	call	_delay_ms
	popw	x
;	i2c_explore.c: 275: ack= i2c_write(i);
	ld	a, (0x81, sp)
	push	a
	call	_i2c_write
	addw	sp, #1
	ld	(0x82, sp), a
;	i2c_explore.c: 276: delay_ms(1);
	push	#0x01
	push	#0x00
	call	_delay_ms
	popw	x
;	i2c_explore.c: 277: i2c_stop();
	call	_i2c_stop
;	i2c_explore.c: 278: if (ack)
	tnz	(0x82, sp)
	jreq	00102$
;	i2c_explore.c: 280: printf(" Bus-Scan: %xh found\r",i);
	ldw	y, (0x87, sp)
	ldw	x, (0x89, sp)
	pushw	x
	pushw	y
	call	_my_printf
	addw	sp, #4
;	i2c_explore.c: 281: delay_ms(1000);
	push	#0xe8
	push	#0x03
	call	_delay_ms
	popw	x
;	i2c_explore.c: 282: i2c_devices[i2c_anz]= i;
	clrw	x
	ld	a, (0x01, sp)
	ld	xl, a
	addw	x, (0x83, sp)
	ld	a, (0x81, sp)
	ld	(x), a
;	i2c_explore.c: 283: i2c_anz++;
	inc	(0x01, sp)
;	i2c_explore.c: 284: printf("                      \r");
	ldw	x, (0x85, sp)
	pushw	x
	call	_my_printf
	popw	x
00102$:
;	i2c_explore.c: 286: delay_ms(5);
	push	#0x05
	push	#0x00
	call	_delay_ms
	popw	x
;	i2c_explore.c: 270: for (i= 0x00; i< 0xfe; i +=2)
	inc	(0x81, sp)
	inc	(0x81, sp)
	ld	a, (0x81, sp)
	cp	a, #0xfe
	jrc	00108$
;	i2c_explore.c: 288: printf("\n\n\rScan complete...\n\r");
	ld	a, (0x01, sp)
	ld	(0x8f, sp), a
	ldw	x, #___str_3+0
	pushw	x
	call	_my_printf
	popw	x
;	i2c_explore.c: 289: if (i2c_anz)
	tnz	(0x01, sp)
	jreq	00106$
;	i2c_explore.c: 291: printf("\n\rI2C-devices found at:\n\r");
	ldw	x, #___str_4+0
	pushw	x
	call	_my_printf
	popw	x
;	i2c_explore.c: 292: for (i= 0; i< i2c_anz; i++)
	ldw	x, #___str_5+0
	ldw	(0x8d, sp), x
	clr	(0x81, sp)
00111$:
	ld	a, (0x81, sp)
	cp	a, (0x8f, sp)
	jrnc	00113$
;	i2c_explore.c: 294: printf(" %xh \n\r",i2c_devices[i]);
	clrw	x
	ld	a, (0x81, sp)
	ld	xl, a
	addw	x, (0x83, sp)
	ld	a, (x)
	clrw	x
	ld	xl, a
	ldw	y, (0x8d, sp)
	pushw	x
	pushw	y
	call	_my_printf
	addw	sp, #4
;	i2c_explore.c: 292: for (i= 0; i< i2c_anz; i++)
	inc	(0x81, sp)
	jra	00111$
00106$:
;	i2c_explore.c: 298: printf("\n\rNo I2C-devices found \n\r");
	ldw	x, #___str_6+0
	ld	a, xl
	push	a
	ld	a, xh
	push	a
	call	_my_printf
	popw	x
00113$:
	addw	sp, #143
	ret
;	i2c_explore.c: 308: uint8_t dez2bcd(uint8_t value)
;	-----------------------------------------
;	 function dez2bcd
;	-----------------------------------------
_dez2bcd:
	pushw	x
;	i2c_explore.c: 312: hiz= value / 10;
	clrw	x
	ld	a, (0x05, sp)
	ld	xl, a
	ld	a, #0x0a
	div	x, a
;	i2c_explore.c: 313: loz= (value -(hiz*10));
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
;	i2c_explore.c: 314: c= (hiz << 4) | loz;
	ld	a, xl
	swap	a
	and	a, #0xf0
	or	a, (0x01, sp)
;	i2c_explore.c: 315: return c;
	popw	x
	ret
;	i2c_explore.c: 325: uint8_t rtc_read(uint8_t addr)
;	-----------------------------------------
;	 function rtc_read
;	-----------------------------------------
_rtc_read:
;	i2c_explore.c: 330: i2c_start();
	call	_i2c_start
;	i2c_explore.c: 331: i2c_write(rtc_addr);
	push	#0xd0
	call	_i2c_write
	pop	a
;	i2c_explore.c: 332: delay_ms(1);
	push	#0x01
	push	#0x00
	call	_delay_ms
	popw	x
;	i2c_explore.c: 333: i2c_write(addr);
	ld	a, (0x03, sp)
	push	a
	call	_i2c_write
	pop	a
;	i2c_explore.c: 334: delay_ms(1);
	push	#0x01
	push	#0x00
	call	_delay_ms
	popw	x
;	i2c_explore.c: 335: i2c_stop();
	call	_i2c_stop
;	i2c_explore.c: 336: delay_ms(1);
	push	#0x01
	push	#0x00
	call	_delay_ms
	popw	x
;	i2c_explore.c: 337: i2c_start();
	call	_i2c_start
;	i2c_explore.c: 338: i2c_write(rtc_addr | 1);
	push	#0xd1
	call	_i2c_write
	pop	a
;	i2c_explore.c: 339: delay_ms(1);
	push	#0x01
	push	#0x00
	call	_delay_ms
	popw	x
;	i2c_explore.c: 340: value= i2c_read_nack();
	call	_i2c_read_nack
;	i2c_explore.c: 341: delay_ms(1);
	push	a
	push	#0x01
	push	#0x00
	call	_delay_ms
	popw	x
	call	_i2c_stop
	pop	a
;	i2c_explore.c: 344: return value;
	ret
;	i2c_explore.c: 356: void rtc_write(uint8_t addr, uint8_t value)
;	-----------------------------------------
;	 function rtc_write
;	-----------------------------------------
_rtc_write:
;	i2c_explore.c: 359: i2c_start();
	call	_i2c_start
;	i2c_explore.c: 360: i2c_write(rtc_addr);
	push	#0xd0
	call	_i2c_write
	pop	a
;	i2c_explore.c: 361: delay_ms(1);
	push	#0x01
	push	#0x00
	call	_delay_ms
	popw	x
;	i2c_explore.c: 362: i2c_write(addr);
	ld	a, (0x03, sp)
	push	a
	call	_i2c_write
	pop	a
;	i2c_explore.c: 363: delay_ms(1);
	push	#0x01
	push	#0x00
	call	_delay_ms
	popw	x
;	i2c_explore.c: 364: i2c_write(value);
	ld	a, (0x04, sp)
	push	a
	call	_i2c_write
	pop	a
;	i2c_explore.c: 365: delay_ms(1);
	push	#0x01
	push	#0x00
	call	_delay_ms
	popw	x
;	i2c_explore.c: 366: i2c_stop;
	ret
;	i2c_explore.c: 376: void rtc_showtime(void)
;	-----------------------------------------
;	 function rtc_showtime
;	-----------------------------------------
_rtc_showtime:
	sub	sp, #20
;	i2c_explore.c: 381: sek= rtc_read(0) & 0x7f;
	push	#0x00
	call	_rtc_read
	addw	sp, #1
	and	a, #0x7f
	ld	(0x06, sp), a
;	i2c_explore.c: 382: min= rtc_read(1) & 0x7f;
	push	#0x01
	call	_rtc_read
	addw	sp, #1
	and	a, #0x7f
	ld	(0x05, sp), a
;	i2c_explore.c: 383: std= rtc_read(2) & 0x3f;
	push	#0x02
	call	_rtc_read
	addw	sp, #1
	and	a, #0x3f
	ld	(0x04, sp), a
;	i2c_explore.c: 384: day= rtc_read(4) & 0x3f;
	push	#0x04
	call	_rtc_read
	addw	sp, #1
	and	a, #0x3f
	ld	(0x03, sp), a
;	i2c_explore.c: 385: month= rtc_read(5) & 0x1f;
	push	#0x05
	call	_rtc_read
	addw	sp, #1
	and	a, #0x1f
	ld	(0x02, sp), a
;	i2c_explore.c: 386: year= rtc_read(6);
	push	#0x06
	call	_rtc_read
	addw	sp, #1
	ld	(0x01, sp), a
;	i2c_explore.c: 388: printf("\n\r %x.%x.20%x  %x.%x:%x\n\r",day,month,year,std,min,sek);
	ld	a, (0x06, sp)
	ld	(0x0e, sp), a
	clr	(0x0d, sp)
	ld	a, (0x05, sp)
	ld	(0x08, sp), a
	clr	(0x07, sp)
	ld	a, (0x04, sp)
	ld	(0x0c, sp), a
	clr	(0x0b, sp)
	ld	a, (0x01, sp)
	ld	(0x0a, sp), a
	clr	(0x09, sp)
	ld	a, (0x02, sp)
	ld	(0x12, sp), a
	clr	(0x11, sp)
	ld	a, (0x03, sp)
	ld	(0x10, sp), a
	clr	(0x0f, sp)
	ldw	x, #___str_7+0
	ldw	(0x13, sp), x
	ldw	y, (0x13, sp)
	ldw	x, (0x0d, sp)
	pushw	x
	ldw	x, (0x09, sp)
	pushw	x
	ldw	x, (0x0f, sp)
	pushw	x
	ldw	x, (0x0f, sp)
	pushw	x
	ldw	x, (0x19, sp)
	pushw	x
	ldw	x, (0x19, sp)
	pushw	x
	pushw	y
	call	_my_printf
	addw	sp, #34
	ret
;	i2c_explore.c: 397: int main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #34
;	i2c_explore.c: 408: __endasm;
	ldw x, #0x0300
	ldw sp, x
;	i2c_explore.c: 410: sysclock_init(0);
	push	#0x00
	call	_sysclock_init
	pop	a
;	i2c_explore.c: 412: printfkomma= 1;                       // my_printf verwendet mit Formatter %k eine Kommastelle
	mov	_printfkomma+0, #0x01
;	i2c_explore.c: 413: i2c_init(2);                          // 2 = ca. 15kHz I2C Clock-Takt
	push	#0x02
	call	_i2c_init
	pop	a
;	i2c_explore.c: 414: extled_init();
	ldw	x, #0x5011
	ld	a, (x)
	or	a, #0x10
	ld	(x), a
	ldw	x, #0x5012
	ld	a, (x)
	or	a, #0x10
	ld	(x), a
	ldw	x, #0x5013
	ld	a, (x)
	and	a, #0xef
	ld	(x), a
;	i2c_explore.c: 416: extled_set();                         // externe LED an
	ldw	x, #0x500f
	ld	a, (x)
	and	a, #0xef
	ld	(x), a
;	i2c_explore.c: 417: uart_init(19200);
	push	#0x00
	push	#0x4b
	call	_uart_init
	popw	x
;	i2c_explore.c: 419: printf("\n\n\rI2C-Explorer mit STM8S103F3P6\n\r-----------------------------\n\n\r");
	ldw	x, #___str_8+0
	pushw	x
	call	_my_printf
	popw	x
;	i2c_explore.c: 420: printf("\n\rCommands are:  start   / stop    / write   / read");
	ldw	x, #___str_9+0
	pushw	x
	call	_my_printf
	popw	x
;	i2c_explore.c: 421: printf("\n\r               rnack   / scan    / lm75    / time");
	ldw	x, #___str_10+0
	pushw	x
	call	_my_printf
	popw	x
;	i2c_explore.c: 422: printf("\n\r               settime \n\n\r");
	ldw	x, #___str_11+0
	pushw	x
	call	_my_printf
	popw	x
;	i2c_explore.c: 424: while(1)
00124$:
;	i2c_explore.c: 426: uart_prints("I2C:> ");
	ldw	x, #___str_12+0
	pushw	x
	call	_uart_putstring
	popw	x
;	i2c_explore.c: 427: readstr(&inbuffer[0],8);
	ldw	x, sp
	addw	x, #4
	ldw	(0x21, sp), x
	ldw	x, (0x21, sp)
	push	#0x08
	pushw	x
	call	_readstr
	addw	sp, #3
;	i2c_explore.c: 428: ch= checkcmd(&inbuffer[0]);
	ldw	x, (0x21, sp)
	pushw	x
	call	_checkcmd
	popw	x
	ld	(0x13, sp), a
;	i2c_explore.c: 429: switch(ch)
	tnz	(0x13, sp)
	jrpl	00163$
	jp	00121$
00163$:
	ld	a, (0x13, sp)
	cp	a, #0x0a
	jrsle	00164$
	jp	00121$
00164$:
	clrw	x
	ld	a, (0x13, sp)
	ld	xl, a
	sllw	x
	ldw	x, (#00165$, x)
	jp	(x)
00165$:
	.dw	#00121$
	.dw	#00101$
	.dw	#00102$
	.dw	#00103$
	.dw	#00104$
	.dw	#00105$
	.dw	#00106$
	.dw	#00110$
	.dw	#00111$
	.dw	#00115$
	.dw	#00119$
;	i2c_explore.c: 431: case 1 :                               // start - condition
00101$:
;	i2c_explore.c: 433: i2c_start();
	call	_i2c_start
;	i2c_explore.c: 434: printf("\n\r  start-condition done...\n\n\r");
	ldw	x, #___str_13+0
	pushw	x
	call	_my_printf
	popw	x
;	i2c_explore.c: 435: break;
	jra	00124$
;	i2c_explore.c: 437: case 2 :                               // stop - condition
00102$:
;	i2c_explore.c: 439: i2c_stop();
	call	_i2c_stop
;	i2c_explore.c: 440: printf("\n\r  stop-condition done...\n\n\r");
	ldw	x, #___str_14+0
	pushw	x
	call	_my_printf
	popw	x
;	i2c_explore.c: 441: break;
	jp	00124$
;	i2c_explore.c: 443: case 3 :                               // write Data-Byte
00103$:
;	i2c_explore.c: 445: printf("\n\r  byte to write: ");
	ldw	x, #___str_15+0
	pushw	x
	call	_my_printf
	popw	x
;	i2c_explore.c: 446: b= gethex(1);
	push	#0x01
	call	_gethex
	addw	sp, #1
	ld	xh, a
	clr	a
;	i2c_explore.c: 447: i2c_write(b);
	ld	a, xh
	push	a
	call	_i2c_write
	pop	a
;	i2c_explore.c: 448: crlf();
	call	_crlf
;	i2c_explore.c: 449: break;
	jp	00124$
;	i2c_explore.c: 451: case 4 :                               // read Data-Byte
00104$:
;	i2c_explore.c: 453: printf("\n\r  readed byte: ");
	ldw	x, #___str_16+0
	pushw	x
	call	_my_printf
	popw	x
;	i2c_explore.c: 454: b= i2c_read();
	call	_i2c_read
	clrw	x
	ld	xl, a
;	i2c_explore.c: 455: printf("0x%xh = %dd\n\r",b,b);
	ldw	y, #___str_17+0
	pushw	x
	pushw	x
	pushw	y
	call	_my_printf
	addw	sp, #6
;	i2c_explore.c: 456: break;
	jp	00124$
;	i2c_explore.c: 458: case 5 :                               // read Data-Byte, no acknowledge
00105$:
;	i2c_explore.c: 460: printf("\n\r  readed byte: ");
	ldw	x, #___str_16+0
	pushw	x
	call	_my_printf
	popw	x
;	i2c_explore.c: 461: b= i2c_read_nack();
	call	_i2c_read_nack
	clrw	x
	ld	xl, a
;	i2c_explore.c: 462: printf("0x%xh = %dd\n\r",b,b);
	ldw	y, #___str_17+0
	pushw	x
	pushw	x
	pushw	y
	call	_my_printf
	addw	sp, #6
;	i2c_explore.c: 463: break;
	jp	00124$
;	i2c_explore.c: 465: case 6 :
00106$:
;	i2c_explore.c: 467: b= lm75_read();
	call	_lm75_read
	ldw	(0x02, sp), x
;	i2c_explore.c: 468: if (b== -127)
	ldw	x, (0x02, sp)
	cpw	x, #0xff81
	jrne	00108$
;	i2c_explore.c: 470: printf("\n\r  LM75 not connected..\n\r");
	ldw	x, #___str_18+0
	pushw	x
	call	_my_printf
	popw	x
	jp	00124$
00108$:
;	i2c_explore.c: 474: printf("\n\r  Temp.= %k C\n\n\r",b);
	ldw	x, #___str_19+0
	ldw	y, (0x02, sp)
	pushw	y
	pushw	x
	call	_my_printf
	addw	sp, #4
;	i2c_explore.c: 476: break;
	jp	00124$
;	i2c_explore.c: 478: case 7 :                               // scan I2C Bus
00110$:
;	i2c_explore.c: 480: extled_clr();                        // externe LED aus
	ldw	x, #0x500f
	ld	a, (x)
	or	a, #0x10
	ld	(x), a
;	i2c_explore.c: 481: printf("\n\r");
	ldw	x, #___str_20+0
	ldw	(0x1b, sp), x
	ldw	x, (0x1b, sp)
	pushw	x
	call	_my_printf
	popw	x
;	i2c_explore.c: 482: i2c_scan();
	call	_i2c_scan
;	i2c_explore.c: 483: printf("\n\r");
	ldw	x, (0x1b, sp)
	pushw	x
	call	_my_printf
	popw	x
;	i2c_explore.c: 484: extled_set();                         // externe LED an
	ldw	x, #0x500f
	ld	a, (x)
	and	a, #0xef
	ld	(x), a
;	i2c_explore.c: 485: break;
	jp	00124$
;	i2c_explore.c: 487: case 8 :                               // Time
00111$:
;	i2c_explore.c: 489: printf("\n\r");
	ldw	x, #___str_20+0
	ldw	(0x1d, sp), x
	ldw	x, (0x1d, sp)
	pushw	x
	call	_my_printf
	popw	x
;	i2c_explore.c: 490: i2c_start();
	call	_i2c_start
;	i2c_explore.c: 491: delay_ms(1);
	push	#0x01
	push	#0x00
	call	_delay_ms
	popw	x
;	i2c_explore.c: 492: ack= i2c_write(rtc_addr);
	push	#0xd0
	call	_i2c_write
	addw	sp, #1
	ld	(0x1a, sp), a
;	i2c_explore.c: 493: delay_ms(1);
	push	#0x01
	push	#0x00
	call	_delay_ms
	popw	x
;	i2c_explore.c: 494: i2c_stop();
	call	_i2c_stop
;	i2c_explore.c: 495: if (ack)
	tnz	(0x1a, sp)
	jreq	00113$
;	i2c_explore.c: 497: rtc_showtime();
	call	_rtc_showtime
	jra	00114$
00113$:
;	i2c_explore.c: 501: printf("\n\r RTC-device (DS1307) not connected..\n\r");
	ldw	x, #___str_21+0
	pushw	x
	call	_my_printf
	popw	x
00114$:
;	i2c_explore.c: 503: printf("\n\r");
	ldw	x, (0x1d, sp)
	pushw	x
	call	_my_printf
	popw	x
;	i2c_explore.c: 504: break;
	jp	00124$
;	i2c_explore.c: 506: case 9 :                               // Set time
00115$:
;	i2c_explore.c: 508: i2c_start();
	call	_i2c_start
;	i2c_explore.c: 509: delay_ms(1);
	push	#0x01
	push	#0x00
	call	_delay_ms
	popw	x
;	i2c_explore.c: 510: ack= i2c_write(rtc_addr);
	push	#0xd0
	call	_i2c_write
	addw	sp, #1
	ld	(0x01, sp), a
;	i2c_explore.c: 511: delay_ms(1);
	push	#0x01
	push	#0x00
	call	_delay_ms
	popw	x
;	i2c_explore.c: 512: i2c_stop();
	call	_i2c_stop
;	i2c_explore.c: 513: if (ack)
	tnz	(0x01, sp)
	jrne	00170$
	jp	00117$
00170$:
;	i2c_explore.c: 515: printf("\n\n\r");
	ldw	x, #___str_22+0
	ldw	(0x18, sp), x
	ldw	x, (0x18, sp)
	pushw	x
	call	_my_printf
	popw	x
;	i2c_explore.c: 516: printf(" Hour    : ");
	ldw	x, #___str_23+0
	pushw	x
	call	_my_printf
	popw	x
;	i2c_explore.c: 517: hexv= gethex(1) & 0x3f;
	push	#0x01
	call	_gethex
	addw	sp, #1
	and	a, #0x3f
;	i2c_explore.c: 518: rtc_write(2,hexv);
	push	a
	push	#0x02
	call	_rtc_write
	popw	x
;	i2c_explore.c: 519: printf("\n\r");
	ldw	x, #___str_20+0
	ldw	(0x16, sp), x
	ldw	x, (0x16, sp)
	pushw	x
	call	_my_printf
	popw	x
;	i2c_explore.c: 520: printf(" Minute  : ");
	ldw	x, #___str_24+0
	pushw	x
	call	_my_printf
	popw	x
;	i2c_explore.c: 521: hexv= gethex(1) & 0x7f;
	push	#0x01
	call	_gethex
	addw	sp, #1
	and	a, #0x7f
;	i2c_explore.c: 522: rtc_write(1,hexv);
	push	a
	push	#0x01
	call	_rtc_write
	popw	x
;	i2c_explore.c: 523: printf("\n\r");
	ldw	x, (0x16, sp)
	pushw	x
	call	_my_printf
	popw	x
;	i2c_explore.c: 524: printf(" Secound : ");
	ldw	x, #___str_25+0
	pushw	x
	call	_my_printf
	popw	x
;	i2c_explore.c: 525: hexv= gethex(1) & 0x7f;
	push	#0x01
	call	_gethex
	addw	sp, #1
	and	a, #0x7f
;	i2c_explore.c: 526: rtc_write(0,hexv);
	push	a
	push	#0x00
	call	_rtc_write
	popw	x
;	i2c_explore.c: 527: printf("\n\r");
	ldw	x, (0x16, sp)
	pushw	x
	call	_my_printf
	popw	x
;	i2c_explore.c: 528: printf(" Day     : ");
	ldw	x, #___str_26+0
	pushw	x
	call	_my_printf
	popw	x
;	i2c_explore.c: 529: hexv= gethex(1) & 0x3f;
	push	#0x01
	call	_gethex
	addw	sp, #1
	and	a, #0x3f
;	i2c_explore.c: 530: rtc_write(4,hexv);
	push	a
	push	#0x04
	call	_rtc_write
	popw	x
;	i2c_explore.c: 531: printf("\n\r");
	ldw	x, (0x16, sp)
	pushw	x
	call	_my_printf
	popw	x
;	i2c_explore.c: 532: printf(" Month   : ");
	ldw	x, #___str_27+0
	pushw	x
	call	_my_printf
	popw	x
;	i2c_explore.c: 533: hexv= gethex(1) & 0x3f;
	push	#0x01
	call	_gethex
	addw	sp, #1
	and	a, #0x3f
;	i2c_explore.c: 534: rtc_write(5,hexv);
	push	a
	push	#0x05
	call	_rtc_write
	popw	x
;	i2c_explore.c: 535: printf("\n\r");
	ldw	x, (0x16, sp)
	pushw	x
	call	_my_printf
	popw	x
;	i2c_explore.c: 536: printf(" Year    : ");
	ldw	x, #___str_28+0
	pushw	x
	call	_my_printf
	popw	x
;	i2c_explore.c: 537: hexv= gethex(1) & 0x3f;
	push	#0x01
	call	_gethex
	addw	sp, #1
	and	a, #0x3f
;	i2c_explore.c: 538: rtc_write(6,hexv);
	push	a
	push	#0x06
	call	_rtc_write
	popw	x
;	i2c_explore.c: 539: printf("\n\n\r");
	ldw	x, (0x18, sp)
	pushw	x
	call	_my_printf
	popw	x
	jp	00124$
00117$:
;	i2c_explore.c: 543: printf("\n\r RTC-device (DS1307) not connected..\n\r");
	ldw	x, #___str_21+0
	pushw	x
	call	_my_printf
	popw	x
;	i2c_explore.c: 545: break;
	jp	00124$
;	i2c_explore.c: 548: case 10 :
00119$:
;	i2c_explore.c: 550: i2c_start();
	call	_i2c_start
;	i2c_explore.c: 551: i2c_write(0xa0);
	push	#0xa0
	call	_i2c_write
	pop	a
;	i2c_explore.c: 552: i2c_write(0x10);
	push	#0x10
	call	_i2c_write
	pop	a
;	i2c_explore.c: 553: i2c_stop();
	call	_i2c_stop
;	i2c_explore.c: 555: i2c_start();
	call	_i2c_start
;	i2c_explore.c: 556: i2c_write(0xa1);
	push	#0xa1
	call	_i2c_write
	pop	a
;	i2c_explore.c: 557: for (i= 0; i< 5; i++)
	ldw	x, #___str_16+0
	ldw	(0x14, sp), x
	ldw	x, #___str_17+0
	ldw	(0x1f, sp), x
	clrw	x
	ldw	(0x11, sp), x
00126$:
;	i2c_explore.c: 559: printf("\n\r  readed byte: ");
	ldw	x, (0x14, sp)
	pushw	x
	call	_my_printf
	popw	x
;	i2c_explore.c: 560: b= i2c_read();
	call	_i2c_read
	clrw	x
	ld	xl, a
;	i2c_explore.c: 561: printf("0x%xh = %dd\n\r",b,b);
	ldw	y, (0x1f, sp)
	pushw	x
	pushw	x
	pushw	y
	call	_my_printf
	addw	sp, #6
;	i2c_explore.c: 557: for (i= 0; i< 5; i++)
	ldw	x, (0x11, sp)
	incw	x
	ldw	(0x11, sp), x
	ldw	x, (0x11, sp)
	cpw	x, #0x0005
	jrslt	00126$
;	i2c_explore.c: 563: b= i2c_read_nack();
	call	_i2c_read_nack
	clrw	x
	ld	xl, a
;	i2c_explore.c: 564: printf("0x%xh = %dd\n\r",b,b);
	ldw	y, (0x1f, sp)
	pushw	x
	pushw	x
	pushw	y
	call	_my_printf
	addw	sp, #6
;	i2c_explore.c: 565: i2c_stop();
	call	_i2c_stop
;	i2c_explore.c: 566: break;
	jp	00124$
;	i2c_explore.c: 568: default :
00121$:
;	i2c_explore.c: 570: uart_putchar(ch);
	ld	a, (0x13, sp)
	push	a
	call	_uart_putchar
	pop	a
;	i2c_explore.c: 571: uart_prints("\n\runkown command\n\n\r");
	ldw	x, #___str_29+0
	pushw	x
	call	_uart_putstring
	popw	x
;	i2c_explore.c: 574: }
	jp	00124$
	addw	sp, #34
	ret
	.area CODE
_cmds:
	.ascii "start"
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.ascii "stop"
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.ascii "write"
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
	.ascii "rnack"
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.ascii "lm75"
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.ascii "scan"
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.ascii "time"
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.ascii "settime"
	.db 0x00
	.db 0x00
	.ascii "test"
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
___str_0:
	.ascii " Bus-Scan: %xh "
	.db 0x0D
	.db 0x00
___str_1:
	.ascii " Bus-Scan: %xh found"
	.db 0x0D
	.db 0x00
___str_2:
	.ascii "                      "
	.db 0x0D
	.db 0x00
___str_3:
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.ascii "Scan complete..."
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_4:
	.db 0x0A
	.db 0x0D
	.ascii "I2C-devices found at:"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_5:
	.ascii " %xh "
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_6:
	.db 0x0A
	.db 0x0D
	.ascii "No I2C-devices found "
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_7:
	.db 0x0A
	.db 0x0D
	.ascii " %x.%x.20%x  %x.%x:%x"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_8:
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.ascii "I2C-Explorer mit STM8S103F3P6"
	.db 0x0A
	.db 0x0D
	.ascii "--------------------------"
	.ascii "---"
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_9:
	.db 0x0A
	.db 0x0D
	.ascii "Commands are:  start   / stop    / write   / read"
	.db 0x00
___str_10:
	.db 0x0A
	.db 0x0D
	.ascii "               rnack   / scan    / lm75    / time"
	.db 0x00
___str_11:
	.db 0x0A
	.db 0x0D
	.ascii "               settime "
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_12:
	.ascii "I2C:> "
	.db 0x00
___str_13:
	.db 0x0A
	.db 0x0D
	.ascii "  start-condition done..."
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_14:
	.db 0x0A
	.db 0x0D
	.ascii "  stop-condition done..."
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_15:
	.db 0x0A
	.db 0x0D
	.ascii "  byte to write: "
	.db 0x00
___str_16:
	.db 0x0A
	.db 0x0D
	.ascii "  readed byte: "
	.db 0x00
___str_17:
	.ascii "0x%xh = %dd"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_18:
	.db 0x0A
	.db 0x0D
	.ascii "  LM75 not connected.."
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_19:
	.db 0x0A
	.db 0x0D
	.ascii "  Temp.= %k C"
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_20:
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_21:
	.db 0x0A
	.db 0x0D
	.ascii " RTC-device (DS1307) not connected.."
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_22:
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_23:
	.ascii " Hour    : "
	.db 0x00
___str_24:
	.ascii " Minute  : "
	.db 0x00
___str_25:
	.ascii " Secound : "
	.db 0x00
___str_26:
	.ascii " Day     : "
	.db 0x00
___str_27:
	.ascii " Month   : "
	.db 0x00
___str_28:
	.ascii " Year    : "
	.db 0x00
___str_29:
	.db 0x0A
	.db 0x0D
	.ascii "unkown command"
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.db 0x00
	.area INITIALIZER
	.area CABS (ABS)
