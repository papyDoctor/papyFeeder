/*
 * flash.c
 *
 *  Created on: 21 juil. 2020
 *      Author: olivier
 */
#include "board.h"
#include "fsl_iap.h"

#include "defines.h"

/*******************************************************************************
 * Global variables/decl/...
 ******************************************************************************/
extern s_parameters_t parameters;

s_parameters_t paramsInit = {
	{
		0x01,	// myAddress
		20U,	// valueServoTapeOn
		40U,	// valueServoTapeOff
		15U,	// valueServoFilmReverse
		28U,	// valueServoFilmOff
		40U,	// valueServoFilmForward
		11U,	// tickFilmReverse
		12U,	// tickFilmForward
		16U,	// tickTapeOn
		//
		1U,		// numberOfCycles
	},
};

/*******************************************************************************
 * Local variables/decl/...
 ******************************************************************************/
static uint32_t s_IapFlashPage = FSL_FEATURE_SYSCON_FLASH_SECTOR_SIZE_BYTES * IAP_FLASH_SECTOR;

/*******************************************************************************
 * Private functions
 ******************************************************************************/

/*******************************************************************************
 * Public functions
 ******************************************************************************/
status_t storeParameters( void ) {

	status_t status = kStatus_IAP_Success;

    // Erase sector before writing
	status |= IAP_PrepareSectorForWrite(IAP_FLASH_SECTOR, IAP_FLASH_SECTOR);

	status |= IAP_EraseSector(IAP_FLASH_SECTOR, IAP_FLASH_SECTOR, SystemCoreClock);

    // Program page
	status |= IAP_PrepareSectorForWrite(IAP_FLASH_SECTOR, IAP_FLASH_SECTOR);

	status |= IAP_CopyRamToFlash(s_IapFlashPage , (uint32_t *)parameters.raw,
					FSL_FEATURE_SYSCON_FLASH_PAGE_SIZE_BYTES, SystemCoreClock);

    return status;
}

void loadParameters( void ) {

	memcpy((void*)&parameters.raw, (void*)s_IapFlashPage, FSL_FEATURE_SYSCON_FLASH_PAGE_SIZE_BYTES);
}

