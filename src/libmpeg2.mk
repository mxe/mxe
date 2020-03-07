# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libmpeg2
$(PKG)_WEBSITE  := https://libmpeg2.sourceforge.io/
$(PKG)_DESCR    := libmpeg2 - a free MPEG-2 video stream decoder
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.5.1
$(PKG)_CHECKSUM := dee22e893cb5fc2b2b6ebd60b88478ab8556cb3b93f9a0d7ce8f3b61851871d4
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://libmpeg2.sourceforge.io/files/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://libmpeg2.sourceforge.io/downloads.html' | \
    $(SED) -n 's,.*files/libmpeg2-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' 'CFLAGS=-std=gnu89' \
        $(MXE_CONFIGURE_OPTS) \
        --disable-sdl
        PKG_CONFIG='$(TARGET)-pkg-config'

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' install $(MXE_DISABLE_PRGRAMS)

    # compile test (sample1.c included with libmpeg2)
    '$(TARGET)-gcc' \
        -W -Wall -ansi -pedantic \
        '$(SOURCE_DIR)/doc/sample1.c' -o '$(PREFIX)/$(TARGET)/bin/test-libmpeg2.exe' \
        `'$(TARGET)-pkg-config' --cflags --libs libmpeg2`
endef
