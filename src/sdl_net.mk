# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sdl_net
$(PKG)_WEBSITE  := https://www.libsdl.org/projects/SDL_net/
$(PKG)_DESCR    := SDL_net
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.8
$(PKG)_CHECKSUM := 5f4a7a8bb884f793c278ac3f3713be41980c5eedccecff0260411347714facb4
$(PKG)_SUBDIR   := SDL_net-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL_net-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.libsdl.org/projects/SDL_net/release/$($(PKG)_FILE)
$(PKG)_DEPS     := cc sdl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.libsdl.org/projects/SDL_net/release/?C=M;O=D' | \
    $(SED) -n 's,.*SDL_net-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)' \
        --disable-sdltest \
        --disable-gui \
        WINDRES='$(TARGET)-windres'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_PROGRAMS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_PROGRAMS)

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-sdl_net.exe' \
        `'$(TARGET)-pkg-config' SDL_net --cflags --libs`
endef
