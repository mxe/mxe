# This file is part of MXE.
# See index.html for further information.

PKG             := qtscript
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 4cfa13724e9957dbbee19c6dffa8a5b1c33d0e05
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
