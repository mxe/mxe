# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qttools
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 7947bdd758514a0c2d44b0a2110adb6056b18bce75c716711e48bcc8de5c7e82
$(PKG)_SUBDIR    = $(subst qtbase,qttools,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qttools,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qttools,$(qtbase_URL))
$(PKG)_DEPS     := cc qtactiveqt qtbase qtdeclarative
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)

$(PKG)_TEST_DIR := $(dir $(lastword $(MAKEFILE_LIST)))/qttools-test

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install

    # test QUiLoader
    mkdir '$(1)'.test
    cd '$(1)'.test && '$(TARGET)-cmake' '$($(PKG)_TEST_DIR)'
    $(MAKE) -C '$(1)'.test
    cp '$(1)'.test/mxe-cmake-qtuitools.exe \
        '$(PREFIX)/$(TARGET)/bin/test-qttools.exe'
endef

define $(PKG)_BUILD_$(BUILD)
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
