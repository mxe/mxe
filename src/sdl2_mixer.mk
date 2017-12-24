# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sdl2_mixer
$(PKG)_WEBSITE  := https://www.libsdl.org/
$(PKG)_DESCR    := SDL2_mixer
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.2
$(PKG)_CHECKSUM := 4e615e27efca4f439df9af6aa2c6de84150d17cbfd12174b54868c12f19c83bb
$(PKG)_SUBDIR   := SDL2_mixer-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL2_mixer-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.libsdl.org/projects/SDL_mixer/release/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libmodplug mpg123 ogg sdl2 smpeg2 vorbis

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://hg.libsdl.org/SDL_mixer/tags' | \
    $(SED) -n 's,.*release-\([0-9][^<]*\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,^\(Requires:.*\),\1 vorbisfile,' '$(1)/SDL2_mixer.pc.in'
    echo \
        'Libs.private:' \
        "`$(TARGET)-pkg-config libmodplug libmpg123 --libs`" \
        "`$(PREFIX)/$(TARGET)/bin/smpeg2-config --libs`" \
        >> '$(1)/SDL2_mixer.pc.in'
    $(SED) -i 's,for path in /usr/local; do,for path in; do,' '$(1)/configure'
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)' \
        --disable-sdltest \
        --disable-music-mod \
        --enable-music-mod-modplug \
        --enable-music-ogg \
        --disable-music-ogg-shared \
        --disable-music-flac \
        --disable-music-flac-shared \
        --enable-music-mp3 \
        --disable-smpegtest \
        SMPEG_CONFIG='$(PREFIX)/$(TARGET)/bin/smpeg2-config' \
        WINDRES='$(TARGET)-windres' \
        LIBS='-lvorbis -logg'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(MXE_DISABLE_CRUFT)

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TOP_DIR)/src/sdl_mixer-test.c' -o '$(PREFIX)/$(TARGET)/bin/test-sdl2_mixer.exe' \
        `'$(TARGET)-pkg-config' SDL2_mixer --cflags --libs`
endef


