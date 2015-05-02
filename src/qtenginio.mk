# This file is part of MXE.
# See index.html for further information.

PKG             := qtenginio
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 35da0343762a6aa7ded2c62aa4b36e77152a9240
$(PKG)_SUBDIR    = $(subst qtbase,qtenginio,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtenginio,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtenginio,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef

