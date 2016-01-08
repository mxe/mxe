# This file is part of MXE.
# See index.html for further information.

PKG             := qbittorrent
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.3.1
$(PKG)_CHECKSUM := dad15a233a69ce13ea75957585af3f9122dbf915291aab0fdbc48a71b8a229d2
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
