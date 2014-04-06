# This file is part of MXE.
# See index.html for further information.

PKG             := sdl_gfx
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.25
$(PKG)_CHECKSUM := 20a89d0b71b7b790b830c70f17ed2c44100bc0f4
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

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-sdl_gfx.exe' \
        `'$(TARGET)-pkg-config' SDL_gfx --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
