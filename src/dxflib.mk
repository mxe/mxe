# This file is part of MXE.
# See index.html for further information.

PKG             := dxflib
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 2.5.0.0
$(PKG)_CHECKSUM := 20ad9991eec6b0f7a3cc7c500c044481a32110cdc01b65efa7b20d5ff9caefa9
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)-1.src
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://qcad.org/archives/$(PKG)/$(PKG)-$($(PKG)_VERSION)-1.src.tar.gz
$(PKG)_DEPS     := gcc qt5

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://qcad.org/en/dxflib-downloads' | \
    $(SED) -n '/a href/ s,.*/archives/dxflib/dxflib-\([0-9.]*\)-src.tar.gz.*,\1,g;' | \
    head -1
endef

define $(PKG)_BUILD

    cd '$(1)' && $(PREFIX)/$(TARGET)/qt5/bin/qmake 

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    
    $(MAKE) -C '$(1)' -j 1 install
    
endef
