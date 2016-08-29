# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtcharts
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 2bc8a87375c7aeebde2e4cd2408c92c91ec3fed9e6e8b5fde789131b532d5243
$(PKG)_SUBDIR    = $(subst qtbase,qtcharts,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtcharts,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtcharts,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase qtdeclarative qtmultimedia

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
