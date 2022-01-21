# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qt6-qtservice
$(PKG)_WEBSITE  := https://qt.gitorious.org/qt-solutions/
$(PKG)_DESCR    := Qt Solutions
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := $($(subst qt6-,,$(PKG))_VERSION)
$(PKG)_SUBDIR   := $($(subst qt6-,,$(PKG))_SUBDIR)
$(PKG)_FILE     := $($(subst qt6-,,$(PKG))_FILE)
$(PKG)_URL      := $($(subst qt6-,,$(PKG))_URL)
$(PKG)_CHECKSUM := $($(subst qt6-,,$(PKG))_CHECKSUM)
$(PKG)_DEPS     := cc qt6-qtbase

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package qtservice.' >&2;
    echo $(qtservice_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)/qtservice/buildlib' && '$(PREFIX)/$(TARGET)/qt6/bin/qmake'
    $(MAKE) -C '$(1)/qtservice/buildlib' -j '$(JOBS)'
    $(MAKE) -C '$(1)/qtservice/buildlib' -j 1 install
endef
