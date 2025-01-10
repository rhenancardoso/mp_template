PROJECT_NAME := MP_PIAZOTE

PORT_BOOT = /dev/cu.usbmodem101
PORT = /dev/cu.usbmodem_piazoteS3_1
BOARD = PIAZOTE_S3
MICROPYTHON_PATH = src/micropython
ESP32_PATH = $(MICROPYTHON_PATH)/ports/esp32
MPY_CROSS_PATH = $(MICROPYTHON_PATH)/mpy-cross
COPY_FILES = src/application/main.py src/application/boot.py src/aplication/config.json

.PHONY:
all: clean build_upy

.PHONY:
clean:
	echo "Clean Micropython builds for $(BOARD)"
	make BOARD=$(BOARD) -C $(MP_MICROPYTHON_PATH) clean

.PHONY:
erase:
	echo "Erasing the $(BOARD) flash completely"
	esptool.py --port $(PORT_BOOT) --after no_reset erase_flash
	echo "Reset via hardware is required ..."

.PHONY:
build_upy:
	echo "Building Micropython for $(BOARD)"
	make -C $(MPY_CROSS_PATH)
	make submodules -C $(ESP32_PATH)
	make BOARD=$(BOARD) -C $(ESP32_PATH)

.PHONY:
flash_upy: build_upy
	echo "Flashing Micropython to connected $(BOARD)"
	make deploy BOARD=$(BOARD) PORT=$(PORT_BOOT) -C $(ESP32_PATH)

.PHONY:
repl:
	echo "Connect REPL"
	mpremote connect $(PORT) repl

.PHONY:
copy_files:
	echo "Copying files to PiazoteS3"
	mpremote connect $(PORT) cp $(COPY_FILES) : + repl
