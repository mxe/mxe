# This file is part of MXE.
# See index.html for further information.

PKG             := qtmultimedia
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.1.1
$(PKG)_CHECKSUM := bae589a9749d388b2503ad3174c7ac9b3baa0b2b
$(PKG)_SUBDIR   := $(PKG)-opensource-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-opensource-src-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://download.qt-project.org/official_releases/qt/5.1/$($(PKG)_VERSION)/submodules/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qtbase

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
