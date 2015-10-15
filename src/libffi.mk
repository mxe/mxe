# This file is part of MXE.
# See index.html for further information.

PKG             := libffi
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2.1
$(PKG)_CHECKSUM := d06ebb8e1d9a22d19e38d63fdb83954253f39bedc5d46232a05645685722ca37
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.mirrorservice.org/sites/sourceware.org/pub/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://sourceware.org/pub/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/atgreen/libffi/tags' | \
    grep '<a href="/atgreen/libffi/archive/' | \
    $(SED) -n 's,.*href="/atgreen/libffi/archive/v\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)/$(TARGET)' -j '$(JOBS)'
    $(MAKE) -C '$(1)/$(TARGET)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -std=c99 -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-libffi.exe' \
        `'$(TARGET)-pkg-config' libffi --cflags --libs`
endef
