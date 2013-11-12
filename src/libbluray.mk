# This file is part of MXE.
# See index.html for further information.

PKG             := libbluray
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.4.0
$(PKG)_CHECKSUM := 39984aae77efde2e0917ed7e183ebf612813d7f3
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.bz2
$(PKG)_URL      := ftp://ftp.videolan.org/pub/videolan/libbluray/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := freetype gcc libxml2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'ftp://ftp.videolan.org/pub/videolan/libbluray/last/' | \
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
