# This file is part of MXE.
# See index.html for further information.

PKG             := qttranslations
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 16935409b4eea4de6c03481d60f35bcc15162e17
$(PKG)_SUBDIR   := $(PKG)-opensource-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-opensource-src-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://releases.qt-project.org/qt5/$($(PKG)_VERSION)-rc1/submodules_tar/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qtbase qttools

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
