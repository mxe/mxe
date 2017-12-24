# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libsodium
$(PKG)_WEBSITE  := https://download.libsodium.org/doc/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.15
$(PKG)_CHECKSUM := fb6a9e879a2f674592e4328c5d9f79f082405ee4bb05cb6e679b90afe9e178f4
$(PKG)_GH_CONF  := jedisct1/libsodium/releases
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
