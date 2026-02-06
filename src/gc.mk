# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gc
$(PKG)_WEBSITE  := https://github.com/ivmai/bdwgc
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.2.12
$(PKG)_CHECKSUM := 42e5194ad06ab6ffb806c83eb99c03462b495d979cda782f3c72c08af833cd4e
$(PKG)_GH_CONF  := ivmai/bdwgc/releases/latest,v
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_URL      := https://github.com/ivmai/bdwgc/releases/download/v$($(PKG)_VERSION)/$($(PKG)_SUBDIR).tar.gz
$(PKG)_DEPS     := cc libatomic_ops

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-threads=win32 \
        --enable-cplusplus
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
