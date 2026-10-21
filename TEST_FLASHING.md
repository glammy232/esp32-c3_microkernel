# Инструкция по сборке и прошивке bare-metal микроядра на ESP32-C3 SuperMini

## 1. Окружение и оборудование
* **Плата:** ESP32-C3 SuperMini
* **Программатор:** YP-05 (на чипе FTDI/CP2102, создает устройство `/dev/ttyUSB0`)
* **ОС:** Ubuntu 26.04
* **Инструменты:** esptool.py, riscv-none-elf-gcc, miniterm

---

## 2. Подготовка и сборка кода

### Шаг 2.1: Экспорт путей компилятора
Добавьте тулчейн RISC-V в переменную окружения PATH:
```bash
export PATH=$PATH:/home/glammy/src/riscv-none-elf-gcc/bin
```

### Шаг 2.2: Компиляция и линковка
Сборка объектного файла ELF с оптимизацией и очисткой неиспользуемых секций:
```bash
riscv-none-elf-gcc -T linker.ld -nostdlib -ffreestanding -Wl,--gc-sections -o kernel.elf entry.S entry.c
```

### Шаг 2.3: Создание бинарного образа для ESP32-C3
Конвертация ELF-файла в прошиваемый формат `.bin`:
```bash
esptool.py --chip esp32c3 elf2image kernel.elf
```
*(На выходе будет сгенерирован файл `kernel.bin`)*

---

## 3. Подключение и работа с портами

### Шаг 3.1: Настройка прав доступа к порту
Выдайте права на чтение/запись для порта вашего программатора (обычно определяется как `/dev/ttyUSB0` при использовании внешнего YP-05):
```bash
sudo chmod 666 /dev/ttyUSB0
```
*(Если подключаетесь через встроенный USB платы SuperMini, проверяйте порты через `ls /dev/ttyACM*` и давайте права на соответствующий ACM-порт).*

### Шаг 3.2: Перевод ESP32-C3 в режим загрузчика (Bootloader)
1. Зажмите и удерживайте кнопку **BOOT**.
2. Кратковременно нажмите кнопку **RESET**.
3. Отпустите кнопку **BOOT**.

### Шаг 3.3: Проверка связи с чипом
Проверьте, видит ли утилита микроконтроллер:
```bash
esptool.py --port /dev/ttyUSB0 --baud 115200 chip_id
```

---

## 4. Очистка и прошивка

Если чип зависает или стандартная прошивка прерывается, используйте циклы `while` для «подлавливания» момента сброса.

### Вариант А: Стандартная прошивка (рекомендуемый)
Очистка Flash-памяти:
```bash
esptool.py --port /dev/ttyUSB0 --baud 115200 erase_flash
```
Запись микроядра по адресу `0x0`:
```bash
esptool.py --port /dev/ttyUSB0 --baud 460800 write_flash 0x0 kernel.bin
```

### Вариант Б: Агрессивная прошивка в цикле (если чип нестабилен)
Запустите бесконечный цикл очистки:
```bash
while true; do esptool.py --chip esp32c3 -p /dev/ttyUSB0 --baud 115200 --before no_reset --no-stub erase_flash; sleep 0.2; done
```
*Во время работы цикла введите чип в Boot-режим (**BOOT -> RESET -> отпустить BOOT**), пока в терминале не пойдет лог "Erasing flash". После этого остановите цикл (Ctrl+C).*

Запустите бесконечный цикл записи:
```bash
while true; do esptool.py --chip esp32c3 -p /dev/ttyUSB0 --baud 115200 --before no_reset --after no_reset write_flash 0x0 kernel.bin; sleep 0.2; done
```
*Повторите процедуру ввода в Boot-режим для старта прошивки. По окончании прервите цикл (Ctrl+C).*

---

## 5. Запуск и мониторинг

### Шаг 5.1: Запуск монитора порта
Подключитесь к UART для чтения логов вашего микроядра:
```bash
python3 -m serial.tools.miniterm /dev/ttyUSB0 115200
```

### Шаг 5.2: Старт ядра
Нажмите кнопку **RESET** на плате ESP32-C3 SuperMini, чтобы выйти из режима загрузчика и запустить ваше bare-metal приложение.

### Выход из монитора
Чтобы закрыть `miniterm`, нажмите комбинацию клавиш:
```text
Ctrl + ]
```

HELP:
21 - yellow
20 - blue

gnd - black
near gnd - green
