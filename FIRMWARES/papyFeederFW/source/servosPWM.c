/*
 * servosPWM.c
 *
 *  Created on: 19 juil. 2020
 *      Author: olivier
 */

#include "fsl_common.h"
#include "pin_mux.h"
#include "fsl_swm.h"

#include "fsl_ctimer.h"
#include "board.h"
#include "defines.h"




/*******************************************************************************
 * Global variables/decl/...
 ******************************************************************************/
extern s_parameters_t parameters;

/*******************************************************************************
 * Local variables/decl/...
 ******************************************************************************/
static volatile uint32_t g_pwmPeriod  = 0U;
static volatile uint32_t g_pulsePeriod = 0U;
static uint32_t timerClock;

/*******************************************************************************
 * Private functions
 ******************************************************************************/
static status_t CTIMER_GetPwmPeriodValue(uint32_t pwmFreqHz, uint8_t dutyCyclePercent, uint32_t timerClock_Hz) {

    /* Calculate PWM period match value */
    g_pwmPeriod = (timerClock_Hz / pwmFreqHz) - 1;

    /* Calculate pulse width match value */
    if (dutyCyclePercent == 0)
        g_pulsePeriod = g_pwmPeriod + 1;
    else
        g_pulsePeriod = (g_pwmPeriod * (100 - dutyCyclePercent)) / 100;

    return kStatus_Success;
}

static status_t filmServo(uint8_t val) {
	CTIMER_GetPwmPeriodValue(PWM_FREQ, val, timerClock);
	CTIMER_SetupPwmPeriod(CTIMER, CTIMER_PULLER_OUT, g_pwmPeriod, g_pulsePeriod, false);
	return kStatus_Success;
}

static status_t tapeServo(uint8_t val) {
	CTIMER_GetPwmPeriodValue(PWM_FREQ, val, timerClock);
	CTIMER_SetupPwmPeriod(CTIMER,  CTIMER_PUSHER_OUT, g_pwmPeriod, g_pulsePeriod, false);
	return kStatus_Success;
}

/*******************************************************************************
 * Public functions
 ******************************************************************************/
status_t initServosPWM() {
    ctimer_config_t config;
    uint32_t srcClock_Hz;

    /* CTimer0 counter uses the AHB clock, some CTimer1 modules use the Aysnc clock */
    srcClock_Hz = CTIMER_CLK_FREQ;

    CTIMER_GetDefaultConfig(&config);
    timerClock = srcClock_Hz / (config.prescale + 1);

    CTIMER_Init(CTIMER, &config);

    // Pusher
    CTIMER_GetPwmPeriodValue(PWM_FREQ, parameters.valueServoTapeOff, timerClock);
    CTIMER_SetupPwmPeriod(CTIMER, CTIMER_PUSHER_OUT, g_pwmPeriod, g_pulsePeriod, false);

    // Puller
    CTIMER_GetPwmPeriodValue(PWM_FREQ, parameters.valueServoFilmOff, timerClock);
    CTIMER_SetupPwmPeriod(CTIMER, CTIMER_PULLER_OUT, g_pwmPeriod, g_pulsePeriod, false);

    CTIMER_StartTimer(CTIMER);

    return kStatus_Success;
}

status_t filmServoStop() {
	filmServo( parameters.valueServoFilmOff );

    /* Enables clock for switch matrix.: enable */
    CLOCK_EnableClock(kCLOCK_Swm);
    /* TimerMatchChannel0 connect to P0_11: STOP SENDING PWM TO SERVO */
    SWM_SetMovablePinSelect(SWM0, kSWM_T0_MAT_CHN0, kSWM_PortPin_P0_11);
    /* Disable clock for switch matrix. */
    CLOCK_DisableClock(kCLOCK_Swm);

	return kStatus_Success;
}

status_t filmServoStart() {
	filmServo( parameters.valueServoFilmForward );

    /* Enables clock for switch matrix.: enable */
    CLOCK_EnableClock(kCLOCK_Swm);
    /* TimerMatchChannel0 connect to P0_8: START SENDING PWM TO SERVO */
    SWM_SetMovablePinSelect(SWM0, kSWM_T0_MAT_CHN0, kSWM_PortPin_P0_8);
    /* Disable clock for switch matrix. */
    CLOCK_DisableClock(kCLOCK_Swm);

	return kStatus_Success;
}

status_t filmServoReverse() {
	filmServo( parameters.valueServoFilmReverse );

    /* Enables clock for switch matrix.: enable */
    CLOCK_EnableClock(kCLOCK_Swm);
    /* TimerMatchChannel0 connect to P0_8: START SENDING PWM TO SERVO */
    SWM_SetMovablePinSelect(SWM0, kSWM_T0_MAT_CHN0, kSWM_PortPin_P0_8);
    /* Disable clock for switch matrix. */
    CLOCK_DisableClock(kCLOCK_Swm);

	return kStatus_Success;
}

status_t tapeServoStop() {
	tapeServo( parameters.valueServoTapeOff );
	return kStatus_Success;
}

status_t tapeServoStart() {
	tapeServo( parameters.valueServoTapeOn );
	return kStatus_Success;
}

