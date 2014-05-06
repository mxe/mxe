# This file is part of MXE.
# See index.html for further information.

PKG             := sdl2_mixer
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.0
$(PKG)_CHECKSUM := 9ed975587f09a1776ba9776dcc74a58e695aba6e
$(PKG)_SUBDIR   := SDL2_mixer-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL2_mixer-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.libsdl.org/projects/SDL_mixer/release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc sdl2 libmodplug ogg vorbis smpeg2

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
        >> '$(1)/SDL2_mixer.pc.in'
    $(SED) -i 's,for path in /usr/local; do,for path in; do,' '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)' \
        --disable-sdltest \
        --disable-music-mod \
        --enable-music-mod-modplug \
        --enable-music-ogg \
        --disable-music-flac \
        --enable-music-mp3 \
        --disable-music-ogg-shared \
        --disable-music-flac-shared \
        --disable-smpegtest \
        SMPEG_CONFIG='$(PREFIX)/$(TARGET)/bin/smpeg2-config' \
        WINDRES='$(TARGET)-windres' \
        LIBS='-lvorbis -logg'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

#    '$(TARGET)-gcc' \
#        -W -Wall -Werror -ansi -pedantic \
#        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-sdl2_mixer.exe' \
#        `'$(TARGET)-pkg-config' SDL2_mixer --cflags --libs`
endef

$(PKG)_BUILD_i686-pc-mingw32 =

$(PKG)_BUILD_SHARED =
