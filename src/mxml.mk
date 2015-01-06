# This file is part of MXE.
# See index.html for further information.

PKG             := mxml
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.8
$(PKG)_CHECKSUM := 09d88f1720f69b64b76910dfe2a5c5fa24a8b361
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.msweet.org/files/project3/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc pthreads

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.msweet.org/downloads.php?L+Z3' | \
    $(SED) -n 's,.*<a href="files.*mxml-\([0-9\.]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-threads
    $(MAKE) -C '$(1)' -j '$(JOBS)' libmxml.a
    $(MAKE) -C '$(1)' -j 1 install-libmxml.a
    $(INSTALL) -d                   '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/mxml.h'  '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -d                   '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    $(INSTALL) -m644 '$(1)/mxml.pc' '$(PREFIX)/$(TARGET)/lib/pkgconfig/'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-mxml.exe' \
        `'$(TARGET)-pkg-config' mxml --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
