;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Aug 12 2015) (Linux)
; This file was generated Wed Nov  9 15:07:44 2016
;--------------------------------------------------------
	.module sw_i2c_test
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _crlf
	.globl _i2c_read
	.globl _i2c_write
	.globl _i2c_stop
	.globl _i2c_start
	.globl _i2c_master_init
	.globl _uart_init
	.globl _uart_putchar
	.globl _my_printf
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
;	sw_i2c_test.c: 40: void putchar(char ch)
;	-----------------------------------------
;	 function putchar
;	-----------------------------------------
_putchar:
;	sw_i2c_test.c: 42: uart_putchar(ch);
	ld	a, (0x03, sp)
	push	a
	call	_uart_putchar
	pop	a
	ret
;	sw_i2c_test.c: 46: void crlf(void)
;	-----------------------------------------
;	 function crlf
;	-----------------------------------------
_crlf:
;	sw_i2c_test.c: 48: uart_putchar(0x0d);
	push	#0x0d
	call	_uart_putchar
	pop	a
;	sw_i2c_test.c: 49: uart_putchar(0x0a);
	push	#0x0a
	call	_uart_putchar
	pop	a
	ret
;	sw_i2c_test.c: 57: int main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #15
;	sw_i2c_test.c: 64: sysclock_init(0);
	push	#0x00
	call	_sysclock_init
	pop	a
;	sw_i2c_test.c: 66: printfkomma= 1;                       // my_printf verwendet mit Formatter %k eine Kommastelle
	mov	_printfkomma+0, #0x01
;	sw_i2c_test.c: 67: i2c_master_init();
	call	_i2c_master_init
;	sw_i2c_test.c: 68: uart_init(19200);
	push	#0x00
	push	#0x4b
	call	_uart_init
	popw	x
;	sw_i2c_test.c: 70: i2c_master_init();
	call	_i2c_master_init
;	sw_i2c_test.c: 71: printf("\n\rI2C Bus scanning\n\r--------------------------\n\n\r" \
	ldw	x, #___str_0+0
	pushw	x
	call	_my_printf
	popw	x
;	sw_i2c_test.c: 73: anz= 0;
	clr	(0x0d, sp)
;	sw_i2c_test.c: 75: for (cx= 1; cx< 127; cx++)
	ldw	x, #___str_2+0
	ldw	(0x05, sp), x
	ldw	x, #___str_1+0
	ldw	(0x0b, sp), x
	ld	a, #0x01
	ld	(0x02, sp), a
00115$:
;	sw_i2c_test.c: 77: ack= i2c_start(cx << 1);
	ld	a, (0x02, sp)
	sll	a
	push	a
	call	_i2c_start
	addw	sp, #1
	ld	(0x01, sp), a
;	sw_i2c_test.c: 78: delay_ms(1);
	push	#0x01
	push	#0x00
	call	_delay_ms
	popw	x
;	sw_i2c_test.c: 79: i2c_stop();
	call	_i2c_stop
;	sw_i2c_test.c: 80: if (ack)
	tnz	(0x01, sp)
	jreq	00104$
;	sw_i2c_test.c: 82: printf("%xh  ",(cx << 1));
	clrw	x
	ld	a, (0x02, sp)
	ld	xl, a
	sllw	x
	ldw	y, (0x0b, sp)
	pushw	x
	pushw	y
	call	_my_printf
	addw	sp, #4
;	sw_i2c_test.c: 83: anz++;
	ld	a, (0x0d, sp)
	inc	a
;	sw_i2c_test.c: 84: anz= anz % 5;
	clrw	x
	ld	xl, a
	ld	a, #0x05
	div	x, a
	ld	(0x0d, sp), a
;	sw_i2c_test.c: 85: if (!anz) printf("\n\r");
	tnz	(0x0d, sp)
	jrne	00104$
	ldw	x, (0x05, sp)
	pushw	x
	call	_my_printf
	popw	x
00104$:
;	sw_i2c_test.c: 87: delay_ms(1);
	push	#0x01
	push	#0x00
	call	_delay_ms
	popw	x
;	sw_i2c_test.c: 75: for (cx= 1; cx< 127; cx++)
	inc	(0x02, sp)
	ld	a, (0x02, sp)
	cp	a, #0x7f
	jrc	00115$
;	sw_i2c_test.c: 89: printf("\n\n\rEnd of I2C-bus scanning... \n\n\r");
	ldw	x, #___str_3+0
	pushw	x
	call	_my_printf
	popw	x
;	sw_i2c_test.c: 90: i2c_stop();
	call	_i2c_stop
;	sw_i2c_test.c: 118: printf("\n\n\rgelesene Werte: \n\r");
	ldw	x, #___str_4+0
	pushw	x
	call	_my_printf
	popw	x
;	sw_i2c_test.c: 120: for (cnt= 0; cnt< 8; cnt++)
	ldw	x, #___str_5+0
	ldw	(0x0e, sp), x
	clrw	x
	ldw	(0x03, sp), x
00117$:
;	sw_i2c_test.c: 122: i2c_start(0xa0);
	push	#0xa0
	call	_i2c_start
	pop	a
;	sw_i2c_test.c: 123: i2c_write(0x10+cnt);
	ld	a, (0x04, sp)
	add	a, #0x10
	push	a
	call	_i2c_write
	pop	a
;	sw_i2c_test.c: 125: i2c_start(0xa1);
	push	#0xa1
	call	_i2c_start
	pop	a
;	sw_i2c_test.c: 126: inp= i2c_read_nack();
	push	#0x00
	call	_i2c_read
	addw	sp, #1
	clrw	x
	ld	xl, a
;	sw_i2c_test.c: 127: i2c_stop();
	pushw	x
	call	_i2c_stop
	popw	x
;	sw_i2c_test.c: 128: printf("%xh ",inp);
	ldw	y, (0x0e, sp)
	pushw	x
	pushw	y
	call	_my_printf
	addw	sp, #4
;	sw_i2c_test.c: 120: for (cnt= 0; cnt< 8; cnt++)
	ldw	x, (0x03, sp)
	incw	x
	ldw	(0x03, sp), x
	ldw	x, (0x03, sp)
	cpw	x, #0x0008
	jrslt	00117$
;	sw_i2c_test.c: 131: printf("\n\n\rPageread 1:\n\r");
	ldw	x, #___str_6+0
	pushw	x
	call	_my_printf
	popw	x
;	sw_i2c_test.c: 133: i2c_start(0xa0);
	push	#0xa0
	call	_i2c_start
	pop	a
;	sw_i2c_test.c: 134: i2c_write(0x10);
	push	#0x10
	call	_i2c_write
	pop	a
;	sw_i2c_test.c: 135: i2c_start(0xa1);
	push	#0xa1
	call	_i2c_start
	pop	a
;	sw_i2c_test.c: 137: for (cnt= 0; cnt< 7; cnt++)
	ldw	y, (0x0e, sp)
	ldw	(0x07, sp), y
	clrw	x
	ldw	(0x03, sp), x
00119$:
;	sw_i2c_test.c: 139: inp= i2c_read_ack();
	push	#0x01
	call	_i2c_read
	addw	sp, #1
	clrw	x
	ld	xl, a
;	sw_i2c_test.c: 140: printf("%xh ",inp);
	ldw	y, (0x07, sp)
	pushw	x
	pushw	y
	call	_my_printf
	addw	sp, #4
;	sw_i2c_test.c: 137: for (cnt= 0; cnt< 7; cnt++)
	ldw	x, (0x03, sp)
	incw	x
	ldw	(0x03, sp), x
	ldw	x, (0x03, sp)
	cpw	x, #0x0007
	jrslt	00119$
;	sw_i2c_test.c: 142: inp= i2c_read_nack();
	push	#0x00
	call	_i2c_read
	addw	sp, #1
	clrw	x
	ld	xl, a
;	sw_i2c_test.c: 143: printf("%xh ",inp);
	ldw	y, (0x0e, sp)
	pushw	x
	pushw	y
	call	_my_printf
	addw	sp, #4
;	sw_i2c_test.c: 144: i2c_stop();
	call	_i2c_stop
;	sw_i2c_test.c: 146: printf("\n\n\rPageread 2:\n\r");
	ldw	x, #___str_7+0
	pushw	x
	call	_my_printf
	popw	x
;	sw_i2c_test.c: 148: i2c_start(0xa0);
	push	#0xa0
	call	_i2c_start
	pop	a
;	sw_i2c_test.c: 149: i2c_write(0x40);
	push	#0x40
	call	_i2c_write
	pop	a
;	sw_i2c_test.c: 150: i2c_start(0xa1);
	push	#0xa1
	call	_i2c_start
	pop	a
;	sw_i2c_test.c: 152: for (cnt= 0; cnt< 7; cnt++)
	ldw	y, (0x0e, sp)
	ldw	(0x09, sp), y
	clrw	x
	ldw	(0x03, sp), x
00121$:
;	sw_i2c_test.c: 154: inp= i2c_read_ack();
	push	#0x01
	call	_i2c_read
	addw	sp, #1
	clrw	x
	ld	xl, a
;	sw_i2c_test.c: 155: printf("%xh ",inp);
	ldw	y, (0x09, sp)
	pushw	x
	pushw	y
	call	_my_printf
	addw	sp, #4
;	sw_i2c_test.c: 152: for (cnt= 0; cnt< 7; cnt++)
	ldw	x, (0x03, sp)
	incw	x
	ldw	(0x03, sp), x
	ldw	x, (0x03, sp)
	cpw	x, #0x0007
	jrslt	00121$
;	sw_i2c_test.c: 157: inp= i2c_read_nack();
	push	#0x00
	call	_i2c_read
	addw	sp, #1
	clrw	x
	ld	xl, a
;	sw_i2c_test.c: 158: printf("%xh ",inp);
	ldw	y, (0x0e, sp)
	pushw	x
	pushw	y
	call	_my_printf
	addw	sp, #4
;	sw_i2c_test.c: 159: i2c_stop();
	call	_i2c_stop
;	sw_i2c_test.c: 161: printf("\n\n\rend of test\n\r");
	ldw	x, #___str_8+0
	pushw	x
	call	_my_printf
	popw	x
;	sw_i2c_test.c: 163: while(1)
00110$:
	jra	00110$
;	sw_i2c_test.c: 167: while(1);
	addw	sp, #15
	ret
	.area CODE
___str_0:
	.db 0x0A
	.db 0x0D
	.ascii "I2C Bus scanning"
	.db 0x0A
	.db 0x0D
	.ascii "--------------------------"
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.ascii "Devices fou"
	.ascii "nd at address:"
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_1:
	.ascii "%xh  "
	.db 0x00
___str_2:
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_3:
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.ascii "End of I2C-bus scanning... "
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_4:
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.ascii "gelesene Werte: "
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_5:
	.ascii "%xh "
	.db 0x00
___str_6:
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.ascii "Pageread 1:"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_7:
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.ascii "Pageread 2:"
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_8:
	.db 0x0A
	.db 0x0A
	.db 0x0D
	.ascii "end of test"
	.db 0x0A
	.db 0x0D
	.db 0x00
	.area INITIALIZER
	.area CABS (ABS)
