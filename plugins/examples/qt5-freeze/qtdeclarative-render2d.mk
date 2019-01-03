# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtdeclarative-render2d
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 831913488bb887993ae8701e5966f53875667a774c0230fc5dc39d6077828c7f
$(PKG)_PATCHES  := $(realpath $(sort $(wildcard $(dir $(lastword $(MAKEFILE_LIST)))/$(PKG)-[0-9]*.patch)))
$(PKG)_SUBDIR    = $(subst qtbase,qtdeclarative-render2d,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtdeclarative-render2d,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtdeclarative-render2d,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase qtdeclarative

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    $(QMAKE_MAKE_INSTALL)
endef
