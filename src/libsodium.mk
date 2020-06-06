# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libsodium
$(PKG)_WEBSITE  := https://download.libsodium.org/doc/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.18
$(PKG)_CHECKSUM := b7292dd1da67a049c8e78415cd498ec138d194cfdb302e716b08d26b80fecc10
$(PKG)_GH_CONF  := jedisct1/libsodium/releases/latest,,-RELEASE
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
