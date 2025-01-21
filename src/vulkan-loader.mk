# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := vulkan-loader
$(PKG)_WEBSITE  := https://github.com/KhronosGroup/$(PKG)
$(PKG)_DESCR    := vulkan loader
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := vulkan-sdk-1.3.283.0
$(PKG)_CHECKSUM := 59151a3cdbf8dcfe9c2ce4b5bf33358255a197f48d8d0ee8a1d8642ed9ace80f
$(PKG)_GH_CONF  := KhronosGroup/Vulkan-Loader/tags
$(PKG)_DEPS     := cc vulkan-headers

define $(PKG)_BUILD
    '$(TARGET)-cmake' -S $(SOURCE_DIR) -B $(BUILD_DIR) \
        -DUSE_MASM=OFF \
        -DBUILD_TESTS=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' install
endef
