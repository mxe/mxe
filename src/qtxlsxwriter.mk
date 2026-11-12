# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtxlsxwriter
$(PKG)_WEBSITE  := https://github.com/VSRonin/QtXlsxWriter/
$(PKG)_DESCR    := QtXlsxWriter
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.2.2
$(PKG)_CHECKSUM := 2424533f0c8a1c934a1b8bd18a0ff3468d5cd070d217736db5fa0c03482a4946
$(PKG)_GH_CONF  := VSRonin/QtXlsxWriter/tags,v,,doc
$(PKG)_DEPS     := cc qtbase

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
