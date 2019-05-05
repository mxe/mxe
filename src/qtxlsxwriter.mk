# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtxlsxwriter
$(PKG)_WEBSITE  := https://github.com/VSRonin/QtXlsxWriter/
$(PKG)_DESCR    := QtXlsxWriter
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 9ba6f64
$(PKG)_CHECKSUM := f1373d28337e514da07ca4a58f3a968118f4a539593055b7df08446b92ef65ae
$(PKG)_GH_CONF  := VSRonin/QtXlsxWriter/branches/master
$(PKG)_DEPS     := cc qtbase

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
