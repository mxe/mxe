# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtlottie
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 845987860c7990035a7cd9a0e7581d210f786e551882df8b5be69f08987f2ba0
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
