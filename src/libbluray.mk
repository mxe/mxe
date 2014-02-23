# This file is part of MXE.
# See index.html for further information.

PKG             := libbluray
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.5.0
$(PKG)_CHECKSUM := 1a9c61daefc31438f9165e7681c563d0524b2d3e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.bz2
$(PKG)_URL      := ftp://ftp.videolan.org/pub/videolan/libbluray/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc freetype libxml2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.videolan.org/developers/libbluray.html' | \
    $(SED) -n 's,.*libbluray-\([0-9][^<]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --disable-examples \
        --with-freetype \
        --with-libxml2 \
        --disable-bdjava
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
