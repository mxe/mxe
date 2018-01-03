# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := keepassx
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.4.3
$(PKG)_CHECKSUM := cd901a0611ce57e62cf6df7eeeb1b690b5232302bdad8626994eb54adcfa1e85
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.keepassx.org/releases/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_WEBSITE  := https://www.keepassx.org
$(PKG)_OWNER    := https://github.com/starius
$(PKG)_DEPS     := cc qt

define $(PKG)_UPDATE
$(WGET) -q -O- 'https://www.keepassx.org/downloads/' | \
    $(SED) -n 's,.*keepassx-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(TARGET)-qmake-qt4' \
        "PREFIX=$(PREFIX)/$(TARGET)/bin/"
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
