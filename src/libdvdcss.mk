# This file is part of MXE.
# See index.html for further information.

PKG             := libdvdcss
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.13
$(PKG)_CHECKSUM := 1a4a5e55c7529da46386c1c333340eee2c325a77
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.bz2
$(PKG)_URL      := http://download.videolan.org/pub/libdvdcss/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://download.videolan.org/pub/libdvdcss/last/' | \
    $(SED) -n 's,.*libdvdcss-\([0-9][^<]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-doc
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
