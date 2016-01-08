# This file is part of MXE.
# See index.html for further information.

PKG             := sdl2_mixer
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.0
$(PKG)_CHECKSUM := a8ce0e161793791adeff258ca6214267fdd41b3c073d2581cd5265c8646f725b
$(PKG)_SUBDIR   := SDL2_mixer-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL2_mixer-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.libsdl.org/projects/SDL_mixer/release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libmodplug ogg sdl2 smpeg2 vorbis

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://hg.libsdl.org/SDL_mixer/tags' | \
    $(SED) -n 's,.*release-\([0-9][^<]*\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,^\(Requires:.*\),\1 vorbisfile,' '$(1)/SDL2_mixer.pc.in'
    echo \
        'Libs.private:' \
        "`$(TARGET)-pkg-config libmodplug --libs`" \
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


