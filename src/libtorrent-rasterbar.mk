# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libtorrent-rasterbar
$(PKG)_WEBSITE  := http://www.rasterbar.com/products/libtorrent/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.0
$(PKG)_CHECKSUM := 2713df7da4aec5263ac11b6626ea966f368a5a8081103fd8f2f2ed97b5cd731d
$(PKG)_SUBDIR   := libtorrent-rasterbar-$($(PKG)_VERSION)
$(PKG)_FILE     := libtorrent-rasterbar-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/arvidn/libtorrent/releases/download/libtorrent-$(subst .,_,$($(PKG)_VERSION))/libtorrent-rasterbar-$($(PKG)_VERSION).tar.gz
# this will likely revert to standard naming in future releases
$(PKG)_URL      := https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_1/libtorrent-rasterbar-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc boost openssl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/arvidn/libtorrent/releases' | \
    $(SED) -n 's,.*libtorrent-rasterbar-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        --with-boost='$(PREFIX)/$(TARGET)' \
        --disable-debug \
        --disable-tests \
        --disable-examples \
        CXXFLAGS='-D_WIN32_WINNT=0x0501 -g -O2'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef

$(PKG)_BUILD_SHARED =
