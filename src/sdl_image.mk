# This file is part of MXE.
# See index.html for further information.

PKG             := sdl_image
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.12
$(PKG)_CHECKSUM := 5e3e393d4e366638048bbb10d6a269ea3f4e4cf2
$(PKG)_SUBDIR   := SDL_image-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL_image-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.libsdl.org/projects/SDL_image/release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc sdl jpeg libpng tiff

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://hg.libsdl.org/SDL_image/tags' | \
    $(SED) -n 's,.*release-\([0-9][^<]*\).*,\1,p' | \
    grep '^1\.' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,^\(Requires:.*\),\1 libtiff-4 libpng,' '$(1)/SDL_image.pc.in'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)' \
        --disable-sdltest \
        --disable-jpg-shared \
        --disable-png-shared \
        --disable-tif-shared \
        WINDRES='$(TARGET)-windres' \
        LIBS='-lz'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-sdl_image.exe' \
        `'$(TARGET)-pkg-config' SDL_image --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
