# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sdl_sound
$(PKG)_WEBSITE  := https://icculus.org/SDL_sound/
$(PKG)_DESCR    := SDL_sound
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.3
$(PKG)_CHECKSUM := 3999fd0bbb485289a52be14b2f68b571cb84e380cc43387eadf778f64c79e6df
$(PKG)_SUBDIR   := SDL_sound-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL_sound-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://icculus.org/SDL_sound/downloads/$($(PKG)_FILE)
$(PKG)_DEPS     := cc flac libmikmod ogg sdl speex vorbis

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://hg.icculus.org/icculus/SDL_sound/tags' | \
    $(SED) -n 's,.*release-\([0-9][^<]*\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)' \
        --disable-sdltest \
        --enable-voc \
        --enable-wav \
        --enable-raw \
        --enable-aiff \
        --enable-au \
        --enable-shn \
        --enable-midi \
        --disable-smpeg \
        --enable-mpglib \
        --$(if $(BUILD_STATIC),en,dis)able-mikmod \
        --disable-modplug \
        --enable-ogg \
        --enable-flac \
        --enable-speex \
        --disable-physfs \
        --disable-altcvt \
        CFLAGS='-g -O2 -fno-inline' \
        LIBS="`'$(TARGET)-pkg-config' vorbisfile flac speex --libs` `'$(PREFIX)/$(TARGET)/bin/libmikmod-config' --libs`"
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_PROGRAMS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_PROGRAMS)

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: $(PKG)'; \
     echo 'Requires: sdl vorbisfile flac speex ogg vorbis'; \
     echo 'Libs: -lSDL_sound'; \
     echo "Libs.private: `'$(PREFIX)/$(TARGET)/bin/libmikmod-config' --libs`";) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/SDL_sound.pc'

    $(if $(BUILD_SHARED),\
        rm -f '$(PREFIX)/$(TARGET)/lib/libSDL_sound.a' && \
        $(MAKE_SHARED_FROM_STATIC) '$(BUILD_DIR)/.libs/libSDL_sound.a' \
        `$(TARGET)-pkg-config SDL_sound --libs-only-l | $(SED) 's/-lSDL_sound//'`)

    '$(TARGET)-gcc' \
        -W -Wall -Werror -std=c99 -pedantic \
        '$(PWD)/src/$(PKG)-test.c' -o '$(PREFIX)/$(TARGET)/bin/test-sdl_sound.exe' \
        `'$(TARGET)-pkg-config' SDL_sound --cflags --libs`

    mkdir -p '$(BUILD_DIR).cmake-build-test'
    cp '$(PWD)/src/$(PKG)-test-CMakeLists.txt' '$(BUILD_DIR).cmake-build-test/CMakeLists.txt'
    cp '$(PWD)/src/$(PKG)-test.c' '$(BUILD_DIR).cmake-build-test/'
    cd '$(BUILD_DIR).cmake-build-test' && '$(TARGET)-cmake' .
    $(MAKE) -C '$(BUILD_DIR).cmake-build-test' -j '$(JOBS)'
endef
