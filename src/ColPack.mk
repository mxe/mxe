# This file is part of MXE.
# See index.html for further information.

PKG             := ColPack
$(PKG)_VERSION  := 1.0.9
$(PKG)_CHECKSUM := c963424c3e97a7bc3756d3feb742418e89721e48
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://cscapes.cs.purdue.edu/download/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://cscapes.cs.purdue.edu/download/ColPack/' | \
    $(SED) -n -n 's,.*ColPack-\([0-9.]*\)[.]tar.*".*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
