# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := nasm
$(PKG)_WEBSITE  := https://www.nasm.us/
$(PKG)_DESCR    := NASM - The Netwide Assembler
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.01
$(PKG)_CHECKSUM := b7324cbe86e767b65f26f467ed8b12ad80e124e3ccb89076855c98e43a9eddd4
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://www.nasm.us/pub/$(PKG)/releasebuilds/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(BUILD)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.nasm.us/pub/nasm/releasebuilds/?C=M;O=D' | \
    $(SED) -n 's,.*href="\([0-9\.]*[^a-z]\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD_$(BUILD)
    # build nasm compiler
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
