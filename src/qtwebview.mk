# This file is part of MXE.
# See index.html for further information.

PKG             := qtwebview
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := a48fa53e9e012102774c3faa6c99113918442f891952cd97ef67e05544800b57
$(PKG)_SUBDIR    = $(subst qtbase,qtwebview,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtwebview,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtwebview,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
