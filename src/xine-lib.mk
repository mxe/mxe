# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# xine-lib
PKG             := xine-lib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.18.1
$(PKG)_CHECKSUM := 783232b6d6e23850a7ac97bf53b2a8bc2e743270
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.xine-project.org/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/xine/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib libiconv libmng sdl vorbis theora speex flac freetype fontconfig pthreads

define $(PKG)_UPDATE
    wget -q -O- 'http://hg.debian.org/hg/xine-lib/xine-lib/tags' | \
    $(SED) -n 's,>,\n,gp' | \
    $(SED) -n 's,^\([0-9][^< ]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-static \
        --disable-shared \
        --disable-mmap \
        --disable-nls \
        --enable-mng \
        --disable-real-codecs \
        --without-external-ffmpeg \
        --without-x \
        --with-sdl \
        --with-vorbis \
        --with-theora \
        --with-speex \
        --with-libflac \
        --without-external-a52dec \
        --without-external-libmad \
        --without-external-libmpcdec \
        --without-imagemagick \
        --with-freetype \
        --with-fontconfig \
        --without-alsa \
        --without-esound \
        --without-arts \
        --without-fusionsound \
        --with-internal-vcdlibs \
        --without-external-libfaad \
        --without-external-libdts \
        --without-wavpack \
        CFLAGS='-I$(1)/win32/include' \
        PTHREAD_LIBS='-lpthread -lws2_32'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
