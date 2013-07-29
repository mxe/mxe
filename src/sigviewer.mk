# This file is part of MXE.
# See index.html for further information.

PKG             := sigviewer
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 0.5.1
$(PKG)_CHECKSUM := b667d7f8d0f7d1c1b21a517eaea529520156f2fb
$(PKG)_SUBDIR   := sigviewer-0.5.1-r553-src
$(PKG)_FILE     := $($(PKG)_SUBDIR).zip
$(PKG)_URL      := http://sourceforge.net/projects/sigviewer/files/0.5.1/$($(PKG)_FILE)/download
$(PKG)_DEPS     := gcc biosig qt

define $(PKG)_UPDATE
#    wget -q -O- 'http://biosig.sourceforge.net/download.html' | \
#    $(SED) -n 's_.*>libbiosig, version \([0-9]\.[0-9]\.[0-9]\).*tar.gz_\1_ip'
    head -1
endef

define $(PKG)_BUILD

	cd '$(1)'/src/ && CFLAGS=-fstack-protector CXXFLAGS=-fstack-protector $(PREFIX)/$(TARGET)/qt/bin/qmake

	$(MAKE) -C '$(1)'/src/  

	$(INSTALL) '$(1)'/bin/release/sigviewer.exe $(PREFIX)/$(TARGET)/bin/

endef

