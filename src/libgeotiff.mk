# This file is part of MXE.
# See index.html for further information.

PKG             := libgeotiff
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.0
$(PKG)_CHECKSUM := d0acb8d341fd6a8f2c673456e09fdb8f50f91e3166ac934719fe05b30d328329
$(PKG)_SUBDIR   := libgeotiff-$($(PKG)_VERSION)
$(PKG)_FILE     := libgeotiff-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://download.osgeo.org/geotiff/libgeotiff/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.remotesensing.org/geotiff/libgeotiff/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc jpeg proj tiff zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://trac.osgeo.org/geotiff/' | \
    $(SED) -n 's,.*libgeotiff-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,/usr/local,@prefix@,' '$(1)/bin/Makefile.in'
    touch '$(1)/configure'
    cd '$(1)' && autoreconf -fi
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-jpeg \
        --with-zlib \
        LIBS="`'$(TARGET)-pkg-config' --libs libtiff-4` -ljpeg -lz"
    $(MAKE) -C '$(1)' -j 1 all install \
        LDFLAGS=-no-undefined \
        EXEEXT=.remove-me \
        MAKE='$(MAKE)'
    rm -fv '$(PREFIX)/$(TARGET)'/bin/*.remove-me
endef
