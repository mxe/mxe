# This file is part of MXE.
# See index.html for further information.

PKG             := libsodium
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.6
$(PKG)_CHECKSUM := 940d03ea7d2caa7940e24564bf6d9f66d6edd1df1e0111ff8e3655f3b864fb59
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
