# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := vulkan-headers
$(PKG)_WEBSITE  := https://github.com/KhronosGroup/$(PKG)
$(PKG)_DESCR    := vulkan headers
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.280
$(PKG)_CHECKSUM := 717b49c52dbd37c78cf2f7f0fc715292c42e74841219e6cca918cd293ad5dce4
$(PKG)_GH_CONF  := KhronosGroup/Vulkan-Headers/releases,v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    '$(TARGET)-cmake' -S $(SOURCE_DIR) -B $(BUILD_DIR)
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' install
endef
