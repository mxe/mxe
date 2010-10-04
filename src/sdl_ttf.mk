# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# SDL_ttf
PKG             := sdl_ttf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.10
$(PKG)_CHECKSUM := 98f6518ec71d94b8ad303a197445e0991850b887
$(PKG)_SUBDIR   := SDL_ttf-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL_ttf-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.libsdl.org/projects/SDL_ttf/
$(PKG)_URL      := http://www.libsdl.org/projects/SDL_ttf/release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc sdl freetype

define $(PKG)_UPDATE
    wget -q -O- 'http://hg.libsdl.org/SDL_ttf/tags' | \
    $(SED) -n 's,.*release-\([0-9][^<]*\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)' \
        --disable-sdltest \
        --with-freetype-prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
