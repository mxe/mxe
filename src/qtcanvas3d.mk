# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtcanvas3d
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := c0821f1232c6bcd00648af9a5d1eade8e0397c6bfff60621e0fcdfc75561baea
$(PKG)_SUBDIR    = $(subst qtbase,qtcanvas3d,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtcanvas3d,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtcanvas3d,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase qtdeclarative

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
