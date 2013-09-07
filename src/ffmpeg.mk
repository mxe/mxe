# This file is part of MXE.
# See index.html for further information.

PKG             := ffmpeg
$(PKG)_IGNORE   := 2%
$(PKG)_VERSION  := 1.2.2
$(PKG)_CHECKSUM := 5ccf4067f43853e5d63218aba13bc571b1108b5a
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.ffmpeg.org/releases/$($(PKG)_FILE)
$(PKG)_URL_2    := http://launchpad.net/ffmpeg/main/$($(PKG)_VERSION)/+download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc bzip2 lame libass libvpx opencore-amr opus sdl speex theora vorbis x264 xvidcore zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.ffmpeg.org/download.html' | \
    $(SED) -n 's,.*ffmpeg-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    '$(SED)' -i "s^[-]lvpx^`'$(TARGET)'-pkg-config --libs-only-l vpx`^g;" $(1)/configure
    cd '$(1)' && ./configure \
        --cross-prefix='$(TARGET)'- \
        --enable-cross-compile \
        --arch=$(patsubst -%,,$(TARGET)) \
        --target-os=mingw32 \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --disable-debug \
        --enable-memalign-hack \
        --disable-pthreads \
        --enable-w32threads \
        --disable-doc \
        --enable-gpl \
        --enable-version3 \
        --disable-nonfree \
        --enable-avisynth \
        --enable-libass \
        --disable-libfaac \
        --enable-libmp3lame \
        --enable-libopencore-amrnb \
        --enable-libopencore-amrwb \
        --enable-libopus \
        --enable-libspeex \
        --enable-libtheora \
        --enable-libvorbis \
        --enable-libvpx \
        --enable-libx264 \
        --enable-libxvid \
        --enable-postproc
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
