/*
 * OBC_Slave_Functionality_Test_Aniruddha.c
 *
 * Created: 15-07-2017 22:47:29
 * Author : Aniruddha Ranade
 *
 * For Slave OBC
 */ 

#define F_CPU 8000000
#include <avr/io.h>
#include "common.h"
#include "timer.h"
#include "uart.h"
#include "spi.h"



int main(void)
{
	// Initializations
	init_UART0();	// Preflight
	
	sei();
	
	
    while (1) 
    {
    }
}

