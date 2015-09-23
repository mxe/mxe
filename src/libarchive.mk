# This file is part of MXE.
# See index.html for further information.

PKG             := libarchive
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1.2
$(PKG)_CHECKSUM := eb87eacd8fe49e8d90c8fdc189813023ccc319c5e752b01fb6ad0cc7b2c53d5e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.libarchive.org/downloads/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc bzip2 libiconv libxml2 openssl xz zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.libarchive.org/downloads/' | \
    $(SED) -n 's,.*libarchive-\([0-9][^<]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    $(if $(BUILD_STATIC),\
        $(SED) -i '1i#ifndef LIBARCHIVE_STATIC\n#define LIBARCHIVE_STATIC\n#endif' -i '$(1)/libarchive/archive.h'
        $(SED) -i '1i#ifndef LIBARCHIVE_STATIC\n#define LIBARCHIVE_STATIC\n#endif' -i '$(1)/libarchive/archive_entry.h')
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-bsdtar \
        --disable-bsdcpio \
        --disable-bsdcat \
        XML2_CONFIG='$(PREFIX)/$(TARGET)'/bin/xml2-config
    $(MAKE) -C '$(1)' -j '$(JOBS)' man_MANS=
    $(MAKE) -C '$(1)' -j 1 install man_MANS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-libarchive.exe' \
        `'$(TARGET)-pkg-config' --libs-only-l libarchive`
endef
