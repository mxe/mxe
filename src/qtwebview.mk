# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtwebview
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := b3bcf9693e0205263f5d227f2204cf12c3a3d1e200b3114723511ee3bdf2159f
$(PKG)_SUBDIR    = $(subst qtbase,qtwebview,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtwebview,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtwebview,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
