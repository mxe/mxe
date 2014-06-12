# This file is part of MXE.
# See index.html for further information.
PKG             := qtsystems
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2bbccf8ca1a4ba7e39413982986bc02d55e936be
$(PKG)_CHECKSUM := d351adbd503008f1981e48f7f3cd7651778ebd48
$(PKG)_SUBDIR   := qt-$(PKG)
$(PKG)_FILE     := $($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://qt.gitorious.org/qt/qtsystems/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qtbase qtdeclarative qtxmlpatterns

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package qtsystems.' >&2;
    echo $(qtsystems_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/syncqt.pl' -version 5.4.0
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
