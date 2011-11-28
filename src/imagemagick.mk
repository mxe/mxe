# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# ImageMagick
PKG             := imagemagick
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.7.2-7
$(PKG)_CHECKSUM := 13198d502e95abb305c23c3d56378e9139fcb7c3
$(PKG)_SUBDIR   := ImageMagick-$($(PKG)_VERSION)
$(PKG)_FILE     := ImageMagick-$($(PKG)_VERSION).tar.xz
$(PKG)_WEBSITE  := http://www.imagemagick.org/
$(PKG)_URL      := http://ftp.nluug.nl/ImageMagick/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc bzip2 ffmpeg fftw freetype jasper jpeg lcms libpng libtool openexr pthreads tiff zlib

define $(PKG)_UPDATE
    wget -q -O- 'http://www.imagemagick.org/' | \
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
        ac_cv_prog_freetype_config='$(PREFIX)/$(TARGET)/bin/freetype-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS=
endef
