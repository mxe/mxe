# This file is part of MXE.
# See index.html for further information.

PKG             := edfbrowser
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 1.56
$(PKG)_CHECKSUM := 06b9360ceb1dcddd0b00370c23b3708a019f2b60872533e7776b49a5b4484d01
$(PKG)_SUBDIR   := edfbrowser_156_source
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

