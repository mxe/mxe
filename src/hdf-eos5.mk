# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := hdf-eos5
$(PKG)_WEBSITE  := https://hdfeos.org/software/library.php
$(PKG)_DESCR    := HDF-EOS5
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.16
$(PKG)_CHECKSUM := 7054de24b90b6d9533329ef8dc89912c5227c83fb447792103279364e13dd452
$(PKG)_SUBDIR   := hdfeos5
$(PKG)_FILE     := HDF-EOS5.$($(PKG)_VERSION).tar.Z
$(PKG)_URL      := https://observer.gsfc.nasa.gov/ftp/edhs/hdfeos5/latest_release/$($(PKG)_FILE)
$(PKG)_DEPS     := cc hdf5

define $(PKG)_UPDATE
    echo 'TODO: write update script for hdf-eos5.' >&2;
    echo $(hdf-eos5_VERSION)
endef

define $(PKG)_BUILD
    # gctp is also present in hdf-eos2 and some headers are also
    # duplicated, so install to sub-directories
    cd '$(SOURCE_DIR)' && chmod -R ugo+w .
    cd '$(SOURCE_DIR)' && autoconf
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --includedir='$(PREFIX)/$(TARGET)/include/$(PKG)' \
        --libdir='$(PREFIX)/$(TARGET)/lib/$(PKG)' \
        --enable-install-include

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-gcc' \
        -std=c99 -W -Wall -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        -I'$(PREFIX)/$(TARGET)/include/$(PKG)' \
        -L'$(PREFIX)/$(TARGET)/lib/$(PKG)' \
        -lhe5_hdfeos -lhdf5_hl -lhdf5 -lz
endef

$(PKG)_BUILD_SHARED =
