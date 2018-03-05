# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtactiveqt
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 9021ab7e34b10b30a80d6f5e2474afa8faea10792867d459b53dd11ba23891e4
$(PKG)_SUBDIR    = $(subst qtbase,qtactiveqt,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtactiveqt,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtactiveqt,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
