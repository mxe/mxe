# This file is part of MXE.
# See index.html for further information.

PKG             := minizip
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1
$(PKG)_CHECKSUM := f0a47893d86e48c7336558aa7ec7b6742a1c102f
$(PKG)_COMMIT   := 1f38dffc395c1e847eb26dbd921168e8cc2b6db2
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_COMMIT)
$(PKG)_FILE     := $(PKG)-$($(PKG)_COMMIT).zip
$(PKG)_URL      := https://github.com/nmoinvaz/minizip/archive/$($(PKG)_COMMIT).zip
$(PKG)_DEPS     := gcc zlib

define $(PKG)_UPDATE
    echo 'TODO: write update script for $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

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
