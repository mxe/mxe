# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtscxml
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 370b13d76c9a2ddf05336e797edf7f54d41db6063e3b921e0825dd6dd26c51f1
$(PKG)_SUBDIR    = $(subst qtbase,qtscxml,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtscxml,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtscxml,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase qtdeclarative

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
