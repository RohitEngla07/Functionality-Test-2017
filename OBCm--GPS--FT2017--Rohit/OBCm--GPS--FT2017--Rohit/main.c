/*
 * OBCm--GPS--FT2017--Rohit.c
 *
 * Created: 07-08-2017 21:59:36
 * Author : Rohit Engla
 */ 

#define F_CPU 8000000
#include <avr/io.h>
#include <avr/interrupt.h>
#include "common.h"
#include "timer.h"
#include "uart.h"
#include "spi.h"
#include "i2c.h"
#include "led_tests.h"
#include "gps.h"

int main(void)

{
	//init_UART_GPS();
	init_UART0();
	sei();
    while (1) 
    {
	//led_test_m_config();
    }
}

