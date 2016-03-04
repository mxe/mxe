# This file is part of MXE.
# See index.html for further information.

PKG             := hdf-eos2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 19v1.00
$(PKG)_CHECKSUM := 3fffa081466e85d2b9436d984bc44fe97bbb33ad9d8b7055a322095dc4672e31
$(PKG)_SUBDIR   := hdfeos
$(PKG)_FILE     := HDF-EOS2.$($(PKG)_VERSION).tar.Z
$(PKG)_URL      := ftp://edhs1.gsfc.nasa.gov/edhs/hdfeos/latest_release/$(PKG)_FILE
$(PKG)_DEPS     := gcc hdf4

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
