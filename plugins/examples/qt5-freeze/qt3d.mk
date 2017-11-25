# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qt3d
$(PKG)_WEBSITE  := http://qt-project.org/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 1d74cf431777b8086d771ab0d4d2c01f9c28eb14cc2d73d7f838a665d1f707ea
$(PKG)_PATCHES  := $(realpath $(sort $(wildcard $(dir $(lastword $(MAKEFILE_LIST)))/$(PKG)-[0-9]*.patch)))
$(PKG)_SUBDIR    = $(subst qtbase,qt3d,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qt3d,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qt3d,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase qtdeclarative

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(QMAKE_EXECUTABLE) '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' || $(MAKE) -C '$(BUILD_DIR)' -j 1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
