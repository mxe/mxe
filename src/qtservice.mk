# This file is part of MXE.
# See index.html for further information.
PKG             := qtservice
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := fd22bee
$(PKG)_CHECKSUM := 0d83dc54d692da3557213144140e74a63a6f4911
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

$(PKG)_BUILD_i686-pc-mingw32 =
