/* ---------------------------------------------------------------------------------------*/
/*  @file:    startup_LPC54102_cm4.S                                                      */
/*  @purpose: CMSIS Cortex-M4 Core Device Startup File                                    */
/*            LPC54102_cm4                                                                */
/*  @version: 1.0                                                                         */
/*  @date:    2016-11-2                                                                   */
/*  @build:   b161214                                                                     */
/* ---------------------------------------------------------------------------------------*/
/*                                                                                        */
/* Copyright 1997-2016 Freescale Semiconductor, Inc.                                      */
/* Copyright 2016-2018 NXP                                                                */
/*                                                                                        */
/* SPDX-License-Identifier: BSD-3-Clause                           */
/*****************************************************************************/
/* Version: GCC for ARM Embedded Processors                                  */
/*****************************************************************************/
    .syntax unified
    .arch armv7-m

    .section .isr_vector, "a"
    .align 2
    .globl __Vectors
__Vectors:
    .long   __StackTop                                      /* Top of Stack */
    .long   Reset_Handler                                   /* Reset Handler */
    .long   NMI_Handler                                     /* NMI Handler*/
    .long   HardFault_Handler                               /* Hard Fault Handler*/
    .long   MemManage_Handler                               /* MPU Fault Handler*/
    .long   BusFault_Handler                                /* Bus Fault Handler*/
    .long   UsageFault_Handler                              /* Usage Fault Handler*/
    .long   0                                               /* Reserved*/
    .long   0                                               /* Reserved*/
    .long   0                                               /* Reserved*/
    .long   0                                               /* Reserved*/
    .long   SVC_Handler                                     /* SVCall Handler*/
    .long   DebugMon_Handler                                /* Debug Monitor Handler*/
    .long   0                                               /* Reserved*/
    .long   PendSV_Handler                                  /* PendSV Handler*/
    .long   SysTick_Handler                                 /* SysTick Handler*/

                                                            /* External Interrupts*/
    .long   WDT_IRQHandler                                  /* Watchdog Timer */
    .long   BOD_IRQHandler                                  /* BOD interrupt */
    .long   0                                               /* Reserved */
    .long   DMA0_IRQHandler                                 /* DMA controller interrupt */
    .long   GINT0_IRQHandler                                /* GPIO group 0 */
    .long   PIN_INT0_IRQHandler                             /* Pin interrupt 0 or pattern match engine slice 0 */
    .long   PIN_INT1_IRQHandler                             /* Pin interrupt 1 or pattern match engine slice 1 */
    .long   PIN_INT2_IRQHandler                             /* Pin interrupt 2 or pattern match engine slice 2 */
    .long   PIN_INT3_IRQHandler                             /* Pin interrupt 3 or pattern match engine slice 3 */
    .long   UTICK0_IRQHandler                               /* Micro-tick Timer */
    .long   MRT0_IRQHandler                                 /* Multi-rate timer */
    .long   CTIMER0_IRQHandler                              /* Standard counter/timer CTIMER0 */
    .long   CTIMER1_IRQHandler                              /* Standard counter/timer CTIMER1 */
    .long   CTIMER2_IRQHandler                              /* Standard counter/timer CTIMER2 */
    .long   CTIMER3_IRQHandler                              /* Standard counter/timer CTIMER3 */
    .long   CTIMER4_IRQHandler                              /* Standard counter/timer CTIMER4 */
    .long   SCT0_IRQHandler                                 /* SCTimer/PWM */
    .long   USART0_IRQHandler                               /* USART0 */
    .long   USART1_IRQHandler                               /* USART1 */
    .long   USART2_IRQHandler                               /* USART2 */
    .long   USART3_IRQHandler                               /* USART3 */
    .long   I2C0_IRQHandler                                 /* I2C0 */
    .long   I2C1_IRQHandler                                 /* I2C1 */
    .long   I2C2_IRQHandler                                 /* I2C2 */
    .long   SPI0_IRQHandler                                 /* SPI0 */
    .long   SPI1_IRQHandler                                 /* SPI1 */
    .long   ADC0_SEQA_IRQHandler                            /* ADC0 sequence A completion */
    .long   ADC0_SEQB_IRQHandler                            /* ADC0 sequence B completion */
    .long   ADC0_THCMP_IRQHandler                           /* ADC0 threshold compare and error. */
    .long   RTC_IRQHandler                                  /* RTC alarm and wake-up interrupts */
    .long   0                                               /* Reserved */
    .long   MAILBOX_IRQHandler                              /* Mailbox interrupt */
    .long   GINT1_IRQHandler                                /* GPIO group 1 */
    .long   PIN_INT4_IRQHandler                             /* Pin interrupt 4 or pattern match engine slice 4 int */
    .long   PIN_INT5_IRQHandler                             /* Pin interrupt 5 or pattern match engine slice 5 int */
    .long   PIN_INT6_IRQHandler                             /* Pin interrupt 6 or pattern match engine slice 6 int */
    .long   PIN_INT7_IRQHandler                             /* Pin interrupt 7 or pattern match engine slice 7 int */
    .long   0                                               /* Reserved interrupt */
    .long   0                                               /* Reserved interrupt */
    .long   0                                               /* Reserved interrupt */
    .long   RIT_IRQHandler                                  /* Repetitive Interrupt Timer */
    .size    __Vectors, . - __Vectors


    
    .text
    .thumb
#ifndef  SLAVEBOOT
rel_vals:
    .long   0xE000ED00   /* cpu_id */
    .long   0x40000300   /* cpu_ctrl */
    .long   0x40000304   /* coproc_boot */
    .long   0x40000308   /* coproc_stack */
    .short  0x0FFF       
    .short  0x0C24
#endif
/* Reset Handler */

    .thumb_func
    .align 2
    .globl   Reset_Handler
    .weak    Reset_Handler
    .type    Reset_Handler, %function

Reset_Handler:
#ifndef  SLAVEBOOT
/* Both the M0+ and M4 core come via this shared startup code,
 * but the M0+ and M4 core have different vector tables.
 * Determine if the core executing this code is the master or
 * the slave and handle each core state individually. */

shared_boot_entry:
    ldr     r6, =rel_vals
                
    /* Flag for slave core (0) */                
    movs    r4, 0
    movs    r5, 1

    /* Determine which core (M0+ or M4) this code is running on */
    /* r2 = (((*cpu_id) >> 4) & 0xFFF); (M4 core == 0xC24) */
get_current_core_id:
    ldr     r0, [r6, #0]
    ldr     r1, [r0]                        /* r1 = CPU ID status */
    lsrs    r1, r1, #4                      /* Right justify 12 CPU ID bits */
    ldrh    r2, [r6, #16]                   /* Mask for CPU ID bits */
    ands    r2, r1, r2                      /* r2 = ARM COrtex CPU ID */
    ldrh    r3, [r6, #18]                   /* Mask for CPU ID bits */
    cmp     r3, r2                          /* Core ID matches M4 identifier */
    bne     get_master_status
    mov     r4, r5                          /* Set flag for master core (1) */

    /* Determine if M4 core is the master or slave */
    /* r3 = ((*cpu_ctrl) & 1); (0 == m0+, 1 == M4) */
get_master_status:
    ldr     r0, [r6, #4]
    ldr     r3, [r0]                        /* r3 = SYSCON co-processor CPU control status */

    ands    r3, r3, r5                      /* r3 = (Bit 0: 1 = M4 is master, 0 = M4 is slave) */

    /* Select boot based on selected master core and core ID */

select_boot:
    eors    r3, r3, r4                      /* r4 = (Bit 0: 0 = master, 1 = slave) */

    bne     slave_boot
    b       normal_boot

    /* Slave boot */
slave_boot:
    ldr     r0, [r6, #8]
    ldr     r2, [r0]                        /* r1 = SYSCON co-processor boot address */

    cmp     r2, #0                          /* Slave boot address = 0 (not set up)? */

    beq     cpu_sleep
    ldr     r0, [r6, #12]
    ldr     r1, [r0]                        /* r5 = SYSCON co-processor stack address */

    mov     sp, r1                          /* Update slave CPU stack pointer */

    /* Be sure to update VTOR for the slave MCU to point to the */
    /* slave vector table in boot memory */
    bx      r2                              /* Jump to slave boot address */

    /* Slave isn't yet setup for system boot from the master */
    /* so sleep until the master sets it up and then reboots it */
cpu_sleep:
    mov     sp, r5                          /* Will force exception if something happens */
cpu_sleep_wfi:
    wfi                                     /* Sleep forever until master reboots */
    b       cpu_sleep_wfi
#endif /* defined(SLAVEBOOT) */

#ifndef __START
#define __START _start
#endif
#ifndef __ATOLLIC__
normal_boot:
#ifndef __NO_SYSTEM_INIT
    ldr   r0,=SystemInit
    blx   r0
#endif
    /*      Loop to copy data from read only memory to RAM. The ranges
     *      of copy from/to are specified by following symbols evaluated in
     *      linker script.
     *      __etext: End of code section, i.e., begin of data sections to copy from.
     *      __data_start__/__data_end__: RAM address range that data should be
     *      copied to. Both must be aligned to 4 bytes boundary.  */

    ldr    r1, =__etext
    ldr    r2, =__data_start__
    ldr    r3, =__data_end__

#if 1
/* Here are two copies of loop implemenations. First one favors code size
 * and the second one favors performance. Default uses the first one.
 * Change to "#if 0" to use the second one */
.LC0:
    cmp     r2, r3
    ittt    lt
    ldrlt   r0, [r1], #4
    strlt   r0, [r2], #4
    blt    .LC0
#else
    subs    r3, r2
    ble    .LC1
.LC0:
    subs    r3, #4
    ldr    r0, [r1, r3]
    str    r0, [r2, r3]
    bgt    .LC0
.LC1:
#endif

#ifdef __STARTUP_CLEAR_BSS
/*     This part of work usually is done in C library startup code. Otherwise,
 *     define this macro to enable it in this startup.
 *
 *     Loop to zero out BSS section, which uses following symbols
 *     in linker script:
 *      __bss_start__: start of BSS section. Must align to 4
 *      __bss_end__: end of BSS section. Must align to 4
 */
    ldr r1, =__bss_start__
    ldr r2, =__bss_end__

    movs    r0, 0
.LC2:
    cmp     r1, r2
    itt    lt
    strlt   r0, [r1], #4
    blt    .LC2
#endif /* __STARTUP_CLEAR_BSS */
    ldr   r0,=__START
    blx   r0
#else
    ldr   r0,=__libc_init_array
    blx   r0
    ldr   r0,=main
    bx    r0
#endif
    
    .pool
    .size Reset_Handler, . - Reset_Handler

    .align  1
    .thumb_func
    .weak DefaultISR
    .type DefaultISR, %function
DefaultISR:
    b DefaultISR
    .size DefaultISR, . - DefaultISR

    .align 1
    .thumb_func
    .weak NMI_Handler
    .type NMI_Handler, %function
NMI_Handler:
    ldr   r0,=NMI_Handler
    bx    r0
    .size NMI_Handler, . - NMI_Handler

    .align 1
    .thumb_func
    .weak HardFault_Handler
    .type HardFault_Handler, %function
HardFault_Handler:
    ldr   r0,=HardFault_Handler
    bx    r0
    .size HardFault_Handler, . - HardFault_Handler

    .align 1
    .thumb_func
    .weak MemManage_Handler
    .type MemManage_Handler, %function
MemManage_Handler:
    ldr   r0,=MemManage_Handler
    bx    r0
    .size MemManage_Handler, . - MemManage_Handler

    .align 1
    .thumb_func
    .weak BusFault_Handler
    .type BusFault_Handler, %function
BusFault_Handler:
    ldr   r0,=BusFault_Handler
    bx    r0
    .size BusFault_Handler, . - BusFault_Handler

    .align 1
    .thumb_func
    .weak UsageFault_Handler
    .type UsageFault_Handler, %function
UsageFault_Handler:
    ldr   r0,=UsageFault_Handler
    bx    r0
    .size UsageFault_Handler, . - UsageFault_Handler
    
    .align 1
    .thumb_func
    .weak SVC_Handler
    .type SVC_Handler, %function
SVC_Handler:
    ldr   r0,=SVC_Handler
    bx    r0
    .size SVC_Handler, . - SVC_Handler

    .align 1
    .thumb_func
    .weak DebugMon_Handler
    .type DebugMon_Handler, %function
DebugMon_Handler:
    ldr   r0,=DebugMon_Handler
    bx    r0
    .size DebugMon_Handler, . - DebugMon_Handler
    
    .align 1
    .thumb_func
    .weak PendSV_Handler
    .type PendSV_Handler, %function
PendSV_Handler:
    ldr   r0,=PendSV_Handler
    bx    r0
    .size PendSV_Handler, . - PendSV_Handler

    .align 1
    .thumb_func
    .weak SysTick_Handler
    .type SysTick_Handler, %function
SysTick_Handler:
    ldr   r0,=SysTick_Handler
    bx    r0
    .size SysTick_Handler, . - SysTick_Handler

    .align 1
    .thumb_func
    .weak WDT_IRQHandler
    .type WDT_IRQHandler, %function
WDT_IRQHandler:
    ldr   r0,=WDT_DriverIRQHandler
    bx    r0
    .size WDT_IRQHandler, . - WDT_IRQHandler

    .align 1
    .thumb_func
    .weak BOD_IRQHandler
    .type BOD_IRQHandler, %function
BOD_IRQHandler:
    ldr   r0,=BOD_DriverIRQHandler
    bx    r0
    .size BOD_IRQHandler, . - BOD_IRQHandler

    .align 1
    .thumb_func
    .weak DMA0_IRQHandler
    .type DMA0_IRQHandler, %function
DMA0_IRQHandler:
    ldr   r0,=DMA0_DriverIRQHandler
    bx    r0
    .size DMA0_IRQHandler, . - DMA0_IRQHandler

    .align 1
    .thumb_func
    .weak GINT0_IRQHandler
    .type GINT0_IRQHandler, %function
GINT0_IRQHandler:
    ldr   r0,=GINT0_DriverIRQHandler
    bx    r0
    .size GINT0_IRQHandler, . - GINT0_IRQHandler

    .align 1
    .thumb_func
    .weak PIN_INT0_IRQHandler
    .type PIN_INT0_IRQHandler, %function
PIN_INT0_IRQHandler:
    ldr   r0,=PIN_INT0_DriverIRQHandler
    bx    r0
    .size PIN_INT0_IRQHandler, . - PIN_INT0_IRQHandler

    .align 1
    .thumb_func
    .weak PIN_INT1_IRQHandler
    .type PIN_INT1_IRQHandler, %function
PIN_INT1_IRQHandler:
    ldr   r0,=PIN_INT1_DriverIRQHandler
    bx    r0
    .size PIN_INT1_IRQHandler, . - PIN_INT1_IRQHandler

    .align 1
    .thumb_func
    .weak PIN_INT2_IRQHandler
    .type PIN_INT2_IRQHandler, %function
PIN_INT2_IRQHandler:
    ldr   r0,=PIN_INT2_DriverIRQHandler
    bx    r0
    .size PIN_INT2_IRQHandler, . - PIN_INT2_IRQHandler

    .align 1
    .thumb_func
    .weak PIN_INT3_IRQHandler
    .type PIN_INT3_IRQHandler, %function
PIN_INT3_IRQHandler:
    ldr   r0,=PIN_INT3_DriverIRQHandler
    bx    r0
    .size PIN_INT3_IRQHandler, . - PIN_INT3_IRQHandler

    .align 1
    .thumb_func
    .weak UTICK0_IRQHandler
    .type UTICK0_IRQHandler, %function
UTICK0_IRQHandler:
    ldr   r0,=UTICK0_DriverIRQHandler
    bx    r0
    .size UTICK0_IRQHandler, . - UTICK0_IRQHandler

    .align 1
    .thumb_func
    .weak MRT0_IRQHandler
    .type MRT0_IRQHandler, %function
MRT0_IRQHandler:
    ldr   r0,=MRT0_DriverIRQHandler
    bx    r0
    .size MRT0_IRQHandler, . - MRT0_IRQHandler

    .align 1
    .thumb_func
    .weak CTIMER0_IRQHandler
    .type CTIMER0_IRQHandler, %function
CTIMER0_IRQHandler:
    ldr   r0,=CTIMER0_DriverIRQHandler
    bx    r0
    .size CTIMER0_IRQHandler, . - CTIMER0_IRQHandler

    .align 1
    .thumb_func
    .weak CTIMER1_IRQHandler
    .type CTIMER1_IRQHandler, %function
CTIMER1_IRQHandler:
    ldr   r0,=CTIMER1_DriverIRQHandler
    bx    r0
    .size CTIMER1_IRQHandler, . - CTIMER1_IRQHandler

    .align 1
    .thumb_func
    .weak CTIMER2_IRQHandler
    .type CTIMER2_IRQHandler, %function
CTIMER2_IRQHandler:
    ldr   r0,=CTIMER2_DriverIRQHandler
    bx    r0
    .size CTIMER2_IRQHandler, . - CTIMER2_IRQHandler

    .align 1
    .thumb_func
    .weak CTIMER3_IRQHandler
    .type CTIMER3_IRQHandler, %function
CTIMER3_IRQHandler:
    ldr   r0,=CTIMER3_DriverIRQHandler
    bx    r0
    .size CTIMER3_IRQHandler, . - CTIMER3_IRQHandler

    .align 1
    .thumb_func
    .weak CTIMER4_IRQHandler
    .type CTIMER4_IRQHandler, %function
CTIMER4_IRQHandler:
    ldr   r0,=CTIMER4_DriverIRQHandler
    bx    r0
    .size CTIMER4_IRQHandler, . - CTIMER4_IRQHandler    

    .align 1
    .thumb_func
    .weak SCT0_IRQHandler
    .type SCT0_IRQHandler, %function
SCT0_IRQHandler:
    ldr   r0,=SCT0_DriverIRQHandler
    bx    r0
    .size SCT0_IRQHandler, . - SCT0_IRQHandler

    .align 1
    .thumb_func
    .weak USART0_IRQHandler
    .type USART0_IRQHandler, %function
USART0_IRQHandler:
    ldr   r0,=USART0_DriverIRQHandler
    bx    r0
    .size USART0_IRQHandler, . - USART0_IRQHandler
    
    .align 1
    .thumb_func
    .weak USART1_IRQHandler
    .type USART1_IRQHandler, %function
USART1_IRQHandler:
    ldr   r0,=USART1_DriverIRQHandler
    bx    r0
    .size USART1_IRQHandler, . - USART1_IRQHandler

    .align 1
    .thumb_func
    .weak USART2_IRQHandler
    .type USART2_IRQHandler, %function
USART2_IRQHandler:
    ldr   r0,=USART2_DriverIRQHandler
    bx    r0
    .size USART2_IRQHandler, . - USART2_IRQHandler

    .align 1
    .thumb_func
    .weak USART3_IRQHandler
    .type USART3_IRQHandler, %function
USART3_IRQHandler:
    ldr   r0,=USART3_DriverIRQHandler
    bx    r0
    .size USART3_IRQHandler, . - USART3_IRQHandler

    .align 1
    .thumb_func
    .weak I2C0_IRQHandler
    .type I2C0_IRQHandler, %function
I2C0_IRQHandler:
    ldr   r0,=I2C0_DriverIRQHandler
    bx    r0
    .size I2C0_IRQHandler, . - I2C0_IRQHandler

    .align 1
    .thumb_func
    .weak I2C1_IRQHandler
    .type I2C1_IRQHandler, %function
I2C1_IRQHandler:
    ldr   r0,=I2C1_DriverIRQHandler
    bx    r0
    .size I2C1_IRQHandler, . - I2C1_IRQHandler

    .align 1
    .thumb_func
    .weak I2C2_IRQHandler
    .type I2C2_IRQHandler, %function
I2C2_IRQHandler:
    ldr   r0,=I2C2_DriverIRQHandler
    bx    r0
    .size I2C2_IRQHandler, . - I2C2_IRQHandler

    .align 1
    .thumb_func
    .weak SPI0_IRQHandler
    .type SPI0_IRQHandler, %function
SPI0_IRQHandler:
    ldr   r0,=SPI0_DriverIRQHandler
    bx    r0
    .size SPI0_IRQHandler, . - SPI0_IRQHandler

    .align 1
    .thumb_func
    .weak SPI1_IRQHandler
    .type SPI1_IRQHandler, %function
SPI1_IRQHandler:
    ldr   r0,=SPI1_DriverIRQHandler
    bx    r0
    .size SPI1_IRQHandler, . - SPI1_IRQHandler
    
    .align 1
    .thumb_func
    .weak ADC0_SEQA_IRQHandler
    .type ADC0_SEQA_IRQHandler, %function
ADC0_SEQA_IRQHandler:
    ldr   r0,=ADC0_SEQA_DriverIRQHandler
    bx    r0
    .size ADC0_SEQA_IRQHandler, . - ADC0_SEQA_IRQHandler

    .align 1
    .thumb_func
    .weak ADC0_SEQB_IRQHandler
    .type ADC0_SEQB_IRQHandler, %function
ADC0_SEQB_IRQHandler:
    ldr   r0,=ADC0_SEQB_DriverIRQHandler
    bx    r0
    .size ADC0_SEQB_IRQHandler, . - ADC0_SEQB_IRQHandler

    .align 1
    .thumb_func
    .weak ADC0_THCMP_IRQHandler
    .type ADC0_THCMP_IRQHandler, %function
ADC0_THCMP_IRQHandler:
    ldr   r0,=ADC0_THCMP_DriverIRQHandler
    bx    r0
    .size ADC0_THCMP_IRQHandler, . - ADC0_THCMP_IRQHandler

    .align 1
    .thumb_func
    .weak RTC_IRQHandler
    .type RTC_IRQHandler, %function
RTC_IRQHandler:
    ldr   r0,=RTC_DriverIRQHandler
    bx    r0
    .size RTC_IRQHandler, . - RTC_IRQHandler

    .align 1
    .thumb_func
    .weak MAILBOX_IRQHandler
    .type MAILBOX_IRQHandler, %function
MAILBOX_IRQHandler:
    ldr   r0,=MAILBOX_DriverIRQHandler
    bx    r0
    .size MAILBOX_IRQHandler, . - MAILBOX_IRQHandler

    .align 1
    .thumb_func
    .weak GINT1_IRQHandler
    .type GINT1_IRQHandler, %function
GINT1_IRQHandler:
    ldr   r0,=GINT1_DriverIRQHandler
    bx    r0
    .size GINT1_IRQHandler, . - GINT1_IRQHandler

    .align 1
    .thumb_func
    .weak PIN_INT4_IRQHandler
    .type PIN_INT4_IRQHandler, %function
PIN_INT4_IRQHandler:
    ldr   r0,=PIN_INT4_DriverIRQHandler
    bx    r0
    .size PIN_INT4_IRQHandler, . - PIN_INT4_IRQHandler
    
    .align 1
    .thumb_func
    .weak PIN_INT5_IRQHandler
    .type PIN_INT5_IRQHandler, %function
PIN_INT5_IRQHandler:
    ldr   r0,=PIN_INT5_DriverIRQHandler
    bx    r0
    .size PIN_INT5_IRQHandler, . - PIN_INT5_IRQHandler

    .align 1
    .thumb_func
    .weak PIN_INT6_IRQHandler
    .type PIN_INT6_IRQHandler, %function
PIN_INT6_IRQHandler:
    ldr   r0,=PIN_INT6_DriverIRQHandler
    bx    r0
    .size PIN_INT6_IRQHandler, . - PIN_INT6_IRQHandler

    .align 1
    .thumb_func
    .weak PIN_INT7_IRQHandler
    .type PIN_INT7_IRQHandler, %function
PIN_INT7_IRQHandler:
    ldr   r0,=PIN_INT7_DriverIRQHandler
    bx    r0
    .size PIN_INT7_IRQHandler, . - PIN_INT7_IRQHandler
    
    .align 1
    .thumb_func
    .weak RIT_IRQHandler
    .type RIT_IRQHandler, %function
RIT_IRQHandler:
    ldr   r0,=RIT_DriverIRQHandler
    bx    r0
    .size RIT_IRQHandler, . - RIT_IRQHandler
    
/*    Macro to define default handlers. Default handler
 *    will be weak symbol and just dead loops. They can be
 *    overwritten by other handlers */
    .macro def_irq_handler  handler_name
    .weak \handler_name
    .set  \handler_name, DefaultISR
    .endm

/* Exception Handlers */
    def_irq_handler    WDT_DriverIRQHandler
    def_irq_handler    BOD_DriverIRQHandler
    def_irq_handler    DMA0_DriverIRQHandler
    def_irq_handler    GINT0_DriverIRQHandler
    def_irq_handler    PIN_INT0_DriverIRQHandler
    def_irq_handler    PIN_INT1_DriverIRQHandler
    def_irq_handler    PIN_INT2_DriverIRQHandler
    def_irq_handler    PIN_INT3_DriverIRQHandler
    def_irq_handler    UTICK0_DriverIRQHandler
    def_irq_handler    MRT0_DriverIRQHandler
    def_irq_handler    CTIMER0_DriverIRQHandler
    def_irq_handler    CTIMER1_DriverIRQHandler
    def_irq_handler    CTIMER2_DriverIRQHandler
    def_irq_handler    CTIMER3_DriverIRQHandler
    def_irq_handler    CTIMER4_DriverIRQHandler
    def_irq_handler    SCT0_DriverIRQHandler
    def_irq_handler    USART0_DriverIRQHandler
    def_irq_handler    USART1_DriverIRQHandler
    def_irq_handler    USART2_DriverIRQHandler
    def_irq_handler    USART3_DriverIRQHandler
    def_irq_handler    I2C0_DriverIRQHandler
    def_irq_handler    I2C1_DriverIRQHandler
    def_irq_handler    I2C2_DriverIRQHandler
    def_irq_handler    SPI0_DriverIRQHandler
    def_irq_handler    SPI1_DriverIRQHandler
    def_irq_handler    ADC0_SEQA_DriverIRQHandler
    def_irq_handler    ADC0_SEQB_DriverIRQHandler
    def_irq_handler    ADC0_THCMP_DriverIRQHandler
    def_irq_handler    RTC_DriverIRQHandler
    def_irq_handler    MAILBOX_DriverIRQHandler
    def_irq_handler    GINT1_DriverIRQHandler
    def_irq_handler    PIN_INT4_DriverIRQHandler
    def_irq_handler    PIN_INT5_DriverIRQHandler
    def_irq_handler    PIN_INT6_DriverIRQHandler
    def_irq_handler    PIN_INT7_DriverIRQHandler
    def_irq_handler    RIT_DriverIRQHandler

    .end
