# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtpurchasing
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 7884c5bfca7aaafaf9393a6dfc3789fa0fcbbc88c242771cc4cd378989509375
$(PKG)_SUBDIR    = $(subst qtbase,qtpurchasing,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtpurchasing,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtpurchasing,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase qtdeclarative

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
