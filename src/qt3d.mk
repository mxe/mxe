# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qt3d
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 9da82f1cc4b7d416d31ec96224c59d221473a48f6e579eef978f7d2e3932c674
$(PKG)_SUBDIR    = $(subst qtbase,qt3d,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qt3d,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qt3d,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase qtdeclarative qtgamepad

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)' || $(MAKE) -C '$(1)' -j  1
    $(MAKE) -C '$(1)' -j 1 install
endef
