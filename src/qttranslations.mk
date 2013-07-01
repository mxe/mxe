# This file is part of MXE.
# See index.html for further information.

PKG             := qttranslations
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := b0fd6a6b919a80f63e2ed733cd74b4f3e245ed17
$(PKG)_SUBDIR   := $(PKG)-opensource-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-opensource-src-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://download.qt-project.org/development_releases/qt/5.1/$($(PKG)_VERSION)/submodules/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qtbase qttools

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
