# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtpurchasing
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 2127f180c4889055d88e2b402b62be80a5a213a0e48d2056cc9a01d9913b3a16
$(PKG)_SUBDIR    = $(subst qtbase,qtpurchasing,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtpurchasing,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtpurchasing,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase qtdeclarative

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
