TARGET = kernel
PORT = /dev/ttyUSB0
BAUD_FLASH = 460800
BAUD_MONITOR = 115200

export PATH := $(PATH):/home/glammy/src/riscv-none-elf-gcc/bin

CC = riscv-none-elf-gcc
ESPTOOL = esptool.py

ARCH_FLAGS = -march=rv32imac_zicsr -mabi=ilp32
CFLAGS = $(ARCH_FLAGS) -T linker.ld -nostdlib -ffreestanding -O0 -g3 -fno-omit-frame-pointer -mno-relax -Wl,--gc-sections
SRC = entry.S trapvec.S swtch.S entry.c trap.c

all: $(TARGET).bin

run_openocd:
	~/Downloads/openocd-esp32/bin/openocd -c 'set ESP_RTOS none' -f ~/Downloads/openocd-esp32/share/openocd/scripts/board/esp32c3-builtin.cfg
build_run_openocd:
	~/Downloads/openocd-esp32/bin/openocd -c 'set ESP_RTOS none' -f ~/Downloads/openocd-esp32/share/openocd/scripts/board/esp32c3-builtin.cfg -c "init; halt; load_image kernel.elf; resume 0x40380000"

$(TARGET).asm:
	@echo "=== Компиляция ASM дампа ==="
	riscv-none-elf-objdump -S -d -l $(TARGET).elf > $(TARGET).asm

$(TARGET).elf: $(SRC) linker.ld
	@echo "=== Компиляция ELF ==="
	$(CC) $(CFLAGS) -o $@ $(SRC)

$(TARGET).bin: $(TARGET).elf $(TARGET).asm
	@echo "=== Конвертация в BIN ==="
	$(ESPTOOL) --chip esp32c3 elf2image --flash_mode dio --flash_size 4MB --flash_freq 40m $<

flash: $(TARGET).bin perms
	@echo "=== Внимание: Переведите чип в режим BOOT ==="
	@echo "Нажмите Enter для продолжения..." && read _
	@echo "=== Прошивка чипа ==="
	$(ESPTOOL) --chip esp32c3 --port $(PORT) --baud $(BAUD_FLASH) write_flash 0x0 $(TARGET).bin
	@echo "=== ПРОШИВКА ЗАВЕРШЕНА ==="
	@echo "Теперь ОТКЛЮЧИТЕ и СНОВА ПОДКЛЮЧИТЕ USB-кабель платы!"
	@echo "После этого запустите: make monitor"

erase: perms
	$(ESPTOOL) --chip esp32c3 --port $(PORT) --baud $(BAUD_MONITOR) erase_flash

monitor: perms
	@echo "=== Открытие монитора ==="
	python3 -m serial.tools.miniterm $(PORT) $(BAUD_MONITOR) --dtr 0 --rts 0

perms:
	sudo chmod 666 $(PORT)

clean:
	rm -f $(TARGET).elf $(TARGET).bin $(TARGET).asm

.PHONY: all flash erase monitor perms clean
