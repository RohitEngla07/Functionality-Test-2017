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
//#include "gps.h"
#include <stdio.h>
#include <avr/wdt.h>

uint8_t OC_status=0xFF;
int mag_on;

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
		if((~(OC_status)&0x04)==0x04){ 
			transmit_UART0('c');
			mag_on=1;
			OC_status=0xff;} 
		if(mag_on == 0)
		{
			transmit_UART0(OC_status);
			transmit_UART0('m');
		//mag_poll();
		_delay_ms(500);}
		else {
			mag_on++;
			if(mag_on == 6){ 
				transmit_UART0('b');
				mag_on=0;
			}
		}
		transmit_UART0('g');
		//poll_function();
		_delay_ms(500);
		
		

	}
}

ISR(USART0_RX_vect){
	char recx = UDR0;
	if(recx=='a'){
		transmit_UART0('a');
		OC_status = ~(0b00000100);
	}
	else if (recx='b'){
		OC_status = ~(0b00001000);
	}
	else if(recx='c'){
		OC_status = ~(0b00001100);
	}
}