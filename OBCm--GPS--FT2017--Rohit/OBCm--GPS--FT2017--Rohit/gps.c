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
uint8_t message[4];
int i=1;

ISR(USART0_RX_vect)
{
	message[i]=UDR0;
	i=i+1;
	if(i==3)
	{
		message_ID();
		i=1;
	}
}

void message_ID()//for checking which part of data is coming
{
	//for(int i=0;i<4;i++)
	//{
		//message[i]=receive_UART0();
	//}
	if(message[2]==0x04 && message[3]== 0xAC)//have to check that it will be AC04 or 04AC
	{
		get_position();//will execute if data is position
	}
	if(message[2]==0x05 && message[3]== 0xAC)
	{
		get_velocity();//will execute if data is velocity
	}
	if(message[2]==0x0F && message[3]== 0xAC)
	{
		get_time();//will execute if data is time
	}
	if(message[2]==0x0B && message[3]== 0xAC)
	{
		get_DOP();//will execute if data is time
	}
}

void get_position()
{
//for x position
	
	for(int i=0;i<4;i++)
	{
		position_x[i]= receive_UART0();
		transmit_string_UART0(position_x[i]);
	}	

//for y position

	for(int i=0;i<4;i++)
	{
		position_y[i]= receive_UART0();
		transmit_string_UART0(position_y[i]);
	}

//for z position

	for(int i=0;i<4;i++)
	{
		position_z[i]= receive_UART0();
		transmit_string_UART0(position_z[i]);
	}

}

void get_velocity()
{

//for x velocity	

	for(int i=0;i<4;i++)
	{
		velocity_x[i]=receive_UART0();
		transmit_string_UART0(velocity_x[i]);
	}

//for y velocity

	for(int i=0;i<4;i++)
	{
		velocity_y[i]=receive_UART0();
		transmit_string_UART0(velocity_y[i]);
	}

//for z velocity

	for(int i=0;i<4;i++)
	{
		velocity_z[i]=receive_UART0();
		transmit_string_UART0(velocity_z[i]);
	}

}

void get_time()
{

	//for time in hours(1 byte)-minutes(1)-second(1)

	for(int i=0;i<3;i++)
	{
		TIME[i]=receive_UART0();
		transmit_string_UART0(TIME[i]);
	}

	//for date in format date(1)-month(1)-year(2)

	for(int i=0;i<4;i++)
	{
		Date[i]=receive_UART0();
		transmit_string_UART0(Date[i]);
	}

}

void get_DOP()//checking dilution of precision
{
	
	for(int i=0;i<2;i++)
	{
		HDOP[i]=receive_UART0();
		transmit_string_UART0(HDOP[i]);
	}
	
	for(int i=0;i<2;i++)
	{
		PDOP[i]=receive_UART0();
		transmit_string_UART0(PDOP[i]);
	}
	
	for(int i=0;i<4;i++)
	{
		GPS_second[i]=receive_UART0();
		transmit_string_UART0(GPS_second[i]);
	}
}

void print_data()
{
	
	for(int i=0;i<4;i++)
	{
		transmit_string_UART0(position_x);
	}
	
	for(int i=0;i<4;i++)
	{
		transmit_string_UART0(position_y);
	}
	
	for(int i=0;i<4;i++)
	{
		transmit_string_UART0(position_z);
	}
	
	for(int i=0;i<4;i++)
	{
		transmit_string_UART0(velocity_x);
	}
	
	for(int i=0;i<4;i++)
	{
		transmit_string_UART0(velocity_y);
	}
	
	for(int i=0;i<4;i++)
	{
		transmit_string_UART0(velocity_z);
	}
}

