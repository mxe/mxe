# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtgraphicaleffects
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 297a89bb6c771f849c4ce866e5c98dadf665163b3dab03bc48a58f51424e7e66
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
