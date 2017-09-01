# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := make-w32-bin
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.2.1
$(PKG)_CHECKSUM := 30641be9602712be76212b99df7209f4f8f518ba764cf564262bc9d6e4047cc7
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
