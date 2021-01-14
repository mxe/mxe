# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gc
$(PKG)_WEBSITE  := https://github.com/ivmai/bdwgc
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.0.4
$(PKG)_CHECKSUM := 436a0ddc67b1ac0b0405b61a9675bca9e075c8156f4debd1d06f3a56c7cd289d
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
