# This file is part of MXE.
# See index.html for further information.

PKG             := sdl2_net
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.0
$(PKG)_CHECKSUM := 31c93fcbb67de83ec7f15cceec44db566286d4b1
$(PKG)_SUBDIR   := SDL2_net-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL2_net-$($(PKG)_VERSION).tar.gz
#$(PKG)_URL      := http://www.libsdl.org/projects/SDL_net/release/$($(PKG)_FILE)
$(PKG)_URL      := http://www.libsdl.org/tmp/SDL_net/release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc sdl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.libsdl.org/projects/SDL_net/release/?C=M;O=D' | \
    $(SED) -n 's,.*SDL_net-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)' \
        --disable-sdltest \
        --disable-gui
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -std=c99 -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-sdl2_net.exe' \
        `'$(TARGET)-pkg-config' SDL2_net --cflags --libs` \
        -lws2_32 -liphlpapi
endef

$(PKG)_BUILD_i686-pc-mingw32 =
