# This file is part of MXE.
# See index.html for further information.

PKG             := sdl_sound
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.3
$(PKG)_CHECKSUM := 3999fd0bbb485289a52be14b2f68b571cb84e380cc43387eadf778f64c79e6df
$(PKG)_SUBDIR   := SDL_sound-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL_sound-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://icculus.org/SDL_sound/downloads/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc flac libmikmod ogg sdl speex vorbis

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://hg.icculus.org/icculus/SDL_sound/tags' | \
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
        --enable-voc \
        --enable-wav \
        --enable-raw \
        --enable-aiff \
        --enable-au \
        --enable-shn \
        --enable-midi \
        --disable-smpeg \
        --enable-mpglib \
        --enable-mikmod \
        --disable-modplug \
        --enable-ogg \
        --enable-flac \
        --enable-speex \
        --disable-physfs \
        --disable-altcvt \
        CFLAGS='-g -O2 -fno-inline' \
        LIBS="`'$(TARGET)-pkg-config' vorbisfile flac speex --libs` `'$(PREFIX)/$(TARGET)/bin/libmikmod-config' --libs`"
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: $(PKG)'; \
     echo 'Requires: sdl vorbisfile flac speex'; \
     echo 'Libs: -lSDL_sound'; \
     echo "Libs.private: `'$(PREFIX)/$(TARGET)/bin/libmikmod-config' --libs`";) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/SDL_sound.pc'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -std=c99 -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-sdl_sound.exe' \
        `'$(TARGET)-pkg-config' SDL_sound --cflags --libs`

    mkdir -p '$(1)/cmake-build-test'
    cp '$(2)-CMakeLists.txt' '$(1)/cmake-build-test/CMakeLists.txt'
    cp '$(2).c' '$(1)/cmake-build-test/'
    cd '$(1)/cmake-build-test' && cmake . \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)'
    $(MAKE) -C '$(1)/cmake-build-test' -j '$(JOBS)'
endef

$(PKG)_BUILD_SHARED =
