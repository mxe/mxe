# This file is part of MXE.
# See index.html for further information.

PKG             := edfbrowser
$(PKG)_WEBSITE  := https://www.teuniz.net/edfbrowser/
$(PKG)_DESCR    := EDFbrowser
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 1.67
$(PKG)_CHECKSUM := fd3e1fbf5926817403ac3bef41f77cddfd921bc6c2fd63de23962f00f51128ed
$(PKG)_SUBDIR   := edfbrowser_167_source
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://www.teuniz.net/edfbrowser/$($(PKG)_FILE)
                   https://gitlab.com/Teuniz/EDFbrowser/releases
$(PKG)_GH_CONF  := Teuniz/EDFbrowser/releases v
$(PKG)_QT_DIR   := qt5
$(PKG)_DEPS     := cc qtbase


define $(PKG)_BUILD

    cd '$(1)' && $(PREFIX)/$(TARGET)/$($(PKG)_QT_DIR)/bin/qmake

    $(MAKE) -C '$(1)'
    
    $(INSTALL) '$(1)/release/edfbrowser.exe' '$(PREFIX)/$(TARGET)/bin/'

endef

