# This file is part of MXE.
# See index.html for further information.

PKG             := qtserialport_qt4
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5c3b6cc770
$(PKG)_CHECKSUM := 4e0bee3bd608b67e47dfbf2baa7f5ed7d9e39a3da16e4cc6056ffd0a4baa1495
$(PKG)_GH_USER  := qtproject
$(PKG)_GH_REPO  := qtserialport
$(PKG)_GH_TREE  := qt4-dev
$(PKG)_SUBDIR   := $($(PKG)_GH_USER)-$($(PKG)_GH_REPO)-$(call substr,$($(PKG)_VERSION),1,7)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/$($(PKG)_GH_USER)/$($(PKG)_GH_REPO)/tarball/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qt

$(PKG)_UPDATE   := $(call MXE_GET_GITHUB_SHA, $($(PKG)_GH_USER)/$($(PKG)_GH_REPO), $($(PKG)_GH_TREE))

define $(PKG)_BUILD_SHARED
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
