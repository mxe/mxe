# This file is part of MXE.
# See index.html for further information.

PKG             := old
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.17
$(PKG)_CHECKSUM := d519a8282b0774c344ffeb1b4899f8be53d6d7b3
$(PKG)_SUBDIR   := old-$($(PKG)_VERSION)
$(PKG)_FILE     := old-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://blitiri.com.ar/p/old/files/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://blitiri.com.ar/p/old/' | \
    grep 'old-' | \
    $(SED) -n 's,.*old-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && $(TARGET)-gcc -O3 -Iinclude -c -o libold.o lib/libold.c
    cd '$(1)' && $(TARGET)-ar cr libold.a libold.o
    $(TARGET)-ranlib '$(1)/libold.a'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/libold.a' '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/lib/old.h' '$(PREFIX)/$(TARGET)/include/'
endef

$(PKG)_BUILD_SHARED =
