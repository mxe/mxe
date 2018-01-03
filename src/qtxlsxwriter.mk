# This file is part of MXE. See LICENSE.md for licensing information.
PKG             := qtxlsxwriter
$(PKG)_WEBSITE  := https://github.com/dbzhang800/QtXlsxWriter/
$(PKG)_DESCR    := QtXlsxWriter
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6895d8ba6c3a80768c98539445b124654801e8dd
$(PKG)_CHECKSUM := fdf6a7c81e1b8f222770471158b067d3aa49dd2de426bd066b346f2c10bebfb9
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
