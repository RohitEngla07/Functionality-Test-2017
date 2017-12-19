/*
 * GccApplication5.c
 *
 * Created: 24-06-2017 18:55:30
 * Author : Rohit Engl
 */ 

#include <avr/io.h>
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
}
int main(void)
{
    /* Replace with your application code */
    while (1) 
    {
		SPI_MasterTransmit('A');
    }
}

