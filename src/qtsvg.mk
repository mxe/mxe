# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtsvg
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 409e8845c28412041c36f559a7a6e2414f3d9a8dd45c5a85065e279b788e07ab
$(PKG)_SUBDIR    = $(subst qtbase,qtsvg,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtsvg,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtsvg,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
