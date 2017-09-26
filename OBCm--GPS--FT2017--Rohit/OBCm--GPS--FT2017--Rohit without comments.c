/*
 * gps.c
 *
 * Created: 07-08-2017 23:52:36
 *  Author: Rohit Engl
 */ 
#include "common.h"
#include "gps.h"
#include "uart.h"
#include "led_tests.h"

uint8_t position_x[4];
uint8_t position_y[4];
uint8_t position_z[4];
uint8_t velocity_x[4];
uint8_t velocity_y[4];
uint8_t velocity_z[4];
uint8_t TIME[3];
uint8_t Date[4];
uint8_t HDOP[2];
uint8_t PDOP[2];
uint8_t GPS_second[4];
uint8_t message[2000];
int i;

ISR(USART0_RX_vect)
{
	message[i]=UDR0;
	i=i+1;
	if(i>=22)
	{
		if(message[0]==0x3F && message[1]==0x3F)
		{
			message_ID();
		}
		else
		{
			for(int shift=0; shift<=i ;shift++)
			{
				message[shift]=message[shift+1];
			}
		}
	}
}

void message_ID()
{
	if(message[2]==0x04 && message[3] == 0xAC)
	{
		transmit_string_UART0("position");
		get_position();
		i=0;
	}
	else if(message[2]==0x05 && message[3]== 0xAC)
	{
		transmit_string_UART0("velocity");
		get_velocity();
		i=0;
	}
	else if(message[2]==0x0F && message[3]== 0xAC)
	{
		transmit_string_UART0("time");
		get_time();
		i=10;
	}
	else if(message[2]==0x0B && message[3]== 0xAC)
	{
		transmit_string_UART0("DOP");
		get_DOP();
		i=9;
	}
	else
	{
		i=0;
	}
}

void get_position()
{
	
	for(int p=0;p<4;p++)
	{
		position_x[p]= message[p+4];
		transmit_UART0(position_x[p]);
	}	

	for(int p=0;p<4;p++)
	{
		position_y[p]= message[p+8];
		transmit_UART0(position_y[p]);
	}

	for(int p=0;p<4;p++)
	{
		position_z[p]= message[p+12];
		transmit_UART0(position_z[p]);
	}

}

void get_velocity()
{	

	for(int v=0;v<4;v++)
	{
		velocity_x[v]=message[v+4];
		transmit_UART0(velocity_x[v]);
	}

	for(int v=0;v<4;v++)
	{
		velocity_y[v]=message[v+8];
		transmit_UART0(velocity_y[v]);
	}

	for(int v=0;v<4;v++)
	{
		velocity_z[v]=message[v+12];
		transmit_UART0(velocity_z[v]);
	}

}

void get_time()
{

	for(int t=0;t<3;t++)
	{
		TIME[i]=message[t+4];
		transmit_UART0(TIME[i]);
	}

	for(int t=0;t<4;t++)
	{
		Date[t]=message[t+7];
		transmit_UART0(Date[t]);
	}

	for(int t=0;t<9;t++)
	{
		message[t] = message[t+13];
	}
}

void get_DOP()
{
	
	for(int d=0;d<2;d++)
	{
		HDOP[d]=message[d+4];
		transmit_UART0(HDOP[d]);
	}
	
	for(int d=0;d<2;d++)
	{
		PDOP[d]=message[d+6];
		transmit_UART0(PDOP[d]);
	}
	
	for(int d=0;d<4;d++)
	{
		GPS_second[d]=message[d+8];
		transmit_UART0(GPS_second[d]);
	}
	
	for(int t=0;t<8;t++)
	{
		message[t] = message[t+14];
	}
}