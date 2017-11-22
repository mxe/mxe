# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtcanvas3d
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 5e38b17844af801be57844da0379cc6882750b9019034f4fe884aae70c300abc
$(PKG)_SUBDIR    = $(subst qtbase,qtcanvas3d,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtcanvas3d,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtcanvas3d,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase qtdeclarative

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
