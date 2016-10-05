# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtquickcontrols2
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 63f5b0777992c32bd602b88de657e202cd6d5e8ba0371c6d5da16fb8c7481045
$(PKG)_SUBDIR    = $(subst qtbase,qtquickcontrols2,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtquickcontrols2,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtquickcontrols2,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase qtdeclarative

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
