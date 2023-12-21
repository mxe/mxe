# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtquick3d
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := df71f11bf032e3ddbba777ecedf159a5b7cccc48147801f22e64ecb224447af3
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
