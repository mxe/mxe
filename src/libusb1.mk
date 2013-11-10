# This file is part of MXE.
# See index.html for further information.

PKG             := libusb1
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.17
$(PKG)_CHECKSUM := a491054e7f4f3f52b12bd567335180586a54ae16
$(PKG)_SUBDIR   := libusbx-$($(PKG)_VERSION)
$(PKG)_FILE     := libusbx-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/libusbx/releases/$($(PKG)_VERSION)/source/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/libusbx/files/releases/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --enable-static \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
