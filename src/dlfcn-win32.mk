# This file is part of MXE.
# See index.html for further information.

PKG             := dlfcn-win32
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := a0033e37a547c52059d0bf8664a96ecdeeb66419
$(PKG)_SUBDIR   := dlfcn-win32-$($(PKG)_VERSION)
$(PKG)_FILE     := dlfcn-win32-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://dlfcn-win32.googlecode.com/files/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://code.google.com/p/dlfcn-win32/downloads/list?sort=-uploaded' | \
    $(SED) -n 's,.*dlfcn-win32-\([0-9][^<]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure --cc='$(PREFIX)/bin/$(TARGET)-gcc' \
        --cross-prefix='$(PREFIX)/bin/$(TARGET)-' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --libdir='$(PREFIX)/$(TARGET)/lib' \
        --incdir='$(PREFIX)/$(TARGET)/include'
    $(MAKE) -C '$(1)' -j '$(JOBS)' libdl.a
    $(MAKE) -C '$(1)' -j '$(JOBS)' static-install
endef
