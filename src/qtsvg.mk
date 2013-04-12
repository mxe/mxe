# This file is part of MXE.
# See index.html for further information.

PKG             := qtsvg
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 5c08f333b14ebbc728867edd49c25e48ada3ea05
$(PKG)_SUBDIR   := $(PKG)-opensource-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-opensource-src-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://origin.releases.qt-project.org/qt5/$($(PKG)_VERSION)/submodules/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qtbase

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
