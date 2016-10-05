# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtgamepad
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 5898f7bc002d0ac65b698043f24f3e2ff2bb7ca7735f43b74e37056c2db5663c
$(PKG)_SUBDIR    = $(subst qtbase,qtgamepad,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtgamepad,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtgamepad,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase qtdeclarative

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
