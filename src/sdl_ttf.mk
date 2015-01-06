# This file is part of MXE.
# See index.html for further information.

PKG             := sdl_ttf
$(PKG)_IGNORE   := 2%
$(PKG)_VERSION  := 2.0.11
$(PKG)_CHECKSUM := 0ccf7c70e26b7801d83f4847766e09f09db15cc6
$(PKG)_SUBDIR   := SDL_ttf-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL_ttf-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.libsdl.org/projects/SDL_ttf/release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc sdl freetype

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://hg.libsdl.org/SDL_ttf/tags' | \
    $(SED) -n 's,.*release-\([0-9][^<]*\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    echo 'Requires.private: freetype2' >> '$(1)/SDL_ttf.pc.in'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)' \
        --disable-sdltest \
        --with-freetype-prefix='$(PREFIX)/$(TARGET)' \
        WINDRES='$(TARGET)-windres'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef

$(PKG)_BUILD_SHARED =
