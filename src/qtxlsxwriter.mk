# This file is part of MXE.
# See index.html for further information.
PKG             := qtxlsxwriter
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := fe3fbb23eb878b7a85e40805f3525f0a277b5570
$(PKG)_CHECKSUM := 5d759f2b0faa2fea9d77e2f0d5733302fbf33958
$(PKG)_SUBDIR   := QtXlsxWriter-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/dbzhang800/QtXlsxWriter/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc qtbase

$(PKG)_UPDATE    = $(call MXE_GET_GITHUB_SHA, dbzhang800/QtXlsxWriter, master)

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef

