# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtconnectivity
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 652821dc6819658ec4bc1a6bf149fd7a61008748ff4745b54f038ccf276d3ec9
$(PKG)_SUBDIR    = $(subst qtbase,qtconnectivity,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtconnectivity,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtconnectivity,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase qtdeclarative

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
