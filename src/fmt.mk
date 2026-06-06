# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := fmt
$(PKG)_WEBSITE  := https://github.com/fmtlib/$(PKG)
$(PKG)_DESCR    := A modern formatting library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 12.1.0
$(PKG)_CHECKSUM := ea7de4299689e12b6dddd392f9896f08fb0777ac7168897a244a6d6085043fea
$(PKG)_GH_CONF  := fmtlib/fmt/releases
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    '$(TARGET)-cmake' -S $(SOURCE_DIR) -B $(BUILD_DIR)
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' install
endef
