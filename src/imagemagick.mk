# This file is part of MXE.
# See index.html for further information.

PKG             := imagemagick
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.9.0-0
$(PKG)_CHECKSUM := 6bf4263ceaeea61e00fe15a95db320d49bcc48c4
$(PKG)_SUBDIR   := ImageMagick-$($(PKG)_VERSION)
$(PKG)_FILE     := ImageMagick-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://www.imagemagick.org/download/releases/$($(PKG)_FILE)
$(PKG)_URL_2    := http://ftp.sunet.se/pub/multimedia/graphics/ImageMagick/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc bzip2 ffmpeg fftw freetype jasper jpeg lcms liblqr-1 libpng libltdl openexr pthreads tiff

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.imagemagick.org/' | \
    $(SED) -n 's,.*<p>The current release is ImageMagick \([0-9][0-9.-]*\).*,\1,p' | \
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

$(PKG)_BUILD_x86_64-w64-mingw32 =

$(PKG)_BUILD_SHARED =
