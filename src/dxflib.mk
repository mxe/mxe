# This file is part of MXE.
# See index.html for further information.

PKG             := dxflib
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 2.5.0.0
$(PKG)_CHECKSUM := af2e496aaf097e40bdb5d6155ba9b0d176d71729
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)-1.src
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://qcad.org/archives/$(PKG)/$(PKG)-$($(PKG)_VERSION)-1.src.tar.gz
$(PKG)_DEPS     := gcc qt5

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://qcad.org/en/dxflib-downloads' | \
    $(SED) 's,.*<a href="/archives/dxflib/dxflib-\([0-9\.]*[0-9-]*\).src.tar.gz">.*,\1,g;' | \
    head -1
endef

define $(PKG)_BUILD

    cd '$(1)' && $(PREFIX)/$(TARGET)/qt5/bin/qmake 

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    
    $(MAKE) -C '$(1)' -j 1 install
    
endef
