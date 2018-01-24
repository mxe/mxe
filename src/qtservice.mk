# This file is part of MXE. See LICENSE.md for licensing information.
PKG             := qtservice
$(PKG)_WEBSITE  := https://qt.gitorious.org/qt-solutions/
$(PKG)_DESCR    := Qt Solutions
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := ee17851
$(PKG)_CHECKSUM := 4c4cbfbe405b659df4422f7f024aa621de601b0269416206a35bfd6b758e98a0
$(PKG)_SUBDIR   := qtproject-qt-solutions-$($(PKG)_VERSION)
$(PKG)_FILE     := qt-solutions-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/qtproject/qt-solutions/tarball/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc qtbase

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package qtservice.' >&2;
    echo $(qtservice_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)/qtservice/buildlib' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)/qtservice/buildlib' -j '$(JOBS)'
    $(MAKE) -C '$(1)/qtservice/buildlib' -j 1 install
endef
