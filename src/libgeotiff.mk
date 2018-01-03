# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libgeotiff
$(PKG)_WEBSITE  := https://trac.osgeo.org/geotiff/
$(PKG)_DESCR    := GeoTiff
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.2
$(PKG)_CHECKSUM := ad87048adb91167b07f34974a8e53e4ec356494c29f1748de95252e8f81a5e6e
$(PKG)_SUBDIR   := libgeotiff-$($(PKG)_VERSION)
$(PKG)_FILE     := libgeotiff-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://download.osgeo.org/geotiff/libgeotiff/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.remotesensing.org/geotiff/libgeotiff/$($(PKG)_FILE)
$(PKG)_DEPS     := cc jpeg proj tiff zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://trac.osgeo.org/geotiff/' | \
    $(SED) -n 's,.*libgeotiff-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

# Note: towgs84 is set to disabled for binary compatibility to < 1.4.2
# Enabling towgs84 *may* require some work.
define $(PKG)_BUILD
    $(SED) -i 's,/usr/local,@prefix@,' '$(1)/bin/Makefile.in'
    touch '$(1)/configure'
    cd '$(1)' && autoreconf -fi
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-jpeg \
        --with-zlib \
        --disable-towgs84 \
        LIBS="`'$(TARGET)-pkg-config' --libs libtiff-4` -ljpeg -lz"
    $(MAKE) -C '$(1)' -j 1 all install \
        LDFLAGS=-no-undefined \
        EXEEXT=.remove-me \
        MAKE='$(MAKE)'
    rm -fv '$(PREFIX)/$(TARGET)'/bin/*.remove-me
endef
