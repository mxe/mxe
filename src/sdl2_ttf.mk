# This file is part of MXE.
# See index.html for further information.

PKG             := sdl2_ttf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.12
$(PKG)_CHECKSUM := 461928a2b3372e03ee7f4cf3be65c226f8ecabc6
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

$(PKG)_BUILD_i686-pc-mingw32 =
