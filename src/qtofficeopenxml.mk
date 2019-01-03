# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtofficeopenxml
$(PKG)_WEBSITE  := https://github.com/dbzhang800/QtOfficeOpenXml/
$(PKG)_DESCR    := QtOfficeOpenXml
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 02dda4a
$(PKG)_CHECKSUM := 02927da4386d5e5f1ed4679f089db3029c4ff8dfebc448c93fa1bacf1828d8d9
$(PKG)_GH_CONF  := dbzhang800/QtOfficeOpenXml/branches/master
$(PKG)_DEPS     := cc qtbase

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
