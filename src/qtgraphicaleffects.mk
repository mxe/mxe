# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtgraphicaleffects
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 31d73a252f8d1dfce910521fa3857188f53fe3871092af8cdd2ad09469e0899c
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
