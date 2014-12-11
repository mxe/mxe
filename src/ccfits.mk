# This file is part of MXE.
# See index.html for further information.

PKG             := ccfits
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4
$(PKG)_CHECKSUM := 3de2a6379bc1024300befae95cfdf33645a7b64a
$(PKG)_SUBDIR   := CCfits
$(PKG)_FILE     := CCfits-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://heasarc.gsfc.nasa.gov/fitsio/CCfits/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc cfitsio

define $(PKG)_UPDATE
    echo 'TODO: write update script for $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-cfitsio='$(PREFIX)/$(TARGET)'
        
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef

$(PKG)_BUILD_SHARED =
