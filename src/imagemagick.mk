# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# ImageMagick
PKG             := imagemagick
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.6.2-1
$(PKG)_CHECKSUM := 35c08d163b0025d66ea1d29545c1be1370a0cbfb
$(PKG)_SUBDIR   := ImageMagick-$($(PKG)_VERSION)
$(PKG)_FILE     := ImageMagick-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.imagemagick.org/
$(PKG)_URL      := http://ftp.nluug.nl/ImageMagick/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc lcms tiff freetype jasper jpeg libpng fftw bzip2 openexr zlib pthreads

define $(PKG)_UPDATE
    wget -q -O- 'http://ftp.nluug.nl/ImageMagick/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="ImageMagick-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
	--with-x=no
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS=
endef
