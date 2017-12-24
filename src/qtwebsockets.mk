# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtwebsockets
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 17ab0fa22007e5485bf98cb5fef5387628274548d5e96923f45d097838f49403
$(PKG)_SUBDIR    = $(subst qtbase,qtwebsockets,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtwebsockets,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtwebsockets,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
