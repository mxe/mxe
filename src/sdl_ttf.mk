# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sdl_ttf
$(PKG)_WEBSITE  := https://www.libsdl.org/projects/SDL_ttf/
$(PKG)_DESCR    := SDL_ttf
$(PKG)_IGNORE   := 2%
$(PKG)_VERSION  := 2.0.11
$(PKG)_CHECKSUM := 724cd895ecf4da319a3ef164892b72078bd92632a5d812111261cde248ebcdb7
$(PKG)_SUBDIR   := SDL_ttf-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL_ttf-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.libsdl.org/projects/SDL_ttf/release/$($(PKG)_FILE)
$(PKG)_DEPS     := cc freetype sdl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://hg.libsdl.org/SDL_ttf/tags' | \
    $(SED) -n 's,.*release-\([0-9][^<]*\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    echo 'Requires.private: freetype2' >> '$(SOURCE_DIR)/SDL_ttf.pc.in'
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)' \
        --disable-sdltest \
        --with-freetype-prefix='$(PREFIX)/$(TARGET)' \
        WINDRES='$(TARGET)-windres'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_PROGRAMS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_PROGRAMS)
endef
