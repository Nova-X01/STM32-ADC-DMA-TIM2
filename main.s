    .syntax unified
    .thumb

.equ GPIOC_CRL,  0x40011000
.equ GPIOC_CRH,  0x40011004
.equ GPIOC_IDR,  0x40011008
.equ GPIOC_ODR,  0x4001100C
.equ GPIOC_BSRR, 0x40011010
.equ GPIOC_BRR,  0x40011014
.equ GPIOC_LCKR, 0x40011018

.equ GPIOA_CRL,  0x40010800
.equ GPIOA_CRH,  0x40010804
.equ GPIOA_IDR,  0x40010808
.equ GPIOA_ODR,  0x4001080C
.equ GPIOA_BSRR, 0x40010810
.equ GPIOA_BRR,  0x40010814
.equ GPIOA_LCKR, 0x40010818

.equ AHBENR,     0x40021014
.equ APB1ENR,    0x4002101C
.equ APB2ENR,    0x40021018

.equ TIM2_CR1,   0x40000000
.equ TIM2_CR2,   0x40000004
.equ TIM2_SMCR,  0x40000008
.equ TIM2_DIER,  0x4000000C
.equ TIM2_SR,    0x40000010
.equ TIM2_EGR,   0x40000014
.equ TIM2_CCMR1, 0x40000018
.equ TIM2_CCMR2, 0x4000001C
.equ TIM2_CCER,  0x40000020
.equ TIM2_CNT,   0x40000024
.equ TIM2_PSC,   0x40000028
.equ TIM2_ARR,   0x4000002C
.equ TIM2_CCR1,  0x40000034
.equ TIM2_CCR2,  0x40000038
.equ TIM2_CCR3,  0x4000003C
.equ TIM2_CCR4,  0x40000040
.equ TIM2_DCR,   0x40000048
.equ TIM2_DMAR,  0x4000004C

.equ NVIC_ISER0, 0xE000E100
.equ NVIC_ISER1, 0xE000E104

.equ ADC_SR,     0x40012400
.equ ADC_CR1,    0x40012404
.equ ADC_CR2,    0x40012408
.equ ADC_SMPR1,  0x4001240C
.equ ADC_SMPR2,  0x40012410
.equ ADC_JOFR1,  0x40012414
.equ ADC_JOFR2,  0x40012418
.equ ADC_JOFR3,  0x4001241C
.equ ADC_JOFR4,  0x40012420
.equ ADC_HTR,    0x40012424
.equ ADC_LTR,    0x40012428
.equ ADC_SQR1,   0x4001242C
.equ ADC_SQR2,   0x40012430
.equ ADC_SQR3,   0x40012434
.equ ADC_JSQR,   0x40012438
.equ ADC_JDR1,   0x4001243C
.equ ADC_JDR2,   0x40012440
.equ ADC_JDR3,   0x40012444
.equ ADC_JDR4,   0x40012448
.equ ADC_DR,     0x4001244C

.equ DMA_ISR,    0x40020000
.equ DMA_IFCR,   0x40020004
.equ DMA_CCR1,   0x40020008
.equ DMA_CNDTR1, 0x4002000C
.equ DMA_CPAR1,  0x40020010
.equ DMA_CMAR1,  0x40020014



.section .data
.align 4
counter: .word 0x12345678

.section .text
    .global main
.type main, %function
    main:
        LDR R0, =APB2ENR
        LDR R1, [R0]
        ORR R1, R1, #(1 << 2)  @ Clock PORT A
        ORR R1, R1, #(1 << 9)  @ Clock PORT ADC1
        ORR R1, R1, #(1 << 10) @ Clock PORT ADC2
        STR R1, [R0]

        LDR R0, =AHBENR
        LDR R1, [R0]
        ORR R1, R1, #(1 << 0)
        STR R1, [R0]

        LDR R0, =GPIOA_CRL
        LDR R1, [R0]
        BIC R1, R1, #0xFF
        ORR R1, R1, #0x0B
        STR R1, [R0]



        @ вмикаєм тактування таймера 2
        LDR R0, =APB1ENR
        LDR R1, [R0]
        ORR R1, R1, #(1 << 0)
        STR R1, [R0]
        
        @ PSC /1
        LDR R0, =TIM2_PSC
        LDR R1, [R0]
        MOV R1, #0
        STR R1, [R0]

        @ TIM2_ARR
        LDR R0, =TIM2_ARR
        LDR R1, [R0]
        MOV R1, #4095
        STR R1, [R0]

        @ TIM2_CCR1
        LDR R0, =TIM2_CCR1
        LDR R1, [R0]
        MOV R1, #2000
        STR R1, [R0]

        @ URS
        LDR R0, =TIM2_CR1
        LDR R1, [R0]
        ORR R1, R1, #(1 << 2)
        ORR R1, R1, #(1 << 7)
        STR R1, [R0]

        @TIM2_DIER
        LDR R0, =TIM2_DIER
        LDR R1, [R0]
        ORR R1, R1, #(1 << 0)
        STR R1, [R0]
        
        @TIM2_CCMR1
        LDR R0, =TIM2_CCMR1
        LDR R1, [R0]
        ORR R1, R1, #(1 << 3)
        BIC R1, R1, #(1 << 4)
        ORR R1, R1, #(1 << 5)
        ORR R1, R1, #(1 << 6)
        STR R1, [R0]

        @TIM2_CCER
        LDR R0, =TIM2_CCER
        LDR R1, [R0]
        ORR R1, R1, #(1 << 0)
        STR R1, [R0]

    @ NVIC
        @NVIC_ISER0
        LDR R0, =NVIC_ISER0
        LDR R1, [R0]
        ORR R1, R1, #(1 << 11)  @ DMA1
    @   ORR R1, R1, #(1 << 18)  @ ADC  У нашому коді не використовується
        ORR R1, R1, #(1 << 28)  @ TIM2
        STR R1, [R0]

        @TIM2_EGR
        LDR R0, =TIM2_EGR
        LDR R1, [R0]
        ORR R1, R1, #(1 << 0)
        STR R1, [R0]

    @ ADC
        LDR R0, =ADC_CR2 @ COUT = 0 ONE mode conversion
        LDR R1, [R0]
        ORR R1, R1, #(1 << 1)   @ COUT
        ORR R1, R1, #(1 << 8)   @ DMA 
        BIC R1, R1, #(1 << 11)  @ ALIGN
        ORR R1, R1, #(1 << 20)  @ EXTTRIG
        ORR R1, R1, #(1 << 19)  @ EXTSEL = SWSTART
        ORR R1, R1, #(1 << 18)  @
        ORR R1, R1, #(1 << 17)  @
        STR R1, [R0]

        LDR R0, =ADC_CR1
        LDR R1, [R0]
        BIC R1, R1, #(1 << 5)   @ EOCIE NO EOC переривання
        STR R1, [R0]

        LDR R0, =ADC_SMPR2
        LDR R1, [R0]
        ORR R1, R1, #(1 << 5)   @ 41.2 вимір циклів ADC каналу
        STR R1, [R0]

        @ ADC_SQR1
        LDR R0, =ADC_SQR1
        LDR R1, [R0]
        BIC R1, R1, #(1 << 23)  @ 1 перетворення
        BIC R1, R1, #(1 << 22)
        BIC R1, R1, #(1 << 21)
        BIC R1, R1, #(1 << 20)
        STR R1, [R0]

        @ ADC_SQR3
        LDR R0, =ADC_SQR3
        LDR R1, [R0]
        MOV R1, #0x01           @ Chanel 1 ADC
        STR R1, [R0]

        @ ADON = 1
        LDR R0, =ADC_CR2
        LDR R1, [R0]
        ORR R1, R1, #(1 << 0)
        STR R1, [R0]
        NOP @ 2 цикли для стабілізації живлення (можна також використати delay функцію для 100% стабілізації живлення) 
        NOP

        @ calibtovka
        LDR R0, =ADC_CR2
        LDR R1, [R0]
        ORR R1, R1, #(1 << 3)
        STR R1, [R0]

    b0:
        LDR R0, =ADC_CR2
        LDR R1, [R0]
        TST R1, #(1 << 3)
        BNE b0 
        
        LDR R0, =ADC_CR2
        LDR R1, [R0]
        ORR R1, R1, #(1 << 2)
        STR R1, [R0]

    b1:
        LDR R0, =ADC_CR2
        LDR R1, [R0]
        TST R1, #(1 << 2)
        BNE b1 

    @ DMA
        LDR R0, =DMA_CMAR1
        LDR R1, =0x20000004
        STR R1, [R0]

        LDR R0, =DMA_CPAR1
        LDR R1, =ADC_DR
        STR R1, [R0]

        LDR R0, =DMA_CNDTR1    
        MOV R1, #1
        STR R1, [R0]

        LDR R0, =DMA_CCR1
        LDR R1, [R0]
        ORR R1, R1, #(1 << 1)  @ TC перреривання
        BIC R1, R1, #(1 << 4)  @ DIR  = 0   ADC -> SPAM    
        ORR R1, R1, #(1 << 5)  @ CIRC = 1
        ORR R1, R1, #(1 << 9)  @ 32 Bit mode переферія
        BIC R1, R1, #(1 << 8)  @
        ORR R1, R1, #(1 << 11) @ 32 Bit mode память
        BIC R1, R1, #(1 << 10) @
        BIC R1, R1, #(1 << 14) @ MEM2MEM OFF
        STR R1, [R0]



    @ Start
        @ запускаєм DMA 
        LDR R0, =DMA_CCR1
        LDR R1, [R0]
        ORR R1, R1, #(1 << 0)
        STR R1, [R0]

        LDR R0, =ADC_CR2 @ Запускаєм ADC SWSTART
        LDR R1, [R0]
        ORR R1, R1, #(1 << 22)
        STR R1, [R0]
        
        @TIM2 CR1 CEN Start Timer 2
        LDR R0, =TIM2_CR1
        LDR R1, [R0]
        ORR R1, R1, #(1 << 0)
        STR R1, [R0]        
        
        CPSIE i         @ Дозволяєм переривання

    loop:
        

        b loop


    .global delay
.type delay, %function
    delay:
    LDR R0, =100000
d1:
    SUBS R0, R0, #1
    BNE d1
    BX LR
