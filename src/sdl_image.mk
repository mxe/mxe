# This file is part of MXE.
# See index.html for further information.

PKG             := sdl_image
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.12
$(PKG)_CHECKSUM := 0b90722984561004de84847744d566809dbb9daf732a9e503b91a1b5a84e5699
$(PKG)_SUBDIR   := SDL_image-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL_image-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.libsdl.org/projects/SDL_image/release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc jpeg libpng libwebp sdl tiff

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://hg.libsdl.org/SDL_image/tags' | \
    $(SED) -n 's,.*release-\([0-9][^<]*\).*,\1,p' | \
    grep '^1\.' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,^\(Requires:.*\),\1 libtiff-4 libpng libwebp,' '$(1)/SDL_image.pc.in'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)' \
        --disable-sdltest \
        --disable-jpg-shared \
        --disable-png-shared \
        --disable-tif-shared \
        --disable-webp-shared \
        WINDRES='$(TARGET)-windres' \
        LIBS='-lz'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-sdl_image.exe' \
        `'$(TARGET)-pkg-config' SDL_image --cflags --libs`

    mkdir -p '$(1)/cmake-build-test'
    cp '$(2)-CMakeLists.txt' '$(1)/cmake-build-test/CMakeLists.txt'
    cp '$(2).c' '$(1)/cmake-build-test/'
    cd '$(1)/cmake-build-test' && cmake . \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)'
    $(MAKE) -C '$(1)/cmake-build-test' -j '$(JOBS)'
endef

$(PKG)_BUILD_SHARED =
