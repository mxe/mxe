# This file is part of MXE.
# See index.html for further information.

PKG             := qtwebchannel
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 7a27eac0bead6e60b5faaf360a6236dd96013c12
$(PKG)_SUBDIR    = $(subst qtbase,qtwebchannel,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtwebchannel,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtwebchannel,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase qtdeclarative qtwebsockets

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef

