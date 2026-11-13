# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := hidapi
$(PKG)_WEBSITE  := https://github.com/libusb/hidapi/
$(PKG)_DESCR    := HIDAPI
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.15.0
$(PKG)_CHECKSUM := 5d84dec684c27b97b921d2f3b73218cb773cf4ea915caee317ac8fc73cef8136
$(PKG)_GH_CONF  := libusb/hidapi/tags,hidapi-
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    '$(TARGET)-cmake' -S $(SOURCE_DIR) -B $(BUILD_DIR) \
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' install
endef
