PREFIX = arm-none-eabi
AS = $(PREFIX)-as
CC = $(PREFIX)-gcc
OBJCOPY = $(PREFIX)-objcopy

CPU = -mcpu=cortex-m3 -mthumb

all: main.bin

startup.o: startup.s
	$(AS) $(CPU) startup.s -o startup.o

main.o: main.s
	$(AS) $(CPU) main.s -o main.o

# Замість ld → gcc
main.elf: startup.o main.o linker.ld
	$(CC) $(CPU) -nostdlib -T linker.ld startup.o main.o -o main.elf

main.bin: main.elf
	$(OBJCOPY) -O binary main.elf main.bin

flash: main.bin
	st-flash write main.bin 0x08000000

clean:
	rm -f *.o *.elf *.bin

