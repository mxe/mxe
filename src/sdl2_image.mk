# This file is part of MXE.
# See index.html for further information.

PKG             := sdl2_image
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.0
$(PKG)_CHECKSUM := a24b1dd95e1274ffc84f5f1b95d9cb6e6f13f6e8
$(PKG)_SUBDIR   := SDL2_image-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL2_image-$($(PKG)_VERSION).tar.gz
#$(PKG)_URL      := http://www.libsdl.org/projects/SDL_image/release/$($(PKG)_FILE)
$(PKG)_URL      := http://www.libsdl.org/tmp/SDL_image/release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc sdl2 jpeg libpng tiff

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://hg.libsdl.org/SDL_image/tags' | \
    $(SED) -n 's,.*release-\([0-9][^<]*\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,^\(Requires:.*\),\1 libtiff-4 libpng,' '$(1)/SDL2_image.pc.in'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)' \
        --disable-sdltest \
        --disable-jpg-shared \
        --disable-webp-shared \
        --disable-png-shared \
        --disable-tif-shared \
        LIBS='-lz'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef

$(PKG)_BUILD_i686-pc-mingw32 =
