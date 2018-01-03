# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ccfits
$(PKG)_WEBSITE  := https://heasarc.gsfc.nasa.gov/fitsio/ccfits
$(PKG)_DESCR    := CCfits
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.5
$(PKG)_CHECKSUM := 938ecd25239e65f519b8d2b50702416edc723de5f0a5387cceea8c4004a44740
$(PKG)_SUBDIR   := CCfits
$(PKG)_FILE     := CCfits-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://heasarc.gsfc.nasa.gov/fitsio/CCfits/$($(PKG)_FILE)
$(PKG)_DEPS     := cc cfitsio

define $(PKG)_UPDATE
    $(WGET) -q -O- "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/ccfits/" | \
    grep -i '<a href="CCfits.*tar' | \
    $(SED) -n 's,.*CCfits-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef

$(PKG)_BUILD_SHARED =
