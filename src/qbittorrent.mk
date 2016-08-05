# This file is part of MXE.
# See index.html for further information.

PKG             := qbittorrent
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2.3
$(PKG)_CHECKSUM := 5b5ff9cd6b6b6d4fd751fa305fd343d55141f83c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$(PKG)-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libtorrent-rasterbar qt boost

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.qbittorrent.org/download.php' | \
    $(SED) -n 's,.*qbittorrent-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # On Windows, GeoIP database must be embedded
    $(WGET) -O- \
        "http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz" \
        | gunzip > '$(1)'/src/gui/geoip/GeoIP.dat
    cd '$(1)' && \
        QMAKE_LRELEASE='$(PREFIX)/$(TARGET)/qt/bin/lrelease' \
        ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-boost='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    cp '$(1)'/src/release/qbittorrent.exe '$(PREFIX)/$(TARGET)/bin/'
endef

$(PKG)_BUILD_SHARED =
