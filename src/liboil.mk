# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := liboil
$(PKG)_WEBSITE  := https://liboil.freedesktop.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.3.17
$(PKG)_CHECKSUM := 105f02079b0b50034c759db34b473ecb5704ffa20a5486b60a8b7698128bfc69
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(PKG).freedesktop.org/download/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://cgit.freedesktop.org/liboil/refs/tags' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?h=[^0-9]*\\([0-9][^']*\\)'.*,\\1,p" | \
    head -1
endef

# liboil is in maintenance-only phase:
# https://cgit.freedesktop.org/liboil/commit/?h=04b154aa118c0fdf244932dadc3d085f6290db7a

# configure doesn't wildcard host test for x86_64
# `as_cv_unaligned_access` so set it manually

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --disable-debug \
        --disable-examples \
        as_cv_unaligned_access=yes
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
