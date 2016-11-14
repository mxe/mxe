# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := enchant
$(PKG)_VERSION  := 1-6-1
$(PKG)_CHECKSUM := 2f4e0df56c3f4e4a613963c82b27e1975431164d4af7fb1ac3fb4510b807ebf7
$(PKG)_SUBDIR   := enchant-enchant-$($(PKG)_VERSION)
$(PKG)_FILE     := enchant-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/AbiWord/enchant/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo 'TODO: write update script for $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && ./autogen.sh && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        CFLAGS='-DG_PLATFORM_WIN32 -DG_OS_WIN32' \
		--disable-ispell \
		--disable-myspell
    $(MAKE) -C '$(1)' -j 1 install
endef

