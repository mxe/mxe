# This file is part of MXE.
# See index.html for further information.

PKG             := sdl2_gfx
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.1
$(PKG)_CHECKSUM := d69bcbceb811b4e5712fbad3ede737166327f44b727f1388c32581dbbe8c599a
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
    cd '$(1)' && ./autogen.sh && ./configure \
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
