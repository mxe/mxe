# GeoTiff
# http://trac.osgeo.org/geotiff/

PKG            := libgeotiff
$(PKG)_VERSION := 1.2.5
$(PKG)_SUBDIR  := libgeotiff-$($(PKG)_VERSION)
$(PKG)_FILE    := libgeotiff-$($(PKG)_VERSION).tar.gz
$(PKG)_URL     := http://download.osgeo.org/geotiff/libgeotiff/$($(PKG)_FILE)
$(PKG)_URL_2   := ftp://ftp.remotesensing.org/pub/geotiff/libgeotiff/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc zlib jpeg tiff proj

define $(PKG)_UPDATE
    wget -q -O- 'http://trac.osgeo.org/geotiff/' | \
    $(SED) -n 's,.*libgeotiff-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) 's,/usr/local,@prefix@,' -i '$(1)/bin/Makefile.in'
    touch '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j 1 all install EXEEXT=.remove-me
    rm -fv '$(PREFIX)/$(TARGET)'/bin/*.remove-me
endef
