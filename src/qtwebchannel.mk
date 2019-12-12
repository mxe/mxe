# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtwebchannel
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 0cb8dd07b34da8d44f8a14701409ce87fce5010f9b57273b357717c2dfd35383
$(PKG)_SUBDIR    = $(subst qtbase,qtwebchannel,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtwebchannel,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtwebchannel,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase qtdeclarative qtwebsockets

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
