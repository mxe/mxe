# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sdl2_net
$(PKG)_WEBSITE  := https://www.libsdl.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.1
$(PKG)_CHECKSUM := 1fefe563ea333a2655c32169d03a376a334cdbe39da51fd424bf5f430dec83f4
$(PKG)_GH_CONF  := libsdl-org/SDL_net/releases/tag,release-,,
$(PKG)_DEPS     := cc sdl2

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)' \
        --disable-sdltest \
        --disable-gui
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -std=c99 -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-sdl2_net.exe' \
        `'$(TARGET)-pkg-config' SDL2_net --cflags --libs`
endef

