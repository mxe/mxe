# libxslt
# http://xmlsoft.org/XSLT/

PKG            := libxslt
$(PKG)_VERSION := 1.1.24
$(PKG)_SUBDIR  := libxslt-$($(PKG)_VERSION)
$(PKG)_FILE    := libxslt-$($(PKG)_VERSION).tar.gz
$(PKG)_URL     := ftp://xmlsoft.org/libxslt/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc libxml2 libgcrypt

define $(PKG)_UPDATE
    wget -q -O- 'ftp://xmlsoft.org/libxslt/' | \
    $(SED) -n 's,.*LATEST_LIBXSLT_IS_\([0-9][^>]*\)</a>.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --without-debug \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-libxml-prefix='$(PREFIX)/$(TARGET)' \
        LIBGCRYPT_CONFIG='$(PREFIX)/$(TARGET)/bin/libgcrypt-config' \
        --without-python \
        --without-plugins
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
