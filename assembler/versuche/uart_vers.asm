/* -------------------------------------------
                   uart_vers.asm

     Versuche, den STM8S103 mittels Assembler
     - naken_asm - zu programmieren

       MCU   :  STM8S103F3
       Takt  :  interner Takt 16 MHz

       11.04.2017  R. Seelig
   ------------------------------------------- */
.stm8

#include "stm8defs.inc"

#define speedh 0x01
#define speedl 0xa4


// RAM lieg an Adresse 0x0000..0x03ff ( 1kByte )

r0 equ 0x0000                   // Speichrplaetze fuer allgemeinen Gebrauch
r1 equ 0x0001
r2 equ 0x0002
r3 equ 0x0003
r4 equ 0x0004
r5 equ 0x0005
r6 equ 0x0006
r7 equ 0x0007

ch equ 0x0008                   // Bytevariable
b1 equ 0x0009
cx equ 0x000a

YH equ 0x000b
YL equ 0x000c

.org 0x8000                     // Startadresse nach dem Einschalten
  jp main

.org 0x8080                     // ab 0x8080 kann ein Programm gespeichert sein
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
  bset PB_ODR, #5
.endm

.macro pb5_clr
  bres PB_ODR, #5
.endm

.macro pb4_set
  bset PB_ODR, #4
.endm

.macro pb4_clr
  bres PB_ODR, #4
.endm

; kopiert Byte MSB von Y in Variable YH und LSB von Y in Variable YL
.macro y2hilo
  pushw x
  push a

  ldw x, #YH
  pushw y
  pop a
  ld (x), a
  incw x
  pop a
  ld (x), a

  pop a
  popw x
.endm

; kopiert die Variable YH und YL nach Y (16 Bit)
.macro hilo2y
  pushw x
  push a

  ldw x, #YL
  ld a,(x)
  push a
  decw x
  ld a,(x)
  push a
  popw y

  pop a
  pushw x
.endm

.macro call_delay
  push #speedl
  push #speedh
  call delay
  popw x
.endm

.macro send_crlf
  push a
  ld a, #0x0a
  call uart_putchar
  ld a, #0x0d
  call uart_putchar
  pop a
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

  bset USART1_CR2, #USART_CR2_TEN

  ; RxD enable
  bset USART1_CR2, #USART_CR2_REN

  ; Stopbit = 1
  bres USART1_CR3, #USART_CR3_STOP1

  ; 57600 Baud
  mov USART1_BRR1, #0x11
  mov USART1_BRR2, #0x06

  ret

// ------------------------------------------
//   uart_putchar
//
//   sendet das Zeichen im Akku
// ------------------------------------------
uart_putchar:

  pushw x
  push a
uart_waitsend:
  ldw x, #USART1_SR
  ld a, (x)
  tnz a
  jrpl uart_waitsend        ; springt, wenn a > 0
  pop a
  popw x

  ld USART1_DR, a           ; Zeichen R senden (0x52)

  ret

// ------------------------------------------
//   uart_getchar
//
//   liest ein Zeichen in den Akku ein
// ------------------------------------------
uart_getchar:
  pushw x
ug_waitpresent:
  ldw x, #USART1_SR
  ld a, (x)
  bcp a, #RXNE_MASK
  jreq ug_waitpresent
  ldw x, #USART1_DR
  ld a,(x)
  popw x

  ret

// ------------------------------------------
//   uart_ischar
//
//   testet, ob ein Zeichen eingetroffen ist
//     Zero = 0 wenn eingetroffen
//            1 wenn nicht
//
//   Beispiel:
//     call uart_ischar
//     jreq nochar_present
//
// ------------------------------------------
uart_ischar:
  rcf
  ldw x, #USART1_SR
  ld a, (x)
  and a, #RXNE_MASK

  ret


// ------------------------------------------
//   uart_sendstring
//
//   sendet einen AsciiZ -  String auf
//   den X zeigt
// ------------------------------------------
uart_sendstring:
  ld a, (x)
  call uart_putchar
  incw x
  ld  a, (x)
  tnz     a
  jrne uart_sendstring

  ret

// ------------------------------------------
//   uart_sendhex
//
//   sendet den Wert in a als Hexadezimal-
//   zahl
// ------------------------------------------
uart_sendhex:
  push a
  ld r0, a

  swap a                    ; oberes Nibble nach unten
  and a, #0x0f              ; nur noch oberes Nibble unten vorhanden
  cp a, #0x0a               ; Testen, ob es alphanumerisches Zeichen ist
                            ; Carry ist gesetzt, wenn 0x0a groesser als a ist
  jrnc sh_alphah
  add a,#'0'
  jra sh_endhnibble
sh_alphah:
  add a,#55
sh_endhnibble:
  call uart_putchar

  ld a, r0
  and a, #0x0f
  cp a, #0x0a
  jrnc sh_alphal
  add a,#'0'
  jra sh_endlnibble
sh_alphal:
  add a,#55
sh_endlnibble:
  call uart_putchar

  pop a
  ret

// ------------------------------------------
//   uart_sendhexw
//
//   sendet den 16-Bit Wert, auf den
//   X zeigt
// ------------------------------------------
uart_sendhexw:
  push a
  ld a, (x)
  call uart_sendhex
  incw x
  ld a, (x)
  call uart_sendhex
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
  inc b1                        ; in Speicherstelle b1 steht jetzt 'H'

  // Unlock Flash-Speicher
  mov FLASH_PUKR, #FLASH_RASS_KEY1
  mov FLASH_PUKR, #FLASH_RASS_KEY2

  ldw x, #0x8012                ; Speicherstelle im Codebereich
  ld a, #0x30
  ld (x), a
  incw x
  add a,#2
  ld (x), a


  ldw x, #msg1
  call uart_sendstring

  ld a, #0xab
  call uart_sendhex

  send_crlf

  mov r1, #0x90
  mov r2, #0x7c

  ldw x, #r1
  call uart_sendhexw

  send_crlf

  ldw x, #msg2
  call uart_sendstring

  ldw x, #0x8012
  ld a,(x)
  call uart_sendhex

  send_crlf
  send_crlf

  ldw y, #msg1

  incw y
  y2hilo

  ldw x,#YH
  call uart_sendhexw
  send_crlf

  mov cx,#0
  ldw x, #YH
  ld a,#0x00
  ld (x), a
  incw x
  ld a,#0x05
  ld (x), a
  hilo2y

repeat:

  pb5_clr
  pb4_set

  call_delay

  pb5_set
  pb4_clr

  call_delay

  ldw x, #msg3
  call uart_sendstring

  decw y
  tnzw y
  jrne ynotnull
  ldw x, #counterzero
  call uart_sendstring
  ldw x, #msg3
  call uart_sendstring
ynotnull:
  y2hilo
  ldw x, #YH
  call uart_sendhexw
  ld a,#' '
  call uart_putchar

  jp repeat

msg1:
  .db 13,10,"Ralph Seelig",13,10,0
msg2:
  .db "Byte im Flashspeicher: ",0
msg3:
  .db 13," Counter: ",0
counterzero:
  .db 13,10," Counter wurde zu null... ",13,10,0