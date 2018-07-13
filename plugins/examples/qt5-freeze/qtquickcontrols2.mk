# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtquickcontrols2
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := f2e8acd0badbf604f28258b063c94ba71e28147c53c435ae9eb484497cf3e7ec
$(PKG)_PATCHES  := $(realpath $(sort $(wildcard $(dir $(lastword $(MAKEFILE_LIST)))/$(PKG)-[0-9]*.patch)))
$(PKG)_SUBDIR    = $(subst qtbase,qtquickcontrols2,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtquickcontrols2,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtquickcontrols2,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase qtdeclarative

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    $(QMAKE_MAKE_INSTALL)
endef
