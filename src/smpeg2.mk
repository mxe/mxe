# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := smpeg2
$(PKG)_WEBSITE  := https://icculus.org/smpeg/
$(PKG)_DESCR    := smpeg
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.0
$(PKG)_CHECKSUM := 979a65b211744a44fa641a9b6e4d64e64a12ff703ae776bafe3c4c4cd85494b3
$(PKG)_SUBDIR   := smpeg2-$($(PKG)_VERSION)
$(PKG)_FILE     := smpeg2-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.libsdl.org/projects/smpeg/release/$($(PKG)_FILE)
$(PKG)_DEPS     := cc sdl2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.libsdl.org/projects/smpeg/release' | \
    $(SED) -n 's,.*smpeg2-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,\(-lsmpeg2\),\1 -lstdc++,' '$(1)/smpeg2-config.in'
    cd '$(1)' && ./configure \
        AR='$(TARGET)-ar' \
        NM='$(TARGET)-nm' \
        $(MXE_CONFIGURE_OPTS) \
        --disable-debug \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)' \
        --disable-sdltest \
        --disable-gtk-player \
        --disable-opengl-player \
        CFLAGS='-ffriend-injection -Wno-narrowing'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(MXE_DISABLE_CRUFT)

    '$(TARGET)-gcc' \
        -W -Wall -Werror -std=c99 -pedantic \
        '$(TOP_DIR)/src/smpeg-test.c' -o '$(PREFIX)/$(TARGET)/bin/test-smpeg2.exe' \
        `'$(PREFIX)/$(TARGET)/bin/smpeg2-config' --cflags --libs`
endef

