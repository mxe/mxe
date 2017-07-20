# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtquickcontrols
$(PKG)_WEBSITE  := http://qt-project.org/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 6feb1a736bf93af98c40d04cde6b36c113e4cdf84ccb9b306ca92ef9b1779e9d
$(PKG)_PATCHES  := $(realpath $(sort $(wildcard $(dir $(lastword $(MAKEFILE_LIST)))/$(PKG)-[0-9]*.patch)))
$(PKG)_SUBDIR    = $(subst qtbase,qtquickcontrols,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtquickcontrols,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtquickcontrols,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase qtdeclarative

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
