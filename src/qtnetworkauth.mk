# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtnetworkauth
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 6ad3083e2bb61f7f265932d9521b5b8cb156b18bae9eead71f7c8bb0d4d59c86
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
