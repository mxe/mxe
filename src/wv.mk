# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := wv
$(PKG)_VERSION  := 1.2.9
$(PKG)_CHECKSUM := 4c730d3b325c0785450dd3a043eeb53e1518598c4f41f155558385dd2635c19d
$(PKG)_SUBDIR   := wv-$($(PKG)_VERSION)
$(PKG)_FILE     := wv-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://abisource.com/downloads/wv/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo 'TODO: write update script for $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
		PKG_CONFIG=$(PREFIX)/bin/$(TARGET)-pkg-config
    $(MAKE) -C '$(1)' -j 1 install
endef

