# This file is part of MXE.
# See doc/index.html for further information.

# GnuTLS
PKG             := gnutls
$(PKG)_VERSION  := 3.0.17
$(PKG)_CHECKSUM := 2e2adc41e0c75d8170fdca5955bd007ae93ceada
$(PKG)_SUBDIR   := gnutls-$($(PKG)_VERSION)
$(PKG)_FILE     := gnutls-$($(PKG)_VERSION).tar.xz
$(PKG)_WEBSITE  := http://www.gnu.org/software/gnutls/
$(PKG)_URL      := ftp://ftp.gnutls.org/pub/gnutls/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.gnupg.org/gcrypt/gnutls/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc nettle zlib

define $(PKG)_UPDATE
    wget -q -O- 'http://git.savannah.gnu.org/gitweb/?p=gnutls.git;a=tags' | \
    grep '<a class="list name"' | \
    $(SED) -n 's,.*<a[^>]*>gnutls_\([0-9]*_[0-9]*[02468]_[^<]*\)<.*,\1,p' | \
    $(SED) 's,_,.,g' | \
    grep -v '^2\.' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's, sed , $(SED) ,g' '$(1)/gl/tests/Makefile.am'
    cd '$(1)' && aclocal -I m4 -I gl/m4 -I src/libopts/m4 --install
    cd '$(1)' && autoconf
    cd '$(1)' && automake
    # AI_ADDRCONFIG referenced by src/serv.c but not provided by mingw.
    # Value taken from http://msdn.microsoft.com/en-us/library/windows/desktop/ms737530%28v=vs.85%29.aspx
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --enable-static \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-nls \
        --disable-guile \
        --with-included-libtasn1 \
        --with-included-libcfg \
        --without-p11-kit \
        --disable-silent-rules \
        CPPFLAGS='-DWINVER=0x0501 -DAI_ADDRCONFIG=0x0400' \
        LIBS='-lws2_32' \
        ac_cv_prog_AR='$(TARGET)-ar'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-gnutls.exe' \
        `'$(TARGET)-pkg-config' gnutls --cflags --libs`
endef
