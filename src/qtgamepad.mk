# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtgamepad
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 3d9835538afe7299e42d53a7bb85fb90aecdc714846671582139ff80d752a657
$(PKG)_SUBDIR    = $(subst qtbase,qtgamepad,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtgamepad,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtgamepad,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase qtdeclarative

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
