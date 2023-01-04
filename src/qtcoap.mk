# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtcoap
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 1b970b163ba6e89e4087e1ac4faa8c8f078da655f29d3aea6a80919e9e43d102
$(PKG)_SUBDIR    = $(subst qtbase,qtcoap,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtcoap,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtcoap,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
