# This file is part of MXE.
# See index.html for further information.

PKG             := qtserialport
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := c87b381d6a0b6445c7fab54ef2807a555bfbcb47
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

