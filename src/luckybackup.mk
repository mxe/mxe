# This file is part of MXE.
# See index.html for further information.

PKG             := luckybackup
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 0.4.7
$(PKG)_CHECKSUM := 7a436c29a636e359991cd131a5a966e3d4755372
$(PKG)_SUBDIR   := luckybackup-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://downloads.sourceforge.net/project/$(PKG)/$($(PKG)_VERSION)/source/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qt

define $(PKG)_UPDATE
#    wget -q -O- 'http://luckybackup.sourceforge.net' | \
#    $(SED) -n 's_.*current stable version.*>\([0-9]\.[0-9]\.[0-9]\)<.*_\1_ip' \
    head -1
endef

define $(PKG)_BUILD

	cd '$(1)' && \
	$(PREFIX)/$(TARGET)/qt/bin/qmake && \
	$(MAKE) && \
	rm -rf $(PREFIX)/$(TARGET)/bin/manual $(PREFIX)/$(TARGET)/bin/translations && \
	mv -f release/luckybackup.exe manual translations $(PREFIX)/$(TARGET)/bin/ 

	cd $(PREFIX)/$(TARGET)/bin && \
	rm ../luckybackup.zip && \
	zip -r ../luckybackup.zip luckybackup.exe manual translations
		
endef
