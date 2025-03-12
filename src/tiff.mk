# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := tiff
$(PKG)_WEBSITE  := https://download.osgeo.org/libtiff/
$(PKG)_DESCR    := LibTIFF
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.7.0
$(PKG)_CHECKSUM := 273a0a73b1f0bed640afee4a5df0337357ced5b53d3d5d1c405b936501f71017
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
