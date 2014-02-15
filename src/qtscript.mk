# This file is part of MXE.
# See index.html for further information.

PKG             := qtscript
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 329290ebb443966cbd9443189ced39a933de88e2
$(PKG)_SUBDIR    = $(subst qtbase,qtscript,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtscript,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtscript,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
