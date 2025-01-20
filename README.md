# Mycropython Template for PIAZOTE dev boards

## Flashing Micropython to PIAZOTE board
### Using MAKE
1. Update `PORT` and `BOARD` in the Makefile in the root directory, and run the following command.
><i>Note that for boards such as ESP32-S2, ESP32-S3 and ESP32-C3, the board needs to be in 'boot mode'.
>It can be done by simply pressing and holding `BOOT` button, then connect the USB</i>.
```
make flash_upy
```

## Accesing the REPL
1. With `mpremote` installed, run
```
make repl
```

## Erasing FLASH
1. First update `PORT` in the Makefile in the root directory, then run
```
make erase
```


# Contributing
## Pre-requisites
### ESP-IDF
First [install esp-idf](https://docs.espressif.com/projects/esp-idf/en/v5.3.2/esp32/get-started/index.html), currently using version v5.3.2.

### Pre-commmit
This repo also uses `pre-commit` for linting. To install it, run:
```
pip install pre-commit
```

## Initialise Micopython submodule
1. Run
```
git submodule update --init --recursive
```

## Linting
1. When copying this repository run
```
pre-commit install
```
2. For linting run
```
pre-commit run --all-fiels
```
