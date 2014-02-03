# This file is part of MXE.
# See index.html for further information.

PKG             := mman-win32
$(PKG)_VERSION  := 0.0.1
$(PKG)_CHECKSUM := cfa0906e6f72c1c902c29b52d140c22ecdcd617e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://github.com/mcgarrah/$(PKG)/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc ranlib

define $(PKG)_UPDATE
    $(WGET) -q -O- https://github.com/mcgarrah/mman-win32/tags | \
    $(SED) -n 's,.*<span class="tag-name">\([0-9.]*\)</span>.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --cross-prefix='$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
