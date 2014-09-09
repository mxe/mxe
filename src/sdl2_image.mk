# This file is part of MXE.
# See index.html for further information.

PKG             := sdl2_image
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.0
$(PKG)_CHECKSUM := 20b1b0db9dd540d6d5e40c7da8a39c6a81248865
$(PKG)_SUBDIR   := SDL2_image-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL2_image-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.libsdl.org/projects/SDL_image/release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc sdl2 jpeg libpng libwebp tiff

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://hg.libsdl.org/SDL_image/tags' | \
    $(SED) -n 's,.*release-\([0-9][^<]*\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,^\(Requires:.*\),\1\nRequires.private: libtiff-4 libpng libwebp,' '$(1)/SDL2_image.pc.in'
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)' \
        --disable-sdltest \
        --disable-jpg-shared \
        --disable-webp-shared \
        --disable-png-shared \
        --disable-tif-shared
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef

# Disable until sdl2 can be built on MinGW32
$(PKG)_BUILD_i686-pc-mingw32 =
