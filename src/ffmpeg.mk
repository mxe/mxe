# This file is part of MXE.
# See index.html for further information.

PKG             := ffmpeg
$(PKG)_IGNORE   := 2%
$(PKG)_VERSION  := 2.1.1
$(PKG)_CHECKSUM := e7a5b2d7f702c4e9ca69e23c6d3527f93de0d1bd
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.ffmpeg.org/releases/$($(PKG)_FILE)
$(PKG)_URL_2    := http://launchpad.net/ffmpeg/main/$($(PKG)_VERSION)/+download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc bzip2 lame libass libnut libvpx opencore-amr opus sdl speex theora vo-aacenc vo-amrwbenc vorbis x264 xvidcore zlib

$(PKG)_CONFS    := --enable-cross-compile \
                   --target-os=mingw32 \
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
                   --enable-libnut \
                   --enable-libopencore-amrnb \
                   --enable-libopencore-amrwb \
                   --enable-libopus \
                   --enable-libspeex \
                   --enable-libtheora \
                   --enable-libvo-aacenc \
                   --enable-libvo-amrwbenc \
                   --enable-libvorbis \
                   --enable-libvpx \
                   --enable-libx264 \
                   --enable-libxvid \
                   --enable-postproc


define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.ffmpeg.org/download.html' | \
    $(SED) -n 's,.*ffmpeg-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep 2.* | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    '$(SED)' -i "s^[-]lvpx^`'$(TARGET)'-pkg-config --libs-only-l vpx`^g;" $(1)/configure
    cd '$(1)' && ./configure \
        --cross-prefix='$(TARGET)'- \
        --arch=$(patsubst -%,,$(TARGET)) \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        $($(PKG)_CONFS) 
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
