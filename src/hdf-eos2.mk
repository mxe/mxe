# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := hdf-eos2
$(PKG)_WEBSITE  := http://hdfeos.org/software/library.php
$(PKG)_DESCR    := HDF-EOS2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 19v1.00
$(PKG)_CHECKSUM := 3fffa081466e85d2b9436d984bc44fe97bbb33ad9d8b7055a322095dc4672e31
$(PKG)_SUBDIR   := hdfeos
$(PKG)_FILE     := HDF-EOS2.$($(PKG)_VERSION).tar.Z
$(PKG)_URL      := ftp://edhs1.gsfc.nasa.gov/edhs/hdfeos/latest_release/$($(PKG)_FILE)
$(PKG)_DEPS     := cc hdf4

define $(PKG)_UPDATE
    echo 'TODO: write update script for hdf-eos2.' >&2;
    echo $(hdf-eos2_VERSION)
endef

define $(PKG)_BUILD
    # gctp is also present in hdf-eos5 and some headers are also
    # duplicated, so install to sub-directories
    cd '$(SOURCE_DIR)' && chmod -R ugo+w .
    cd '$(SOURCE_DIR)' && autoconf
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
	    $(MXE_CONFIGURE_OPTS) \
	    --includedir='$(PREFIX)/$(TARGET)/include/$(PKG)' \
	    --libdir='$(PREFIX)/$(TARGET)/lib/$(PKG)' \
        --enable-install-include \
        ac_cv_func_malloc_0_nonnull=yes \
        ac_cv_func_realloc_0_nonnull=yes

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-gcc' \
        -std=c99 -W -Wall -Werror -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        -I'$(PREFIX)/$(TARGET)/include/$(PKG)' \
        -L'$(PREFIX)/$(TARGET)/lib/$(PKG)' \
        -lhdfeos -lmfhdf -ldf -lz -ljpeg -lportablexdr -lws2_32
endef

$(PKG)_BUILD_SHARED =
