# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtquick3d
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 6db37612f9a37d0fa6e8af302411f058b1fdd73c8bc9be1ba18b7f765f81d893
$(PKG)_SUBDIR    = $(subst qtbase,qtquick3d,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtquick3d,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtquick3d,$(qtbase_URL))
$(PKG)_DEPS     := cc assimp qtbase qtdeclarative

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
