# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := docbook-xsl
$(PKG)_VERSION  := 1.79.2
$(PKG)_CHECKSUM := 316524ea444e53208a2fb90eeb676af755da96e1417835ba5f5eb719c81fa371
$(PKG)_SUBDIR   := docbook-xsl-$($(PKG)_VERSION)
$(PKG)_FILE     := docbook-xsl-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://github.com/docbook/xslt10-stylesheets/releases/download/release%2F$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS_$(BUILD) :=

define $(PKG)_BUILD_$(BUILD)
    mkdir -p '$(PREFIX)/$(TARGET)/share/xml/docbook/xsl-stylesheets'
    cp -r '$(SOURCE_DIR)'/* '$(PREFIX)/$(TARGET)/share/xml/docbook/xsl-stylesheets/'
endef

define $(PKG)_BUILD
    $($(PKG)_BUILD_$(BUILD))
endef
