# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qbittorrent
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.3.4
$(PKG)_CHECKSUM := c0d0d4b72c240f113b59a061146803bc1b7926d3d7f39b06b50a4d26f5ad91b8
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$(PKG)-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_WEBSITE  := https://qbittorrent.org/
$(PKG)_OWNER    := https://github.com/starius
$(PKG)_DEPS     := cc boost libtorrent-rasterbar qt $(BUILD)~geoip-database

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.qbittorrent.org/download.php' | \
    $(SED) -n 's,.*qbittorrent-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && \
        QMAKE_LRELEASE='$(PREFIX)/$(TARGET)/qt/bin/lrelease' \
        ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-qt4=yes \
        --with-boost='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    cp '$(1)'/src/release/qbittorrent.exe '$(PREFIX)/$(TARGET)/bin/'
endef

$(PKG)_BUILD_SHARED =
