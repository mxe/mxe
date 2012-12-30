# This file is part of MXE.
# See index.html for further information.

PKG             := qtscript
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 32da5598e71b81e6b83d288adc3c90d9bd5bed37
$(PKG)_SUBDIR   := $(PKG)-opensource-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-opensource-src-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://releases.qt-project.org/qt5/$($(PKG)_VERSION)/submodules_tar/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qtbase

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package qtscript.' >&2;
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
