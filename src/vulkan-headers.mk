# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := vulkan-headers
$(PKG)_WEBSITE  := https://github.com/KhronosGroup/$(PKG)
$(PKG)_DESCR    := vulkan headers
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.169
$(PKG)_CHECKSUM := e1acfa36056a2fa73ddc01bdac416d0188c880161e2073bbd5a86c8fbbc9bdbf
$(PKG)_GH_CONF  := KhronosGroup/Vulkan-Headers/releases,v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    '$(TARGET)-cmake' -S $(SOURCE_DIR) -B $(BUILD_DIR)
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' install
endef
