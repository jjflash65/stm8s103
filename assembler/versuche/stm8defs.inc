/* -------------------------------------------
                   stm8defs.inc

     Speicheradressen diverser Register des
     STM8S103F3P6
   ------------------------------------------- */

#define PB_ODR           0x5005
#define PB_IDR           0x5006
#define PB_DDR           0x5007
#define PB_CR1           0x5008
#define PB_CR2           0x5009

// Clock

#define CLK_ICKR         0x50C0
#define CLK_ECKR         0x50C1
#define CLK_CMSR         0x50C3
#define CLK_SWR          0x50C4
#define CLK_SWCR         0x50C5
#define CLK_CKDIVR       0x50C6
#define CLK_PCKENR1      0x50C7
#define CLK_CSSR         0x50C8
#define CLK_CCOR         0x50C9
#define CLK_PCKENR2      0x50CA
#define CLK_HSITRIMR     0x50CC
#define CLK_SWIMCCR      0x50CD

// CLOCK : Bitadressen

#define HSIEN   1
#define HSIRDY  2
#define SWEN    2
#define SWBSY   8

#define HSEEN   1
#define HSERDY  2

#define SWIF    8

//  USART

#define USART1_SR        0x5230
#define USART1_DR        0x5231
#define USART1_BRR1      0x5232
#define USART1_BRR2      0x5233
#define USART1_CR1       0x5234
#define USART1_CR2       0x5235
#define USART1_CR3       0x5236
#define USART1_CR4       0x5237
#define USART1_CR5       0x5238
#define USART1_GTR       0x5239
#define USART1_PSCR      0x523A

// USART_CR1 Bitpositionen
#define USART_CR1_R8        7
#define USART_CR1_T8        6
#define USART_CR1_UARTD     5
#define USART_CR1_M         4
#define USART_CR1_WAKE      3
#define USART_CR1_PCEN      2
#define USART_CR1_PS        1
#define USART_CR1_PIEN      0

// USART_CR2 bits
#define USART_CR2_TIEN      7
#define USART_CR2_TCIEN     6
#define USART_CR2_RIEN      5
#define USART_CR2_ILIEN     4
#define USART_CR2_TEN       3
#define USART_CR2_REN       2
#define USART_CR2_RWU       1
#define USART_CR2_SBK       0

// USART_CR3 bits
#define USART_CR3_LINEN     6
#define USART_CR3_STOP2     5
#define USART_CR3_STOP1     4
#define USART_CR3_CLKEN     3
#define USART_CR3_CPOL      2
#define USART_CR3_CPHA      1
#define USART_CR3_LBCL      0

// USART_SR bits
#define USART_SR_TXE        7
#define USART_SR_TC         6
#define USART_SR_RXNE       5
#define USART_SR_IDLE       4
#define USART_SR_OR         3
#define USART_SR_NF         2
#define USART_SR_FE         1
#define USART_SR_PE         0

#define RXNE_MASK           0x20

// FLASH

#define FLASH_PUKR       0x5062

#define FLASH_RASS_KEY1  0x56
#define FLASH_RASS_KEY2  0xAE
