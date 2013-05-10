# This file is part of MXE.
# See index.html for further information.

PKG             := gnutls
$(PKG)_CHECKSUM := f53e8621a94ce05162f261c2dc3898d9b39587db
$(PKG)_SUBDIR   := gnutls-$($(PKG)_VERSION)
$(PKG)_FILE     := gnutls-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := ftp://ftp.gnutls.org/gcrypt/gnutls/v3.1//$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gettext nettle pcre zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- ftp://ftp.gnutls.org/gcrypt/gnutls/v3.1/ | \
    $(SED) -n 's,.*gnutls-\([1-9]\+\.[0-9]\+.[0-9]\+\)\..*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    $(SED) -i 's, sed , $(SED) ,g' '$(1)/gl/tests/Makefile.am'
    cd '$(1)' && aclocal -I m4 -I gl/m4 -I src/libopts/m4 --install
    cd '$(1)' && autoconf
    cd '$(1)' && automake --add-missing
    # skip the run test for libregex support since we are cross compiling
    $(SED) -i 's/libopts_cv_with_libregex=no/libopts_cv_with_libregex=yes/g;' '$(1)/configure'
    # AI_ADDRCONFIG referenced by src/serv.c but not provided by mingw.
    # Value taken from http://msdn.microsoft.com/en-us/library/windows/desktop/ms737530%28v=vs.85%29.aspx
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --enable-static \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-nls \
        --disable-guile \
        --disable-docs \
        --with-included-libtasn1 \
        --with-libregex='$(PREFIX)/$(TARGET)' \
        --with-regex-header=pcreposix.h \
        --with-libregex-cflags="`'$(TARGET)-pkg-config' libpcreposix --cflags`" \
        --with-libregex-libs="`'$(TARGET)-pkg-config' libpcreposix --libs`" \
        --without-p11-kit \
        --disable-silent-rules \
        CPPFLAGS='-DWINVER=0x0501 -DAI_ADDRCONFIG=0x0400 -DIPV6_V6ONLY=27' \
        LIBS='-lws2_32' \
        ac_cv_prog_AR='$(TARGET)-ar'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-gnutls.exe' \
        `'$(TARGET)-pkg-config' gnutls --cflags --libs`
endef
