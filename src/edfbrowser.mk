# This file is part of MXE.
# See index.html for further information.

PKG             := edfbrowser
$(PKG)_WEBSITE  := https://www.teuniz.net/edfbrowser/
$(PKG)_DESCR    := EDFbrowser
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 1.60
$(PKG)_CHECKSUM := beeed235bb87abcd28df865f4dc60e25b119b1306fb07faf616d2ad91fa43b1e
$(PKG)_SUBDIR   := edfbrowser_160_source
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://github.com/Teuniz/EDFbrowser/releases
                   https://www.teuniz.net/edfbrowser/$($(PKG)_FILE)
$(PKG)_GH_CONF  := Teuniz/EDFbrowser/releases v
$(PKG)_DEPS     := gcc qt


define $(PKG)_BUILD

    cd '$(1)' && $(PREFIX)/$(TARGET)/qt/bin/qmake 

    $(MAKE) -C '$(1)'
    
    $(INSTALL) '$(1)/release/edfbrowser.exe' '$(PREFIX)/$(TARGET)/bin/'

endef

