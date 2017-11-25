# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := imagemagick
$(PKG)_WEBSITE  := https://www.imagemagick.org/
$(PKG)_DESCR    := ImageMagick
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.9.0-0
$(PKG)_CHECKSUM := 12331c904c691cb128865fdc97e5f8a2654576f9b032e274b74dd7617aa1b9b6
$(PKG)_SUBDIR   := ImageMagick-$($(PKG)_VERSION)
$(PKG)_FILE     := ImageMagick-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://www.imagemagick.org/download/releases/$($(PKG)_FILE)
$(PKG)_URL_2    := https://ftp.sunet.se/pub/multimedia/graphics/ImageMagick/$($(PKG)_FILE)
$(PKG)_DEPS     := cc bzip2 ffmpeg fftw freetype jasper jpeg lcms \
                   liblqr-1 libltdl libpng openexr pthreads tiff

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.imagemagick.org/' | \
    $(SED) -n 's,.*<p>The current release is ImageMagick \([0-9][0-9.-]*\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
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
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-imagemagick.exe' \
        `'$(TARGET)-pkg-config' ImageMagick++ --cflags --libs`
endef
