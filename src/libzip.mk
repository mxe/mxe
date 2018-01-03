# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libzip
$(PKG)_WEBSITE  := https://www.nih.at/libzip/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.3
$(PKG)_CHECKSUM := 729a295a59a9fd6e5b9fe9fd291d36ae391a9d2be0b0824510a214cfaa05ceee
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://www.nih.at/libzip/$($(PKG)_FILE)
$(PKG)_DEPS     := cc zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.nih.at/libzip/' | \
    $(SED) -n 's,.*libzip-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(MXE_DISABLE_CRUFT) SUBDIRS=lib

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-libzip.exe' \
        `'$(TARGET)-pkg-config' libzip --cflags --libs`
endef
