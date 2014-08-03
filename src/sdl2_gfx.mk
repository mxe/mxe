# This file is part of MXE.
# See index.html for further information.

PKG             := sdl2_gfx
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.1
$(PKG)_CHECKSUM := b908d1a77d28ae708d4a305db8560820b45d380a
$(PKG)_SUBDIR   := SDL2_gfx-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL2_gfx-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.ferzkopp.net/Software/SDL2_gfx/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc sdl2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.ferzkopp.net/joomla/content/view/19/14/' | \
    grep 'href.*tar\.' | \
    $(SED) -n 's,.*SDL2_gfx-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/sdl2_gfx-test.exe' \
        `'$(TARGET)-pkg-config' SDL2_gfx --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
