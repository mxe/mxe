# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtdeclarative-render2d
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 0613298f653b147bb3c26d0f0ee0bb95fec74894d07575f1953e8a7fe248c8e1
$(PKG)_SUBDIR    = $(subst qtbase,qtdeclarative-render2d,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtdeclarative-render2d,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtdeclarative-render2d,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase qtdeclarative

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
