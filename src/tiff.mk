# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# LibTIFF
PKG             := tiff
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.0.0
$(PKG)_CHECKSUM := 85d85520fea40fc9291995a60e3d40cf980b5522
$(PKG)_SUBDIR   := tiff-$($(PKG)_VERSION)
$(PKG)_FILE     := tiff-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.remotesensing.org/libtiff/
$(PKG)_URL      := http://download.osgeo.org/libtiff/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.remotesensing.org/libtiff/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib jpeg xz

define $(PKG)_UPDATE
    wget -q -O- 'http://www.remotesensing.org/libtiff/' | \
    $(SED) -n 's,.*>v\([0-9][^<]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./autogen.sh
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --without-x
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
