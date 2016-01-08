# This file is part of MXE.
# See index.html for further information.

PKG             := waf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.17
$(PKG)_CHECKSUM := 63c53b03dd23afde1008dced06a011dad581d24392818c8069a40af99f6ac2b6
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://waf.io/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://waf.io/' | \
    $(SED) -n 's,.*waf-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD_$(BUILD)
    mkdir -p '$(PREFIX)/$(BUILD)/bin'
    cp '$(1)/waf' '$(PREFIX)/$(BUILD)/bin/waf'
endef
