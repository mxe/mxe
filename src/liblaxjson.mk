# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := liblaxjson
$(PKG)_WEBSITE  := https://github.com/andrewrk/liblaxjson
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.5
$(PKG)_CHECKSUM := ffc495b5837e703b13af3f5a5790365dc3a6794f12f0fa93fb8593b162b0b762
$(PKG)_SUBDIR   := liblaxjson-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/andrewrk/liblaxjson/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/andrewrk/liblaxjson/releases' | \
    $(SED) -n 's,.*/archive/\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && '$(TARGET)-cmake' '$(1)'

    '$(TARGET)-cmake' --build '$(1).build' -- -j '$(JOBS)'

    '$(TARGET)-cmake' \
        -DCMAKE_INSTALL_COMPONENT=$(if $(BUILD_STATIC),static,shared)-lib \
        -P '$(1).build/cmake_install.cmake'
    '$(TARGET)-cmake' \
        -DCMAKE_INSTALL_COMPONENT=header \
        -P '$(1).build/cmake_install.cmake'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic -std=c99 \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-liblaxjson.exe' \
        -llaxjson
endef
