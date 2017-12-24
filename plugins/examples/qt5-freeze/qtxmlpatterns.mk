# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtxmlpatterns
$(PKG)_WEBSITE  := http://qt-project.org/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := a805938c2ab1379d7dc83dcec606edd7950b5155c073b9eb53c53e62deb5f8e5
$(PKG)_PATCHES  := $(realpath $(sort $(wildcard $(dir $(lastword $(MAKEFILE_LIST)))/$(PKG)-[0-9]*.patch)))
$(PKG)_SUBDIR    = $(subst qtbase,qtxmlpatterns,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtxmlpatterns,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtxmlpatterns,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    $(QMAKE_MAKE_INSTALL)
endef
