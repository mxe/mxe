# This file is part of MXE.
# See index.html for further information.

PKG             := wxpython
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := c292cd45b51e29c558c4d9cacf93c4616ed738b9
$(PKG)_SUBDIR   := wxPython-src-$($(PKG)_VERSION)
$(PKG)_FILE     := wxPython-src-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://sourceforge.net/projects/wxpython/files/wxPython/$($(PKG)_VERSION)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := gcc 


define $(PKG)_UPDATE
    wget -q -O- 'http://wxpython.org/download/releases/' | \
    $(SED) -n 's_.*">Python \(3.3.[0-9]\)</a>.*_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD

	cd '$(1)'
	
	exit -1 

endef

