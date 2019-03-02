# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qdbm
$(PKG)_WEBSITE  := https://fallabs.com/qdbm/
$(PKG)_DESCR    := QDBM
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.78
$(PKG)_CHECKSUM := b466fe730d751e4bfc5900d1f37b0fb955f2826ac456e70012785e012cdcb73e
$(PKG)_SUBDIR   := qdbm-$($(PKG)_VERSION)
$(PKG)_FILE     := qdbm-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://fallabs.com/qdbm/$($(PKG)_FILE)
$(PKG)_DEPS     := cc bzip2 libiconv lzo zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://fallabs.com/qdbm/' | \
    grep 'qdbm-' | \
    $(SED) -n 's,.*qdbm-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    find '$(1)' -name 'Makefile.in' \
        -exec $(SED) -i 's,make ,$(MAKE) ,g' {} \;
    $(SED) -i 's,LD=`which ld`,LD=$(TARGET)-ld,' '$(1)/configure'
    $(SED) -i 's,AR=`which ar`,AR=$(TARGET)-ar,' '$(1)/configure'
    cd '$(1)' && CC='$(PREFIX)/bin/$(TARGET)-gcc' ./configure \
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
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-qdbm.exe' \
        `'$(TARGET)-pkg-config' qdbm --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
