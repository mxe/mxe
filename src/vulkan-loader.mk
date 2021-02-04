# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := vulkan-loader
$(PKG)_WEBSITE  := https://github.com/KhronosGroup/$(PKG)
$(PKG)_DESCR    := vulkan loader
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.166
$(PKG)_CHECKSUM := 1094b303ead1843fd31a5c11b0f5c2f91949b0608f36619bf92c738f6d561b35
$(PKG)_GH_CONF  := KhronosGroup/Vulkan-Loader/releases,v
$(PKG)_DEPS     := cc vulkan-headers

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$1/build' && '$(TARGET)-cmake' .. \
        -DUSE_MASM=OFF \
        -DBUILD_TESTS=OFF
    $(MAKE) -C '$(1)/build' -j $(JOBS) install
endef
