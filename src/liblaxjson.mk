# This file is part of MXE.
# See index.html for further information.

PKG             := liblaxjson
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.3
$(PKG)_CHECKSUM := 9d47f2d23cf4a8992e8ef015136c1ff5c540afaa912ed75ee830dea17736c5f2
$(PKG)_SUBDIR   := liblaxjson-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/andrewrk/liblaxjson/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/andrewrk/liblaxjson/releases' | \
    $(SED) -n 's,.*/archive/\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)'

    $(MAKE) -C '$(1)/build' -j '$(JOBS)'

    $(INSTALL) -m644 '$(1)/include/laxjson.h' '$(PREFIX)/$(TARGET)/include'
    $(if $(BUILD_STATIC),\
         $(INSTALL) -m644 '$(1)/build/liblaxjson.a' '$(PREFIX)/$(TARGET)/lib'\
    $(else),\
         $(INSTALL) -m755 '$(1)/build/liblaxjson.dll'   '$(PREFIX)/$(TARGET)/bin';\
         $(INSTALL) -m755 '$(1)/build/liblaxjson.dll.a' '$(PREFIX)/$(TARGET)/lib')

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic -std=c99 \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-liblaxjson.exe' \
        -llaxjson
endef
