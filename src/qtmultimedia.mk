# This file is part of MXE.
# See index.html for further information.

PKG             := qtmultimedia
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 0c686a2174c02e27bbf912a16b2939bf8b3e873d
$(PKG)_SUBDIR    = $(subst qtbase,qtmultimedia,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtmultimedia,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtmultimedia,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
