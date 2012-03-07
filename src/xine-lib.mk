# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# xine-lib
PKG             := xine-lib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.20.1
$(PKG)_CHECKSUM := 68e85049723b491ccb22d5123bf8fa780529868a
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.xine-project.org/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/xine/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc faad2 ffmpeg flac fontconfig freetype graphicsmagick libiconv libmng pthreads sdl speex theora vorbis zlib

define $(PKG)_UPDATE
    wget -q -O- 'http://hg.debian.org/hg/xine-lib/xine-lib/tags' | \
    $(SED) -n 's,>,\n,gp' | \
    $(SED) -n 's,^\([0-9][^< ]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # rebuild configure script as one of the patches modifies configure.ac
    cd '$(1)' && aclocal -I m4
    cd '$(1)' && $(LIBTOOLIZE)
    cd '$(1)' && autoconf

    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-static \
        --disable-shared \
        --disable-mmap \
        --disable-nls \
        --disable-aalib \
        --enable-mng \
        --disable-real-codecs \
        --with-external-ffmpeg \
        --without-x \
        --with-sdl \
        --with-vorbis \
        --with-theora \
        --with-speex \
        --with-libflac \
        --without-external-a52dec \
        --without-external-libmad \
        --without-external-libmpcdec \
        --with-freetype \
        --with-fontconfig \
        --without-alsa \
        --without-esound \
        --without-arts \
        --without-fusionsound \
        --with-internal-vcdlibs \
        --with-external-libfaad \
        --without-external-libdts \
        --without-wavpack \
        CFLAGS='-I$(1)/win32/include' \
        PTHREAD_LIBS='-lpthread -lws2_32' \
        LIBS="`$(TARGET)-pkg-config --libs libmng`"
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
