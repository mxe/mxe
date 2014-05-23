# This file is part of MXE.
# See index.html for further information.
PKG             := qtsystems
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3b3b759c6ccd65eb6251fca68e5618c5ed8b6dd5
$(PKG)_CHECKSUM := 1b606f7f4c884afaa6b33c46b4fc19d94b07cd90
$(PKG)_SUBDIR   := qt-$(PKG)
$(PKG)_FILE     := $($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://qt.gitorious.org/qt/qtsystems/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qtbase qtdeclarative qtxmlpatterns

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package qtsystems.' >&2;
    echo $(qtsystems_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/syncqt.pl' -version $(qtbase_VERSION)
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
