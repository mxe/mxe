# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := hidapi
$(PKG)_WEBSITE  := https://github.com/signal11/hidapi/
$(PKG)_DESCR    := HIDAPI
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := a6a622f
$(PKG)_CHECKSUM := 32ea444bdd6c6a8a940bfa3287a2dc8c291a141fdc78cd638b37b546b44d95be
$(PKG)_GH_CONF  := signal11/hidapi/branches/master
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
