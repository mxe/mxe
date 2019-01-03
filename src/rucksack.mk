# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := rucksack
$(PKG)_WEBSITE  := https://github.com/andrewrk/rucksack
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1.0
$(PKG)_CHECKSUM := dcdaab57b06fdeb9be63ed0f2c2de78d0b1e79f7a896bb1e76561216a4458e3b
$(PKG)_GH_CONF  := andrewrk/rucksack/tags
$(PKG)_DEPS     := cc freeimage liblaxjson

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)'

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' \
        rucksack_$(if $(BUILD_STATIC),static,shared) \
        rucksackspritesheet_$(if $(BUILD_STATIC),static,shared) \
        VERBOSE=1

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include/rucksack'
    $(INSTALL) -m644 '$(SOURCE_DIR)/src/rucksack.h'    '$(PREFIX)/$(TARGET)/include/rucksack'
    $(INSTALL) -m644 '$(SOURCE_DIR)/src/spritesheet.h' '$(PREFIX)/$(TARGET)/include/rucksack'
    $(INSTALL) -m644 -v '$(BUILD_DIR)/lib'*.a   '$(PREFIX)/$(TARGET)/lib/'
    $(if $(BUILD_SHARED),\
    $(INSTALL) -m755 -v '$(BUILD_DIR)/lib'*.dll '$(PREFIX)/$(TARGET)/bin/')

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic -std=c99 \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-rucksack.exe' \
        -lrucksack -llaxjson \
        `'$(TARGET)-pkg-config' freeimage --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
