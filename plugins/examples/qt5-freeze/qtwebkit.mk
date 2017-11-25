# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtwebkit
$(PKG)_WEBSITE  := http://qt-project.org/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := a46cf7c89339645f94a5777e8ae5baccf75c5fc87ab52c9dafc25da3327b5f03
$(PKG)_PATCHES  := $(realpath $(sort $(wildcard $(dir $(lastword $(MAKEFILE_LIST)))/$(PKG)-[0-9]*.patch)))
$(PKG)_SUBDIR    = $(subst qtbase,qtwebkit,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtwebkit,$(qtbase_FILE))
$(PKG)_URL       = $(subst /submodules/,/,$(subst official_releases/qt,community_releases,$(subst qtbase,qtwebkit,$(qtbase_URL))))
$(PKG)_DEPS     := cc qtbase qtmultimedia sqlite

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD_SHARED
    # looks for build tools with .exe suffix and tries to use win_flex
    $(SED) -i 's,\.exe,,' '$(SOURCE_DIR)/Tools/qmake/mkspecs/features/functions.prf'
    cd '$(BUILD_DIR)' && mkdir -p .git && $(QMAKE_EXECUTABLE) FLEX=flex '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
