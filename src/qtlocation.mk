# This file is part of MXE.
# See index.html for further information.

PKG             := qtlocation
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := c47e80c4282f96de843d90341f93cd0f48333284
$(PKG)_SUBDIR    = $(subst qtbase,qtlocation,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtlocation,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtlocation,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase qtdeclarative qtmultimedia

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef

