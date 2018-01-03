# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := rucksack
$(PKG)_WEBSITE  := https://github.com/andrewrk/rucksack
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1.0
$(PKG)_CHECKSUM := dcdaab57b06fdeb9be63ed0f2c2de78d0b1e79f7a896bb1e76561216a4458e3b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/andrewrk/rucksack/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc freeimage liblaxjson

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/andrewrk/rucksack/releases' | \
    $(SED) -n 's,.*/archive/\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && '$(TARGET)-cmake' ..

    $(MAKE) -C '$(1)/build' -j '$(JOBS)' \
        rucksack_static \
        rucksackspritesheet_static \
        VERBOSE=1

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include/rucksack'
    $(INSTALL) -m644 '$(1)/src/rucksack.h'    '$(PREFIX)/$(TARGET)/include/rucksack'
    $(INSTALL) -m644 '$(1)/src/spritesheet.h' '$(PREFIX)/$(TARGET)/include/rucksack'
    $(INSTALL) -m644 '$(1)/build/lib'*.a      '$(PREFIX)/$(TARGET)/lib/'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic -std=c99 \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-rucksack.exe' \
        -lrucksack -llaxjson \
        `'$(TARGET)-pkg-config' freeimage --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
