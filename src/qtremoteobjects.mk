# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtremoteobjects
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := a70ecc92c4939761d59001b19969542154c036041b44d273369cb47e8795a853
$(PKG)_SUBDIR    = $(subst qtbase,qtremoteobjects,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtremoteobjects,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtremoteobjects,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase qtdeclarative

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
