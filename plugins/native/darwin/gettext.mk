# This file is part of MXE. See LICENSE.md for licensing information.
$(PLUGIN_HEADER)

PKG := gettext

$(PKG)_VERSION  := 0.20.1
$(PKG)_CHECKSUM := 53f02fbbec9e798b0faaf7c73272f83608e835c6288dd58be6c9bb54624a3800
$(PKG)_SUBDIR   := gettext-$($(PKG)_VERSION)
$(PKG)_FILE     := gettext-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://ftp.gnu.org/gnu/gettext/$($(PKG)_FILE)
$(PKG)_URL_2    := https://ftpmirror.gnu.org/gettext/$($(PKG)_FILE)
$(PKG)_PATCHES  := $(dir $(lastword $(MAKEFILE_LIST)))/$(PKG)-1.patch

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
