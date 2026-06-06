# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libsodium
$(PKG)_WEBSITE  := https://download.libsodium.org/doc/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.22
$(PKG)_CHECKSUM := 5838bb0c3da6148c24ebe531d1ed1297de9a87aea77d426bcd99f289e681631c
$(PKG)_GH_CONF  := jedisct1/libsodium/releases/latest,,-RELEASE
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        ac_cv_func_mprotect=no
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
