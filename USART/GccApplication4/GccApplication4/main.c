#include <avr/io.h>
#include <avr/interrupt.h>
#define F_CPU 14745600UL
#include <util/delay.h>
#define BAUDRATE 9600
#define BAUD_PRESCALER 95
//replaced correct file
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

unsigned char USART_Recieve( void )
{
	/* Wait for empty transmit buffer */
	while ( !( UCSRA & (1<<RXC)) );
	/* Put data into buffer, sends the data */
	return UDR;
}


int main(void)
{
	/* Replace with your application code */
	USART_Init( BAUD_PRESCALER);
	UCSRB |= (1 << RXEN); // Enable the USART Recieve Complete interrupt (USART_RXC)
	sei(); // Enable the Global Interrupt Enable flag so that interrupts can be processed
	while(1)
	{
		char a = USART_Recieve();
		USART_Transmit(UDR);
	}
}
ISR(USART_RXC_vect)
{
	char b,a;
	b = a; // Fetch the received byte value into the variable "ByteReceived"
	UDR = b; // Echo back the received byte back to the computer
}
