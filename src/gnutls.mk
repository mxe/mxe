# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gnutls
$(PKG)_VERSION  := 3.4.15
$(PKG)_CHECKSUM := eb2a013905f5f2a0cbf7bcc1d20c85a50065063ee87bd33b496c4e19815e3498
$(PKG)_SUBDIR   := gnutls-$($(PKG)_VERSION)
$(PKG)_FILE     := gnutls-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://mirrors.dotsrc.org/gnupg/gnutls/v3.4/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.gnutls.org/gcrypt/gnutls/v3.4//$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gettext gmp libgnurx libidn nettle zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- ftp://ftp.gnutls.org/gcrypt/gnutls/v3.4/ | \
    $(SED) -n 's,.*gnutls-\([1-9]\+\.[0-9]\+.[0-9]\+\)\..*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    # AI_ADDRCONFIG referenced by src/serv.c but not provided by mingw.
    # Value taken from http://msdn.microsoft.com/en-us/library/windows/desktop/ms737530%28v=vs.85%29.aspx
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-rpath \
        --disable-nls \
        --disable-guile \
        --disable-doc \
        --enable-local-libopts \
        --with-included-libtasn1 \
        --with-libregex-libs="-lgnurx" \
        --without-p11-kit \
        --disable-silent-rules \
        CPPFLAGS='-DWINVER=0x0501 -DAI_ADDRCONFIG=0x0400 -DIPV6_V6ONLY=27' \
        LIBS='-lws2_32' \
        ac_cv_prog_AR='$(TARGET)-ar'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-gnutls.exe' \
        `'$(TARGET)-pkg-config' gnutls --cflags --libs`
endef
