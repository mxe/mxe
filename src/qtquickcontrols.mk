# This file is part of MXE.
# See index.html for further information.

PKG             := qtquickcontrols
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 4ee9ad4dc0136b022d1d818e5ec8fca9f9d450ae
$(PKG)_SUBDIR    = $(subst qtbase,qtquickcontrols,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtquickcontrols,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtquickcontrols,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase qtdeclarative

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
