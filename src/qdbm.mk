# This file is part of MXE.
# See index.html for further information.

PKG             := qdbm
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 8c2ab938c2dad8067c29b0aa93efc6389f0e7076
$(PKG)_SUBDIR   := qdbm-$($(PKG)_VERSION)
$(PKG)_FILE     := qdbm-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://fallabs.com/qdbm/qdbm-1.8.78.tar.gz
$(PKG)_DEPS     := gcc bzip2 libiconv lzo zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://fallabs.com/qdbm/' | \
    grep 'qdbm-' | \
    $(SED) -n 's,.*qdbm-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    find '$(1)' -name 'Makefile.in' \
        -exec $(SED) -i 's,make ,$(MAKE) ,g' {} \;
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-lzo \
        --enable-bzip \
        --enable-zlib \
        --enable-iconv
    $(MAKE) -C '$(1)' -j '$(JOBS)' \
        static \
        MYBINS= \
        MYLIBS=libqdbm.a \
        AR='$(TARGET)-ar' \
        RANLIB='$(TARGET)-ranlib'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    $(INSTALL) -m644 '$(1)/libqdbm.a' '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/qdbm.pc'   '$(PREFIX)/$(TARGET)/lib/pkgconfig/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    cd '$(1)' && $(INSTALL) -m644 depot.h curia.h relic.h hovel.h \
        cabin.h villa.h vista.h odeum.h '$(PREFIX)/$(TARGET)/include/'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-qdbm.exe' \
        `'$(TARGET)-pkg-config' qdbm --cflags --libs`
endef
