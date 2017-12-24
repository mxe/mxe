# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := nasm
$(PKG)_WEBSITE  := http://www.nasm.us/
$(PKG)_DESCR    := NASM - The Netwide Assembler
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.13.01
$(PKG)_CHECKSUM := aa0213008f0433ecbe07bb628506a5c4be8079be20fc3532a5031fd639db9a5e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://www.nasm.us/pub/$(PKG)/releasebuilds/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(BUILD)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.nasm.us/pub/nasm/releasebuilds/?C=M;O=D' | \
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
