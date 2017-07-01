# This file is part of MXE. See LICENSE.md for licensing information.
PKG             := qtofficeopenxml
$(PKG)_WEBSITE  := https://github.com/dbzhang800/QtOfficeOpenXml/
$(PKG)_DESCR    := QtOfficeOpenXml
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 02dda4a46f92a843eaba5f5a021952860eadfe01
$(PKG)_CHECKSUM := 50f989b2af404e8a9a20b46b3ca4955093ad295cb61f0cfb42fa06480d1fbad2
$(PKG)_SUBDIR   := QtOfficeOpenXml-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/dbzhang800/QtOfficeOpenXml/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc qtbase

$(PKG)_UPDATE    = $(call MXE_GET_GITHUB_SHA, dbzhang800/QtOfficeOpenXml, master)

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
