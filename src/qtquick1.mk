# This file is part of MXE.
# See index.html for further information.

PKG             := qtquick1
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.1.1
$(PKG)_CHECKSUM := 75e07675a9edf5bb096953e1f7646ff1af405dad
$(PKG)_SUBDIR   := $(PKG)-opensource-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-opensource-src-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://download.qt-project.org/official_releases/qt/5.1/$($(PKG)_VERSION)/submodules/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qtbase qtscript qtsvg qttools qtxmlpatterns

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
