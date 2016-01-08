# This file is part of MXE.
# See index.html for further information.

PKG             := sdl_net
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.8
$(PKG)_CHECKSUM := 5f4a7a8bb884f793c278ac3f3713be41980c5eedccecff0260411347714facb4
$(PKG)_SUBDIR   := SDL_net-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL_net-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.libsdl.org/projects/SDL_net/release/$($(PKG)_FILE)
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
        --disable-gui \
        WINDRES='$(TARGET)-windres'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-sdl_net.exe' \
        `'$(TARGET)-pkg-config' SDL_net --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
