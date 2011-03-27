# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# SDL_mixer
PKG             := sdl_mixer
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.11
$(PKG)_CHECKSUM := ef5d45160babeb51eafa7e4019cec38324ee1a5d
$(PKG)_SUBDIR   := SDL_mixer-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL_mixer-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.libsdl.org/projects/SDL_mixer/
$(PKG)_URL      := http://www.libsdl.org/projects/SDL_mixer/release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc sdl libmikmod ogg vorbis smpeg

define $(PKG)_UPDATE
    wget -q -O- 'http://www.libsdl.org/cgi/viewvc.cgi/tags/SDL_mixer/?sortby=date' | \
    grep '<a name="' | \
    $(SED) -n 's,.*<a name="release-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,^\(Requires:.*\),\1 vorbisfile,' '$(1)/SDL_mixer.pc.in'
    echo \
        'Libs.private:' \
        "`$(PREFIX)/$(TARGET)/bin/libmikmod-config --libs`" \
        "`$(PREFIX)/$(TARGET)/bin/smpeg-config     --libs`" \
        >> '$(1)/SDL_mixer.pc.in'
    $(SED) -i 's,for path in /usr/local; do,for path in; do,' '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)' \
        --disable-sdltest \
        --enable-music-mod \
        --enable-music-ogg \
        --disable-music-flac \
        --enable-music-mp3 \
        --disable-music-mod-shared \
        --disable-music-ogg-shared \
        --disable-music-flac-shared \
        --disable-music-mp3-shared \
        --disable-smpegtest \
        --with-smpeg-prefix='$(PREFIX)/$(TARGET)' \
        LIBMIKMOD_CONFIG='$(PREFIX)/$(TARGET)/bin/libmikmod-config' \
        LIBS='-lvorbis -logg'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-sdl_mixer.exe' \
        `'$(TARGET)-pkg-config' SDL_mixer --cflags --libs`
endef
