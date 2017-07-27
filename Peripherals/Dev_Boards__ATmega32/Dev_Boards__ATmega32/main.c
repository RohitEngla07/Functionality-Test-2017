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
	//char gps_data[]="gps_data";
	char mag_flag;	
	char mag_data[]="mag_data";
		
    while (1) 
    {
		//// dummy gps
		//transmit_string_UART(gps_data);
		//_delay_ms(100);
		// dummy mag 
		mag_flag=receive_UART();
		if(mag_flag=='m')
		{
			transmit_string_UART(mag_data);
		}
		
	}
}

