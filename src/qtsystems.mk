# This file is part of MXE.
# See index.html for further information.
PKG             := qtsystems
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 32e6573
$(PKG)_VERSION  := 37b614a
$(PKG)_CHECKSUM := eba4177015dc02fb438dd28a8d2b80650d805048
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
    # invoke qmake with removed debug options as a workaround for
    # https://bugreports.qt-project.org/browse/QTBUG-30898
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake' CONFIG-='debug debug_and_release'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
