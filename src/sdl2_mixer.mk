# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sdl2_mixer
$(PKG)_WEBSITE  := https://www.libsdl.org/
$(PKG)_DESCR    := SDL2_mixer
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.8.1
$(PKG)_CHECKSUM := 63804b4b2ba503865c0853f102231aeff489b1dfc6dea4750a69e2a8ef54b2bb
$(PKG)_GH_CONF  := libsdl-org/SDL_mixer/releases/tag,release-,,
$(PKG)_DEPS     := cc libmodplug mpg123 ogg opusfile sdl2 smpeg2 vorbis

define $(PKG)_BUILD
    $(SED) -i 's,^\(Requires:.*\),\1 opusfile vorbisfile,' '$(1)/SDL2_mixer.pc.in'
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
        LIBS="`$(TARGET)-pkg-config libmodplug libmpg123 opusfile vorbisfile --libs-only-l`"
    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(MXE_DISABLE_CRUFT)

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TOP_DIR)/src/sdl_mixer-test.c' -o '$(PREFIX)/$(TARGET)/bin/test-sdl2_mixer.exe' \
        `'$(TARGET)-pkg-config' SDL2_mixer --cflags --libs`
endef
