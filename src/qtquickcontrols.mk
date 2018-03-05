# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtquickcontrols
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := d231a1993dc6a3f0dbc60a21d01fc0be15b0c26e881bd0631573952ea61682b7
$(PKG)_SUBDIR    = $(subst qtbase,qtquickcontrols,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtquickcontrols,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtquickcontrols,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase qtdeclarative

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
