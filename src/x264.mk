# This file is part of MXE.
# See index.html for further information.

PKG             := x264
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 768008db411c03afbd74ea808da5a1f57a77fed4
$(PKG)_SUBDIR   := $(PKG)-snapshot-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-snapshot-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://download.videolan.org/pub/videolan/$(PKG)/snapshots/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc yasm

define $(PKG)_UPDATE
    $(DATE) -d yesterday +%Y%m%d-2245
endef

define $(PKG)_BUILD
    $(SED) -i 's,yasm,$(TARGET)-yasm,g' '$(1)/configure'
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
