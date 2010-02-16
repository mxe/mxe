# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# GeoTiff
PKG             := libgeotiff
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.5
$(PKG)_CHECKSUM := 38b10070374636fedfdde328ff1c9f3c6e8e581f
$(PKG)_SUBDIR   := libgeotiff-$($(PKG)_VERSION)
$(PKG)_FILE     := libgeotiff-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://trac.osgeo.org/geotiff/
$(PKG)_URL      := http://ftp.remotesensing.org/geotiff/libgeotiff/$($(PKG)_FILE)
$(PKG)_URL_2    := http://download.osgeo.org/geotiff/libgeotiff/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib jpeg tiff proj

define $(PKG)_UPDATE
    wget -q -O- 'http://trac.osgeo.org/geotiff/' | \
    $(SED) -n 's,.*libgeotiff-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,/usr/local,@prefix@,' '$(1)/bin/Makefile.in'
    touch '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j 1 all install EXEEXT=.remove-me MAKE='$(MAKE)'
    rm -fv '$(PREFIX)/$(TARGET)'/bin/*.remove-me
endef
