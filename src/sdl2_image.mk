# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sdl2_image
$(PKG)_WEBSITE  := https://www.libsdl.org/
$(PKG)_DESCR    := SDL2_image
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.1
$(PKG)_CHECKSUM := 3a3eafbceea5125c04be585373bfd8b3a18f259bd7eae3efc4e6d8e60e0d7f64
$(PKG)_SUBDIR   := SDL2_image-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL2_image-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.libsdl.org/projects/SDL_image/release/$($(PKG)_FILE)
$(PKG)_DEPS     := cc jpeg libpng libwebp sdl2 tiff

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://hg.libsdl.org/SDL_image/tags' | \
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
