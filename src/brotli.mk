# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := brotli
$(PKG)_WEBSITE  := https://github.com/google/brotli
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.0
$(PKG)_CHECKSUM := 816c96e8e8f193b40151dad7e8ff37b1221d019dbcb9c35cd3fadbfe6477dfec
$(PKG)_GH_CONF  := google/brotli/releases/tag,v,,
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)'
    '$(TARGET)-cmake' --build '$(BUILD_DIR)' --config Release --target install
    rm -f '$(PREFIX)/$(TARGET)/bin/brotli.exe'
endef
