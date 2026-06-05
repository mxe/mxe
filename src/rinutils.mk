# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := rinutils
$(PKG)_WEBSITE  := https://github.com/shlomif/rinutils
$(PKG)_DESCR    := Rinutils
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.10.3
$(PKG)_CHECKSUM := f9e527d37a6cc8c7b8870ada63caa24f32ab0d29fd1116df3ebb686583030955
$(PKG)_SUBDIR   := rinutils-$($(PKG)_VERSION)
$(PKG)_FILE     := rinutils-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://github.com/shlomif/rinutils/releases/download/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://api.github.com/repos/shlomif/rinutils/releases/latest' | \
    grep '"tag_name":' | \
    $(SED) -n 's,.*"tag_name": "\([0-9][^"]*\)".*,\1,p'
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
