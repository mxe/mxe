# This file is part of MXE.
# See index.html for further information.

PKG             := minizip
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0b46a2b
$(PKG)_CHECKSUM := 411f52a78dca8af254993e7a82be26bfc64af885
$(PKG)_SUBDIR   := nmoinvaz-minizip-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/nmoinvaz/minizip/tarball/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib

$(PKG)_UPDATE    = $(call MXE_GET_GITHUB_SHA, nmoinvaz/minizip, master)

define $(PKG)_BUILD
    cd '$(1)' && $(TARGET)-gcc -c -O '$(1)'/*.c
    cd '$(1)' && $(TARGET)-ar cr libminizip.a *.o
    $(TARGET)-ranlib '$(1)/libminizip.a'
    $(INSTALL) -d               '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)'/*.a '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -d               '$(PREFIX)/$(TARGET)/include/minizip'
    $(INSTALL) -m644 '$(1)'/ioapi.h '$(PREFIX)/$(TARGET)/include/minizip/'
    $(INSTALL) -m644 '$(1)'/unzip.h '$(PREFIX)/$(TARGET)/include/minizip/'
    $(INSTALL) -m644 '$(1)'/zip.h '$(PREFIX)/$(TARGET)/include/minizip/'
endef

$(PKG)_BUILD_SHARED =
