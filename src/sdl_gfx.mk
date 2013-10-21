# This file is part of MXE.
# See index.html for further information.

PKG             := sdl_gfx
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.24
$(PKG)_CHECKSUM := 34e8963188e4845557468a496066a8fa60d5f563
$(PKG)_SUBDIR   := SDL_gfx-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL_gfx-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.ferzkopp.net/Software/SDL_gfx-2.0/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc sdl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.ferzkopp.net/joomla/content/view/19/14/' | \
    grep 'href.*tar\.' | \
    $(SED) -n 's,.*SDL_gfx-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

# --disable-mmx: the GCC ASM never worked properly (segfaults), and
#   doesn't compile on 64bit.  This is fixed for the future SDL2_gfx:
#   http://sourceforge.net/p/sdl2gfx/code/HEAD/tree/trunk/SDL2_imageFilter.c
#   No plans for SDL(1)_gfx, but see https://gitorious.org/sdlgfx/asm/
define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-mmx \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-sdl_gfx.exe' \
        `'$(TARGET)-pkg-config' SDL_gfx --cflags --libs`
endef
