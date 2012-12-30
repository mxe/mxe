# This file is part of MXE.
# See index.html for further information.

PKG             := ffmpeg
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 007465d01dcd4cae973285f89f5c6c500602a3ec
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.ffmpeg.org/releases/$($(PKG)_FILE)
$(PKG)_URL_2    := http://launchpad.net/ffmpeg/main/$($(PKG)_VERSION)/+download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc bzip2 lame libvpx opencore-amr sdl speex theora vorbis x264 xvidcore zlib

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
        $(LINK_STYLE) \
        --disable-debug \
        --disable-doc \
        --enable-memalign-hack \
        --enable-gpl \
        --enable-version3 \
        --disable-nonfree \
        --enable-postproc \
        --disable-pthreads \
        --enable-w32threads \
        --enable-avisynth \
        --enable-libspeex \
        --enable-libtheora \
        --enable-libvorbis \
        --enable-libmp3lame \
        --enable-libxvid \
        --disable-libfaac \
        --enable-libopencore-amrnb \
        --enable-libopencore-amrwb \
        --enable-libx264 \
        --enable-libvpx
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef


define $(PKG)_BUILD_x86_64-static-mingw32
    $(subst enable-libmp3lame,disable-libmp3lame,\
    $(subst enable-libxvid,disable-libxvid,\
    $($(PKG)_BUILD)))
endef
