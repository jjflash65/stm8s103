;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Aug 12 2015) (Linux)
; This file was generated Mon Apr 10 21:08:09 2017
;--------------------------------------------------------
	.module txlcd_demo
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _my_printf
	.globl _txlcd_putchar
	.globl _txlcd_setuserchar
	.globl _gotoxy
	.globl _txlcd_init
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
;	txlcd_demo.c: 78: void putchar(char ch)
;	-----------------------------------------
;	 function putchar
;	-----------------------------------------
_putchar:
;	txlcd_demo.c: 80: txlcd_putchar(ch);
	ld	a, (0x03, sp)
	push	a
	call	_txlcd_putchar
	pop	a
	ret
;	txlcd_demo.c: 84: int main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #4
;	txlcd_demo.c: 88: sysclock_init(0);                     // erst Initialisieren mit internem RC
	push	#0x00
	call	_sysclock_init
	pop	a
;	txlcd_demo.c: 91: txlcd_init();
	call	_txlcd_init
;	txlcd_demo.c: 92: delay_ms(500);
	push	#0xf4
	push	#0x01
	call	_delay_ms
	popw	x
;	txlcd_demo.c: 93: txlcd_setuserchar(0,&hoch2bmp[0]);
	ldw	x, #_hoch2bmp+0
	pushw	x
	push	#0x00
	call	_txlcd_setuserchar
	addw	sp, #3
;	txlcd_demo.c: 95: cnt= 0;
	clrw	x
	ldw	(0x03, sp), x
;	txlcd_demo.c: 97: gotoxy(1,1); printf(" STM8 S103 F3P6");
	push	#0x01
	push	#0x01
	call	_gotoxy
	popw	x
	ldw	x, #___str_0+0
	pushw	x
	call	_my_printf
	popw	x
;	txlcd_demo.c: 98: gotoxy(1,2); printf(" TX-LCD ");
	push	#0x02
	push	#0x01
	call	_gotoxy
	popw	x
	ldw	x, #___str_1+0
	pushw	x
	call	_my_printf
	popw	x
;	txlcd_demo.c: 104: delay_ms(2000);
	push	#0xd0
	push	#0x07
	call	_delay_ms
	popw	x
;	txlcd_demo.c: 105: gotoxy(1,2); printf("        ");
	push	#0x02
	push	#0x01
	call	_gotoxy
	popw	x
	ldw	x, #___str_2+0
	ldw	(0x01, sp), x
	ldw	x, (0x01, sp)
	pushw	x
	call	_my_printf
	popw	x
;	txlcd_demo.c: 106: while(1)
00104$:
;	txlcd_demo.c: 108: gotoxy(4,2);
	push	#0x02
	push	#0x04
	call	_gotoxy
	popw	x
;	txlcd_demo.c: 109: printf("%d%c= %d ",cnt,0,cnt*cnt);
	ldw	x, (0x03, sp)
	pushw	x
	ldw	x, (0x05, sp)
	pushw	x
	call	__mulint
	addw	sp, #4
	ldw	y, #___str_3+0
	pushw	x
	clrw	x
	pushw	x
	ldw	x, (0x07, sp)
	pushw	x
	pushw	y
	call	_my_printf
	addw	sp, #8
;	txlcd_demo.c: 110: cnt++;
	ldw	x, (0x03, sp)
	incw	x
;	txlcd_demo.c: 111: cnt= cnt % 31;
	ldw	y, #0x001f
	divw	x, y
	ldw	(0x03, sp), y
;	txlcd_demo.c: 112: if (!cnt)
	ldw	x, (0x03, sp)
	jrne	00102$
;	txlcd_demo.c: 114: gotoxy(4,2); printf("        ");
	push	#0x02
	push	#0x04
	call	_gotoxy
	popw	x
	ldw	x, (0x01, sp)
	pushw	x
	call	_my_printf
	popw	x
00102$:
;	txlcd_demo.c: 116: delay_ms(1000);
	push	#0xe8
	push	#0x03
	call	_delay_ms
	popw	x
	jra	00104$
	addw	sp, #4
	ret
	.area CODE
_hoch2bmp:
	.db #0x06	; 6
	.db #0x01	; 1
	.db #0x06	; 6
	.db #0x08	; 8
	.db #0x0F	; 15
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
___str_0:
	.ascii " STM8 S103 F3P6"
	.db 0x00
___str_1:
	.ascii " TX-LCD "
	.db 0x00
___str_2:
	.ascii "        "
	.db 0x00
___str_3:
	.ascii "%d%c= %d "
	.db 0x00
	.area INITIALIZER
	.area CABS (ABS)
