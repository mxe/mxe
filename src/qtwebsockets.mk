# This file is part of MXE.
# See index.html for further information.

PKG             := qtwebsockets
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := d0b7e62bbdd634de01d5321f94a4bdff8b228cf5
$(PKG)_SUBDIR    = $(subst qtbase,qtwebsockets,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtwebsockets,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtwebsockets,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef

