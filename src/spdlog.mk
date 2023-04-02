# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := spdlog
$(PKG)_WEBSITE  := https://github.com/gabime/$(PKG)
$(PKG)_DESCR    := Fast C++ logging library.
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.11.0
$(PKG)_CHECKSUM := ca5cae8d6cac15dae0ec63b21d6ad3530070650f68076f3a4a862ca293a858bb
$(PKG)_GH_CONF  := gabime/spdlog/releases,v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    '$(TARGET)-cmake' -S $(SOURCE_DIR) -B $(BUILD_DIR)
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' install
endef
