# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtlocation
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := c68b0778a521e5522641c41b1778999dd408ebfda1e0de166a83743268be5f3f
$(PKG)_SUBDIR    = $(subst qtbase,qtlocation,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtlocation,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtlocation,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase qtdeclarative qtmultimedia

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
