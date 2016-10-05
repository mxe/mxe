# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtwinextras
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 8dabe231a4fdaa74acc2f79a44391a49ef779db8d0acf41cbb29f2c71d9e07ba
$(PKG)_SUBDIR    = $(subst qtbase,qtwinextras,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtwinextras,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtwinextras,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase qtdeclarative qtmultimedia

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
