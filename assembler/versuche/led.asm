.stm8

#include "stm8defs.inc"

speedl equ 0x80
speedh equ 0x00

.org 0x8000
  jp main

.org 0x8080

; lesen, modifizieren, zurueckschreiben
// Kommentar
/*

laengerer Kommentar
*/
.macro pb5_set
  ld a, PB_ODR
  or a, #$20                ; = 0010.0000
  ld PB_ODR,a
.endm

.macro pb5_clr
  ld a, PB_ODR
  and a, #$df                ; = 1101.1111
  ld PB_ODR,a
.endm

.macro pb4_set
  ld a, PB_ODR
  or a, #$10                ; = 0001.0000
  ld PB_ODR,a
.endm

.macro pb4_clr
  ld a, PB_ODR
  and a, #$ef               ; = 1110.1111
  ld PB_ODR,a
.endm

.macro call_delay
  push #speedl
  push #speedh
  call delay
  popw x
.endm


delay:
  pushw y
  ldw y, (0x05, sp)
loop_outer:
  pushw y

  ldw y, #1600
loop_inner:
  decw y
  jrne loop_inner

  popw y
  decw y
  jrne loop_outer
  popw y
  ret


main:
  mov PB_CR1, #$30
  mov PB_CR2, #$cf
  mov PB_DDR, #$30              ; Direction Register (aehnlich AVR)

repeat:
  mov PB_ODR, #$30              ; PB5 an, alle anderen aus

  pb5_clr
  pb4_set

  call_delay

  pb5_set
  pb4_clr

  call_delay

  jp repeat


