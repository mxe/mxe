# This file is part of MXE.
# See index.html for further information.

PKG             := szip
$(PKG)_VERSION  := 2.1
$(PKG)_CHECKSUM := d241c9acc26426a831765d660b683b853b83c131
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.hdfgroup.org/ftp/lib-external/$(PKG)/$($(PKG)_VERSION)/src/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.hdfgroup.org/ftp/lib-external/szip/' | \
    $(SED) -n 's,.*<a href="\([0-9.]*\)\/">.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
