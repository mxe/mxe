# SDL_image

PKG            := sdl_image
$(PKG)_VERSION := 1.2.7
$(PKG)_SUBDIR  := SDL_image-$($(PKG)_VERSION)
$(PKG)_FILE    := SDL_image-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE := http://libsdl.org/projects/SDL_image/
$(PKG)_URL     := http://libsdl.org/projects/SDL_image/release/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc sdl jpeg libpng tiff

define $(PKG)_UPDATE
    wget -q -O- 'http://libsdl.org/projects/SDL_image/' | \
    $(SED) -n 's,.*SDL_image-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)' \
        --disable-sdltest \
        --disable-jpg-shared \
        --disable-png-shared \
        --disable-tif-shared \
	LIBS='-lz'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
