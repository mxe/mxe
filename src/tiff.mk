# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := tiff
$(PKG)_WEBSITE  := http://simplesystems.org/libtiff/
$(PKG)_DESCR    := LibTIFF
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.5.0
$(PKG)_CHECKSUM := dafac979c5e7b6c650025569c5a4e720995ba5f17bc17e6276d1f12427be267c
$(PKG)_SUBDIR   := tiff-$($(PKG)_VERSION)
$(PKG)_FILE     := tiff-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.osgeo.org/libtiff/$($(PKG)_FILE)
$(PKG)_DEPS     := cc jpeg libwebp xz zlib

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
