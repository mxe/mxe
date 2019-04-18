# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtxlsxwriter
$(PKG)_WEBSITE  := https://github.com/VSRonin/QtXlsxWriter/
$(PKG)_DESCR    := QtXlsxWriter
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 061567b
$(PKG)_CHECKSUM := c1df9518839111bdc33f4265b86565b2c29244707a03f23227cb8d4e6af9430f
$(PKG)_GH_CONF  := VSRonin/QtXlsxWriter/branches/master
$(PKG)_DEPS     := cc qtbase

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
