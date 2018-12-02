# This file is part of MXE.
# See index.html for further information.

PKG             := libb64
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 1.2.1
$(PKG)_CHECKSUM := 20106f0ba95cfd9c35a13c71206643e3fb3e46512df3e2efb2fdbf87116314b2
$(PKG)_SUBDIR   := libb64-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).zip
$(PKG)_URL      := https://sourceforge.net/projects/$(PKG)/files/$(PKG)/$(PKG)/$($(PKG)_FILE)

$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/libb64/files/' | \
    $(SED) -n 's_.*libb64-\([0-9]\.[0-9]\.[0-9]\).*zip_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD

    CC=$(TARGET)-gcc CXX=$(TARGET)-g++ PKG_CONFIG=$(TARGET)-pkg_config AR=$(TARGET)-ar $(MAKE) -C '$(1)/src'

    cp -r '$(1)/include/b64' '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) '$(1)/src/libb64.a' '$(PREFIX)/$(TARGET)/lib/'

endef

