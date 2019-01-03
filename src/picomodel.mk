# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := picomodel
$(PKG)_WEBSITE  := https://code.google.com/p/picomodel/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1142ad8
$(PKG)_CHECKSUM := e9dd8b78278a454602a81eb388603142a15f2124f549f478d4edc93149eb6dd0
$(PKG)_GH_CONF  := ufoai/picomodel/branches/master
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && ./autogen.sh
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
