# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cimg
$(PKG)_WEBSITE  := http://cimg.eu/
$(PKG)_DESCR    := CImg Library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.6.3
$(PKG)_CHECKSUM := c2a3c62d05d1e322afa6afae086cf96df82a3a13b839e9bf1cedcb014d921ce7
$(PKG)_SUBDIR   := CImg-$($(PKG)_VERSION)
$(PKG)_FILE     := CImg_$($(PKG)_VERSION).zip
$(PKG)_URL      := http://cimg.eu/files/$($(PKG)_FILE)
$(PKG)_DEPS     := cc fftw imagemagick jpeg libpng opencv openexr tiff zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://cimg.eu/files/' | \
    $(SED) -n 's,.*CImg_\([0-9][^"]*\)\.zip.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cp -r '$(1)/CImg.h' '$(1)/plugins' '$(PREFIX)/$(TARGET)/include/'

    # Build examples

    # use Mlinux instead of Mwindows to get more features
    # Mlinux does not link against CIMG_GDI32_LIBS,
    # so set CIMG_X11_LIBS to -lgdi32

    # no colored terminal, no X server, no minc2
    # curl is not used by any example

    $(MAKE) -C '$(1)/examples' -j '$(JOBS)' \
        'CIMG_VERSION=$($(PKG)_VERSION)' \
        'CC=$(TARGET)-g++' \
        'EXESFX=.exe' \
        'CIMG_VT100_CFLAGS=' \
        'CIMG_X11_CFLAGS=-mwindows' 'CIMG_X11_LIBS=-lgdi32' \
        'CIMG_XSHM_CFLAGS=' 'CIMG_XSHM_LIBS=' \
        'CIMG_XRANDR_CFLAGS=' 'CIMG_XRANDR_LIBS=' \
        'CIMG_MINC2_CFLAGS=' 'CIMG_MINC2_LIBS=' \
        'CIMG_CURL_CFLAGS=' 'CIMG_CURL_LIBS=' \
        'CIMG_TIFF_INCDIR=`$(TARGET)-pkg-config --cflags libtiff-4`' \
        'CIMG_TIFF_LIBS=`$(TARGET)-pkg-config --libs libtiff-4`' \
        'CIMG_EXR_INCDIR=`$(TARGET)-pkg-config --cflags OpenEXR`' \
        'CIMG_EXR_LIBS=`$(TARGET)-pkg-config --libs OpenEXR`' \
        'CIMG_PNG_INCDIR=`$(TARGET)-pkg-config --cflags libpng`' \
        'CIMG_PNG_LIBS=`$(TARGET)-pkg-config --libs libpng`' \
        'CIMG_JPEG_INCDIR=`$(TARGET)-pkg-config --cflags jpeg`' \
        'CIMG_JPEG_LIBS=`$(TARGET)-pkg-config --libs jpeg`' \
        'CIMG_ZLIB_INCDIR=`$(TARGET)-pkg-config --cflags zlib`' \
        'CIMG_ZLIB_LIBS=`$(TARGET)-pkg-config --libs zlib`' \
        'CIMG_OPENCV_INCDIR=`$(TARGET)-pkg-config --cflags opencv`' \
        'CIMG_OPENCV_LIBS=`$(TARGET)-pkg-config --libs opencv`' \
        'CIMG_MAGICK_INCDIR=`$(TARGET)-pkg-config --cflags ImageMagick++`' \
        'CIMG_MAGICK_LIBS=`$(TARGET)-pkg-config --libs ImageMagick++`' \
        'CIMG_FFTW3_INCDIR=`$(TARGET)-pkg-config --cflags fftw3`' \
        'CIMG_FFTW3_LIBS=`$(TARGET)-pkg-config --libs fftw3`' \
        Mlinux
endef
