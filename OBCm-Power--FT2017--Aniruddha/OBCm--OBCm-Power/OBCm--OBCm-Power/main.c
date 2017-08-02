/*
 * OBCm--OBCm-Power.c
 *
 * Created: 01-08-2017 21:45:03
 * Author : Aniruddha Ranade
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
	init_UART0();
	
	// Variables 
	
	
	sei();
	
    while (1) 
    {
		// Loop 
		led_test_m_config();
		led_test_m_a();
		led_test_m_b();
		led_test_m_c();
		led_test_m_d();
		
    }
}

