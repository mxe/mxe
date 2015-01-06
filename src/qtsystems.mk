# This file is part of MXE.
# See index.html for further information.
PKG             := qtsystems
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 32e6573
$(PKG)_CHECKSUM := a36520f065948c6066e8e539ff4e67ad490a5af7
$(PKG)_SUBDIR   := qtproject-$(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/qtproject/qtsystems/tarball/$($(PKG)_VERSION)/$($(PKG)_FILE)
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

