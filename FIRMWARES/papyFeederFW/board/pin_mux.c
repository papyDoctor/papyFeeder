/*
 * Copyright 2019 NXP
 * All rights reserved.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */

#include "fsl_common.h"
#include "pin_mux.h"
#include "fsl_swm.h"

/* FUNCTION ************************************************************************************************************
 *
 * Function Name : BOARD_InitBootPins
 * Description   : Calls initialization functions.
 *
 * END ****************************************************************************************************************/
void BOARD_InitBootPins(void)
{
    BOARD_InitPins();
}

void BOARD_InitPins(void)
{
    /* Enables clock for switch matrix.: enable */
    CLOCK_EnableClock(kCLOCK_Swm);

    /* USART0_TXD connect to P0_4 */
    SWM_SetMovablePinSelect(SWM0, kSWM_USART0_TXD, kSWM_PortPin_P0_4);

    /* USART0_RXD connect to P0_0 */
    SWM_SetMovablePinSelect(SWM0, kSWM_USART0_RXD, kSWM_PortPin_P0_0);

    /* TimerMatchChannel0 connect to P0_8 */
    SWM_SetMovablePinSelect(SWM0, kSWM_T0_MAT_CHN0, kSWM_PortPin_P0_8);

    /* TimerMatchChannel1 connect to P0_9 */
    SWM_SetMovablePinSelect(SWM0, kSWM_T0_MAT_CHN1, kSWM_PortPin_P0_9);

    /* Disable clock for switch matrix. */
    CLOCK_DisableClock(kCLOCK_Swm);
}
