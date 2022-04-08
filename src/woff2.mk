# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := woff2
$(PKG)_WEBSITE  := https://github.com/google/woff2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.2
$(PKG)_CHECKSUM := add272bb09e6384a4833ffca4896350fdb16e0ca22df68c0384773c67a175594
$(PKG)_GH_CONF  := google/woff2/releases/tag,v,,
$(PKG)_DEPS     := cc brotli

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' \
        -DGEN_PKG_VERSION=ON \
        '$(SOURCE_DIR)'
 
    '$(TARGET)-cmake' --build '$(BUILD_DIR)' --config Release --target install
endef
