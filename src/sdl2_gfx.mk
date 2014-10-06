# This file is part of MXE.
# See index.html for further information.

PKG             := sdl2_gfx
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.1
$(PKG)_CHECKSUM := a136873b71a8c00c0233db26e0c1dad9629b4209
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
        $(MXE_CONFIGURE_OPTS) \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)' \
        SDL_LIBS="`$(TARGET)-pkg-config --libs sdl2 | $(SED) -e 's/-lmingw32//' -e 's/-lSDL2main//'`" \
        SDL_CFLAGS="`$(TARGET)-pkg-config --cflags sdl2 | $(SED) 's/-Dmain=SDL_main//'`"
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-sdl2_gfx.exe' \
        `'$(TARGET)-pkg-config' SDL2_gfx --cflags --libs`
endef

# sdl2 is disabled on i686-pc-mingw32.
$(PKG)_BUILD_i686-pc-mingw32 =
