# This file is part of MXE. See LICENSE.md for licensing information.
PKG             := qtxlsxwriter
$(PKG)_WEBSITE  := https://github.com/dbzhang800/QtXlsxWriter/
$(PKG)_DESCR    := QtXlsxWriter
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 37ef9dae209f989ed07f3aec37d5fbd1c821335c
$(PKG)_CHECKSUM := e1cf5ecb51e048ee4531362b08ff844147a63d0fb2ba568ce29c8ff2b037a42f
$(PKG)_SUBDIR   := QtXlsxWriter-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/VSRonin/QtXlsxWriter/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc qtbase

$(PKG)_UPDATE    = $(call MXE_GET_GITHUB_SHA, VSRonin/QtXlsxWriter, master)

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
