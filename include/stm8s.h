/* -----------------------------------------------
      Register- und Bitadressen fuer einen
      STM8S MCU.

      UNVOLLSTAENDIG, es wurden nur die fuer den
      Umgang mit meinen Softwaremodulen noetigen
      Adressen (vor allem die der Bitadressen)
      aufgefuehrt.

      Bei Bedarf ins Datenblatt sehen und
      erweitern

      Compiler: SDCC

      18.05.2016    R. Seelig
   ----------------------------------------------- */

// ------------------- GPIO -------------------
#define PA_ODR *(unsigned char*)0x5000
#define PA_IDR *(unsigned char*)0x5001
#define PA_DDR *(unsigned char*)0x5002
#define PA_CR1 *(unsigned char*)0x5003
#define PA_CR2 *(unsigned char*)0x5004

#define PB_ODR *(unsigned char*)0x5005
#define PB_IDR *(unsigned char*)0x5006
#define PB_DDR *(unsigned char*)0x5007
#define PB_CR1 *(unsigned char*)0x5008
#define PB_CR2 *(unsigned char*)0x5009

#define PC_ODR *(unsigned char*)0x500A
#define PC_IDR *(unsigned char*)0x500B
#define PC_DDR *(unsigned char*)0x500C
#define PC_CR1 *(unsigned char*)0x500D
#define PC_CR2 *(unsigned char*)0x500E

#define PD_ODR *(unsigned char*)0x500F
#define PD_IDR *(unsigned char*)0x5010
#define PD_DDR *(unsigned char*)0x5011
#define PD_CR1 *(unsigned char*)0x5012
#define PD_CR2 *(unsigned char*)0x5013

#define PE_ODR *(unsigned char*)0x5014
#define PE_IDR *(unsigned char*)0x5015
#define PE_DDR *(unsigned char*)0x5016
#define PE_CR1 *(unsigned char*)0x5017
#define PE_CR2 *(unsigned char*)0x5018

#define PF_ODR *(unsigned char*)0x5019
#define PF_IDR *(unsigned char*)0x501A
#define PF_DDR *(unsigned char*)0x501B
#define PF_CR1 *(unsigned char*)0x501C
#define PF_CR2 *(unsigned char*)0x501D

// Portbits

#define PA0      0
#define PA1      1
#define PA2      2
#define PA3      3
#define PA4      4
#define PA5      5
#define PA6      6
#define PA7      7

#define PB0      0
#define PB1      1
#define PB2      2
#define PB3      3
#define PB4      4
#define PB5      5
#define PB6      6
#define PB7      7

#define PC0      0
#define PC1      1
#define PC2      2
#define PC3      3
#define PC4      4
#define PC5      5
#define PC6      6
#define PC7      7

#define PD0      0
#define PD1      1
#define PD2      2
#define PD3      3
#define PD4      4
#define PD5      5
#define PD6      6
#define PD7      7


// ------------------- CLOCK -------------------
#define CLK_ICKR        *(unsigned char*)0x50C0
#define CLK_ECKR	*(unsigned char*)0x50C1
#define CLK_CMSR        *(unsigned char*)0x50C3
#define CLK_SWR 	*(unsigned char*)0x50C4
#define CLK_SWCR	*(unsigned char*)0x50C5
#define CLK_CKDIVR	*(unsigned char*)0x50C6
#define CLK_PCKENR1     *(unsigned char*)0x50C7
#define CLK_CSSR	*(unsigned char*)0x50C8
#define CLK_CCOR	*(unsigned char*)0x50C9
#define CLK_PCKENR2     *(unsigned char*)0x50CA
#define CLK_HSITRIMR	*(unsigned char*)0x50CC
#define CLK_SWIMCCR     *(unsigned char*)0x50CD

// CLOCK : Bitadressen
#define HSIEN   (1 << 0)
#define HSIRDY  (1 << 1)
#define SWEN    (1 << 1)
#define SWBSY   (1 << 3)

#define HSEEN   (1 << 0)
#define HSERDY  (1 << 1)

#define SWIF    (1 << 3)


// ------------------- SPI -------------------
#define SPI_CR1         *(unsigned char*)0x5200
#define SPI_CR2         *(unsigned char*)0x5201
#define SPI_ICR         *(unsigned char*)0x5202
#define SPI_SR          *(unsigned char*)0x5203
#define SPI_DR          *(unsigned char*)0x5204
#define SPI_CRCPR       *(unsigned char*)0x5205
#define SPI_RXCRCR      *(unsigned char*)0x5206
#define SPI_TXCRCR      *(unsigned char*)0x5207

// Bits der SPI-Register
#define SPI_CR1_CPHA     (1 << 0)
#define SPI_CR1_CPOL     (1 << 1)
#define SPI_CR1_MSTR     (1 << 2)
#define SPI_CR1_BR       3                      // Baudratenbitposition=>  SPI_CR1 |=  (Teilerfaktor << SPI_CR1_BR);
#define SPI_CR1_BR0      (1 << 3)               // Baudraten Ctrl Bit0
#define SPI_CR1_BR1      (1 << 4)               // dto.           Bit1
#define SPI_CR1_BR2      (1 << 5)               // dto.           Bit2
#define SPI_CR1_SPE      (1 << 6)
#define SPI_CR1_LSBFIRST (1 << 7)


#define SPI_CR2_SSI      (1 << 0)
#define SPI_CR2_SSM      (1 << 1)
#define SPI_CR2_RXONLY   (1 << 2)
#define SPI_CR2_reserv   (1 << 3)
#define SPI_CR2_CRCNEXT  (1 << 4)
#define SPI_CR2_CRCEN    (1 << 5)
#define SPI_CR2_BDOE     (1 << 6)
#define SPI_CR2_BDM      (1 << 7)

#define SPI_ICR_WKIE     (1 << 4)
#define SPI_ICR_ERRIE    (1 << 5)
#define SPI_ICR_RXIE     (1 << 6)
#define SPI_ICR_TXIE     (1 << 7)

#define SPI_SR_RXNE      (1 << 0)
#define SPI_SR_TXE       (1 << 1)
#define SPI_SR_reserv    (1 << 2)
#define SPI_SR_WKUP      (1 << 3)
#define SPI_SR_CRCERR    (1 << 4)
#define SPI_SR_MODF      (1 << 5)
#define SPI_SR_OVR       (1 << 6)
#define SPI_SR_BSY       (1 << 7)


// ------------------- USART -------------------
#define USART1_SR *(unsigned char*)0x5230
#define USART1_DR *(unsigned char*)0x5231
#define USART1_BRR1 *(unsigned char*)0x5232
#define USART1_BRR2 *(unsigned char*)0x5233
#define USART1_CR1 *(unsigned char*)0x5234
#define USART1_CR2 *(unsigned char*)0x5235
#define USART1_CR3 *(unsigned char*)0x5236
#define USART1_CR4 *(unsigned char*)0x5237
#define USART1_CR5 *(unsigned char*)0x5238
#define USART1_GTR *(unsigned char*)0x5239
#define USART1_PSCR *(unsigned char*)0x523A

// USART_CR1 bits
#define USART_CR1_R8 (1 << 7)
#define USART_CR1_T8 (1 << 6)
#define USART_CR1_UARTD (1 << 5)
#define USART_CR1_M (1 << 4)
#define USART_CR1_WAKE (1 << 3)
#define USART_CR1_PCEN (1 << 2)
#define USART_CR1_PS (1 << 1)
#define USART_CR1_PIEN (1 << 0)

// USART_CR2 bits
#define USART_CR2_TIEN (1 << 7)
#define USART_CR2_TCIEN (1 << 6)
#define USART_CR2_RIEN (1 << 5)
#define USART_CR2_ILIEN (1 << 4)
#define USART_CR2_TEN (1 << 3)
#define USART_CR2_REN (1 << 2)
#define USART_CR2_RWU (1 << 1)
#define USART_CR2_SBK (1 << 0)

// USART_CR3 bits
#define USART_CR3_LINEN (1 << 6)
#define USART_CR3_STOP2 (1 << 5)
#define USART_CR3_STOP1 (1 << 4)
#define USART_CR3_CLKEN (1 << 3)
#define USART_CR3_CPOL (1 << 2)
#define USART_CR3_CPHA (1 << 1)
#define USART_CR3_LBCL (1 << 0)

// USART_SR bits
#define USART_SR_TXE (1 << 7)
#define USART_SR_TC (1 << 6)
#define USART_SR_RXNE (1 << 5)
#define USART_SR_IDLE (1 << 4)
#define USART_SR_OR (1 << 3)
#define USART_SR_NF (1 << 2)
#define USART_SR_FE (1 << 1)
#define USART_SR_PE (1 << 0)


// ------------------- TIMER 1 ------------------
#define TIM1_CR1 *(unsigned char*)0x5250
#define TIM1_CR2 *(unsigned char*)0x5251
#define TIM1_SMCR *(unsigned char*)0x5252
#define TIM1_ETR *(unsigned char*)0x5253
#define TIM1_IER *(unsigned char*)0x5254
#define TIM1_SR1 *(unsigned char*)0x5255
#define TIM1_SR2 *(unsigned char*)0x5256
#define TIM1_EGR *(unsigned char*)0x5257
#define TIM1_CCMR1 *(unsigned char*)0x5258
#define TIM1_CCMR2 *(unsigned char*)0x5259
#define TIM1_CCMR3 *(unsigned char*)0x525A
#define TIM1_CCMR4 *(unsigned char*)0x525B
#define TIM1_CCER1 *(unsigned char*)0x525C
#define TIM1_CCER2 *(unsigned char*)0x525D
#define TIM1_CNTRH *(unsigned char*)0x525E
#define TIM1_CNTRL *(unsigned char*)0x525F
#define TIM1_PSCRH *(unsigned char*)0x5260
#define TIM1_PSCRL *(unsigned char*)0x5261
#define TIM1_ARRH *(unsigned char*)0x5262
#define TIM1_ARRL *(unsigned char*)0x5263
#define TIM1_RCR *(unsigned char*)0x5264
#define TIM1_CCR1H *(unsigned char*)0x5265
#define TIM1_CCR1L *(unsigned char*)0x5266
#define TIM1_CCR2H *(unsigned char*)0x5267
#define TIM1_CCR2L *(unsigned char*)0x5268
#define TIM1_CCR3H *(unsigned char*)0x5269
#define TIM1_CCR3L *(unsigned char*)0x526A
#define TIM1_CCR4H *(unsigned char*)0x526B
#define TIM1_CCR4L *(unsigned char*)0x526C
#define TIM1_BKR *(unsigned char*)0x526D
#define TIM1_DTR *(unsigned char*)0x526E
#define TIM1_OISR *(unsigned char*)0x526F

// TIM1_IER bits
#define TIM1_IER_BIE (1 << 7)
#define TIM1_IER_TIE (1 << 6)
#define TIM1_IER_COMIE (1 << 5)
#define TIM1_IER_CC4IE (1 << 4)
#define TIM1_IER_CC3IE (1 << 3)
#define TIM1_IER_CC2IE (1 << 2)
#define TIM1_IER_CC1IE (1 << 1)
#define TIM1_IER_UIE (1 << 0)

// TIM1_CR1 bits
#define TIM1_CR1_ARPE (1 << 7)
#define TIM1_CR1_CMSH (1 << 6)
#define TIM1_CR1_CMSL (1 << 5)
#define TIM1_CR1_DIR (1 << 4)
#define TIM1_CR1_OPM (1 << 3)
#define TIM1_CR1_URS (1 << 2)
#define TIM1_CR1_UDIS (1 << 1)
#define TIM1_CR1_CEN (1 << 0)

// TIM1_SR1 bits
#define TIM1_SR1_BIF (1 << 7)
#define TIM1_SR1_TIF (1 << 6)
#define TIM1_SR1_COMIF (1 << 5)
#define TIM1_SR1_CC4IF (1 << 4)
#define TIM1_SR1_CC3IF (1 << 3)
#define TIM1_SR1_CC2IF (1 << 2)
#define TIM1_SR1_CC1IF (1 << 1)
#define TIM1_SR1_UIF   (1 << 0)

// TIM1_CCER1 bits
#define TIM1_CCER1_CC1E (1 << 0)
#define TIM1_CCER1_CC1P (1 << 1)
#define TIM1_CCER1_CC1NE (1 << 2)
#define TIM1_CCER1_CC1NP (1 << 3)
#define TIM1_CCER1_CC2E (1 << 4)
#define TIM1_CCER1_CC2P (1 << 5)
#define TIM1_CCER1_CC2NE (1 << 6)
#define TIM1_CCER1_CC2NP (1 << 7)

// TIM1 CCMR1 Bits und Bitpositionen
#define TIM1_CCMR1_CC1S_POS    0
#define TIM1_CCMR1_OC1M_POS    4
#define TIM1_CCMR1_OC1PE (1 << 3)


// ------------------- TIMER 2 ------------------
#define TIM2_CR1 *(unsigned char*)0x5300
#define TIM2_rv0 *(unsigned char*)0x5301                // reserviert
#define TIM2_rv1 *(unsigned char*)0x5302                // reserviert
#define TIM2_IER *(unsigned char*)0x5303
#define TIM2_SR1 *(unsigned char*)0x5304
#define TIM2_SR2 *(unsigned char*)0x5305
#define TIM2_EGR *(unsigned char*)0x5306
#define TIM2_CCMR1 *(unsigned char*)0x5307
#define TIM2_CCMR2 *(unsigned char*)0x5308
#define TIM2_CCMR3 *(unsigned char*)0x5309
#define TIM2_CCER1 *(unsigned char*)0x530a
#define TIM2_CCER2 *(unsigned char*)0x530b
#define TIM2_CNTRH *(unsigned char*)0x530c
#define TIM2_CNTRL *(unsigned char*)0x530d
#define TIM2_PSCR *(unsigned char*)0x530e
#define TIM2_ARRH *(unsigned char*)0x530f
#define TIM2_ARRL *(unsigned char*)0x5310
#define TIM2_CCR1H *(unsigned char*)0x5311
#define TIM2_CCR1L *(unsigned char*)0x5312
#define TIM2_CCR2H *(unsigned char*)0x5313
#define TIM2_CCR2L *(unsigned char*)0x5314
#define TIM2_CCR3H *(unsigned char*)0x5315
#define TIM2_CCR3L *(unsigned char*)0x5316

// TIM2_SR1 bits
#define TIM2_SR1_TIF   (1 << 6)
#define TIM2_SR1_CC3IF (1 << 3)
#define TIM2_SR1_CC2IF (1 << 2)
#define TIM2_SR1_CC1IF (1 << 1)
#define TIM2_SR1_UIF   (1 << 0)

// TIM2_IER bits
#define TIM2_IER_UIE    (1 << 0)
#define TIM2_IER_CC1IE  (1 << 1)
#define TIM2_IER_CC2IE  (1 << 2)
#define TIM2_IER_CC3IE  (1 << 3)
#define TIM2_IER_TIE    (1 << 6)

// TIM2_CR1 bits
#define TIM2_CR1_CEN  (1 << 0)
#define TIM2_CR1_UDIS (1 << 1)
#define TIM2_CR1_URS  (1 << 2)
#define TIM2_CR1_OPM  (1 << 3)
#define TIM2_CR1_ARPE (1 << 7)


// TIM2_CCER1 bits
#define TIM2_CCER1_CC1E (1 << 0)
#define TIM2_CCER1_CC1P (1 << 1)
#define TIM2_CCER1_CC2E (1 << 4)
#define TIM2_CCER1_CC2P (1 << 5)

// TIM2 CCMR1 Bits und Bitpositionen
#define TIM2_CCMR1_CC1S_POS    0
#define TIM2_CCMR1_OC1M_POS    4
#define TIM2_CCMR1_OC1PE (1 << 3)


// ------------------- ADC -------------------
#define ADC_CSR *(unsigned char*)0x5400
#define ADC_CR1 *(unsigned char*)0x5401
#define ADC_CR2 *(unsigned char*)0x5402
#define ADC_CR3 *(unsigned char*)0x5403
#define ADC_DRH *(unsigned char*)0x5404
#define ADC_DRL *(unsigned char*)0x5405
#define ADC_TDRH *(unsigned char*)0x5406
#define ADC_TDRL *(unsigned char*)0x5407
#define ADC_HTRH *(unsigned char*)0x5408
#define ADC_HTRL *(unsigned char*)0x5409
#define ADC_LTRH *(unsigned char*)0x540A
#define ADC_LTRL *(unsigned char*)0x540B
#define ADC_AWSRH *(unsigned char*)0x540C
#define ADC_AWSRL *(unsigned char*)0x540D
#define ADC_AWCRH *(unsigned char*)0x540E
#define ADC_AWCRL *(unsigned char*)0x540F

// ADC - Bitadressen

#define ADC_CR1_ADON    ( 1 << 0 )
#define ADC_CR1_CONT    ( 1 << 1 )
#define ADC_CR1_SPSEL   4            // Bitposition ab der der Prescaler (3 Bit) eingestellt wird
#define ADC_CR1_SPSEL0  ( 1 << 4 )
#define ADC_CR1_SPSEL1  ( 1 << 5 )
#define ADC_CR1_SPSEL2  ( 1 << 6 )

#define ADC_CR3_OVR     ( 1 << 1 )

#define ADC_CSR_CH      0            // Bitposition ab der die Kanalauswahl beginnt (4 Bit)
#define ADC_CSR_CH0     ( 1 << 0 )
#define ADC_CSR_CH1     ( 1 << 1 )
#define ADC_CSR_CH2     ( 1 << 2 )
#define ADC_CSR_CH3     ( 1 << 3 )
#define ADC_CSR_EOX     ( 1 << 7 )

// ------------------- I2C -------------------
#define I2C_CR1 *(unsigned char*)0x5210
#define I2C_CR2 *(unsigned char*)0x5211
#define I2C_FREQR *(unsigned char*)0x5212
#define I2C_OARL *(unsigned char*)0x5213
#define I2C_OARH *(unsigned char*)0x5214

#define I2C_DR *(unsigned char*)0x5216
#define I2C_SR1 *(unsigned char*)0x5217
#define I2C_SR2 *(unsigned char*)0x5218
#define I2C_SR3 *(unsigned char*)0x5219
#define I2C_ITR *(unsigned char*)0x521A
#define I2C_CCRL *(unsigned char*)0x521B
#define I2C_CCRH *(unsigned char*)0x521C
#define I2C_TRISER *(unsigned char*)0x521D
#define I2C_PECR *(unsigned char*)0x521E

// I2C - Bitadressen

#define I2C_CR1_PE          ( 1 << 0 )
#define I2C_CR1_ENGC        ( 1 << 6 )
#define I2C_CR1_NOSTRETCH   ( 1 << 7 )
#define I2C_CR2_START       ( 1 << 0 )
#define I2C_CR2_STOP        ( 1 << 1 )
#define I2C_CR2_ACK         ( 1 << 2 )
#define I2C_CR2_POS         ( 1 << 3 )
#define I2C_CR2_SWRST       ( 1 << 7 )
#define I2C_ITR_ITEVTEN     ( 1 << 1 )
#define I2C_OARH_ADDCONF    ( 1 << 6 )
#define I2C_SR1_SB          ( 1 << 0 )
#define I2C_SR1_ADDR        ( 1 << 1 )
#define I2C_SR1_BTF         ( 1 << 2 )
#define I2C_SR1_RXNE        ( 1 << 6 )
#define I2C_SR1_TXE         ( 1 << 7 )
#define I2C_SR2_AF          ( 1 << 2 )
#define I2C_SR3_BUSY        ( 1 << 1 )
#define I2C_SR3_TRA         ( 1 << 2 )


// ----------------- EEPROM -----------------
#define EEPROM_BASE_ADDR       0x4000            // soll als "Offset" fuer Zugriffe dienen
#define FLASH_IAPSR *(unsigned char*)0x505F
#define FLASH_DUKR *(unsigned char*)0x5064

// EEPROM - Bitadressen

#define FLASH_IAPSR_DUL     ( 1 << 3 )           // Anzeigeflag ob EEPROM geschuetzt ist oder nicht

// ---------------- Independ Watchdog ----------------
#define IWDG_KR  *(unsigned char*)0x50E0
#define IWDG_PR  *(unsigned char*)0x50E1
#define IWDG_RLR *(unsigned char*)0x50E2


#define uint8_t  unsigned char
#define uint16_t unsigned int
#define uint32_t unsigned long

