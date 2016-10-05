# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtserialport
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 5ce150d843a243854736489d4a71205a8ca8dc8f93626ec29d1aa7a249a08265
$(PKG)_SUBDIR    = $(subst qtbase,qtserialport,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtserialport,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtserialport,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
