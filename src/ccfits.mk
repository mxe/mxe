# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ccfits
$(PKG)_WEBSITE  := https://heasarc.gsfc.nasa.gov/fitsio/ccfits
$(PKG)_DESCR    := CCfits
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.7
$(PKG)_CHECKSUM := f63546d2feecbf732cc08aaaa80a2eb5334ada37fb2530181b7363a5dbdeb01a
$(PKG)_SUBDIR   := CCfits-$($(PKG)_VERSION)
$(PKG)_FILE     := CCfits-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/ccfits/CCfits.tar.gz
$(PKG)_DEPS     := cc cfitsio

define $(PKG)_UPDATE
    $(WGET) -q -O- "https://heasarc.gsfc.nasa.gov/fitsio/ccfits/" | \
    grep -o 'Version [0-9.]*' | \
    $(SED) 's/Version //' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DTESTS=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
