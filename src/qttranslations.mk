# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qttranslations
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 0a0ed428f6a3a01b49c80e0d2b80199f66d77578588d2929923097c77c795a6d
$(PKG)_SUBDIR    = $(subst qtbase,qttranslations,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qttranslations,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qttranslations,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase qttools

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef

