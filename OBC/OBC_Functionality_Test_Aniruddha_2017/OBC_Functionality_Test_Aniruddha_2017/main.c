/*
 * OBC_Functionality_Test_Aniruddha_2017.c
 *
 * Created: 15-07-2017 21:25:34
 * Author : Aniruddha Ranade
 *
 * For Master OBC 
 */ 

#define F_CPU 8000000
#include <avr/io.h>
#include "common.h"
#include "timer.h"
#include "uart.h"
#include "spi.h"
#include "i2c.h"
#include "led_tests.h"


int main(void)
{
	// Initializations
	init_UART0();	// GPS and Preflight 
	//init_UART1();	// Magnetometer
	//init_SPI();		// OBC Slave  
	//TWI_init_master();	// Power
	 
	// Variables
	//uint8_t gps_data;
	//uint8_t mag_data;
	 
	//led_test_config(); 
	 
	sei();
	 
    while (1) 
    {
		// 2 second loop 
		timer_reset_two_sec();
		
		// Watchdog timers to ensure loop runs for 2 seconds  
		wdt_enable(WDTO_2S);
		wdt_reset();
		
		//		
		led_test_m_config();
		led_test_m_a();
		led_test_m_b();
		led_test_m_c();
		led_test_m_d();
		
		wdt_disable();
		
		timer_wait_reset();
    }
}

