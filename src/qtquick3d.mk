# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtquick3d
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 1dfe98c5ec69f7a282c8d6bf129cdcc6153873bd2f1b2bf2ca20568dea3a692c
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
