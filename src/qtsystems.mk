# This file is part of MXE.
# See index.html for further information.
PKG             := qtsystems
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 341352b4bb1e729f384a3af1ca966ebd123f16e3
$(PKG)_CHECKSUM := f46c1a96363d7194b186d5fec7f6261ad64f9eea
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
