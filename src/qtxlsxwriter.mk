# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtxlsxwriter
$(PKG)_WEBSITE  := https://github.com/dbzhang800/QtXlsxWriter/
$(PKG)_DESCR    := QtXlsxWriter
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 779555d
$(PKG)_CHECKSUM := b3e9917f253c9712ce5ea2d96bc5cd65ac647fbe1a355b1971362a118bce9f5b
$(PKG)_GH_CONF  := VSRonin/QtXlsxWriter/branches/master
$(PKG)_DEPS     := cc qtbase

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
