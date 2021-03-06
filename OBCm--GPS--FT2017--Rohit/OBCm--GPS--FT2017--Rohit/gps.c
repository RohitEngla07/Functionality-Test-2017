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
  int32_t x;
  int32_t y;
  int32_t z;
  
  ///* Velocity data bytes: Long(4) Unit(mm/s) ECEF Frame
  int32_t v_x;
  int32_t v_y;
  int32_t v_z;
  
  ///* Latitude Longitude Altitude
  int32_t lat;
  int32_t lon;
  int32_t alt;
  
  ///* Time data HH:MM:SS DD/MM/YYYY
  uint8_t hours;
  uint8_t minutes;
  uint8_t seconds;
  
  uint8_t date;
  uint8_t month;
  uint16_t year;
  uint16_t pdop;
  uint8_t gps_OC;
  uint8_t gps_power_main;
  
  int flag_gps = 0;
  ///* Stores the time since last GPS reading
  uint16_t time_since_reading;
//uint8_t position_x[4];
//uint8_t position_y[4];
//uint8_t position_z[4];
//uint8_t geo_pos_x[4];
//uint8_t geo_pos_y[4];
//uint8_t geo_pos_z[4];
//uint8_t velocity_x[4];
//uint8_t velocity_y[4];
//uint8_t velocity_z[4];
//uint8_t TIME[3];
//uint8_t Date[4];
//uint8_t HDOP[2];
//uint8_t PDOP[2];
//uint8_t GPS_second[4];
//uint8_t message[2000];
//uint8_t position[16];
//uint8_t velocity[16];
volatile static uint32_t buffer = 0;
///Position variables for the data in GPS structure
volatile static uint8_t pos = 0xFF,vel = 0xFF,dop = 0xFF,geo = 0xFF, time = 0xFF;
///Variables to check whether the message has ended
volatile static uint8_t last_byte, message_end;
//volatile static uint16_t pdop = 0xFFFF;

///Temporary GPS reading
/*volatile struct GPS_reading gps;*/

char arrayx[40];

char arrayy[40];

char arrayz[40];
//int i=0;

void init_UART_GPS(void)
{

	UCSR0A = 0;
	UCSR0B = 0;
	UCSR0C = 0;
	
	///Double Baud Rate
	UCSR0A |= _BV(U2X0);
	///Enable Reception
	UCSR0B |= _BV(RXEN0) | _BV(TXEN0) | _BV(RXCIE0);
	///8-bit Data Byte, 2 Stop bits
	UCSR0C |= _BV(USBS0) | _BV(UCSZ01) | _BV(UCSZ00);
	///Set Baud Rate to 9600
	UBRR0L = 103;
	UBRR0H = 0;
	
	x=1;
	y=1;
	z=1;
	v_x=1;
	v_y=1;
	v_z=1;
	lat=1;
	lon=1;
	alt=1;
	hours=1;
	minutes=1;
	seconds=1;
	date=1;
	month=1;
	year=1;
	pdop=1;
}

void poll_function()
{
	flag_gps = 1;
}

ISR(USART0_RX_vect)
{
	uint8_t recv = UDR0;
	if(recv =='g') poll_function();
	if(flag_gps == 1)
	{
	//cli();
	//message[i]=UDR0;
	//i=i+1;
	//ISR(USART0_RX_vect)

  PORTA ^= 0xf0;
  
  ///Buffer the Received Byte
  last_byte = UDR0;
  
  
  ///Put the received byte in the last 4-bytes buffer
  buffer = buffer << 8;
  buffer &= 0xFFFFFF00;
  buffer |= (uint32_t) last_byte;
  
   ///Check the buffer against message ID's
   ///Position
   if(buffer == 0x3F3F04AC)
   {
	   uint8_t messagep;
	   messagep = 0x04;
	   transmit_UART0(messagep);
	   message_end = 0;
	   pos = 0;
   }
   ///Velocity
   else if(buffer == 0x3F3F05AC)
   {
	   uint8_t messagev;
	   messagev = 0x05;
	   transmit_UART0(messagev);
	  // transmit_string_UART0(buffer);
	   vel = 0;
   }
   ///DOP
   else if(buffer == 0x3F3F0BAC)
   {
	    uint8_t messaged;
	    messaged = 0x0B;
	    transmit_UART0(messaged);
	   //transmit_string_UART0(buffer);
	   dop = 0;
   }
   ///Geodetic System
   else if(buffer == 0x3F3F0EAC)
   {
	    uint8_t messageg;
	    messageg = 0x0E;
	    transmit_UART0(messageg);
	   //transmit_string_UART0(buffer);
	   geo = 0;
   }
   ///Time
   else if(buffer == 0x3F3F0FAC)
   {
	    uint8_t messaget;
	    messaget = 0x0F;
	    transmit_UART0(messaget);
	   //transmit_string_UART0(buffer);
	   time = 0;
   }
  ///Check if the last byte was for position
  if(pos < 13)
  {
    //uint8_t message;
    //message = 0x04;
    //transmit_UART0(message);
    if(pos>0 && pos<5)
	{
		//x = x >> 8;
		//x &= 0x00FFFFFF;
        //x |= ((uint32_t) last_byte)<<24;
		transmit_UART0(last_byte);
		//uint32_t *ptr;
		//ptr = &x;
		//transmit_string_UART0(ptr);
        //sprintf(arrayx,"%x %x",last_byte);transmit_string_UART0(arrayx);
        //
        //transmit_UART0('\r');
	}
	else if (pos<9)
	{
		//y = y >> 8;
		//y &= 0x00FFFFFF;
		//y |= ((uint32_t) last_byte)<<24;
		transmit_UART0(last_byte);
		//sprintf(arrayy,"%x %x",last_byte);transmit_string_UART0(arrayy);
		//
		//transmit_UART0('\r');
	}
	
	else if(pos<13)
	{
		//z = z >> 8;
		//z &= 0x00FFFFFF;
		//z |= ((uint32_t) last_byte)<<24;
		transmit_UART0(last_byte);
		//sprintf(arrayz,"%x %x",last_byte);transmit_string_UART0(arrayz);
		//
		//transmit_UART0('\r');
	}
    ///* Increment position and terminate it if full
    pos++;
    if(pos == 13)
	{
      pos = 0xFF;
	  //x = convert_uint32_to_int32((int32_t)x1);
	  //y = convert_uint32_to_int32(y1);
	  //z = convert_uint32_to_int32(z1);
	   }
	   
  }
  
  ///Check if the last byte was for velocity
  if(vel < 12)
  {
	//uint8_t message;
	//message = 0x05  ;
	//transmit_UART0(message);
    if(vel < 4)
	{
		//v_x = v_x >> 8;
		//v_x &= 0x00FFFFFF;
        //v_x |= ((uint32_t) last_byte)<<24;
		transmit_UART0(last_byte);
		//sprintf(arrayx,"%x %x",last_byte);transmit_string_UART0(arrayx);
		//
		//transmit_UART0('\r');
		
	}
	else if(vel < 8)
	{
		
		//v_y = v_y >> 8;
		//v_y &= 0x00FFFFFF;
        //v_y |= ((uint32_t) last_byte)<<24;
		transmit_UART0(last_byte);
		//sprintf(arrayy,"%x %x",last_byte);transmit_string_UART0(arrayy);
		//
		//transmit_UART0('\r');
	}
	else if(vel < 12)
	{
		//v_z = v_z >> 8;
		//v_z &= 0x00FFFFFF;
        //v_z |= ((uint32_t) last_byte)<<24;
		transmit_UART0(last_byte);
		//sprintf(arrayz,"%x %x",last_byte);transmit_string_UART0(arrayz);
		//
		//transmit_UART0('\r');
	}
	//*((uint8_t *)&gps.v_x + vel) = last_byte;
	vel++;
    if(vel == 12)
     {
		  vel = 0xFF;
		  //v_x = convert_uint32_to_int32(v_x1);
		  //v_y = convert_uint32_to_int32(v_y1);
		  //v_z = convert_uint32_to_int32(v_z1);

	 }
  }
  
  ///Check if the last byte was for PDOP
  if(dop < 4)
  {
    if(dop >= 2)
    {
		 //pdop =  pdop >> 8;
		 //pdop &= 0x00FF;
         //pdop |= ((uint16_t) last_byte)<<8;
		 transmit_UART0(last_byte);
     }
//	*((uint8_t *)&pdop + (dop - 2)) = last_byte;
	dop++;
    if(dop == 4)
      dop = 0xFF;
  }
  
  ///Check if the last byte was for Geodetic position
  if(geo < 16)
  {
	if(geo < 4);  
    else if(geo < 8)
	{
		//lat = lat >> 8;
		//lat &= 0x00FFFFFF;
		//lat |= ((uint32_t) last_byte)<<24;
		transmit_UART0(last_byte);
	}
	else if(geo < 12)
	{
		//lon = lon >> 8;
		//lon &= 0x00FFFFFF;
		//lon |= ((uint32_t) last_byte)<<24;
		transmit_UART0(last_byte);
	}
	else if(geo < 16 )
	{
		//alt = alt >> 8;
		//alt &= 0x00FFFFFF;
		//alt |= ((uint32_t) last_byte)<<24;
		transmit_UART0(last_byte);
	}
	
//    *((uint8_t *)&gps.lat + (geo - 4)) = last_byte;
    
    geo++;
    if(geo == 16)
	{
      geo = 0xFF;
	  //lat = convert_uint32_to_int32(lat1);
	  //lon = convert_uint32_to_int32(lon1);
	  //alt = convert_uint32_to_int32(alt1);

	}
  }
  
  ///Check if the last byte was for Time
  if(time < 7)
  {
	  
	  if(time == 0)
	  {
		  //hours = last_byte;
		  transmit_UART0(last_byte);
	  }
	  else if(time == 1)
	  {
		  //minutes = last_byte;
		  transmit_UART0(last_byte);
	  }
	  else if(time == 2)
	  {
		  //seconds = last_byte;
		  transmit_UART0(last_byte);
	  }
	  else if(time == 3)
	  {
		  //date = last_byte;
		  transmit_UART0(last_byte);
	  }else if(time == 4)
	  {
		  //month = last_byte;
		  transmit_UART0(last_byte);
	  }else if(time > 4)
	  {
		  //year = year >> 8;
		  //year &= 0x00FF;
		  //year |= ((uint16_t) last_byte)<<8;
		  transmit_UART0(last_byte);

	  }
    //*((uint8_t *)&gps.hours + time) = last_byte;
    
    time++;
    if(time == 7)
    {
      time = 0xFF;
      ///* * The Entire message has been read
      message_end = 1;
	 //  UCSR0B &= ~(_BV(RXCIE0)); //remember this change iterrupt off
	 flag_gps = 0;
    }
  }
  
 
	//if(i>=22)
	//{
		//
		//if(message[0]==0x3F && message[1]==0x3F) //63 == 0x3F
		//{
			//message_ID();
		//}
		//else
		//{
			//for(int shift=0; shift<(i-1) ;shift++)
			//{
				//message[shift]=message[shift+1];
			//}
			//i=i-1;
		//}
	//}
	//sei();
	  
	  }
}
//void message_ID()
//{
	//if(message[2] == 0x04 && message[3] == 0xAC) 
	//{
		//get_position();
		//i=0;
	//}
	//else if(message[2]==0x05 && message[3]== 0xAC)  
	//{
		//get_velocity();
		//i=0;
	//}
	//else if(message[2]==0x0F && message[3]== 0xAC) 
	//{
		//get_time();
		//i=9;
	//}
	//else if(message[2]==0x0B && message[3]== 0xAC) 
	//{
		//get_DOP();
		//i=8;
	//}
	//else if(message[2]==0x0E && message[3]== 0xAC)
	//{
		//get_geopos();
		//i=0;
	//}
	////else if(message[2]==0x08 && message[3]== 0xAC)
	////{
		////i=0;
	////}
	////else if(message[2]==0x0A && message[3]== 0xAC)
	////{
		////for(int i=0; i<4; i++)
		////{
			////message[i]=message[i+18];
		////}
		////i=4;
	////}
	////else if(message[2]==0x06 && message[3]== 0xAC)
	////{
		////for(int i=0; i<4; i++)
		////{
			////message[i]=message[i+18];
		////}
		////i=4;
	////}
	////else //part2
	////{
		////for(int shift=0; shift<(i-4) ;shift++)
		////{
			////message[shift]=message[shift+4];
		////}
		////i=i-1;
	////}
	//
	//else //part1 15 4 11
	//{
    	//for(int shift=0; shift<(i-14) ;shift++)
		//{
			//message[shift]=message[shift+14];
		//}
		//i=i-14;
	//}
//}
//
//void get_position()
//{
	//for(int p=0;p<4;p++)
	//{
		//transmit_UART0(message[p]);
	//}
	//
	//for(int p=0;p<4;p++)
	//{
		//position_x[p]= message[p+4];
		//transmit_UART0(position_x[p]);
	//}	
//
	//for(int p=0;p<4;p++)
	//{
		//position_y[p]= message[p+8];
		//transmit_UART0(position_y[p]);
	//}
//
	//for(int p=0;p<4;p++)
	//{
		//position_z[p]= message[p+12];
		//transmit_UART0(position_z[p]);
	//}
//
//}
//
//void get_velocity()
//{
	//for(int v=0;v<4;v++)
	//{
		//transmit_UART0(message[v]);
	//}
		//
	//for(int v=0;v<4;v++)
	//{
		//velocity_x[v]=message[v+4];
		//transmit_UART0(velocity_x[v]);
	//}
//
	//for(int v=0;v<4;v++)
	//{
		//velocity_y[v]=message[v+8];
		//transmit_UART0(velocity_y[v]);
	//}
//
	//for(int v=0;v<4;v++)
	//{
		//velocity_z[v]=message[v+12];
		//transmit_UART0(velocity_z[v]);
	//}
//
//}
//
//void get_DOP()
//{
	//for(int d=0;d<4;d++)
	//{
		//transmit_UART0(message[d]);
	//}
	//
	//for(int d=0;d<2;d++)
	//{
		//HDOP[d]=message[d+4];
		//transmit_UART0(HDOP[d]);
	//}
	//
	//for(int d=0;d<2;d++)
	//{
		//PDOP[d]=message[d+6];
		//transmit_UART0(PDOP[d]);
	//}
	//
	//for(int d=0;d<4;d++)
	//{
		//GPS_second[d]=message[d+8];
		//transmit_UART0(GPS_second[d]);
	//}
	//
	//for(int d=0;d<8;d++)
	//{
		//message[d] = message[d+14];
	//}
//}
//
//void get_geopos()
//{
	//for(int p=0;p<4;p++)
	//{
		//transmit_UART0(message[p]);
	//}
	//
	//for(int p=0;p<4;p++)
	//{
		//geo_pos_x[p]= message[p+4];
		//transmit_UART0(geo_pos_x[p]);
	//}
//
	//for(int p=0;p<4;p++)
	//{
		//geo_pos_y[p]= message[p+8];
		//transmit_UART0(geo_pos_y[p]);
	//}
//
	//for(int p=0;p<4;p++)
	//{
		//geo_pos_z[p]= message[p+12];
		//transmit_UART0(geo_pos_z[p]);
	//}
//}
	//
//void get_time()
//{
	//for(int t=0;t<4;t++)
	//{
		//transmit_UART0(message[t]);
	//}
//
	//for(int t=0;t<3;t++)
	//{
		//TIME[t]=message[t+4];
		//transmit_UART0(TIME[t]);
	//}
//
	//for(int t=0;t<4;t++)
	//{
		//Date[t]=message[t+7];
		//transmit_UART0(Date[t]);
	//}
//
	//for(int t=0;t<9;t++)
	//{
		//message[t] = message[t+13];
	//}
//}




