/*
 * OBCm-Functionality.c
 *
 * Created: 12-12-2017 18:18:09
 * Author : Rohit Engl
 */ 

#define F_CPU 8000000
#include <avr/io.h>
#include "common.h"
#include "timer.h"
#include "uart.h"
#include "spi.h"
#include "i2c.h"
#include "led_tests.h"
#include "mag.h"
#include "gps.h"
#include <stdio.h>
#include <avr/wdt.h>


int main(void)
{
	//Initializations
	
	init_UART0();
	init_UART1();
	for(int xx = 0;xx<3;xx++)
	{
		_delay_ms(2000);
		led_test_m_config();
	}
	//Interrupt
	sei();//global interrupt enable
	
	while(1){
		//mag_poll();
		//_delay_ms(2000);

	}
}