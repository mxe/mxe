# This file is part of MXE.
# See index.html for further information.

PKG             := xine-lib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.4
$(PKG)_CHECKSUM := 32267c5fcaa1439a5fbf7606d27dc4fafba9e504
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/xine/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc faad2 ffmpeg flac fontconfig freetype graphicsmagick libiconv libmng pthreads sdl speex theora vorbis wavpack zlib libmpcdec libcdio vcdimager mman-win32 libmad a52dec libmodplug

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.xine-project.org/releases' | \
    $(SED) -e 's,<a,\n<a,g' | \
    $(SED) -n 's,.*xine-lib-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    # rebuild configure script as one of the patches modifies configure.ac
    cd '$(1)' && autoreconf -fi
    cd '$(1)' && $(LIBTOOLIZE)
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
        --with-freetype \
        --with-fontconfig \
        --without-alsa \
        --without-esound \
        --without-arts \
        --without-fusionsound \
        --with-internal-vcdlibs \
        --with-external-libfaad \
        --without-external-libdts \
        --with-wavpack \
        CFLAGS='-I$(1)/win32/include' \
        PTHREAD_LIBS='-lpthread -lws2_32' \
        LIBS="`$(TARGET)-pkg-config --libs libmng` -logg"
    $(SED) -i 's,[\s^]*sed , $(SED) ,g' '$(1)/src/combined/ffmpeg/Makefile'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef

$(PKG)_BUILD_SHARED =
