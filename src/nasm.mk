# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := nasm
$(PKG)_WEBSITE  := https://www.nasm.us/
$(PKG)_DESCR    := NASM - The Netwide Assembler
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.16.03
$(PKG)_CHECKSUM := 1412a1c760bbd05db026b6c0d1657affd6631cd0a63cddb6f73cc6d4aa616148
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
