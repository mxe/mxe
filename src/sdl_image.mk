# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sdl_image
$(PKG)_WEBSITE  := https://www.libsdl.org/projects/SDL_image/
$(PKG)_DESCR    := SDL_image
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.12
$(PKG)_CHECKSUM := 0b90722984561004de84847744d566809dbb9daf732a9e503b91a1b5a84e5699
$(PKG)_SUBDIR   := SDL_image-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL_image-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.libsdl.org/projects/SDL_image/release/$($(PKG)_FILE)
$(PKG)_DEPS     := cc jpeg libpng libwebp sdl tiff

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://hg.libsdl.org/SDL_image/tags' | \
    $(SED) -n 's,.*release-\([0-9][^<]*\).*,\1,p' | \
    grep '^1\.' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,^\(Requires:.*\),\1 libtiff-4 libpng libwebp,' '$(SOURCE_DIR)/SDL_image.pc.in'
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)' \
        --disable-sdltest \
        $(if $(BUILD_STATIC), \
            --disable-jpg-shared \
            --disable-png-shared \
            --disable-tif-shared \
            --disable-webp-shared) \
        WINDRES='$(TARGET)-windres' \
        LIBS='-lz'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_PROGRAMS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_PROGRAMS)

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(PWD)/src/$(PKG)-test.c' -o '$(PREFIX)/$(TARGET)/bin/test-sdl_image.exe' \
        `'$(TARGET)-pkg-config' SDL_image --cflags --libs`

    mkdir -p '$(BUILD_DIR).cmake-build-test'
    cp '$(PWD)/src/$(PKG)-test-CMakeLists.txt' '$(BUILD_DIR).cmake-build-test/CMakeLists.txt'
    cp '$(PWD)/src/$(PKG)-test.c' '$(BUILD_DIR).cmake-build-test/'
    cd '$(BUILD_DIR).cmake-build-test' && '$(TARGET)-cmake'
    $(MAKE) -C '$(BUILD_DIR).cmake-build-test' -j '$(JOBS)'
endef
