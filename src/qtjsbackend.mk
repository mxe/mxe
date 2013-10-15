# This file is part of MXE.
# See index.html for further information.

PKG             := qtjsbackend
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := e13a5ef112bdbe2fb1691d21c52b287a21da614a
$(PKG)_SUBDIR    = $(subst qtbase,qtjsbackend,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtjsbackend,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtjsbackend,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
