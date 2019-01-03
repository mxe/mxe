# This file is part of MXE. See LICENSE.md for licensing information.

PKG            := mxe-conf
$(PKG)_VERSION := 1
$(PKG)_UPDATE  := echo 1
$(PKG)_TARGETS := $(BUILD) $(MXE_TARGETS)

define $(PKG)_BUILD
    # create basic non-empty directory hierarchy
    for d in bin include lib share; do \
        mkdir -p "$(PREFIX)/$(TARGET)/$$d" && \
        touch    "$(PREFIX)/$(TARGET)/$$d/.gitkeep" ; \
    done

    # install target-specific autotools config file
    # setting ac_cv_build bypasses the config.guess check in every package
    echo "ac_cv_build=$(BUILD)" > '$(PREFIX)/$(TARGET)/share/config.site'
endef

define $(PKG)_BUILD_$(BUILD)
    # install config.guess for general use
    mkdir -p '$(PREFIX)/bin'
    $(INSTALL) -m755 '$(EXT_DIR)/config.guess' '$(PREFIX)/bin/'

    #create script "wine" in a directory which is in PATH
    mkdir -p '$(PREFIX)/$(BUILD)/bin/'
    (echo '#!/usr/bin/env bash'; \
     echo 'exit 1'; \
    ) \
             > '$(PREFIX)/$(BUILD)/bin/wine'
    chmod 0755 '$(PREFIX)/$(BUILD)/bin/wine'
endef
