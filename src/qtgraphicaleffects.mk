# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtgraphicaleffects
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 81058fb12d4dd019bed6bb196a13ea5d308a390d72a1468da11171f8c3003455
$(PKG)_SUBDIR    = $(subst qtbase,qtgraphicaleffects,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtgraphicaleffects,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtgraphicaleffects,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase qtdeclarative

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
