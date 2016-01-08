# This file is part of MXE.
# See index.html for further information.

PKG             := libftdi
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.20
$(PKG)_CHECKSUM := 3176d5b5986438f33f5208e690a8bfe90941be501cc0a72118ce3d338d4b838e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.intra2net.com/en/developer/libftdi/download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libusb

$(PKG)_MESSAGE  :=*** libftdi is deprecated - please use libftdi1 ***

define $(PKG)_UPDATE
    echo 'Warning: libftdi is deprecated' >&2;
    echo $(libftdi_VERSION)
endef

define $(PKG)_UPDATE_DISABLED
    $(WGET) -q -O- 'http://www.intra2net.com/en/developer/libftdi/download.php' | \
    $(SED) -n 's,.*libftdi-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD_DISABLED
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --enable-static \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-libftdipp \
        --disable-python-binding \
        --without-examples \
        --without-docs \
        HAVELIBUSB=true
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef

$(PKG)_BUILD_SHARED =
