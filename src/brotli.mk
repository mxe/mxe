# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := brotli
$(PKG)_WEBSITE  := https://github.com/google/brotli
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.9
$(PKG)_CHECKSUM := f9e8d81d0405ba66d181529af42a3354f838c939095ff99930da6aa9cdf6fe46
$(PKG)_GH_CONF  := google/brotli/releases/tag,v,,
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)'
    '$(TARGET)-cmake' --build '$(BUILD_DIR)' --config Release --target install
endef
