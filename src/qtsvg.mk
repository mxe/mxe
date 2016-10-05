# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtsvg
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := a1f89f035aed48bf8843ff1880c4b54dc2e3a5160dbd743aec03e13831cdd881
$(PKG)_SUBDIR    = $(subst qtbase,qtsvg,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtsvg,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtsvg,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
