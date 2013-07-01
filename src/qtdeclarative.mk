# This file is part of MXE.
# See index.html for further information.

PKG             := qtdeclarative
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 08263cd9939c743dfc4213bb7975ed2bad425c21
$(PKG)_SUBDIR   := $(PKG)-opensource-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-opensource-src-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://download.qt-project.org/development_releases/qt/5.1/$($(PKG)_VERSION)/submodules/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qtbase qtjsbackend qtsvg qtxmlpatterns

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
