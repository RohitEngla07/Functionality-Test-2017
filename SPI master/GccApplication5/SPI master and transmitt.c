/*
 * GccApplication5.c
 *
 * Created: 24-06-2017 18:55:30
 * Author : Rohit Engl
 */ 
#include <avr/io.h>
#define F_CPU 14745600UL
#include <util/delay.h>
#define BAUDRATE 9600
#define BAUD_PRESCALER 95
void USART_Init( unsigned int ubrr)
{
	/*Set baud rate */
	UBRRH = (unsigned char)(95>>8);
	UBRRL = (unsigned char)95;
	UCSRB = (1<<RXEN)|(1<<TXEN);
	/* Set frame format: 8data, 2stop bit */
	UCSRC = (1<<URSEL)|(1<<USBS)|(3<<UCSZ0);
}
void USART_Transmit( unsigned char data )
{
	/* Wait for empty transmit buffer */
	while ( !( UCSRA & (1<<UDRE)) );
	/* Put data into buffer, sends the data */
	UDR = data;
}
void SPI_MasterInit(void)
{
	/* Set MOSI and SCK output, all others input */
	DDRB = 0b10100000;
	/* Enable SPI, Master, set clock rate fck/16 */
	SPCR = (1<<SPE)|(1<<MSTR)|(1<<SPR0);
}
void SPI_MasterTransmit(char cData)
{
	/* Start transmission */
	SPDR = cData;
	/* Wait for transmission complete */
	while(!(SPSR & (1<<SPIF)));
}
char SPI_MasterReceive(void)
{
	/* Wait for reception complete */
	while(!(SPSR & (1<<SPIF)));
	/* Return Data Register */
	return SPDR;
}
}
int main(void)
{
	USART_Init(BAUD_PRESCALER);
	SPI_MasterInit();
    /* Replace with your application code */
    while (1) 
    {
		USART_Transmit('1');
		SPI_MasterTransmit('A');
		USART_Transmit('2');
		char x = SPI_MasterReceive();
		USART_Transmit('3');
		USART_Transmit(x);
		USART_Transmit('4');
    }
}

