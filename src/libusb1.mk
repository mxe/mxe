# This file is part of MXE.
# See index.html for further information.

PKG             := libusb1
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.16
$(PKG)_CHECKSUM := ec164f02e6732c373e5a24be6b33a59142435615
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
