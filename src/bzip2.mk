# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# bzip2
PKG             := bzip2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.5
$(PKG)_CHECKSUM := 8b02713ea0c8eb501cc8bdac4432d7f29700f767
$(PKG)_SUBDIR   := bzip2-$($(PKG)_VERSION)
$(PKG)_FILE     := bzip2-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.bzip.org/
$(PKG)_URL      := http://www.bzip.org/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://www.bzip.org/downloads.html' | \
    grep 'bzip2-' | \
    $(SED) -n 's,.*bzip2-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,sys\\stat\.h,sys/stat.h,g' '$(1)/bzip2.c'
    $(MAKE) -C '$(1)' -j '$(JOBS)' libbz2.a \
        PREFIX='$(PREFIX)/$(TARGET)' \
        CC='$(TARGET)-gcc' \
        AR='$(TARGET)-ar' \
        RANLIB='$(TARGET)-ranlib'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m664 '$(1)/libbz2.a' '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m664 '$(1)/bzlib.h' '$(PREFIX)/$(TARGET)/include/'
endef
