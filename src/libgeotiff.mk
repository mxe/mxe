# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libgeotiff
$(PKG)_WEBSITE  := https://trac.osgeo.org/geotiff/
$(PKG)_DESCR    := GeoTiff
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.6.0
$(PKG)_CHECKSUM := 9311017e5284cffb86f2c7b7a9df1fb5ebcdc61c30468fb2e6bca36e4272ebca
$(PKG)_SUBDIR   := libgeotiff-$($(PKG)_VERSION)
$(PKG)_FILE     := libgeotiff-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://download.osgeo.org/geotiff/libgeotiff/$($(PKG)_FILE)
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
        --with-libtiff='$(PREFIX)/$(TARGET)' \
        --with-proj \
        --disable-towgs84 \
        LIBS="`'$(TARGET)-pkg-config' --libs libtiff-4 proj libcurl` -ljpeg -lz"
    $(MAKE) -C '$(1)' -j 1 all install \
        LDFLAGS=-no-undefined \
        EXEEXT=.remove-me \
        MAKE='$(MAKE)'
    rm -fv '$(PREFIX)/$(TARGET)'/bin/*.remove-me
endef
