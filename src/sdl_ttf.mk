# SDL_ttf

PKG             := sdl_ttf
$(PKG)_VERSION  := 2.0.9
$(PKG)_CHECKSUM := 6bc3618b08ddbbf565fe8f63f624782c15e1cef2
$(PKG)_SUBDIR   := SDL_ttf-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL_ttf-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://libsdl.org/projects/SDL_ttf/
$(PKG)_URL      := http://libsdl.org/projects/SDL_ttf/release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc sdl freetype

define $(PKG)_UPDATE
    wget -q -O- 'http://libsdl.org/projects/SDL_ttf/' | \
    $(SED) -n 's,.*SDL_ttf-\([0-9][^>]*\)\.tar.*,\1,p' | \
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
