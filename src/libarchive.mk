# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# Libarchive
PKG             := libarchive
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.8.5
$(PKG)_CHECKSUM := e48a3b50de84b1d747f5af9ca5ba90eb6d3a4a78
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://code.google.com/p/libarchive/
$(PKG)_URL      := http://libarchive.googlecode.com/files/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc bzip2 libxml2 openssl xz zlib

define $(PKG)_UPDATE
    wget -q -O- 'http://code.google.com/p/libarchive/downloads/list?sort=-uploaded' | \
    $(SED) -n 's,.*libarchive-\([0-9][^<]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i '1i#ifndef LIBARCHIVE_STATIC\n#define LIBARCHIVE_STATIC\n#endif' -i '$(1)/libarchive/archive.h'
    $(SED) -i '1i#ifndef LIBARCHIVE_STATIC\n#define LIBARCHIVE_STATIC\n#endif' -i '$(1)/libarchive/archive_entry.h'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --disable-bsdtar \
        --disable-bsdcpio \
        XML2_CONFIG='$(PREFIX)/$(TARGET)'/bin/xml2-config
    $(MAKE) -C '$(1)' -j '$(JOBS)' man_MANS=
    $(MAKE) -C '$(1)' -j 1 install man_MANS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-libarchive.exe' \
        -larchive -lz
endef
