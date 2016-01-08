# This file is part of MXE.
# See index.html for further information.

PKG             := gc
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.2e
$(PKG)_CHECKSUM := 09315b48a82d600371207691126ad058c04677281ac318d86fa84c98c3c9af4b
$(PKG)_SUBDIR   := $(PKG)-7.2
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://hboehm.info/$(PKG)/$(PKG)_source/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://hboehm.info/gc/gc_source/' | \
    grep '<a href="gc-' | \
    $(SED) -n 's,.*<a href="gc-\([0-9][^"]*\)\.tar.*,\1,p' | \
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
