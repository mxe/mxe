# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sdl_mixer
$(PKG)_WEBSITE  := https://www.libsdl.org/projects/SDL_mixer/
$(PKG)_DESCR    := SDL_mixer
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.12
$(PKG)_CHECKSUM := 1644308279a975799049e4826af2cfc787cad2abb11aa14562e402521f86992a
$(PKG)_SUBDIR   := SDL_mixer-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL_mixer-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.libsdl.org/projects/SDL_mixer/release/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libmodplug ogg sdl smpeg vorbis

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://hg.libsdl.org/SDL_mixer/tags' | \
    $(SED) -n 's,.*release-\([0-9][^<]*\).*,\1,p' | \
    grep '^1\.' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,^\(Requires:.*\),\1 vorbisfile,' '$(SOURCE_DIR)/SDL_mixer.pc.in'
    echo \
        'Libs.private:' \
        "`$(TARGET)-pkg-config libmodplug --libs`" \
        "`$(PREFIX)/$(TARGET)/bin/smpeg-config     --libs`" \
        >> '$(SOURCE_DIR)/SDL_mixer.pc.in'
    $(SED) -i 's,for path in /usr/local; do,for path in; do,' '$(SOURCE_DIR)/configure'
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)' \
        --disable-sdltest \
        --disable-music-mod \
        --enable-music-mod-modplug \
        --enable-music-ogg \
        --disable-music-flac \
        --enable-music-mp3 \
        $(if $(BUILD_STATIC), \
            --disable-music-mod-shared \
            --disable-music-ogg-shared \
            --disable-music-flac-shared \
            --disable-music-mp3-shared \
            --disable-smpegtest \
            --with-smpeg-prefix='$(PREFIX)/$(TARGET)' \
            , \
            --without-smpeg)
        WINDRES='$(TARGET)-windres' \
        LIBS='-lvorbis -logg'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(if $(BUILD_SHARED),build/libSDL_mixer.la)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install-hdrs install-lib

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-sdl_mixer.exe' \
        `'$(TARGET)-pkg-config' SDL_mixer --cflags --libs`
endef
