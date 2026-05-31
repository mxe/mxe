# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := docbook-xml
$(PKG)_VERSION  := 4.5
$(PKG)_CHECKSUM := 4e4e037a2b83c98c6c94818390d4bdd3f6e10f6ec62dd79188594e26190dc7b4
$(PKG)_SUBDIR   := .
$(PKG)_FILE     := docbook-xml-$($(PKG)_VERSION).zip
$(PKG)_URL      := https://archive.docbook.org/xml/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS_$(BUILD) :=

define $(PKG)_BUILD_$(BUILD)
    mkdir -p '$(PREFIX)/$(TARGET)/share/xml/docbook/schema/dtd/$($(PKG)_VERSION)'
    cp -r '$(SOURCE_DIR)'/* '$(PREFIX)/$(TARGET)/share/xml/docbook/schema/dtd/$($(PKG)_VERSION)/'
endef

define $(PKG)_BUILD
    $($(PKG)_BUILD_$(BUILD))
endef
