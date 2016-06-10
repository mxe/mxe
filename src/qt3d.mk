# This file is part of MXE.
# See index.html for further information.
PKG             := qt3d
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := bcdbf04b74cc7ded4d7b2471347f51b54ff8584b
$(PKG)_CHECKSUM := 7e5e553f0132bc801f11f318f58b4fe3b8b1fd930f4acc23e97757fb6c76049c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := qt-$(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/qtproject/qt3d/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc qtbase qtdeclarative

$(PKG)_UPDATE    = $(call MXE_GET_GITHUB_SHA, qtproject/qt3d, master)

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake' CONFIG+=git_build
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
