# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtquick3d
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := a18ce5549f9d7a3c313385733eae7fe7b501d74a450c2515f887c671a9fa3457
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
