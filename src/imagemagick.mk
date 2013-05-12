# This file is part of MXE.
# See index.html for further information.

PKG             := imagemagick
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 3c932aa3febb1e992a780e9091925bdbc0d61613
$(PKG)_SUBDIR   := ImageMagick-$($(PKG)_VERSION)
$(PKG)_FILE     := ImageMagick-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://www.imagemagick.org/download/$($(PKG)_FILE)
$(PKG)_URL_2    := http://ftp.nluug.nl/ImageMagick/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc bzip2 ffmpeg fftw freetype jasper jpeg lcms liblqr-1 libpng libtool openexr pthreads tiff

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.imagemagick.org/' | \
    $(SED) -n 's,.*<p>The current release is ImageMagick \([0-9][^<]*\).</p>.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --with-x=no \
        --without-zlib \
        --disable-largefile \
        --without-threads \
        --with-freetype='$(PREFIX)/$(TARGET)/bin/freetype-config'
    $(SED) -i 's/#define MAGICKCORE_HAVE_PTHREAD 1//g' '$(1)/magick/magick-baseconfig.h'
    $(SED) -i 's/#define MAGICKCORE_ZLIB_DELEGATE 1//g' '$(1)/magick/magick-config.h'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS=

    '$(1)'/libtool --mode=link --tag=CXX \
        '$(TARGET)-g++' -Wall -Wextra -std=gnu++0x \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-imagemagick.exe' \
        `'$(TARGET)-pkg-config' ImageMagick++ --cflags --libs`
endef
