# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := make-w32-bin
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.2
$(PKG)_CHECKSUM := 6cab11301e601996ab0cb7b3b903e5a55d5bd795614946cf6bd025cd61c710c6
$(PKG)_SUBDIR   := .
$(PKG)_FILE     := make-$($(PKG)_VERSION)-without-guile-w32-bin.zip
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/ezwinports/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/ezwinports/files/' | \
    $(SED) -n 's,.*/make-\([0-9.]*\)-without-guile.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cp '$(1)/bin/'* '$(PREFIX)/$(TARGET)/bin/'
    cp '$(1)/lib/'* '$(PREFIX)/$(TARGET)/lib/'
endef
