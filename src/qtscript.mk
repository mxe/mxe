# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtscript
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := b6feb447f41dea3967f07bdae0aa0d6be264bc4b5c0f3e20e7867425e1de9f3b
$(PKG)_SUBDIR    = $(subst qtbase,qtscript,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtscript,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtscript,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
