# GnuTLS

PKG             := gnutls
$(PKG)_VERSION  := 2.6.4
$(PKG)_CHECKSUM := 11dd1e11599906a32b3ff92308f4c4dbaadbad58
$(PKG)_SUBDIR   := gnutls-$($(PKG)_VERSION)
$(PKG)_FILE     := gnutls-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.gnu.org/software/gnutls/
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/gnutls/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.gnupg.org/gcrypt/gnutls/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libgcrypt

define $(PKG)_UPDATE
    wget -q -O- 'http://git.savannah.gnu.org/gitweb/?p=gnutls.git;a=tags' | \
    grep '<a class="list subject"' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9]*\.[0-9]*[02468]\.[^>]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    echo '/* DEACTIVATED */' > '$(1)/gl/gai_strerror.c'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-libgcrypt-prefix='$(PREFIX)/$(TARGET)' \
        --disable-nls \
        --with-included-opencdk \
        --with-included-libtasn1 \
        --with-included-libcfg \
        --with-included-lzo
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= defexec_DATA=
endef
