# This file is part of MXE.
# See index.html for further information.

PKG             := edfbrowser
$(PKG)_WEBSITE  := https://www.teuniz.net/edfbrowser/
$(PKG)_DESCR    := EDFbrowser
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 2.04
$(PKG)_CHECKSUM := fffac152f28db60ad46b3399a3a5338b31ea573fab0d76fc58e63e6ef3664b8b
$(PKG)_SUBDIR   := edfbrowser_204_source
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

