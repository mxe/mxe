# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtserialport_qt4
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5c3b6cc770
$(PKG)_CHECKSUM := d49c1cd4bb47706561f52c07d6075bb9931700d3bcae656ef3b6d3db3eb014ab
$(PKG)_GH_USER  := qt
$(PKG)_GH_REPO  := qtserialport
$(PKG)_GH_TREE  := qt4-dev
$(PKG)_SUBDIR   := $($(PKG)_GH_USER)-$($(PKG)_GH_REPO)-$(call substr,$($(PKG)_VERSION),1,7)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/$($(PKG)_GH_USER)/$($(PKG)_GH_REPO)/tarball/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qt

$(PKG)_UPDATE   := $(call MXE_GET_GITHUB_SHA, $($(PKG)_GH_USER)/$($(PKG)_GH_REPO), $($(PKG)_GH_TREE))

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
    # install one of the test programs
    cp -f '$(1)/examples/serialport/cenumerator/release/cenumerator.exe' '$(PREFIX)/$(TARGET)/bin/test-qtserialport_qt4.exe'
endef
