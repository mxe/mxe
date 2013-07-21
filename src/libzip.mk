# This file is part of MXE.
# See index.html for further information.

PKG             := libzip
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.11.1
$(PKG)_CHECKSUM := 3c82cdc0de51f06d5e1c60f098d3d9cc0d48f8a7
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://www.nih.at/libzip/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.nih.at/libzip/' | \
    $(SED) -n 's,.*libzip-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-libzip.exe' \
        `'$(TARGET)-pkg-config' libzip --cflags --libs`
endef
