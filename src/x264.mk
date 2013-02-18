# This file is part of MXE.
# See index.html for further information.

PKG             := x264
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := f076166e7927562837383bbfb91430b2c7a3caf2
$(PKG)_SUBDIR   := $(PKG)-snapshot-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-snapshot-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://download.videolan.org/pub/videolan/$(PKG)/snapshots/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    date -d yesterday +%Y%m%d-2245
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --cross-prefix='$(TARGET)'- \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --enable-static \
        --enable-win32thread
    $(MAKE) -C '$(1)' -j 1 uninstall
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
