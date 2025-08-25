# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := brotli
$(PKG)_WEBSITE  := https://github.com/google/brotli
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.0
$(PKG)_CHECKSUM := e720a6ca29428b803f4ad165371771f5398faba397edf6778837a18599ea13ff
$(PKG)_GH_CONF  := google/brotli/releases/tag,v,,
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)'
    '$(TARGET)-cmake' --build '$(BUILD_DIR)' --config Release --target install
    rm -f '$(PREFIX)/$(TARGET)/bin/brotli.exe'
endef
