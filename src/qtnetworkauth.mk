# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtnetworkauth
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := d445c4e0254f694864eccb69e1ef3ceecccd608e4608f9e292b91556a5acfbac
$(PKG)_SUBDIR    = $(subst qtbase,qtnetworkauth,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtnetworkauth,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtnetworkauth,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
