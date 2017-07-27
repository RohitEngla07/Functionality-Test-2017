/*
 * Dev_boards_ATmega16.c
 *
 * Created: 16-07-2017 18:45:51
 * Author : Aniruddha Ranade
 */ 

#include <avr/io.h>
#include "common.h"
#include "uart.h"

int main(void)
{
	// Initializations
	init_UART();
	
	// Variables 
	uint8_t data;
	
    while (1) 
    {
		data="d";	
		transmit_UART(data);
		data=receive_UART();
		transmit_UART(data);
	}
}

