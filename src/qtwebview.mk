# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtwebview
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 801a3faf312fa0235d489c63aa224d477a70cfe1b1ef7803cbe311a8c29e51c4
$(PKG)_SUBDIR    = $(subst qtbase,qtwebview,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtwebview,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtwebview,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
