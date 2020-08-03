/*
 * defines.h
 *
 *  Created on: 19 juil. 2020
 *      Author: olivier
 */

#ifndef INC_DEFINES_H_
#define INC_DEFINES_H_

/*********************************************************************
 * IAP
 *********************************************************************/
#define IAP_FLASH_SECTOR				(14)

// Total memory footprint of s_parameters_t <= page size = 64 bytes
typedef struct __attribute__((packed, aligned(4))) {
	union {
		struct __attribute__((packed, aligned(4))) {
			uint8_t myAddress;
			uint8_t valueServoTapeOn;
			uint8_t valueServoTapeOff;
			uint8_t valueServoFilmReverse;
			uint8_t valueServoFilmOff;
			uint8_t valueServoFilmForward;
			uint8_t tickFilmReverse;
			uint8_t tickFilmForward;
			uint8_t tickTapeOn;
			//
			uint8_t numberOfCycles;
		};
		uint8_t raw[64];
	};
} s_parameters_t;

/*********************************************************************
 * I/Os
 *********************************************************************/
#define PB_PORT					0U
#define PB_PIN					12U

#define LED_PORT				0U
#define LED_PIN					1U

/*********************************************************************
 * PWM SERVOS
 *********************************************************************/
#define CTIMER 					CTIMER0             /* Timer 0 */
#define CTIMER_PUSHER_OUT 		kCTIMER_Match_1 	/* Match output 1 */
#define CTIMER_PULLER_OUT 		kCTIMER_Match_0 	/* Match output 0 */
#define CTIMER_CLK_FREQ 		CLOCK_GetFreq(kCLOCK_CoreSysClk)
#define PWM_FREQ				200

#define MIN_SERVO_POS			10
#define MAX_SERVO_POS			50

#define MIN_SERVO_TIME			5
#define MAX_SERVO_TIME			30

/*********************************************************************
 * UART
 *********************************************************************/
/*! @brief Buffer size (Unit: Byte). */
#define RX_BUFFER_SIZE 			10
#define USART_BAUDRATE			9600

#define ADDR_BROADCAST			0xFF

#define CMD_SET_ADDRESS			'a'

#define CMD_INC_VAL_TAPE_ON		'b'
#define CMD_DEC_VAL_TAPE_ON		'c'

#define CMD_INC_VAL_TAPE_OFF	'd'
#define CMD_DEC_VAL_TAPE_OFF	'e'

#define CMD_INC_VAL_FILM_REV	'f'
#define CMD_DEC_VAL_FILM_REV	'g'

#define CMD_INC_VAL_FILM_OFF	'h'
#define CMD_DEC_VAL_FILM_OFF	'i'

#define CMD_INC_VAL_FILM_FORW	'j'
#define CMD_DEC_VAL_FILM_FORW	'k'

#define CMD_INC_TIME_FILM_REV	'l'
#define CMD_DEC_TIME_FILM_REV	'm'

#define CMD_INC_TIME_FILM_FORW	'n'
#define CMD_DEC_TIME_FILM_FORW	'o'

#define CMD_INC_TIME_TAPE_ON	'p'
#define CMD_DEC_TIME_TAPE_ON	'q'

#define CMD_PULL_FILM			'x'
#define CMD_REVERSE_FILM		'y'
#define CMD_CYCLE_FEEDER		'z'

/*********************************************************************
 * BUTTON states
 *********************************************************************/
typedef enum {
	e_nocmd,				// No push
	e_cmd_cycle,			// Normal push
	e_cmd_film_reverse,		// Long push
	e_cmd_film_pull,		// Short push
} e_cmd_Button_t;

typedef enum {
	e_increment,
	e_decrement,
} e_inc_dec_t;

#endif /* INC_DEFINES_H_ */
