.syntax unified
.thumb

.global Reset_Handler
.global main
.global TIM2_IRQHandler
.global ADC1_2_IRQHandler
.global DMA1CH1_IRQHandler

/* Векторна таблиця */
.section .isr_vector, "a", %progbits
.word _estack            /* Початковий Stack Pointer з лінкера */
.word Reset_Handler      /* Reset-вектор */
.word 0, 0, 0, 0, 0
.word 0, 0, 0, 0
.word 0, 0, 0, 0, 0

.rept 11
.word 0
.endr

.word DMA1CH1_IRQHandler
                                        
.rept 6
.word 0
.endr

.word ADC1_2_IRQHandler

.rept 9
.word 0
.endr

.word TIM2_IRQHandler


.section .text
.thumb_func
Reset_Handler:
    /* 1. Копіювання .data з Flash у RAM */
    ldr r0, =_sidata
    ldr r1, =_sdata
    ldr r2, =_edata
    b copy_data_check

copy_data_loop:
    ldr r3, [r0], #4
    str r3, [r1], #4

copy_data_check:
    cmp r1, r2
    bcc copy_data_loop

    /* 2. Обнулення .bss у RAM */
    ldr r0, =_sbss
    ldr r1, =_ebss
    mov r2, #0
    b zero_bss_check

zero_bss_loop:
    str r2, [r0], #4

zero_bss_check:
    cmp r0, r1
    bcc zero_bss_loop

    /* 3. Виклик основної програми */
    bl main

loop:
    b loop

.thumb_func
.weak TIM2_IRQHandler
.type TIM2_IRQHandler, %function
TIM2_IRQHandler:
   
    LDR R0, =0x40000010
    LDR R1, [R0]
    BIC R1, R1, #(1 << 0)
    BIC R1, R1, #(1 << 1)
    STR R1, [R0]
 
    BX LR


.thumb_func
.weak ADC1_2_IRQHandler
.type ADC1_2_IRQHandler, %function
ADC1_2_IRQHandler:

    BX LR


.thumb_func
.weak DMA1CH1_IRQHandler
.type DMA1CH1_IRQHandler, %function
DMA1CH1_IRQHandler:
    LDR R0, =0x20000004     @ ADC Buffer SPAM 
    LDR R1, [R0]
    LDR R2, =0x40000034     @ TIM2_CCR1
    STR R1, [R2]

    LDR R0, =0x40020000     @ DMA1 CH1 ISR1
    LDR R1, [R0]
    BIC R1, R1, #(1 << 1)
    STR R1, [R0]

    BX LR