# This file is part of MXE.
# See index.html for further information.

PKG             := mman-win32
$(PKG)_VERSION  := 0.0.2
$(PKG)_CHECKSUM := 64b9fe21db9f8a18dbbeec7b02e69a04c13ea45c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://github.com/mcgarrah/$(PKG)/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- https://github.com/mcgarrah/mman-win32/tags | \
    $(SED) -n 's,.*<span class="tag-name">\([0-9.]*\)</span>.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --libdir='$(PREFIX)/$(TARGET)/lib' \
        --incdir='$(PREFIX)/$(TARGET)/include/sys' \
        --cross-prefix='$(TARGET)-'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
