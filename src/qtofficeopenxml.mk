# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtofficeopenxml
$(PKG)_WEBSITE  := https://github.com/dbzhang800/QtOfficeOpenXml/
$(PKG)_DESCR    := QtOfficeOpenXml
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := b26a85b
$(PKG)_CHECKSUM := a7b7c95e3549f7c63b2d0b1f108e006b89f78eeb4433c3a7dae1a51bebf3d254
$(PKG)_GH_CONF  := dbzhang800/QtOfficeOpenXml/branches/master
$(PKG)_DEPS     := cc qtbase

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
