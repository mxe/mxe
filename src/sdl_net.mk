# This file is part of MXE.
# See index.html for further information.

PKG             := sdl_net
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := fd393059fef8d9925dc20662baa3b25e02b8405d
$(PKG)_SUBDIR   := SDL_net-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL_net-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.libsdl.org/projects/SDL_net/release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc sdl

define $(PKG)_UPDATE
    wget -q -O- 'http://www.libsdl.org/projects/SDL_net/release/?C=M;O=D' | \
    $(SED) -n 's,.*SDL_net-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        $(LINK_STYLE) \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)' \
        --disable-sdltest \
        --disable-gui
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-sdl_net.exe' \
        `'$(TARGET)-pkg-config' SDL_net --cflags --libs`
endef

$(PKG)_BUILD_i686-static-mingw32    = $($(PKG)_BUILD)
$(PKG)_BUILD_x86_64-static-mingw32  = $($(PKG)_BUILD)
$(PKG)_BUILD_i686-dynamic-mingw32   = $($(PKG)_BUILD)
$(PKG)_BUILD_x86_64-dynamic-mingw32 = $($(PKG)_BUILD)
