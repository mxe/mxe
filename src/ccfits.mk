# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ccfits
$(PKG)_WEBSITE  := https://heasarc.gsfc.nasa.gov/fitsio/ccfits
$(PKG)_DESCR    := CCfits
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.6
$(PKG)_CHECKSUM := 2bb439db67e537d0671166ad4d522290859e8e56c2f495c76faa97bc91b28612
$(PKG)_SUBDIR   := CCfits-$($(PKG)_VERSION)
$(PKG)_FILE     := CCfits-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://heasarc.gsfc.nasa.gov/fitsio/CCfits/$($(PKG)_FILE)
$(PKG)_DEPS     := cc cfitsio

define $(PKG)_UPDATE
    $(WGET) -q -O- "https://heasarc.gsfc.nasa.gov/fitsio/ccfits/" | \
    grep -i '<a href=".*CCfits.*tar' | \
    $(SED) -n 's,.*CCfits-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBUILD_TESTING=OFF \
        -DBUILD_PROGRAMS=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
