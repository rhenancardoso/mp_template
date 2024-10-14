PROJECT_NAME := MP_PIAZOTE

PORT_BOOT = /dev/cu.usbmodem101
PORT = /dev/cu.usbmodem_piazoteS3_1
ESP32_BOARD = PIAZOTE_S3
MP_MICROPYTHON_PATH = firmware/micropython/ports/esp32
MPY_CROSS_PATH = firmware/micropython/mpy-cross
COPY_FILES = main.py boot.py config.json

all: clean build_upy
.PHONY:

clean:
	echo "Clean Micropython builds for $(ESP32_BOARD)"
	make BOARD=$(ESP32_BOARD) -C $(MP_MICROPYTHON_PATH) clean

erase:
	echo "Erasing the $(ESP32_BOARD) flash completely"
	esptool.py --port $(PORT_BOOT) --after no_reset erase_flash
	echo "Reset via hardware is required ..."

build_upy:
	echo "Building Micropython for $(ESP32_BOARD)"
	make -C $(MPY_CROSS_PATH)
	make submodules -C $(MP_MICROPYTHON_PATH)
	make BOARD=$(ESP32_BOARD) -C $(MP_MICROPYTHON_PATH)

flash_upy: build_upy
	echo "Flashing Micropython to connected $(ESP32_BOARD)"
	make deploy BOARD=$(ESP32_BOARD) PORT=$(PORT_BOOT) -C $(MP_MICROPYTHON_PATH)

repl:
	echo "Connect REPL"
	mpremote connect $(PORT) repl
