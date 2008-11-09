# cURL
# http://curl.haxx.se/libcurl/

PKG            := curl
$(PKG)_VERSION := 7.19.1
$(PKG)_SUBDIR  := curl-$($(PKG)_VERSION)
$(PKG)_FILE    := curl-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL     := http://curl.haxx.se/download/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc gnutls

define $(PKG)_UPDATE
    wget -q -O- 'http://curl.haxx.se/changes.html' | \
    $(SED) -n 's,.*Fixed in \([0-9][^ ]*\) - .*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) 's,-I@includedir@,-I@includedir@ -DCURL_STATICLIB,' -i '$(1)/curl-config.in'
    $(SED) 's,GNUTLS_ENABLED = 1,GNUTLS_ENABLED=1,' -i '$(1)/configure'
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) 's,cross_compiling=no,cross_compiling=yes,' -i '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-gnutls='$(PREFIX)/$(TARGET)' \
        LIBS="-lgcrypt `$(PREFIX)/$(TARGET)/bin/gpg-error-config --libs`"
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
