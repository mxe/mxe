# This file is part of MXE.
# See index.html for further information.

PKG             := qtenginio
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = 1.6.0
$(PKG)_CHECKSUM := 627ddcfbbfc3ec1a83c9dbb5f24287b5cd6cb5d3b9d09af4d1c444c6ac147f0c
$(PKG)_SUBDIR   := $(PKG)-opensource-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-opensource-src-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := $(subst $(qtbase_FILE),$($(PKG)_FILE),$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    # invoke qmake with removed debug options as a workaround for
    # https://bugreports.qt-project.org/browse/QTBUG-30898
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake' CONFIG-='debug debug_and_release'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
