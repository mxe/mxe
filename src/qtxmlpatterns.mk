# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtxmlpatterns
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 38882a4ea5d711be07d10695759359045f7f9d64727a65e1d5e6515d55c7e20b
$(PKG)_SUBDIR    = $(subst qtbase,qtxmlpatterns,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtxmlpatterns,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtxmlpatterns,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
