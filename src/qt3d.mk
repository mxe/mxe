# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qt3d
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 1d74cf431777b8086d771ab0d4d2c01f9c28eb14cc2d73d7f838a665d1f707ea
$(PKG)_SUBDIR    = $(subst qtbase,qt3d,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qt3d,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qt3d,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase qtdeclarative

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)' || $(MAKE) -C '$(1)' -j  1
    $(MAKE) -C '$(1)' -j 1 install
endef
