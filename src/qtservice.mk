# This file is part of MXE.
# See index.html for further information.
PKG             := qtservice
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 38e79e3
$(PKG)_VERSION  := 25e2cbb
$(PKG)_CHECKSUM := b23cac6e92991424c4813b9900241f13715fdb7a
$(PKG)_SUBDIR   := qtproject-qt-solutions-$($(PKG)_VERSION)
$(PKG)_FILE     := qt-solutions-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/qtproject/qt-solutions/tarball/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qtbase

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package qtservice.' >&2;
    echo $(qtservice_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)/qtservice/buildlib' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)/qtservice/buildlib' -j '$(JOBS)'
    $(MAKE) -C '$(1)/qtservice/buildlib' -j 1 install
endef

