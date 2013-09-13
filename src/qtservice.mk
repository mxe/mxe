# This file is part of MXE.
# See index.html for further information.
PKG             := qtservice
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4ac977553f2b04a54feb74ebcbc90ef255d38895
$(PKG)_CHECKSUM := b3a185696066dc8f1792de83aa8d7187fb416580
$(PKG)_SUBDIR   := qt-solutions-qt-solutions
$(PKG)_FILE     := $($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://qt.gitorious.org/qt-solutions/qt-solutions/archive/$($(PKG)_FILE)
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
