# This file is part of MXE.
# See index.html for further information.

PKG             := qtsensors
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 7750d4f9220dcf042ba578971c0312de1e71ad7c
$(PKG)_SUBDIR    = $(subst qtbase,qtsensors,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtsensors,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtsensors,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
