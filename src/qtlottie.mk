# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtlottie
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := dae5a5e650c831a36b342b43863677673ec37fa7dc2f4acc51b4d30ca1cc1490
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
