# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libplist
$(PKG)_WEBSITE  := https://github.com/libimobiledevice/libplist
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.0
$(PKG)_CHECKSUM := 187eb8a7aca2d5abcdfd81c42ac12e67ebe49c434299df1881a942e64b7c7978
$(PKG)_GH_CONF  := libimobiledevice/libplist/tags
$(PKG)_DEPS     := cc libxml2

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && NOCONFIGURE=true $(SHELL) ./autogen.sh
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --without-cython
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
