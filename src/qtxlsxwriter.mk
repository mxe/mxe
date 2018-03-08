# This file is part of MXE. See LICENSE.md for licensing information.
PKG             := qtxlsxwriter
$(PKG)_WEBSITE  := https://github.com/dbzhang800/QtXlsxWriter/
$(PKG)_DESCR    := QtXlsxWriter
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 779555d253f797a2dc9a71ba800e541968269ff9
$(PKG)_CHECKSUM := 229aeba2cbe54fe7ef798be1d197eeff06c3021bd6d3af8faa2cfb334df75526
$(PKG)_SUBDIR   := QtXlsxWriter-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/VSRonin/QtXlsxWriter/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc qtbase

$(PKG)_UPDATE    = $(call MXE_GET_GITHUB_SHA, VSRonin/QtXlsxWriter, master)

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
