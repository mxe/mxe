# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libsodium
$(PKG)_WEBSITE  := https://download.libsodium.org/doc/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.14
$(PKG)_CHECKSUM := 3cfc84d097fdc891b40d291f2ac2c3f99f71a87e36b20cc755c6fa0e97a77ee7
$(PKG)_SUBDIR   := libsodium-$($(PKG)_VERSION)
$(PKG)_FILE     := libsodium-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://download.libsodium.org/libsodium/releases/$($(PKG)_FILE)
$(PKG)_URL_2    := https://github.com/jedisct1/libsodium/releases/download/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://download.libsodium.org/libsodium/releases/' | \
    $(SED) -n 's,.*libsodium-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v mingw | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
