/***********************************************************************************************************************
 * This file was generated by the MCUXpresso Config Tools. Any manual edits made to this file
 * will be overwritten if the respective MCUXpresso Config Tools is used to update this file.
 **********************************************************************************************************************/

/* clang-format off */
/*
 * TEXT BELOW IS USED AS SETTING FOR TOOLS *************************************
!!GlobalInfo
product: Pins v13.0
processor: LPC54102J512
package_id: LPC54102J512BD64
mcu_data: ksdk2_0
processor_version: 13.0.1
board: LPCXpresso54102
 * BE CAREFUL MODIFYING THIS COMMENT - IT IS YAML SETTINGS FOR TOOLS ***********
 */
/* clang-format on */

#include "fsl_common.h"
#include "fsl_iocon.h"
#include "pin_mux.h"

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

/* clang-format off */
/*
 * TEXT BELOW IS USED AS SETTING FOR TOOLS *************************************
BOARD_InitPins:
- options: {callFromInitBoot: 'true', prefix: BOARD_, coreID: cm4, enableClock: 'true'}
- pin_list:
  - {pin_num: '31', peripheral: USART0, signal: RXD, pin_signal: PIO0_0/U0_RXD/SPI0_SSEL0/CT32B0_CAP0/SCT0_OUT3, mode: inactive, invert: disabled, glitch_filter: disabled,
    slew_rate: standard, open_drain: disabled}
  - {pin_num: '32', peripheral: USART0, signal: TXD, pin_signal: PIO0_1/U0_TXD/SPI0_SSEL1/CT32B0_CAP1/SCT0_OUT1, mode: inactive, invert: disabled, glitch_filter: disabled,
    slew_rate: standard, open_drain: disabled}
  - {pin_num: '50', peripheral: SWD, signal: SWO, pin_signal: PIO0_15/SPI0_SSEL1/SWO/CT32B2_MAT2, mode: inactive, invert: disabled, glitch_filter: disabled, slew_rate: standard,
    open_drain: disabled}
 * BE CAREFUL MODIFYING THIS COMMENT - IT IS YAML SETTINGS FOR TOOLS ***********
 */
/* clang-format on */

/* FUNCTION ************************************************************************************************************
 *
 * Function Name : BOARD_InitPins
 * Description   : Configures pin routing and optionally pin electrical features.
 *
 * END ****************************************************************************************************************/
/* Function assigned for the Cortex-M4F */
void BOARD_InitPins(void)
{
    /* Enables the clock for the IOCON block. 0 = Disable; 1 = Enable.: 0x01u */
    CLOCK_EnableClock(kCLOCK_Iocon);

    const uint32_t DEBUG_UART_RX = (/* Pin is configured as U0_RXD */
                                    IOCON_PIO_FUNC1 |
                                    /* No addition pin function */
                                    IOCON_PIO_MODE_INACT |
                                    /* Input function is not inverted */
                                    IOCON_PIO_INV_DI |
                                    /* Enables digital function */
                                    IOCON_PIO_DIGITAL_EN |
                                    /* Input filter disabled */
                                    IOCON_PIO_INPFILT_OFF |
                                    /* Standard mode, output slew rate control is enabled */
                                    IOCON_PIO_SLEW_STANDARD |
                                    /* Open drain is disabled */
                                    IOCON_PIO_OPENDRAIN_DI);
    /* PORT0 PIN0 (coords: 31) is configured as U0_RXD */
    IOCON_PinMuxSet(IOCON, BOARD_DEBUG_UART_RX_PORT, BOARD_DEBUG_UART_RX_PIN, DEBUG_UART_RX);

    const uint32_t DEBUG_UART_TX = (/* Pin is configured as U0_TXD */
                                    IOCON_PIO_FUNC1 |
                                    /* No addition pin function */
                                    IOCON_PIO_MODE_INACT |
                                    /* Input function is not inverted */
                                    IOCON_PIO_INV_DI |
                                    /* Enables digital function */
                                    IOCON_PIO_DIGITAL_EN |
                                    /* Input filter disabled */
                                    IOCON_PIO_INPFILT_OFF |
                                    /* Standard mode, output slew rate control is enabled */
                                    IOCON_PIO_SLEW_STANDARD |
                                    /* Open drain is disabled */
                                    IOCON_PIO_OPENDRAIN_DI);
    /* PORT0 PIN1 (coords: 32) is configured as U0_TXD */
    IOCON_PinMuxSet(IOCON, BOARD_DEBUG_UART_TX_PORT, BOARD_DEBUG_UART_TX_PIN, DEBUG_UART_TX);

    const uint32_t DEBUG_SWD_SWO = (/* Pin is configured as SWO */
                                    IOCON_PIO_FUNC2 |
                                    /* No addition pin function */
                                    IOCON_PIO_MODE_INACT |
                                    /* Input function is not inverted */
                                    IOCON_PIO_INV_DI |
                                    /* Enables digital function */
                                    IOCON_PIO_DIGITAL_EN |
                                    /* Input filter disabled */
                                    IOCON_PIO_INPFILT_OFF |
                                    /* Standard mode, output slew rate control is enabled */
                                    IOCON_PIO_SLEW_STANDARD |
                                    /* Open drain is disabled */
                                    IOCON_PIO_OPENDRAIN_DI);
    /* PORT0 PIN15 (coords: 50) is configured as SWO */
    IOCON_PinMuxSet(IOCON, BOARD_DEBUG_SWD_SWO_PORT, BOARD_DEBUG_SWD_SWO_PIN, DEBUG_SWD_SWO);
}
/***********************************************************************************************************************
 * EOF
 **********************************************************************************************************************/
