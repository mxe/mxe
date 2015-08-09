# This file is part of MXE.
# See index.html for further information.
PKG             := qtservice
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := ad9bc46
$(PKG)_CHECKSUM := 19bb657cc6ea2ef2b35e8d823c6d76d300d4faeb
$(PKG)_SUBDIR   := qtproject-qt-solutions-$($(PKG)_VERSION)
$(PKG)_FILE     := qt-solutions-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/qtproject/qt-solutions/tarball/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qtbase

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package qtservice.' >&2;
    echo $(qtservice_VERSION)
endef

define $(PKG)_BUILD
    # invoke qmake with removed debug options as a workaround for
    # https://bugreports.qt-project.org/browse/QTBUG-30898
    cd '$(1)/qtservice/buildlib' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake' CONFIG-='debug debug_and_release'
    $(MAKE) -C '$(1)/qtservice/buildlib' -j '$(JOBS)'
    $(MAKE) -C '$(1)/qtservice/buildlib' -j 1 install
endef
