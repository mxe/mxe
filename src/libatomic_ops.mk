# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libatomic_ops
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.4.4
$(PKG)_CHECKSUM := bf210a600dd1becbf7936dd2914cf5f5d3356046904848dcfd27d0c8b12b6f8f
$(PKG)_SUBDIR   := $(PKG)-7.4.4
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://hboehm.info/gc/gc_source/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://hboehm.info/gc/gc_source/' | \
    grep '<a href="gc-' | \
    $(SED) -n 's,.*<a href="libatomic_ops-\([0-9][^"]*\)\.tar.*,\1,p' | \
    grep -v 'alpha' | \
    $(SORT) -Vr | \
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

$(PKG)_BUILD_SHARED =
