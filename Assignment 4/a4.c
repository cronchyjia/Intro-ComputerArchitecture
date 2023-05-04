/* a4.c
 * CSC Fall 2022
 * 
 * Student name: Jiayue Wong
 * Student UVic ID: V00------
 * Date of completed work: 3/29/2023
 *
 *
 * Code provided for Assignment #4
 *
 * Author: Mike Zastre (2022-Nov-22)
 *
 * This skeleton of a C language program is provided to help you
 * begin the programming tasks for A#4. As with the previous
 * assignments, there are "DO NOT TOUCH" sections. You are *not* to
 * modify the lines within these section.
 *
 * You are also NOT to introduce any new program-or file-scope
 * variables (i.e., ALL of your variables must be local variables).
 * YOU MAY, however, read from and write to the existing program- and
 * file-scope variables. Note: "global" variables are program-
 * and file-scope variables.
 *
 * UNAPPROVED CHANGES to "DO NOT TOUCH" sections could result in
 * either incorrect code execution during assignment evaluation, or
 * perhaps even code that cannot be compiled.  The resulting mark may
 * be zero.
 */


/* =============================================
 * ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
 * =============================================
 */

#define __DELAY_BACKWARD_COMPATIBLE__ 1
#define F_CPU 16000000UL

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

#define DELAY1 0.000001
#define DELAY3 0.01

#define PRESCALE_DIV1 8
#define PRESCALE_DIV3 64
#define TOP1 ((int)(0.5 + (F_CPU/PRESCALE_DIV1*DELAY1))) 
#define TOP3 ((int)(0.5 + (F_CPU/PRESCALE_DIV3*DELAY3)))

#define PWM_PERIOD ((long int)500)

volatile long int count = 0;
volatile long int slow_count = 0;


ISR(TIMER1_COMPA_vect) {
	count++;
}


ISR(TIMER3_COMPA_vect) {
	slow_count += 5;
}

/* =======================================
 * ==== END OF "DO NOT TOUCH" SECTION ====
 * =======================================
 */


/* *********************************************
 * **** BEGINNING OF "STUDENT CODE" SECTION ****
 * *********************************************
 */

void led_state(uint8_t LED, uint8_t state) {
	switch(LED){
		case 0:
			if(state == 1){
				PORTL |= 0b10000000;
			}
			if(state == 0){
				PORTL &= 0b01111111;
			}
			break;
		case 1:
			if(state == 1){
				PORTL |= 0b00100000;
			}
			if(state == 0){
				PORTL &= 0b11011111;
			}
			break;
		case 2:
			if(state == 1){
				PORTL |= 0b00001000;
			}
			if(state == 0){
				PORTL &= 0b11110111;
			}
			break;
		case 3:
			if(state == 1){
				PORTL |= 0b00000010;
			}
			if(state == 0){
				PORTL &= 0b11111101;
			}
			break;
		case 4:
			if(state == 1){
				PORTB |= 0b00001000;
			}
			if(state == 0){
				PORTB &= 0b11110111;
			}
			break;
		case 5: 
			if(state == 1){
				PORTB |= 0b00000010;
			}
			if(state == 0){
				PORTB &= 0b11111101;
			}
			break;
	}

}



void SOS() {
    uint8_t light[] = {
        0x1, 0, 0x1, 0, 0x1, 0,
        0xf, 0, 0xf, 0, 0xf, 0,
        0x1, 0, 0x1, 0, 0x1, 0,
        0x0
    };

    int duration[] = {
        100, 250, 100, 250, 100, 500,
        250, 250, 250, 250, 250, 500,
        100, 250, 100, 250, 100, 250,
        250
    };

	int length = 19;

    for(int i = 0; i<length; i++){
	    uint8_t which_light = light[i];
	    uint8_t time_len = duration[i];
		uint8_t LED = 0;
		int bit_mask = 0b00000001;
		
	    for(int j = 0; j <= 3; j++){  //only up to 3 since 0xf = 0b1111 only goes up to 3 bits
			
		    LED = which_light & bit_mask; //masks to check all the bits
		    bit_mask = bit_mask << 1; //bit shift left
			
		    if(LED == 0){ //lights off
			    led_state(j,0);
		    }
		    else{
			    led_state(j,1);
		    }
	    }
	    _delay_ms(duration[i]);
    }
}


void glow(uint8_t LED, float brightness) {
	float threshold = PWM_PERIOD * brightness;
	
	for(;;){
		if(count < threshold){
			led_state(LED,1);
		}
		else if(count < PWM_PERIOD){
			led_state(LED,0);
		}
		else{
			led_state(LED,1);
			count = 0;
		}
	}
}



void pulse_glow(uint8_t LED) {
	float brightness = 0; //highest brightness can be is 0.99
	float threshold = 0; 
	int increase_brightness = 1; // 1 if brightness is increasing, 0 if brightness is decreasing
	
	while(1){ //first need to determine if brightness should increase or decrease
		if(slow_count == PWM_PERIOD){
			if(increase_brightness == 1){ //increase brightness
				brightness += 0.15; //number taken off of pg 5 of pdf
				if(brightness > 1){
					increase_brightness = 0;
				}
			}
			else{
				brightness -= 0.15; // decrease brightness, number taken off of pg 5 of pdf
				if(brightness < 0){
					increase_brightness = 1;
				}
			}
			slow_count = 0;
		}
		
		threshold = PWM_PERIOD * brightness;
		if(count < threshold){
			led_state(LED,1);
		}
		else if(count < PWM_PERIOD){
			led_state(LED,0);
		}
		else{
			led_state(LED,1);
			count = 0;
		}
	}
}



void light_show() {
	//code the same as SOS function, only changes are for light[], duration[], and length
	uint8_t light[] = {
		0xf, 0, 0xf, 0, 0xf, 0,
		0x6, 0, 0x9, 0, 0xf, 0,
		0xf, 0, 0xf, 0, 0x9, 0,
		0x6, 0, 0x8, 0xc, 0x6, 0x3,
		0x1, 0x3, 0x6, 0xc, 0x8, 0xc,
		0x6, 0x3, 0x1, 0x3, 0x6, 0,
		0xf, 0, 0xf, 0, 0x6, 0,
		0x6, 0
	};
	
	int duration[] = {
		150, 150, 150, 150, 150, 150,
		100, 100, 100, 100, 150, 150,
		150, 150, 150, 150, 100, 100,
		100, 100, 100, 100, 100, 100,
		100, 100, 100, 100, 100, 100,
		100, 100, 100, 100, 100, 100,
		150, 150, 150, 150, 200, 200,
		150, 150
	};

	int length = 44;

	for(int i = 0; i<length; i++){
		uint8_t which_light = light[i];
		uint8_t time_len = duration[i];
		uint8_t LED = 0;
		int bit_mask = 0b00000001;

		for(int j = 0; j <= 3; j++){  //only up to 3 since 0xf = 0b1111 only goes up to 3 bits
			LED = which_light & bit_mask; //masks to check all the bits
			bit_mask = bit_mask << 1; //bit shift left
			if(LED == 0){ //lights off
				led_state(j,0);
			}
			else{
				led_state(j,1);
			}
		}
		_delay_ms(duration[i]);
	}
}



/* ***************************************************
 * **** END OF FIRST "STUDENT CODE" SECTION **********
 * ***************************************************
 */


/* =============================================
 * ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
 * =============================================
 */

int main() {
    /* Turn off global interrupts while setting up timers. */

	cli();

	/* Set up timer 1, i.e., an interrupt every 1 microsecond. */
	OCR1A = TOP1;
	TCCR1A = 0;
	TCCR1B = 0;
	TCCR1B |= (1 << WGM12);
    /* Next two lines provide a prescaler value of 8. */
	TCCR1B |= (1 << CS11);
	TCCR1B |= (1 << CS10);
	TIMSK1 |= (1 << OCIE1A);

	/* Set up timer 3, i.e., an interrupt every 10 milliseconds. */
	OCR3A = TOP3;
	TCCR3A = 0;
	TCCR3B = 0;
	TCCR3B |= (1 << WGM32);
    /* Next line provides a prescaler value of 64. */
	TCCR3B |= (1 << CS31);
	TIMSK3 |= (1 << OCIE3A);


	/* Turn on global interrupts */
	sei();

/* =======================================
 * ==== END OF "DO NOT TOUCH" SECTION ====
 * =======================================
 */


/* *********************************************
 * **** BEGINNING OF "STUDENT CODE" SECTION ****
 * *********************************************
 */

 //This code could be used to test your work for part A.
/*
	led_state(0, 1);
	_delay_ms(1000);
	led_state(2, 1);
	_delay_ms(1000);
	led_state(1, 1);
	_delay_ms(1000);
	led_state(2, 0);
	_delay_ms(1000);
	led_state(0, 0);
	_delay_ms(1000);
	led_state(1, 0);
	_delay_ms(1000);
*/

// This code could be used to test your work for part B.
/*
	SOS();
*/

// This code could be used to test your work for part C.
/*
	glow(2, .1);
*/



// This code could be used to test your work for part D.
/*
	pulse_glow(3);
*/


// This code could be used to test your work for the bonus part.
/*
	light_show();
*/

/* ****************************************************
 * **** END OF SECOND "STUDENT CODE" SECTION **********
 * ****************************************************
 */
}
