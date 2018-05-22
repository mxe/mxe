# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sparsehash
$(PKG)_WEBSITE  := https://github.com/sparsehash/sparsehash
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.3
$(PKG)_CHECKSUM := 05e986a5c7327796dad742182b2d10805a8d4f511ad090da0490f146c1ff7a8c
$(PKG)_GH_CONF  := sparsehash/sparsehash/tags, sparsehash-
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_DOCS)

    $(INSTALL) '$(BUILD_DIR)/hashtable_test.exe' '$(PREFIX)/$(TARGET)/bin/test-sparsehash.exe'
    $(TARGET)-strip '$(PREFIX)/$(TARGET)/bin/test-sparsehash.exe'
endef
