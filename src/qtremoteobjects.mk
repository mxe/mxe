# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtremoteobjects
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 0940d0a4a961b64f38c52a2e5638c2b3341fe46bd6bd88d1c638707f42159d5f
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
