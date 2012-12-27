# This file is part of MXE.
# See index.html for further information.

PKG             := qtmultimedia
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 33fc39b177aeba6863a28c5d45cd2175b2faedc2
$(PKG)_SUBDIR   := $(PKG)-opensource-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-opensource-src-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://releases.qt-project.org/qt5/$($(PKG)_VERSION)/submodules_tar/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qtbase

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package qtmultimedia.' >&2;
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef

$(PKG)_BUILD_i686-static-mingw32    = $($(PKG)_BUILD)
$(PKG)_BUILD_x86_64-static-mingw32  = $($(PKG)_BUILD)
$(PKG)_BUILD_i686-dynamic-mingw32   = $($(PKG)_BUILD)
$(PKG)_BUILD_x86_64-dynamic-mingw32 = $($(PKG)_BUILD)
