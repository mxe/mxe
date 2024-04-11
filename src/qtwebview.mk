# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtwebview
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 49c85ab1209f5ade9e7b5642a1ba3e92e123a694e32f24d63829c00366d8c084
$(PKG)_SUBDIR    = $(subst qtbase,qtwebview,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtwebview,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtwebview,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase qtdeclarative

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
