# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := hidapi
$(PKG)_WEBSITE  := https://github.com/libusb/hidapi/
$(PKG)_DESCR    := HIDAPI
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2a24bf9
$(PKG)_CHECKSUM := fcf650c10ccd39c47cc86ffd676befc71dd74bd8367f6716418974830f218d1f
$(PKG)_GH_CONF  := libusb/hidapi/branches/master
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    '$(TARGET)-cmake' -S $(SOURCE_DIR) -B $(BUILD_DIR)
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' install
endef
