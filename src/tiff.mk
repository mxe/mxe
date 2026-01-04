# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := tiff
$(PKG)_WEBSITE  := https://download.osgeo.org/libtiff/
$(PKG)_DESCR    := LibTIFF
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.7.1
$(PKG)_CHECKSUM := b92017489bdc1db3a4c97191aa4b75366673cb746de0dce5d7a749d5954681ba
$(PKG)_SUBDIR   := tiff-$($(PKG)_VERSION)
$(PKG)_FILE     := tiff-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.osgeo.org/libtiff/$($(PKG)_FILE)
$(PKG)_DEPS     := cc jpeg libwebp xz zlib zstd

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://download.osgeo.org/libtiff/' | \
    $(SED) -n 's,.*>tiff-\([0-9][^<]*\)\.tar\.xz<.*,\1,p' | \
    grep -v 'alpha\|beta\|rc\|sig' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --without-x
    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(MXE_DISABLE_CRUFT)
endef
