# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtscript
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 9c44e1fd294989ae62b1e452c25fd15574042e84e1377b59cd9ec67241428000
$(PKG)_SUBDIR    = $(subst qtbase,qtscript,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtscript,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtscript,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
