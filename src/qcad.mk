# This file is part of MXE.
# See index.html for further information.

PKG             := qcad
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 3.4.2.0
$(PKG)_CHECKSUM := 6a4228ba2ead58752d1de564840255014e35a40a
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := v$($(PKG)_VERSION).zip
$(PKG)_URL      := https://github.com/$(PKG)/$(PKG)/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qt5

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://qcad.org/en/qcad-downloads-trial' | \
    $(SED) 's,.*QCAD version \([0-9\.]\) .*,\1,g;' | \
    head -1
endef

define $(PKG)_BUILD

    cd '$(1)' && $(PREFIX)/$(TARGET)/qt5/bin/qmake 

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    
    $(MAKE) -C '$(1)' -j 1 install
    
endef
