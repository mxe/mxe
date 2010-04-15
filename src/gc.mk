# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# gc
PKG             := gc
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.1
$(PKG)_CHECKSUM := e84cba5d18f4ea5ed4e5fd3f1dc6a46bc190ff6f
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.hpl.hp.com/personal/Hans_Boehm/$(PKG)/
$(PKG)_URL      := http://www.hpl.hp.com/personal/Hans_Boehm/$(PKG)/$(PKG)_source/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://www.hpl.hp.com/personal/Hans_Boehm/gc/gc_source/?C=M;O=D' | \
    grep '<a href="gc-' | \
    $(SED) -n 's,.*<a href="gc-\([0-9][^"]*\)\.tar.*,\1,p' | \
    grep -v 'alpha' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --enable-threads=win32 \
        --enable-cplusplus
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
