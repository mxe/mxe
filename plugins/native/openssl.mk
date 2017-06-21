# This file is part of MXE. See LICENSE.md for licensing information.

PKG                  := openssl
$(PKG)_TARGETS       := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS_$(BUILD) := zlib

define $(PKG)_BUILD_$(BUILD)
    # can't build out-of-source
    cd '$(SOURCE_DIR)' && './config' \
        --prefix='$(PREFIX)/$(TARGET)' \
        zlib \
        no-shared
    $(MAKE) -C '$(SOURCE_DIR)' all -j '$(JOBS)'
    $(MAKE) -C '$(SOURCE_DIR)' install_sw -j 1
endef
