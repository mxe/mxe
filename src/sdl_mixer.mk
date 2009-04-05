# SDL_mixer

PKG             := sdl_mixer
$(PKG)_VERSION  := 1.2.8
$(PKG)_CHECKSUM := 7fa56d378f9ca53434f9470aeb2997ad84a348c6
$(PKG)_SUBDIR   := SDL_mixer-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL_mixer-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://libsdl.org/projects/SDL_mixer/
$(PKG)_URL      := http://libsdl.org/projects/SDL_mixer/release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc sdl libmikmod ogg smpeg

define $(PKG)_UPDATE
    wget -q -O- 'http://libsdl.org/projects/SDL_mixer/' | \
    $(SED) -n 's,.*SDL_mixer-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) 's,for path in /usr/local; do,for path in; do,' -i '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)' \
        --disable-sdltest \
        --enable-music-libmikmod \
        --enable-music-ogg \
        --disable-music-ogg-shared \
        --with-smpeg-prefix='$(PREFIX)/$(TARGET)' \
        --disable-smpegtest \
        --disable-music-mp3-shared
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
