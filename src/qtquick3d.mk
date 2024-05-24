# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtquick3d
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := b42527d62e6d52f2fb8db75bd55b083ac753668fd5d1c66c7854d9f5f62a87e9
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
