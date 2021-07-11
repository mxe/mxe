# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := woff2
$(PKG)_WEBSITE  := https://github.com/google/woff2
$(PKG)_DESCR    := WOFF2 font compression library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.2
$(PKG)_CHECKSUM := add272bb09e6384a4833ffca4896350fdb16e0ca22df68c0384773c67a175594
$(PKG)_GH_CONF  := google/woff2/tags, v
$(PKG)_DEPS     := cc brotli

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
