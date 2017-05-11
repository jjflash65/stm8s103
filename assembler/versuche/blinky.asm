/* -------------------------------------------
                   blinky.asm

     Versuche, den STM8S103 mittels Assembler
     - naken_asm - zu programmieren

       MCU   :  STM8S103F3
       Takt  :  interner Takt 16 MHz

       11.04.2017  R. Seelig
   ------------------------------------------- */
.stm8

#include "stm8defs.inc"

#define speedl 0xf4
#define speedh 0x00


// RAM lieg an Adresse 0x0000..0x03ff ( 1kByte )

r0 equ 0x0000                   // Speichrplaetze fuer allgemeinen Gebrauch
r1 equ 0x0000
r2 equ 0x0000
r3 equ 0x0000
r4 equ 0x0000
r5 equ 0x0000
r6 equ 0x0000
r7 equ 0x0000
ch equ 0x0008                   // Bytevariable
b1 equ 0x0009



.org 0x8000                     // Startadresse nach dem Einschalten
  jp main

; .org 0x8080                     // ab 0x8080 kann ein Programm gespeichert sein
                                // im Bereich zwischn 0x8000 und 0x8080 liegen
                                // Interruptvektoren

.macro pb_setoutputs(mask)
  mov PB_CR1, #mask
  ld a,#mask
  cpl a
  ld PB_CR2, a
  mov PB_DDR, #mask          ; Data Direction Register ( Bit = 1 => Ausgang )
.endm                        ;                         ( Bit = 0 => Eingang )


.macro pb5_set
// Outputregister :lesen, modifizieren, zurueckschreiben

  ld a, PB_ODR
  or a, #$20                 ; = 0010.0000
  ld PB_ODR, a
.endm

.macro pb5_clr
  ld a, PB_ODR
  and a, #$df                ; = 1101.1111
  ld PB_ODR, a
.endm

.macro pb4_set
  ld a, PB_ODR
  or a, #$10                 ; = 0001.0000
  ld PB_ODR, a
.endm

.macro pb4_clr
  ld a, PB_ODR
  and a, #$ef                ; = 1110.1111
  ld PB_ODR, a
.endm

.macro call_delay
  push #speedl
  push #speedh
  call delay
  popw x
.endm

.macro call_putchar
  push a
  call uart_putchar
  pop a
.endm

.macro send_crlf
  ldw x, #crlf
  pushw x
  call uart_sendstring
  popw x
.endm


// ------------------------------------------
//   delay
//
//   Verzoegerungsschleife, erwartet einen
//   Parameter auf dem Stack um den ver-
//   zoegert werden soll
// ------------------------------------------
delay:
  pushw y
  ldw y, (0x05, sp)
loop_outer:
  pushw y

  ldw y, #5200
loop_inner:
  decw y
  jrne loop_inner

  popw y
  decw y
  jrne loop_outer
  popw y
  ret


// ------------------------------------------
//   sysclock_init
//
//   internen 16MHz Takt setzen
// ------------------------------------------
sysclock_init:
  mov CLK_ICKR, #0x00           ; reset Register int. Takt
  mov CLK_ECKR, #0x00           ; dto. ext. Takt
  mov CLK_ICKR, HSIEN           ; int. Takt enable

wait_itrnclk:
  ldw x, #CLK_ICKR
  ld a,(x)
  bcp a, #HSIRDY
  jreq wait_itrnclk             ; warten bis int. Takt eingeschwungen

  mov CLK_CKDIVR, #0x00         ; Takt-Divider volle Taktfreq.
  mov CLK_PCKENR1, #0xff        ; alle Peripherietakte an
  mov CLK_PCKENR2, #0xff
  mov CLK_CCOR, #0x00           ; CCO aus
  mov CLK_HSITRIMR, #0x00       ; keine Taktjustierung
  mov CLK_SWIMCCR, #0x00        ; SWIM = clock / 2
  mov CLK_SWR, #0xe1            ; int. Generator als Taktquelle
  mov CLK_SWCR, #0x00           ; Reset clock switch control register.
  mov CLK_SWCR, #SWEN           ; Enable switching.

wait_stableperiph:
  ldw x, #CLK_SWCR
  ld a,(x)
  bcp a, #SWBSY
  jrne wait_stableperiph
  ret

// ------------------------------------------
//   uart_init
//
//   57600 Baud 8N1
// ------------------------------------------
uart_init:

  ; TxD enable
  ldw x, #USART1_CR2
  ld a, (x)
  or a, #USART_CR2_TEN
  ld (x), a

  ; RxD enable
  ldw x, #USART1_CR2
  ld a, (x)
  or a, #USART_CR2_REN
  ld (x), a

  ; Stopbit = 1
  ldw x, #USART1_CR3
  ld a, (x)
  and a, #0xef               ; USART_CR3_STOP1 = 0x10, ~0x10 = 0xef
  ld (x), a

  ; 57600 Baud
  mov USART1_BRR1, #0x11
  mov USART1_BRR2, #0x06

  ret

// ------------------------------------------
//   uart_putchar
// ------------------------------------------
uart_putchar:
  push a

  pushw x
uart_waitsend:
  ldw x, #USART1_SR
  ld a, (x)
  tnz a
  jrpl uart_waitsend        ; springt, wenn a > 0
  popw x
  ld a, (0x04, sp)          ; zu sendendes Zeichen vom Stack laden

  ld USART1_DR, a           ; Zeichen R senden (0x52)
  pop a

  ret

// ------------------------------------------
//   uart_sendstring
//
//   erwartet auf dem Stack einen Zeiger
//   auf einen AsciiZ - String
// ------------------------------------------
uart_sendstring:
  pushw x

  ldw x, (0x05, sp)
textout:
  ld a, (x)
  call_putchar
  incw x
  ld  a, (x)
  tnz     a
  jrne textout

  popw x
  ret

// ------------------------------------------
//   uart_sendstring
//
//   sendet ein Byte als hexadezimalen
//   Wert
// ------------------------------------------
uart_sendhex:
  ld a, (0x02, sp)          ; zu sendendes Zeichen vom Stack laden
  push a
  ld r0, a
  pushw x

  swap a                    ; oberes Nibble nach unten
  and a, #0x0f              ; nur noch oberes Nibble unten vorhanden
  cp a, #0x0a               ; Testen, ob es alphanumerisches Zeichen ist
                            ; Carry ist gesetzt, wenn 0x0a groesser als a ist
  jrnc sendhex_alpha1

sendhex_alpha1:

  popw x
  pop a
  ret


// --------------------------------------------------------
//                          M-A-I-N
// --------------------------------------------------------

main:
  call sysclock_init
  pb_setoutputs($30)            ; PB4, PB5 als Ausgang
  call uart_init

  mov ch, #'G'
  mov b1, ch
  inc b1

  ldw x, #msg1
  pushw x
  call uart_sendstring
  popw x

repeat:

  pb5_clr
  pb4_set

  call_delay

  pb5_set
  pb4_clr

  call_delay

  jp repeat

msg1:
  .db 13,10,"Ralph Seelig",13,10,0
crlf:
  .db 0x0a, 0x0d, 0