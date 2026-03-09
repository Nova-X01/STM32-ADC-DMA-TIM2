# STM32-ADC-DMA-TIM2


Цей проект демонструє **низькорівневу роботу STM32F103C8 на чистому асемблері**:
- ADC перетворює аналоговий сигнал
- DMA передає результат у RAM
- TIM2 PWM оновлюється значенням з DMA

Проект **не використовує HAL, LL або будь-які бібліотеки** – лише регістри.

---

## Файли

- `main.s` – головна програма (ADC, DMA, TIM2)
- `startup.s` – Reset_Handler та векторна таблиця та переривання
- `linker.ld` – лінкер-скрипт (Flash / RAM)
- `Makefile` – збірка та прошивка
- `README.md` – цей файл
- `main.bin - готовий скомпільований файл

- Піни STM32 :
A0   -  LED +
A1   -  Понтанціометр центральна ножка 2
3.3V -  крайня ножка понтанціометра    1
GND  -  крайня ножка понтанціометр     3
GND  -  LED -

- прошивка для STM32F103C8
- я прошиваю через STM32 ST-LINK
- Компілюється все через MSYS
- Кроки для компіляції файлів 

1 : export PATH=/c/Users/Name(You)/Desktop/arm-gnu-toolchain-15.2.rel1-mingw-w64-x86_64-arm-none-eabi/bin:$PATH
2 : arm-none-eabi-gcc --version
3 : pacman -Syu
4 : pacman -S make
5 : cd /c/Users/Name(You)/Desktop/stm32_asm
6 : make clean
7 : make

І далі прошивка через STM32 ST-LINK Utility за допмогою .bin/.elf

Увага путь до файлів у вас інший !
Також не забудьте додати PATH
