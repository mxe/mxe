# This file is part of MXE.
# See index.html for further information.

PKG             := bzip2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.6
$(PKG)_CHECKSUM := a2848f34fcd5d6cf47def00461fcb528a0484d8edef8208d6d2e2909dc61d9cd
$(PKG)_SUBDIR   := bzip2-$($(PKG)_VERSION)
$(PKG)_FILE     := bzip2-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.bzip.org/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.bzip.org/downloads.html' | \
    grep 'bzip2-' | \
    $(SED) -n 's,.*bzip2-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD_COMMON
    $(MAKE) -C '$(1)' -j '$(JOBS)' libbz2.a \
        PREFIX='$(PREFIX)/$(TARGET)' \
        CC='$(TARGET)-gcc' \
        AR='$(TARGET)-ar' \
        RANLIB='$(TARGET)-ranlib'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/bzlib.h' '$(PREFIX)/$(TARGET)/include/'
endef

define $(PKG)_BUILD
    $($(PKG)_BUILD_COMMON)
    $(INSTALL) -m644 '$(1)/libbz2.a' '$(PREFIX)/$(TARGET)/lib/'
endef

define $(PKG)_BUILD_SHARED
    $($(PKG)_BUILD_COMMON)
    '$(TARGET)-gcc' '$(1)'/*.o -shared \
        -o '$(PREFIX)/$(TARGET)/bin/libbz2.dll' -Xlinker \
        --out-implib -Xlinker '$(PREFIX)/$(TARGET)/lib/libbz2.dll.a'
endef
