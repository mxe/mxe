# This file is part of MXE.
# See index.html for further information.

PKG             := hdf-eos5
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.15
$(PKG)_CHECKSUM := 119588067abf139c1c600a4519b880d04a3933049576c88acdc8ff6fc71803dd
$(PKG)_SUBDIR   := hdfeos5
$(PKG)_FILE     := HDF-EOS5.$($(PKG)_VERSION).tar.Z
$(PKG)_URL      := ftp://edhs1.gsfc.nasa.gov/edhs/hdfeos5/latest_release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc hdf5

define $(PKG)_UPDATE
    echo 'TODO: write update script for $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && chmod -R ugo+w .
    cd '$(1)' && autoconf
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-shared \
        --enable-static \
        --enable-install-include

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
