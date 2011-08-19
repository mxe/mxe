# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# dlfcn-win32
PKG             := dlfcn-win32
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := r19
$(PKG)_CHECKSUM := a0033e37a547c52059d0bf8664a96ecdeeb66419
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://code.google.com/p/dlfcn-win32/
$(PKG)_URL      := http://$(PKG).googlecode.com/files/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://code.google.com/p/dlfcn-win32/downloads/list?sort=-uploaded' | \
    $(SED) -n 's,.*dlfcn-win32-\(r[0-9][^<]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --incdir='$(PREFIX)/$(TARGET)/include' \
        --libdir='$(PREFIX)/$(TARGET)/lib' \
        --cross-prefix='$(TARGET)-' \
        --disable-shared \
        --enable-static
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
