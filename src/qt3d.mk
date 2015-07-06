# This file is part of MXE.
# See index.html for further information.
PKG             := qt3d
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := bcdbf04b74cc7ded4d7b2471347f51b54ff8584b
$(PKG)_CHECKSUM := c9c36e6a04553bf4fb360c7c3d54282ebd4041b5
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := qt-$(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/qtproject/qt3d/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc qtbase qtdeclarative

$(PKG)_UPDATE    = $(call MXE_GET_GITHUB_SHA, qtproject/qt3d, master)

define $(PKG)_BUILD
    # invoke qmake with removed debug options as a workaround for
    # https://bugreports.qt-project.org/browse/QTBUG-30898
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake' CONFIG+=git_build CONFIG-='debug debug_and_release'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
