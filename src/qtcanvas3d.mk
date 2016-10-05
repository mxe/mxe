# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtcanvas3d
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 7871b3fd4c1a561c5b3eb57746e8504bc5d8fa626f9df578e619f9e823e3bd97
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
