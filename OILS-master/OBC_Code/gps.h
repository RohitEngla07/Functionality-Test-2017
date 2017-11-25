/*
 * gps.h
 *
 * Created: 31-03-2012 15:22:32
 *  Author: Hussain
 */ 

/**
 * @file gps.h
 * @brief Functions to read the GPS device
 */

#ifndef GPS_H_
#define GPS_H_

/** @brief Initialise the UART interface for GPS
 */
void init_UART_GPS(void );

// Aniruddha - added a flag to count number of times ISR for UART0 is called
volatile static uint8_t ISR_count = 0;

#endif /* GPS_H_ */