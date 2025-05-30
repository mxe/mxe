# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtlottie
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 5a4504de7367c3ae78223de29ecb24ec15429f699898cce84e9c077e0d31cd4f
$(PKG)_SUBDIR    = $(subst qtbase,qtlottie,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtlottie,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtlottie,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase qtdeclarative

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
