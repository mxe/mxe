# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtactiveqt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 0c09920de273fa12e40f6486a4715267e2fe54991303b6ddfdac69fe9a24a1d5
$(PKG)_SUBDIR    = $(subst qtbase,qtactiveqt,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtactiveqt,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtactiveqt,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
