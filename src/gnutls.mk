# GnuTLS

PKG            := gnutls
$(PKG)_VERSION := 1.6.3
$(PKG)_SUBDIR  := gnutls-$($(PKG)_VERSION)
$(PKG)_FILE    := gnutls-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE := http://www.gnu.org/software/gnutls/
$(PKG)_URL     := ftp://ftp.gnutls.org/pub/gnutls/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc libgcrypt

define $(PKG)_UPDATE
    wget -q -O- 'http://git.savannah.gnu.org/gitweb/?p=gnutls.git;a=tags' | \
    grep '<a class="list subject"' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9][^>]*\)<.*,\1,p' | \
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
