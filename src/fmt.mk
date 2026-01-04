# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := fmt
$(PKG)_WEBSITE  := https://github.com/fmtlib/$(PKG)
$(PKG)_DESCR    := A modern formatting library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 9.1.0
$(PKG)_CHECKSUM := 5dea48d1fcddc3ec571ce2058e13910a0d4a6bab4cc09a809d8b1dd1c88ae6f2
$(PKG)_GH_CONF  := fmtlib/fmt/releases
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    '$(TARGET)-cmake' -S $(SOURCE_DIR) -B $(BUILD_DIR)
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' install
endef
