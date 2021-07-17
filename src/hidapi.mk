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
    # autoreconf when fetching from source
    cd '$(SOURCE_DIR)' && ./bootstrap
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # install test
    cp -f '$(BUILD_DIR)/hidtest/hidtest.exe' '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe'
endef
