# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# ffmpeg
PKG             := ffmpeg
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.6
$(PKG)_CHECKSUM := 9e4bc2f1fdb4565bea54d7fb38e705b40620e208
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.ffmpeg.org/
$(PKG)_URL      := http://www.ffmpeg.org/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc xvidcore speex theora vorbis lame faad2 faac opencore-amr x264 libvpx

define $(PKG)_UPDATE
    wget -q -O- 'http://www.ffmpeg.org/download.html' | \
    $(SED) -n 's,.*ffmpeg-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
  
    ln -sf $(PREFIX)/$(TARGET)/lib/xvidcore.a $(PREFIX)/$(TARGET)/lib/libxvidcore.a
    ln -sf $(PREFIX)/$(TARGET)/bin/sdl-config $(PREFIX)/bin/$(TARGET)-sdl-config
 
    cd '$(1)' && ./configure \
	--cross-prefix='$(TARGET)'- \
	--enable-cross-compile \
	--arch=i686 \
	--target-os=mingw32 \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
	--disable-debug \
	--disable-doc \
	--enable-memalign-hack \
	--enable-gpl \
	--enable-version3 \
	--enable-nonfree \
	--enable-postproc \
	--enable-libspeex \
	--enable-libtheora \
	--enable-libvorbis \
	--enable-libmp3lame \
	--enable-libxvid \
	--enable-libfaad \
	--enable-libfaac \
	--enable-libopencore-amrnb \
	--enable-libopencore-amrwb \
	--enable-libx264 \
	--enable-libvpx
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
