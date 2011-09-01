# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# GnuTLS
PKG             := gnutls
$(PKG)_VERSION  := 2.12.10
$(PKG)_CHECKSUM := 52ed0bfa3dc7900f8da22f29eaace6ec34439223
$(PKG)_SUBDIR   := gnutls-$($(PKG)_VERSION)
$(PKG)_FILE     := gnutls-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.gnu.org/software/gnutls/
$(PKG)_URL      := ftp://ftp.gnutls.org/pub/gnutls/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.gnupg.org/gcrypt/gnutls/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib libgcrypt

define $(PKG)_UPDATE
    wget -q -O- 'http://git.savannah.gnu.org/gitweb/?p=gnutls.git;a=tags' | \
    grep '<a class="list name"' | \
    $(SED) -n 's,.*<a[^>]*>gnutls_\([0-9]*_[0-9]*[02468]_[^<]*\)<.*,\1,p' | \
    $(SED) 's,_,.,g' | \
    head -1
endef

define $(PKG)_BUILD
    echo '/* DEACTIVATED */' > '$(1)/gl/gai_strerror.c'
    $(SED) -i 's/^\(SUBDIRS.*\) tests/\1/;' '$(1)/Makefile.in'
    $(SED) -i 's/^\(SUBDIRS.*\) doc/\1/;' '$(1)/Makefile.in'
    $(SED) -i 's, sed , $(SED) ,g' '$(1)/gl/tests/Makefile.in'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --enable-static \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-nls \
        --disable-guile \
        --with-included-libtasn1 \
        --with-included-libcfg \
        --with-included-pakchois \
        --with-libgcrypt \
        --without-lzo \
        --without-p11-kit \
        LIBS='-lz'
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= defexec_DATA=
endef
