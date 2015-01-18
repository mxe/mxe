# This file is part of MXE.
# See index.html for further information.

PKG             := edfbrowser
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 1.54
$(PKG)_CHECKSUM := 9b6e2159ebb0278a50b764dd243d354aa202d8b5
$(PKG)_SUBDIR   := edfbrowser_154_source
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := http://www.teuniz.net/edfbrowser/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qt

define $(PKG)_UPDATE
    wget -q -O- 'http://www.teuniz.net/edfbrowser/version.txt' | \
    $(SED) -n 's_^version \([0-9.\]\.[0-9][0-9]\).*_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD

    cd '$(1)' && $(PREFIX)/$(TARGET)/qt/bin/qmake 

    $(MAKE) -C '$(1)'
    
    $(INSTALL) '$(1)/release/edfbrowser.exe' '$(PREFIX)/$(TARGET)/bin/'

endef

