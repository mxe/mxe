# This file is part of MXE.
# See index.html for further information.

PKG             := ccfits
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4
$(PKG)_CHECKSUM := ba6c5012b260adf7633f92581279ea582e331343d8c973981aa7de07242bd7f8
$(PKG)_SUBDIR   := CCfits
$(PKG)_FILE     := CCfits-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://heasarc.gsfc.nasa.gov/fitsio/CCfits/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc cfitsio

define $(PKG)_UPDATE
    $(WGET) -q -O- "http://heasarc.gsfc.nasa.gov/docs/software/fitsio/ccfits/" | \
    grep -i '<a href="CCfits.*tar' | \
    $(SED) -n 's,.*CCfits-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-cfitsio='$(PREFIX)/$(TARGET)'

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef

$(PKG)_BUILD_SHARED =
