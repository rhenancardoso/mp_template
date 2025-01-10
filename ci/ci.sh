#!/bin/bash

########################################################################################
# commit formatting

function ci_commit_formatting_run {
    # If the common ancestor commit hasn't been found, fetch more.
    pip install pre-commit
    pre-commit run --all-files
}


########################################################################################
# ports/esp32

# GitHub tag of ESP-IDF to use for CI (note: must be a tag or a branch)
IDF_VER=v5.2.2
MICROPYTHON_PATH=src/micropython
export IDF_CCACHE_ENABLE=1

function ci_esp32_idf_setup {
    pip3 install pyelftools
    git clone --depth 1 --branch $IDF_VER https://github.com/espressif/esp-idf.git
    # doing a treeless clone isn't quite as good as --shallow-submodules, but it
    # is smaller than full clones and works when the submodule commit isn't a head.
    git -C esp-idf submodule update --init --recursive --filter=tree:0
    ./esp-idf/install.sh
}

# Build Micropython for ESP32
function ci_esp32_build_common {
    source esp-idf/export.sh
    make ${MAKEOPTS} -C $MICROPYTHON_PATH/mpy-cross
    make ${MAKEOPTS} -C $MICROPYTHON_PATH/ports/esp32 submodules
}

# Piazote boards
function ci_piazote_builds {
    source esp-idf/export.sh
    make ${MAKEOPTS} -C $MICROPYTHON_PATH/ports/esp32 BOARD=PIAZOTE_PICO
    make ${MAKEOPTS} -C $MICROPYTHON_PATH/ports/esp32 BOARD=PIAZOTE_S3
    make ${MAKEOPTS} -C $MICROPYTHON_PATH/ports/esp32 BOARD=PIAZOTE_C3
}
