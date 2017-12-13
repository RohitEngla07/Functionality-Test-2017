/*
 * mag.c
 *
 * Created: 23-08-2017 22:19:58
 *  Author: Anirudh Singhal
 */ 

#include "common.h"
#include "mag.h"
#include "uart.h"
#include "led_tests.h"
#include <stdio.h>
char B[6];
int Bz,By,Bx;
float BX,BY,BZ;
int n=0;
int hex = 1;
void mag_ASCII(){
	transmit_string_UART1("*00A\r");
	//transmit_string_UART1("<cr>");
	//transmit_string_UART0("*AOK");
}
void mag_Binary(){
	transmit_string_UART1("*00B\r");
	//transmit_string_UART0("*BOK");
}
void mag_serial_number(){
	transmit_string_UART1("*00#\r");
	//transmit_string_UART0("SOK");
}
void mag_poll(){
	n=0;
	transmit_string_UART1("*00P\r");
	//transmit_string_UART0("MOK");
}
void mag_continous(){
	transmit_string_UART1("*00C\r");
	//transmit_string_UART0("COK");
}
void mag_BaudRate9600(){
	//transmit_string_UART1("*99WE\r");
	transmit_string_UART1("*99!BR=S\r");
	//transmit_string_UART0("9600OK");
}
void mag_global_WE(){
	transmit_string_UART1("*99WE\r");
	//transmit_string_UART1("*99!BR=S\r");
	//transmit_string_UART0("9600OK");
}
void mag_write_enable(){
	transmit_string_UART1("*00WE\r");
	//transmit_string_UART0("9600OK");
}

void mag_zero_on(){
	//transmit_string_UART1("*00WE\r");
	transmit_string_UART1("*00ZN\r");
	//transmit_string_UART0("9600OK");
};

void mag_zero_off(){
	//transmit_string_UART1("*00WE\r");
	transmit_string_UART1("*00ZF\r");
	//transmit_string_UART0("9600OK");
};

void mag_zero_toggle(){
	//transmit_string_UART1("*00WE\r");
	transmit_string_UART1("*00ZR\r");
	//transmit_string_UART0("9600OK");
};


void mag_value(){
	
	int Bxh = B[0];
	int Bxl = B[1];
	int Byh = B[2];
	int Byl = B[3];
	int Bzh = B[4];
	int Bzl = B[5];
	
	Bx = Bxh*16*16 + Bxl;
	By = Byh*16*16 + Byl;
	Bz = Bzh*16*16 + Bzl;
	
	char bx[10];
	sprintf(bx, "%d", Bx);
	char by[10];
	sprintf(by, "%d", By);
	char bz[10];
	sprintf(bz, "%d", Bz);
	transmit_string_UART0("( ");
	transmit_string_UART0(bx);
	transmit_string_UART0(" , ");
	transmit_string_UART0(by);
	transmit_string_UART0(" , ");
	transmit_string_UART0(bz);
	transmit_string_UART0(" ) ");
	
	BX = (Bx/30000.0)*2.0;
	BY = (By/30000.0)*2.0;
	BZ = (Bz/30000.0)*2.0;
	
	
}
ISR(USART1_RX_vect)
{
	maginfo = UDR1;
	//transmit_UART0('x');
	
	transmit_UART0(maginfo);
	if(hex== 1){
	B[n]= maginfo;
	n++;
	
	if (n==6) {
		mag_value();
	}
	}
	/*message[i]=UDR0;
	i=i+1;
	if(i==3)
	{
		message_ID();
		i=1;
	}*/
}
