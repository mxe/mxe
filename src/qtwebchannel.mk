# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtwebchannel
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 3ab4cd177cc742ee5015f2b7f943c16ce13380b840f824436b5005485b749816
$(PKG)_SUBDIR    = $(subst qtbase,qtwebchannel,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtwebchannel,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtwebchannel,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase qtdeclarative qtwebsockets

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
