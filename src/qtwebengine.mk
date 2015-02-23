# This file is part of MXE.
# See index.html for further information.

PKG             := qtwebengine
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := a98b0223ec941ac278b3a6b622d6877929c05185
$(PKG)_SUBDIR    = $(subst qtbase,qtwebengine,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtwebengine,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtwebengine,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase qtquickcontrols qtwebkit

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef

