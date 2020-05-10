# This file is part of MXE. See LICENSE.md for licensing information.

PKG := gettext

define $(PKG)_BUILD_$(BUILD)
    cd '$(SOURCE_DIR)' && autoreconf -fi
    # causes issues with other packages so use different prefix
    # but install *.m4 files and bins to standard location
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-included-libcroco \
        --prefix='$(PREFIX)/$(TARGET).gnu' \
        --bindir='$(PREFIX)/$(TARGET)/bin' \
        --datarootdir='$(PREFIX)/$(TARGET)/share'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_DOCS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_DOCS)
endef
