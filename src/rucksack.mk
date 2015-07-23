# This file is part of MXE.
# See index.html for further information.

PKG             := rucksack
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1.0
$(PKG)_CHECKSUM := 77b0d5d1cb4417496835df811eef5ae1a7d14487
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/andrewrk/rucksack/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc freeimage liblaxjson

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/andrewrk/rucksack/releases' | \
    $(SED) -n 's,.*/archive/\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && cmake .. -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)'

    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install VERBOSE=1

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic -std=c99 \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-rucksack.exe' \
        -lrucksack -llaxjson \
        `'$(TARGET)-pkg-config' freeimage --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
