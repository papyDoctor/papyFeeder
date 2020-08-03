/*
 * Copyright 2019 NXP
 * All rights reserved.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */
#include "board.h"
#include "pin_mux.h"
#include "fsl_iap.h"
#include "fsl_usart.h"

#include "defines.h"

/*******************************************************************************
 * Global variables/decl/...
 ******************************************************************************/
s_parameters_t parameters = {0};
extern s_parameters_t paramsInit;

extern void loadParameters( void );
extern status_t storeParameters( void );

extern status_t initServosPWM();
extern status_t initUART();

extern void commandResponse( char resp );
extern uint8_t hex2Byte(char MSHEX, char LSHEX);

extern status_t filmServoStop();
extern status_t filmServoStart();
extern status_t filmServoReverse();
extern status_t tapeServoStop();
extern status_t tapeServoStart();

extern bool cmdReceived;
extern uint8_t CMDtxt[RX_BUFFER_SIZE];

/*******************************************************************************
 * Local variables/decl/...
 ******************************************************************************/
static e_cmd_Button_t cmdButton = e_nocmd;
static uint32_t ticks;

/*******************************************************************************
 * Private functions
 ******************************************************************************/

/*!
 * @brief Init function
 */
static void initHardware( void ) {
	// Low level inits
    BOARD_InitBootPins();
    BOARD_InitBootClocks();

    // LED and BUTTON
    gpio_pin_config_t pb_config = { kGPIO_DigitalInput, 0, };
    gpio_pin_config_t led_config = { kGPIO_DigitalOutput, 1, };

    GPIO_PortMaskedSet(GPIO, LED_PORT, 0x0000FFFF);
    GPIO_PortMaskedWrite(GPIO, LED_PORT, 0xFFFFFFFF);

    GPIO_PortInit(GPIO, PB_PORT);
    GPIO_PinInit(GPIO, PB_PORT, PB_PIN, &pb_config);
    GPIO_PortInit(GPIO, LED_PORT);
    GPIO_PinInit(GPIO, LED_PORT, LED_PIN, &led_config);

    // init PWM engine
    initServosPWM();

    // init UART, interrupt on receive
    initUART();
}

/*!
 * @brief Process value and storage of positions parameters
 */
static status_t processServoPos( uint8_t* pValue, e_inc_dec_t incDec  ) {

	status_t status;

	if ( incDec == e_increment) {
		if ( *pValue < MAX_SERVO_POS )
			*pValue = *pValue + 1;
	} else {
		if ( *pValue > MIN_SERVO_POS )
			*pValue = *pValue - 1;
	}

	// Save to flash
	status = storeParameters();

	if ( status == kStatus_IAP_Success )
		commandResponse( 'g' );
	else
		commandResponse( '!' );

	return status;
}

/*!
 * @brief Process value and storage of time parameters
 */
static status_t processServoTime( uint8_t* pValue, e_inc_dec_t incDec  ) {

	status_t status;

	if ( incDec == e_increment) {
		if ( *pValue < MAX_SERVO_TIME )
			*pValue = *pValue + 1;
	} else {
		if ( *pValue > MIN_SERVO_TIME )
			*pValue = *pValue - 1;
	}

	// Save to flash
	status = storeParameters();

	if ( status == kStatus_IAP_Success )
		commandResponse( 'g' );
	else
		commandResponse( '!' );

	return status;
}

/*!
 * @brief UART communication
 */
static bool isCommandReceived() {

	status_t status;
	bool commandIsReceived = false;
	uint8_t addrReceived;

    // A command is received
    if ( cmdReceived == true ) {

    	cmdReceived = false;

    	//Check the address
    	addrReceived = hex2Byte( CMDtxt[0], CMDtxt[1] );

    	if ( addrReceived == ADDR_BROADCAST ) {

    		// For any broadcast commands, the button MUST be activated
    		if ( !GPIO_PinRead(GPIO, PB_PORT, PB_PIN) ) {
    			// If it's a setAddress command
    			if ( CMDtxt[2] == CMD_SET_ADDRESS) {
    				parameters.myAddress = hex2Byte( CMDtxt[3], CMDtxt[4] );
    				// Save to flash
    				status = storeParameters();
    				if ( status == kStatus_IAP_Success )
    					commandResponse( 'g' );
    				else
    					commandResponse( '!' );
    			}
    		}

    	} else {

    		if ( addrReceived == parameters.myAddress ) {

    			switch( CMDtxt[2] ) {

    				case CMD_SET_ADDRESS:
        				parameters.myAddress = hex2Byte( CMDtxt[3], CMDtxt[4] );
        				// Save to flash
        				status = storeParameters();
        				if ( status == kStatus_IAP_Success )
        					commandResponse( 'g' );
        				else
        					commandResponse( '!' );
        				break;

					case CMD_INC_VAL_TAPE_ON:
						processServoPos( &parameters.valueServoTapeOn, e_increment );
        				break;

					case CMD_DEC_VAL_TAPE_ON:
						processServoPos( &parameters.valueServoTapeOn, e_decrement );
        				break;

					case CMD_INC_VAL_TAPE_OFF:
						processServoPos( &parameters.valueServoTapeOff, e_increment );
        				break;

					case CMD_DEC_VAL_TAPE_OFF:
						processServoPos( &parameters.valueServoTapeOff, e_decrement );
        				break;

					case CMD_INC_VAL_FILM_REV:
						processServoPos( &parameters.valueServoFilmReverse, e_increment );
        				break;

					case CMD_DEC_VAL_FILM_REV:
						processServoPos( &parameters.valueServoFilmReverse, e_decrement );
        				break;

					case CMD_INC_VAL_FILM_OFF:
						processServoPos( &parameters.valueServoFilmOff, e_increment );
        				break;

					case CMD_DEC_VAL_FILM_OFF:
						processServoPos( &parameters.valueServoFilmOff, e_decrement );
        				break;

					case CMD_INC_VAL_FILM_FORW:
						processServoPos( &parameters.valueServoFilmForward, e_increment );
        				break;

					case CMD_DEC_VAL_FILM_FORW:
						processServoPos( &parameters.valueServoFilmForward, e_decrement );
        				break;

					case CMD_INC_TIME_FILM_REV:
						processServoTime( &parameters.tickFilmReverse, e_increment );
        				break;

					case CMD_DEC_TIME_FILM_REV:
						processServoTime( &parameters.tickFilmReverse, e_decrement );
        				break;

					case CMD_INC_TIME_FILM_FORW:
						processServoTime( &parameters.tickFilmForward, e_increment );
        				break;

					case CMD_DEC_TIME_FILM_FORW:
						processServoTime( &parameters.tickFilmForward, e_decrement );
        				break;

					case CMD_INC_TIME_TAPE_ON:
						processServoTime( &parameters.tickTapeOn, e_increment );
        				break;

					case CMD_DEC_TIME_TAPE_ON:
						processServoTime( &parameters.tickTapeOn, e_decrement );
        				break;

    				case CMD_PULL_FILM:
    					cmdButton = e_cmd_film_pull;
    					commandResponse( 'g' );
    					commandIsReceived = true;
    					break;

    				case CMD_REVERSE_FILM:
    					cmdButton = e_cmd_film_reverse;
    					commandResponse( 'g' );
    					commandIsReceived = true;
    					break;

    				case CMD_CYCLE_FEEDER:
    					parameters.numberOfCycles = CMDtxt[3]-'0';
    					if (parameters.numberOfCycles > 9)
    						parameters.numberOfCycles = 1;
    					cmdButton = e_cmd_cycle;
    					commandResponse( 'g' );
    					commandIsReceived = true;
    					break;

    				default:
    					commandResponse( '!' );
    					break;
    			}
    		}
    	}
    }

	return commandIsReceived;
}

/*!
 * @brief Button management
 */
static void buttonMngmt( void ) {

	bool button;
	static bool lastButton = false;
	static uint8_t tickCount = 0;

	if ( !isCommandReceived() ) {

		button = !GPIO_PinRead(GPIO, PB_PORT, PB_PIN);

		//Case 1: from release to push
		if ( !lastButton && button )
			tickCount++;

		//Case 2: from push to push
		if ( lastButton && button ) {
			tickCount++;
			// Long push
			if ( tickCount >= 6 ) {
				cmdButton = e_cmd_film_reverse;
			}
		}

		//Case 3: from push to release
		if ( lastButton && !button ) {
			// Short push
			if (tickCount < 2) {
				cmdButton = e_cmd_film_pull;
			} else {
				// Normal push
				if (tickCount >= 2 && tickCount < 6 ) {
					cmdButton = e_cmd_cycle;
				}
			}
			tickCount = 0;
		}

		//Case 4: from release to release
		if ( !lastButton && !button ) {
			tickCount = 0;
			cmdButton = e_nocmd;
		}

		lastButton = button;
	}
}

/*!
 * @brief This is my RTOS :)
 */
void SysTick_Handler(void) {

	static uint8_t tick10 = 0;

	if (tick10++ == 10) {
		tick10 = 0;
		buttonMngmt(); // Called every 100ms
	}

	ticks++;
}

void waitABit( uint32_t Nticks ) {

	uint32_t startTick = ticks;

	while (ticks - startTick < Nticks);
}

/*******************************************************************************
 * Public functions
 ******************************************************************************/
/*!
 * @brief Main loop
 */
void mainLoop( void ) {

	while (1) {

		switch ( cmdButton ) {

			// Start cycle
			case e_cmd_cycle:

				for (uint8_t i=0; i<parameters.numberOfCycles; i++) {

					// Blue LED On
					GPIO_PinWrite(GPIO, LED_PORT, LED_PIN, 0);

					// Start the film servo
					filmServoStart();
					// Set the tape servo
					tapeServoStart();

					waitABit(parameters.tickTapeOn);

					// Stop the film servo
					filmServoStop();

					waitABit(parameters.tickFilmForward);

					// Reset the tape servo
					tapeServoStop();

					waitABit(parameters.tickTapeOn);

					// Blue LED Off
					GPIO_PinWrite(GPIO, LED_PORT, LED_PIN, 1);
				}

				cmdButton = e_nocmd;
			break;

			case e_cmd_film_pull:
				// Start the film servo
				filmServoStart();
				// Blue LED On
				GPIO_PinWrite(GPIO, LED_PORT, LED_PIN, 0);

				waitABit(parameters.tickFilmForward);
				cmdButton = e_nocmd;
			break;

			case e_cmd_film_reverse:
				// Reverse the film servo
				filmServoReverse();
				// Blue LED On
				GPIO_PinWrite(GPIO, LED_PORT, LED_PIN, 0);

				waitABit(parameters.tickFilmReverse);
				cmdButton = e_nocmd;
			break;

			case e_nocmd:
				// Stop all
				tapeServoStop();
				filmServoStop();
				// Blue LED Off
				GPIO_PinWrite(GPIO, LED_PORT, LED_PIN, 1);
			break;

			default:
				break;
		}
	}
}

/*!
 * @brief Main function
 */
int main(void) {

	initHardware();

    // Set systick reload value to generate a tick of 10ms
    SysTick_Config(SystemCoreClock / 100U);

	loadParameters();
	if ( parameters.myAddress == 0x00 ) { //params not initialized

		memcpy(&parameters, &paramsInit, sizeof(paramsInit) );
	}
	mainLoop();

    return -1; // Never arrive here
}
