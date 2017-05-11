/* -------------------------------------------------------
                         pwm_test.c

     Versuche zu PWM
     PWM-Signal liegt an PD 4 an

     MCU   :  STM8S103F3
     Takt  :  externer Takt 16 MHz

     29.06.2016  R. Seelig
   ------------------------------------------------------ */

#include "stm8s.h"
#include "stm8_init.h"
#include "stm8_gpio.h"


void tim2_alloff(void)
{
  TIM2_CR1= 0;
  TIM2_IER= 0;
  TIM2_SR2= 0;
  TIM2_CCER1= 0;
  TIM2_CCER2= 0;
  TIM2_CCER1= 0;
  TIM2_CCER2= 0;
  TIM2_CCMR1= 0;
  TIM2_CCMR2= 0;
  TIM2_CCMR3= 0;
  TIM2_CNTRH= 0;
  TIM2_CNTRL= 0;
  TIM2_PSCR= 0;
  TIM2_ARRH= 0;
  TIM2_ARRL= 0;
  TIM2_CCR1H= 0;
  TIM2_CCR1L= 0;
  TIM2_CCR2H= 0;
  TIM2_CCR2L= 0;
  TIM2_CCR3H= 0;
  TIM2_CCR3L= 0;
  TIM2_SR1= 0;
}

/* ---------------------------------------------------
                       pwm_out
     erzeugt eine Rechteckfrequenz mit variabler
     Puls- Pausedauer:

     scaler = Takteiler des Timers, Zaehleingang des
              Timers wird festgelegt F_CPU / 2 ^ scaler

     gesamt = Gesamtzyklenzeit die eine Periode
              dauert

     pause  = Anzahl Zyklen die die Pausezeit dauert,
              ist die Pausezeit = gesamt / 2 entspricht
              dieses einem symetrischen Takt

     f_out= F_CPU / ( gesamt * (2^scaler) )

     Bsp.:
            F_CPU  = 16000000
            scaler = 4           // Teiler durch 16
            gesamt = 1000

            f_out  = 16000000 / (16 * 1000) = 1000
   --------------------------------------------------- */
void pwm_out(uint8_t scaler, uint16_t gesamt, uint16_t pause)
{
  /*
    Prescalerbeispiel:
    Prescaler= 0, Timertakt = F_CPU (16MHz) = 0,0625 uS
             = 4, Timertakt = F_CPU (16MHz) / 16 = 1uS
  */
  TIM2_PSCR= scaler;

  // Reloadwert
  TIM2_ARRH= (uint16_t) gesamt >> 8;
  TIM2_ARRL= (uint16_t) gesamt & 0xff;

  // Tastverhaeltins
  TIM2_CCR1H= (uint16_t) pause >> 8;
  TIM2_CCR1L= (uint16_t) pause & 0xff;

  TIM2_CCER1 |= TIM2_CCER1_CC1E;
  TIM2_CCER1 |= TIM2_CCER1_CC1P;                  // PWM Signal invertieren ( Polaritaet )

  TIM2_CCMR1 |= (6 << TIM2_CCMR1_OC1M_POS);       // PWM Mode 1 ( Ausgangssignal Timer2, Channel 1
                                                  // bei STM8S103 Ausgangssignal = PD 4 )
  TIM2_CR1 |= TIM2_CR1_CEN;                       // Timer2 enable
}

/* ---------------------------------------------------
                       pwm_setfreq

     erzeugt eine Frequzenz mittels Timer2 / Channel 1

     freq = Frequenz in Hz, gueltige Werte sind
            20 Hz .. 30 kHz

     duty = t_pause / t_gesamt in %
   --------------------------------------------------- */
void pwm_setfreq(uint16_t freq, uint8_t duty)
{
  uint16_t  gesamt, pause;
  long      t1;

  TIM2_PSCR= 4;                 // F_CPU / 16   ( 2^4 )
  gesamt= (1000000 / freq) - 1;
  t1= gesamt;
  t1= ((t1 * duty) / 100)+1;
  pause = (uint16_t) t1;


  // Reloadwert
  TIM2_ARRH= (uint16_t) gesamt >> 8;
  TIM2_ARRL= (uint16_t) gesamt & 0xff;

  // Tastverhaeltins
  TIM2_CCR1H= (uint16_t) pause >> 8;
  TIM2_CCR1L= (uint16_t) pause & 0xff;


  TIM2_CCER1 |= TIM2_CCER1_CC1E;
  TIM2_CCER1 |= TIM2_CCER1_CC1P;                  // PWM Signal invertieren ( Polaritaet )

  TIM2_CCMR1 |= (6 << TIM2_CCMR1_OC1M_POS);       // PWM Mode 1 ( Ausgangssignal Timer2, Channel 1
                                                  // bei STM8S103 Ausgangssignal = PD 4 )
  TIM2_CR1 |= TIM2_CR1_CEN;                       // Timer2 enable

}

/* ---------------------------------------------------
                       analogout

      erzeugt ein PWM-Signal, das wenn mittels
      (passivem) Tiefpass gefiltert die gewaehlte
      Analogspannung ausgibt.

      refwert entspricht hier die Spannungshoehe
      des Ausgangsrechtecksignals

      value entspricht der gewuenschten analogen
      Spannung
   --------------------------------------------------- */

void analogout(float value, float refwert)
{
  uint16_t regout;
  float    r;

  r= (value * 1023) / refwert;
  regout= r;

  pwm_out(0,1024,1024-regout);

}


/* ----------------------------------------------------------------------------------
                                           MAIN
   ---------------------------------------------------------------------------------- */

void main(void)
{
  sysclock_init(0);                       // erst Initialisieren mit internem RC
  sysclock_init(1);                       // externer Quarz

  tim2_alloff();
//  pwm_out(0, 20000, 2000);
  pwm_setfreq(10000,50);                  // 10 kHz, 50% tp
//  analogout(1.21, 3.283);

  while(1);
}
