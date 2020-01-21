# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtxlsxwriter
$(PKG)_WEBSITE  := https://github.com/VSRonin/QtXlsxWriter/
$(PKG)_DESCR    := QtXlsxWriter
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := d3bd83b
$(PKG)_CHECKSUM := 2191a30a99588befe5237add95393cbc5de60f8d4f184399cfc6d3e6b9843302
$(PKG)_GH_CONF  := VSRonin/QtXlsxWriter/branches/master
$(PKG)_DEPS     := cc qtbase

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
