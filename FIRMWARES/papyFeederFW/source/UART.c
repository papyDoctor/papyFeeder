/*
 * UART.c
 *
 *  Created on: 20 juil. 2020
 *      Author: olivier
 */

#include "fsl_usart.h"
#include "defines.h"

/*******************************************************************************
 * Global variables/decl/...
 ******************************************************************************/
volatile bool cmdReceived = false;
uint8_t CMDtxt[RX_BUFFER_SIZE];

/*******************************************************************************
 * Local variables/decl/...
 ******************************************************************************/
static uint8_t rxBuffer[RX_BUFFER_SIZE];
static volatile uint8_t rxDataCounter = 0U;

/*******************************************************************************
 * Private functions
 ******************************************************************************/
void USART0_IRQHandler(void)
{
    uint8_t data;

    // Receive
    if (kUSART_RxReady & USART_GetStatusFlags(USART0))
    {
        data = USART_ReadByte(USART0);
        rxBuffer[rxDataCounter++] = data;

        if ( data == 0x0D ) {
        	memcpy(CMDtxt, rxBuffer, RX_BUFFER_SIZE);
        	memset(rxBuffer, 0, RX_BUFFER_SIZE);
        	rxDataCounter = 0U;
        	cmdReceived = true;
        } else
            // Avoid overflow
            if (rxDataCounter == RX_BUFFER_SIZE - 1)
                rxDataCounter = 0U;
    }

    __DSB();
}

/*******************************************************************************
 * Public functions
 ******************************************************************************/
void initUART(void)
{
    usart_config_t config;

    USART_GetDefaultConfig(&config);
    config.enableRx     = true;
    config.enableTx     = true;
    config.baudRate_Bps = USART_BAUDRATE;

    /* Select the main clock as source clock of USART0. */
    CLOCK_Select(kUART0_Clk_From_MainClk);

    /* Initialize the USART with configuration. */
    USART_Init(USART0, &config, CLOCK_GetFreq(kCLOCK_MainClk));

    /* Enable USART RX ready interrupt. */
    USART_EnableInterrupts(USART0, kUSART_RxReadyInterruptEnable);
    EnableIRQ(USART0_IRQn);
}

uint8_t hex2Byte(char MSHEX, char LSHEX) {

	uint8_t value, byte=0;

	byte = MSHEX;
    if (byte >= '0' && byte <= '9') byte = byte - '0';
    else if (byte >= 'a' && byte <='f') byte = byte - 'a' + 10;
    else if (byte >= 'A' && byte <='F') byte = byte - 'A' + 10;

    value = byte << 4;

	byte = LSHEX;
    if (byte >= '0' && byte <= '9') byte = byte - '0';
    else if (byte >= 'a' && byte <='f') byte = byte - 'a' + 10;
    else if (byte >= 'A' && byte <='F') byte = byte - 'A' + 10;

    value += byte;

    return value;
}

void commandResponse( char resp )
{
	USART_WriteByte(USART0, resp);
//	while( !(kUSART_TxReady & USART_GetStatusFlags(USART0)) );
}
