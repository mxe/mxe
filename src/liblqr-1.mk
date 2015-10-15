# This file is part of MXE.
# See index.html for further information.

PKG             := liblqr-1
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.4.2
$(PKG)_CHECKSUM := 173a822efd207d72cda7d7f4e951c5000f31b10209366ff7f0f5972f7f9ff137
$(PKG)_SUBDIR   := liblqr-1-$($(PKG)_VERSION)
$(PKG)_FILE     := liblqr-1-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://liblqr.wdfiles.com/local--files/en:download-page/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc glib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://liblqr.wikidot.com/en:download-page' | \
    $(SED) -n 's,.*liblqr-1-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoconf && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --enable-static \
        --disable-declspec \
        --disable-install-man
    $(MAKE) -C '$(1)' -j
    $(MAKE) -C '$(1)' -j 1 install
endef

$(PKG)_BUILD_SHARED =
