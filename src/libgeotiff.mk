# This file is part of MXE.
# See index.html for further information.

PKG             := libgeotiff
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.0
$(PKG)_CHECKSUM := 4c6f405869826bb7d9f35f1d69167e3b44a57ef0
$(PKG)_SUBDIR   := libgeotiff-$($(PKG)_VERSION)
$(PKG)_FILE     := libgeotiff-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://download.osgeo.org/geotiff/libgeotiff/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.remotesensing.org/geotiff/libgeotiff/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib jpeg tiff proj

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://trac.osgeo.org/geotiff/' | \
    $(SED) -n 's,.*libgeotiff-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && cmake \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DBUILD_SHARED_LIBS=ON \
	-DGEOTIFF_BIN_SUBDIR='$(PREFIX)/$(TARGET)/bin' \
	-DGEOTIFF_CSV_DATA_DIR='$(1)/csv' \
	-DWITH_JPEG=ON \
	-DWITH_PROJ=ON \
	-DWITH_ZLIB=ON \
	-DWITH_TIFF=ON \
	-DCMAKE_VERBOSE_MAKEFILE=OFF \
        '$(1)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)' install
endef
