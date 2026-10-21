# How to flash

# What I use

metal: YP-05 programmator, ESP32-C3 Supermini

OS: Ubuntu 26.04

Tools: esptool.py 

# Connecting

Connect ESP32-C3 and YP-05, then connect YP-05 to computer using USB.

Then (if your chip alive yet) hold BOOT, click RESET and stop to hold BOOT.

Then check your chip connection using:
ls /dev/ttyACM*

## Compiling

To make bin: esptool.py --chip esp32c3 elf2image.kernel.elf

To flash code: while true; do esptool.py --chip esp32c3 -p /dev/ttyACM0 --baud 115200 --before no_reset --no-stub erase_flash; sleep 0.2; done

Then: BOOT->RESET->BOOT while do not see "Erasing flash"

Then: while true; do esptool.py --chip esp32c3 -p /dev/ttyACM0 --baud 115200 --before no_reset --after no_reset write_flash 0x0 kernel.bin; sleep 0.2; done

Then: BOOT->RESET->BOOT

To run code: python3 -m serial.tools.miniterm /dev/ttyACM0 115200

Then: RESET

Include compiler to PATH: export PATH=$PATH:/home/glammy/src/riscv-none-elf-gcc/bin

Compile: elf-riscv-none-elf-gcc -nostdlib -T link.ld boot.S main.c -o kernel.elf

Give access to port: sudo chmod 666 /dev/ttyUSB0

Check the chip: esptool.py --port /dev/ttyUSB0 --baud 115200 chip-id

Flashing bare-metal: esptool.py --port /dev/ttyUSB0 --baud 460800 write_flash 0x0 kernel.bin

Close midterm: Ctrl + ']'

Assembling: elf-riscv-none-elf-gcc -T link.ld -nostdlib-ffreestanding -Wl, -gc-sections -o kernel.elf boot.s main.c

