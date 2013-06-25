# This file is part of MXE.
# See index.html for further information.

PKG             := sdl2_ttf
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := b4067c5bff930ffecdf3f90b45a383621bab4d30
$(PKG)_SUBDIR   := SDL2_ttf-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL2_ttf-$($(PKG)_VERSION).tar.gz
#$(PKG)_URL      := http://www.libsdl.org/projects/SDL_ttf/release/$($(PKG)_FILE)
$(PKG)_URL      := http://www.libsdl.org/tmp/SDL_ttf/release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc sdl2 freetype

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://hg.libsdl.org/SDL_ttf/tags' | \
    $(SED) -n 's,.*release-\([0-9][^<]*\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    echo 'Requires.private: freetype2' >> '$(1)/SDL2_ttf.pc.in'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)' \
        --disable-sdltest \
        --with-freetype-prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
