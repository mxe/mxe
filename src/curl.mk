# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# cURL
PKG             := curl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.23.1
$(PKG)_CHECKSUM := 9bac69696446ead85e59d8488098ee84cf897b7e
$(PKG)_SUBDIR   := curl-$($(PKG)_VERSION)
$(PKG)_FILE     := curl-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://curl.haxx.se/libcurl/
$(PKG)_URL      := http://curl.haxx.se/download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gnutls libidn libssh2

define $(PKG)_UPDATE
    wget -q -O- 'http://curl.haxx.se/download/?C=M;O=D' | \
    $(SED) -n 's,.*curl-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) -i 's,cross_compiling=no,cross_compiling=yes,' '$(1)/configure'
    cd '$(1)' && ./buildconf
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-gnutls \
        --with-libidn \
        --enable-sspi \
        LIBS="`$(TARGET)-pkg-config --libs libidn libssh2`"
    $(MAKE) -C '$(1)' -j '$(JOBS)' install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-curl.exe' \
        `'$(TARGET)-pkg-config' libcurl --cflags --libs`
endef
