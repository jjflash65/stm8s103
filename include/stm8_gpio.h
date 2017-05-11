/* -------------------------------------------------------
                         stm8_gpio.h

     Macros zum Handling der I/O Anschluesse des STM8
     Microcontrollers.

     Jeder einzelne Anschlusspin des MCU ist als Eingang
     oder Ausgang konfigurierbar. Wird ein Anschluss als
     Eingang konfiguriert, wird automatisch der interne
     Pull-Up Widerstand eingeschaltet.

     Verwendung als Ausgang:
     ---------------------------------------------------

     -   Pxy_output_init()

         x bezeichnet den Port (bspw. PA, PB, PC, PD)
         y bezeichnet das Portbit.

     Bit 5 des Ports C muss dann wie folgt
     initialisiert werden:

         PC5_output_init();

     Setzen eines Bits auf 1:

         PC5_set();

     Setzen eines Bits auf 0 (loeschen):

         PC5_clr();

     Verwendung als Eingang:
     ---------------------------------------------------

     - Pxy_input_init()

     Bsp.: Port C, Bit 6 als Eingang:

       PC6_input_init()

     Lesen des Eingangs:

     if (isbit_PC6) PC5_set(); else PC5_clr();

     23.05.2016  R. Seelig
   ------------------------------------------------------ */



//   PA1 I/O
#define PA1_output_init()  {  PA_DDR |=   0x02;         \
                              PA_CR1 |=   0x02;         \
                              PA_CR2 &= ~(0x02); }
#define PA1_set()          (  PA_ODR |=   0x02   )
#define PA1_clr()          (  PA_ODR &= ~(0x02)  )

#define PA1_input_init()   {  PA_DDR &= ~(0x02);        \
                              PA_CR1 |=   0x02;  }
#define is_PA1()           (( PA_IDR &    0x02) >> 1)

//   PA2 I/O
#define PA2_output_init()  {  PA_DDR |=   0x04;         \
                              PA_CR1 |=   0x04;         \
                              PA_CR2 &= ~(0x04); }
#define PA2_set()          (  PA_ODR |=   0x04   )
#define PA2_clr()          (  PA_ODR &= ~(0x04)  )

#define PA2_input_init()   {  PA_DDR &= ~(0x04);        \
                              PA_CR1 |=   0x04;  }
#define is_PA2()           (( PA_IDR &    0x04) >> 2)


//   PA3 I/O
#define PA3_output_init()  {  PA_DDR |=   0x08;         \
                              PA_CR1 |=   0x08;         \
                              PA_CR2 &= ~(0x08); }
#define PA3_set()          (  PA_ODR |=   0x08   )
#define PA3_clr()          (  PA_ODR &= ~(0x08)  )

#define PA3_input_init()   {  PA_DDR &= ~(0x08);        \
                              PA_CR1 |=   0x08;  }
#define is_PA3()           (( PA_IDR &    0x08) >> 3)




//   PB4 I/O
#define PB4_output_init()  {  PB_DDR |=   0x10;         \
                              PB_CR1 |=   0x10;         \
                              PB_CR2 &= ~(0x10); }
#define PB4_set()          (  PB_ODR |=   0x10   )
#define PB4_clr()          (  PB_ODR &= ~(0x10)  )

#define PB4_input_init()   {  PB_DDR &= ~(0x10);        \
                              PB_CR1 |=   0x10;  }
#define is_PB4()           (( PB_IDR &    0x10) >> 4)


//   PB5 I/O
#define PB5_output_init()  {  PB_DDR |=   0x20;         \
                              PB_CR1 |=   0x20;         \
                              PB_CR2 &= ~(0x20); }
#define PB5_set()          (  PB_ODR |=   0x20   )
#define PB5_clr()          (  PB_ODR &= ~(0x20)  )

#define PB5_input_init()   {  PB_DDR &= ~(0x20);        \
                              PB_CR1 |=   0x20;  }
#define is_PB5()           (( PB_IDR &    0x20) >> 5)


//   PC3 I/O
#define PC3_output_init()  {  PC_DDR |=   0x08;         \
                              PC_CR1 |=   0x08;         \
                              PC_CR2 &= ~(0x08); }
#define PC3_set()          (  PC_ODR |=   0x08   )
#define PC3_clr()          (  PC_ODR &= ~(0x08)  )

#define PC3_input_init()   {  PC_DDR &= ~(0x08);        \
                              PC_CR1 |=   0x08;  }
#define is_PC3()           (( PC_IDR &    0x08) >> 3)


//   PC4 I/O
#define PC4_output_init()  {  PC_DDR |=   0x10;         \
                              PC_CR1 |=   0x10;         \
                              PC_CR2 &= ~(0x10); }
#define PC4_set()          (  PC_ODR |=   0x10   )
#define PC4_clr()          (  PC_ODR &= ~(0x10)  )

#define PC4_input_init()   {  PC_DDR &= ~(0x10);        \
                              PC_CR1 |=   0x10;  }
#define is_PC4()           (( PC_IDR &    0x10) >> 4)


//   PC5 I/O
#define PC5_output_init()  {  PC_DDR |=   0x20;         \
                              PC_CR1 |=   0x20;         \
                              PC_CR2 &= ~(0x20); }
#define PC5_set()          (  PC_ODR |=   0x20   )
#define PC5_clr()          (  PC_ODR &= ~(0x20)  )

#define PC5_input_init()   {  PC_DDR &= ~(0x20);        \
                              PC_CR1 |=   0x20;  }
#define is_PC5()           (( PC_IDR &    0x20) >> 5)


//   PC6 I/O
#define PC6_output_init()  {  PC_DDR |=   0x40;         \
                              PC_CR1 |=   0x40;         \
                              PC_CR2 &= ~(0x40); }
#define PC6_set()          (  PC_ODR |=   0x40   )
#define PC6_clr()          (  PC_ODR &= ~(0x40)  )

#define PC6_input_init()   {  PC_DDR &= ~(0x40);        \
                              PC_CR1 |=   0x40;  }
#define is_PC6()           (( PC_IDR &    0x40) >> 6)


//   PC7 I/O
#define PC7_output_init()  {  PC_DDR |=   0x80;         \
                              PC_CR1 |=   0x80;         \
                              PC_CR2 &= ~(0x80); }
#define PC7_set()          (  PC_ODR |=   0x80   )
#define PC7_clr()          (  PC_ODR &= ~(0x80)  )

#define PC7_input_init()   {  PC_DDR &= ~(0x80);        \
                              PC_CR1 |=   0x80;  }
#define is_PC7()           (( PC_IDR &    0x80) >> 7)


//   PD1 I/O
#define PD1_output_init()  {  PD_DDR |=   0x02;         \
                              PD_CR1 |=   0x02;         \
                              PD_CR2 &= ~(0x02); }
#define PD1_set()          (  PD_ODR |=   0x02   )
#define PD1_clr()          (  PD_ODR &= ~(0x02)  )

#define PD1_input_init()   {  PD_DDR &= ~(0x02);        \
                              PD_CR1 |=   0x02;  }
#define is_PD1()           (( PD_IDR &    0x02) >> 1)

//   PD2 I/O
#define PD2_output_init()  {  PD_DDR |=   0x04;         \
                              PD_CR1 |=   0x04;         \
                              PD_CR2 &= ~(0x04); }
#define PD2_set()          (  PD_ODR |=   0x04   )
#define PD2_clr()          (  PD_ODR &= ~(0x04)  )

#define PD2_input_init()   {  PD_DDR &= ~(0x04);        \
                              PD_CR1 |=   0x04;  }
#define is_PD2()           (( PD_IDR &    0x04) >> 2)


//   PD3 I/O
#define PD3_output_init()  {  PD_DDR |=   0x08;         \
                              PD_CR1 |=   0x08;         \
                              PD_CR2 &= ~(0x08); }
#define PD3_set()          (  PD_ODR |=   0x08   )
#define PD3_clr()          (  PD_ODR &= ~(0x08)  )

#define PD3_input_init()   {  PD_DDR &= ~(0x08);        \
                              PD_CR1 |=   0x08;  }
#define is_PD3()           (( PD_IDR &    0x08) >> 3)


//   PD4 I/O
#define PD4_output_init()  {  PD_DDR |=   0x10;         \
                              PD_CR1 |=   0x10;         \
                              PD_CR2 &= ~(0x10); }
#define PD4_set()          (  PD_ODR |=   0x10   )
#define PD4_clr()          (  PD_ODR &= ~(0x10)  )

#define PD4_input_init()   {  PD_DDR &= ~(0x10);        \
                              PD_CR1 |=   0x10;  }
#define is_PD4()           (( PD_IDR &    0x10) >> 4)


//   PD5 I/O
#define PD5_output_init()  {  PD_DDR |=   0x20;         \
                              PD_CR1 |=   0x20;         \
                              PD_CR2 &= ~(0x20); }
#define PD5_set()          (  PD_ODR |=   0x20   )
#define PD5_clr()          (  PD_ODR &= ~(0x20)  )

#define PD5_input_init()   {  PD_DDR &= ~(0x20);        \
                              PD_CR1 |=   0x20;  }
#define is_PD5()           (( PD_IDR &    0x20) >> 5)


//   PD6 I/O
#define PD6_output_init()  {  PD_DDR |=   0x40;         \
                              PD_CR1 |=   0x40;         \
                              PD_CR2 &= ~(0x40); }
#define PD6_set()          (  PD_ODR |=   0x40   )
#define PD6_clr()          (  PD_ODR &= ~(0x40)  )

#define PD6_input_init()   {  PD_DDR &= ~(0x40);        \
                              PD_CR1 |=   0x40;  }
#define is_PD6()           (( PD_IDR &    0x40) >> 6)
