# This file is part of MXE.
# See index.html for further information.

PKG             := libtorrent-rasterbar
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.6
$(PKG)_CHECKSUM := c97de804b77f44591801631aca3869567671df2d3e2afe7f5453d8db2478fd61
$(PKG)_SUBDIR   := libtorrent-rasterbar-$($(PKG)_VERSION)
$(PKG)_FILE     := libtorrent-rasterbar-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/arvidn/libtorrent/releases/download/libtorrent-$(subst .,_,$($(PKG)_VERSION))/libtorrent-rasterbar-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc boost openssl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/arvidn/libtorrent/releases' | \
    $(SED) -n 's,.*libtorrent-rasterbar-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && \
        ./configure \
        $(MXE_CONFIGURE_OPTS) \
        PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        --with-boost-system=boost_system-mt \
        --disable-debug \
        --disable-tests \
        --disable-examples
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef

$(PKG)_BUILD_SHARED =
