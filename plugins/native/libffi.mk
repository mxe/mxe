# This file is part of MXE. See LICENSE.md for licensing information.

PKG                  := libffi
$(PKG)_TARGETS       := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS_$(BUILD) :=

define $(PKG)_BUILD_$(BUILD)
    # build and install the library
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
