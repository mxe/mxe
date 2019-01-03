# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libtorrent-rasterbar
$(PKG)_WEBSITE  := https://www.libtorrent.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.6
$(PKG)_CHECKSUM := b7c74d004bd121bd6e9f8975ee1fec3c95c74044c6a6250f6b07f259f55121ef
$(PKG)_SUBDIR   := libtorrent-rasterbar-$($(PKG)_VERSION)
$(PKG)_FILE     := libtorrent-rasterbar-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/arvidn/libtorrent/releases/download/libtorrent-$(subst .,_,$($(PKG)_VERSION))/libtorrent-rasterbar-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc boost openssl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/arvidn/libtorrent/releases' | \
    $(SED) -n 's,.*libtorrent-rasterbar-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        --with-boost='$(PREFIX)/$(TARGET)' \
        --disable-debug \
        --disable-tests \
        --disable-examples \
        CXXFLAGS='-D_WIN32_WINNT=0x0501 -g -O2' \
        LIBS='-lws2_32 -lmswsock'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' LDFLAGS=-no-undefined
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install LDFLAGS=-no-undefined
endef
