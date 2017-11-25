# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := tiff
$(PKG)_WEBSITE  := http://simplesystems.org/libtiff/
$(PKG)_DESCR    := LibTIFF
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.0.9
$(PKG)_CHECKSUM := 6e7bdeec2c310734e734d19aae3a71ebe37a4d842e0e23dbb1b8921c0026cfcd
$(PKG)_SUBDIR   := tiff-$($(PKG)_VERSION)
$(PKG)_FILE     := tiff-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://download.osgeo.org/libtiff/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.remotesensing.org/libtiff/$($(PKG)_FILE)
$(PKG)_DEPS     := cc jpeg xz zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://simplesystems.org/libtiff/' | \
    $(SED) -n 's,.*>v\([0-9][^<]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --without-x
    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(MXE_DISABLE_CRUFT)
endef
