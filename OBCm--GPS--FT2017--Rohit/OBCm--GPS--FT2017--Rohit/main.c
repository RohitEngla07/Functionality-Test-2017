/*
 * OBCm--GPS--FT2017--Rohit.c
 *
 * Created: 07-08-2017 21:59:36
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
#include "gps.h"

int main(void)
{
	//Initializations 
	init_UART0();
	for(int xx = 0;xx<2;xx++)
	{
	_delay_ms(2000);
	led_test_m_config();
	}
	//Interrupt
	sei();//global interrupt enable
    while (1) 
    {
		message_ID();//commented while using interuppt
    }
}

