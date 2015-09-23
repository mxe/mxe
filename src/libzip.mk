# This file is part of MXE.
# See index.html for further information.

PKG             := libzip
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.11.2
$(PKG)_CHECKSUM := 7cfbbc2c540e154b933b6e9ec781e2671086bd8114eb744ae1a1ade34d2bb6bb
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
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(MXE_DISABLE_CRUFT) SUBDIRS=lib

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-libzip.exe' \
        `'$(TARGET)-pkg-config' libzip --cflags --libs`
endef
