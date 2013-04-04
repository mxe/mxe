# This file is part of MXE.
# See index.html for further information.

PKG             := libemf
$(PKG)_IGNORE   := 
$(PKG)_CHECKSUM := ef61f8d73b6e68785b973cbbe8c449138f40b740
$(PKG)_SUBDIR   := libEMF-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).src.tar.gz
$(PKG)_URL      := http://sourceforge.net/projects/libemf/files/latest/download
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/libemf/files/' | \
    $(SED) -n 's_.*libEMF-\([0-9]\.[0-9]\.[0-9]\).*tar.gz_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD

    #rm -rf '$(1)/include/libEMF/wine/basetsd.h'
	
    # configure
    cd '$(1)' && autoconf && './configure' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-static 

    $(MAKE) -C '$(1)' -j '$(JOBS)'

    $(MAKE) -C '$(1)' -j '$(JOBS)' install

endef

