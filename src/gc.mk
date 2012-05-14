# This file is part of MXE.
# See index.html for further information.

PKG             := gc
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 43c5f2704479dc8d8010fb2c73fa269bf3151d5b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
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
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --enable-threads=win32 \
        --enable-cplusplus
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
