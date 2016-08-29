# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtpurchasing
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 7e514a3cb98addd0b1344a69c494afe4546d854d43340760aed00ad0062664b5
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
