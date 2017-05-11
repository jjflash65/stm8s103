/* -----------------------------------------------------------------------
                              bootloader.asm

     Serieller Bootloader fuer STM8S103F3P6

     Bootloader belegt den Speicher ab Adresse 0x9E40 sodass fuer ein
     Userprogramm der Speicherplatz von 0x8000 . 0x9E3F zur Verfuegung
     steht (7744 Bytes = 121 * 64 Byte-Bloecke)

     Der Bootloader erwartet nach einem Reset das Ascii-Zeichen "u",
     trifft dies nach einer Wartezeit nicht ein, wird das im Flash ab-
     gelegte User-Programm gestartet.

     Proprietaeres Uebertragungsprotokoll:

          Host sendet       STM8 antwortet
       -------------------------------------
             "u"                 "o"
       -------------------------------------
            32-Bit
         Resetvektor
         Userprogramm
         Binaerformat
       -------------------------------------
             Anzahl
             64 Byte
             Bloecke
        (1 Byte binaer)
       -------------------------------------
                             Echo der Re-
                             setvektor-
                             adresse und der
                             Anzahl der
                             Bloecke
       -------------------------------------
           n-Anzahl
       64 Byte Bloecke
                             nach jedem empf-
                             angenem Block
                             wird ein "o"
                             gesendet
       -------------------------------------
                             Start des
                             Userprogramms
       -------------------------------------


       Assembler : naken_asm
       MCU       :  STM8S103F3
       Takt      :  interner Takt 16 MHz

       11.04.2017  R. Seelig
   ----------------------------------------------------------------------- */
.stm8

#include "stm8defs.inc"

; RAM lieg an Adresse 0x0000..0x03ff ( 1kByte )

r0      equ 0x0000                   ; Speichrplaetze fuer allgemeinen Gebrauch
r1      equ 0x0001
r2      equ 0x0002
r3      equ 0x0003
r4      equ 0x0004
r5      equ 0x0005
r6      equ 0x0006
r7      equ 0x0007

blkanz  equ 0x0008                   ; Anzahl zu flashender Bloecke

int32_3 equ 0x0009
int32_2 equ 0x000a
int32_1 equ 0x000b
int32_0 equ 0x000c

YH      equ 0x000d
YL      equ 0x000e

arr64by equ 0x0100


.org 0x8000                         ; Startadresse nach dem Einschalten (Resetvektor)
  jpf main

.org 0x9e40                         ; Speicheradresse, ab der der Bootloader im
                                    ; Flash abgelegt ist. Somit sind 7744 Bytes
                                    ; fuer das Userprogramm verfuegbar


; ------------------------------------------
;   wait_progstart (Macro)
;
;  Warteschleife die nach einem Reset ge-
;  wartet wird. Innerhalb dieser Zeit muss
;  das Ascii-Zeichen "u" eingegangen sein
;  damit das Flashprogramm gestartet wird,
;  anderenfalls wird das Userprogramm im
;  Flash gestartet
; ------------------------------------------
.macro wait_progstart
  push #0x00
  push #0x03
  call delay
  popw x
.endm

; ------------------------------------------
;     y2hilo (Macro)
;
;  kopiert Byte MSB von Register Y nach
;  Variable YH und LSB von Y nach Variable
;  YL
; ------------------------------------------
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

; ------------------------------------------
;     hilo2y (Macro)
;
;  kopiert die Variable YH und YL ins
;  Register  Y (16 Bit)
; ------------------------------------------
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

.macro loady(hi, lo)
  pushw x
  push a

  ldw x, #YH
  ld a,hi
  ld (x), a
  incw x
  ld a,lo
  ld (x), a
  hilo2y
  pop a
  popw x

.endm

; ------------------------------------------
;      waitwritten (Macro)
;
;   wartet, bis ein Flashschreibvorgang
;   beendet ist
; ------------------------------------------
.macro waitwritten
  .scope
  waitwrite:
    btjt FLASH_IAPSR, #FLASH_IAPSR_EOP, waitwrite
  .ends
.endm


; ------------------------------------------
;   delay
;
;   Verzoegerungsschleife, erwartet einen
;   Parameter auf dem Stack um den ver-
;   zoegert werden soll
; ------------------------------------------
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

; ------------------------------------------
;   sysclock_init
;
;   internen 16MHz Takt setzen
; ------------------------------------------
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

; ------------------------------------------
;   uart_init
;
;   57600 Baud 8N1
; ------------------------------------------
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

; ------------------------------------------
;   uart_putchar
;
;   sendet das Zeichen im Akku
; ------------------------------------------
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

; ------------------------------------------
;   uart_getchar
;
;   liest ein Zeichen in den Akku ein
; ------------------------------------------
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

; ------------------------------------------
;   uart_ischar
;
;   testet, ob ein Zeichen eingetroffen ist
;     Zero = 0 wenn eingetroffen
;            1 wenn nicht
;
;   Beispiel:
;     call uart_ischar
;     jreq nochar_present
; ------------------------------------------
uart_ischar:
  rcf
  ldw x, #USART1_SR
  ld a, (x)
  and a, #RXNE_MASK

  ret

; ------------------------------------------
;   uart_getnstore
;
;   liest 4 Bytes auf der seriellen Schnitt-
;   stelle ein und speichert die in X
;   indizierte Stelle im Flash
; ------------------------------------------
uart_getnstore:
  pushw x
  push a

  call uart_getchar
  ld (x),a
  call uart_getchar
  incw x
  ld (x),a
  call uart_getchar
  incw x
  ld (x),a
  call uart_getchar
  incw x
  ld (x),a

  pop a
  popw x
  ret

; ------------------------------------------
;   copyint32
;
;   kopiert einen 32-Bit Wert (4 Bytes) von
;   src nach dest
;
;   y => Zeiger auf src
;   x => Zeiger auf dest
; ------------------------------------------
copyint32:
  ld a,(y)
  ld (x),a
  incw x
  incw y
  ld a,(y)
  ld (x),a
  incw x
  incw y
  ld a,(y)
  ld (x),a
  incw x
  incw y
  ld a,(y)
  ld (x),a
  ret

; --------------------------------------------------------
;                          M-A-I-N
; --------------------------------------------------------

main:
  call sysclock_init
  call uart_init


  ; Unlock Flash-Speicher
  mov FLASH_PUKR, #FLASH_RASS_KEY1
  mov FLASH_PUKR, #FLASH_RASS_KEY2
  wait_progstart

comloop:
  call uart_ischar
  jrne no_userprogstart
  bres FLASH_IAPSR, #FLASH_IAPSR_PUL            ; Lock Flash

  jp org_reset
no_userprogstart:
  call uart_getchar

  cp a,#'u'
  jreq progflash
  bres FLASH_IAPSR, #FLASH_IAPSR_PUL            ; Lock Flash
  jp org_reset
  jp comloop
progflash:

  ld a,#'o'
  call uart_putchar

  ; Word-Programming an (fuer Resetvektor speichern)
  bset FLASH_CR2, #FLASH_CR2_WPRG

  ; Resetvektoradresse via RS-232 laden und am FLASH-Speicherende
  ; speichern
  ldw x,#org_reset
  call uart_getnstore

  waitwritten

  bres FLASH_CR2, #FLASH_CR2_WPRG

  ; Anzahl der zu flashenden 64-Byte Bloecke lesen
  call uart_getchar
  ldw x, #blkanz
  ld (x),a

  ; Addresse Resetvektor an Host zuruecksenden (Kontrolle)
  ldw x,#org_reset
  ld a,(x)
  call uart_putchar

  incw x
  ld a,(x)
  call uart_putchar

  incw x
  ld a,(x)
  call uart_putchar

  incw x
  ld a,(x)
  call uart_putchar

  ; Anzahl der 64-Byte Bloecke zuruecksenden (Kontrolle)
  exg a,blkanz
  call uart_putchar

  push a                        ; Blockanzahl

  ; ersten Block (mit Resetvektoradresse per RS-232 laden
  ; und im RAM speichern

  ldw x,#arr64by
  ld a,#64

blk_copy1:
  push a
  call uart_getchar
  ld (x),a
  incw x
  pop a
  dec a
  jrne blk_copy1

  ; Bootloader Resetvektor ins Ram-Array kopieren
  ldw y,#0x8000
  ldw x,#arr64by
  call copyint32

  ldw x,#0x8000
  ldw y,#arr64by
  ld a,#64

  bset FLASH_CR2, #FLASH_CR2_PRG

  ; ersten 64-Byte Block flashen (dieser unterscheidet sich von allen folgenden
  ; darin, dass hier der Resetvektor dieses Bootloaders an Adresse 0x8000 ge-
  ; schrieben wird. Der Resetvektor des User-Programms wird an org_reset am
  ; Flash-Ende abgelegt
blk_copy2:
  push a
  ld a,(y)
  ld (x),a
  incw x
  incw y
  pop a
  dec a
  jrne blk_copy2

  waitwritten
  ld a,#'o'
  call uart_putchar

  pop a                         ; Blockanzahl

; alle weiteren 64-Byte Bloecke flashen
blk_copy3:
  dec a
  jreq blk_copyend
blk_copy4:
  push a

  ldw y,#arr64by
  ld a,#64
blk_copy1b:
  push a
  call uart_getchar
  ld (y),a
  incw y
  pop a
  dec a
  jrne blk_copy1b

  ldw y,#arr64by
  ld a,#64

blk_copy2b:
  push a
  ld a,(y)
  ld (x),a
  incw x
  incw y
  pop a
  dec a
  jrne blk_copy2b

  waitwritten
  ld a,#'o'
  call uart_putchar

  pop a
  jp blk_copy3

blk_copyend:
  bres FLASH_IAPSR, #FLASH_IAPSR_PUL
  wait_progstart
  jp org_reset
  jp comloop

; 4 Byte - Speicheradresse Resetvektor Userprogramm
.org 0x9ffa
org_reset:
