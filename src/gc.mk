# This file is part of MXE.
# See index.html for further information.

PKG             := gc
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 18c5b1aa9289a12fead3ceeda8fdc81f4ed08964
$(PKG)_SUBDIR   := $(PKG)-7.2
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.hpl.hp.com/personal/Hans_Boehm/$(PKG)/$(PKG)_source/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.hpl.hp.com/personal/Hans_Boehm/gc/gc_source/?C=M;O=D' | \
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
