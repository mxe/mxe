# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ntbtls
$(PKG)_WEBSITE  := https://www.gnupg.org/related_software/ntbtls/
$(PKG)_DESCR    := ntbtls
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.2
$(PKG)_CHECKSUM := 8240db84e50c2351b19eb8064bdfd4d25e3c157d37875c62e335df237d7bdce7
$(PKG)_SUBDIR   := ntbtls-$($(PKG)_VERSION)
$(PKG)_FILE     := ntbtls-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://gnupg.org/ftp/gcrypt/ntbtls/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libgcrypt libksba zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gnupg.org/ftp/gcrypt/ntbtls/' | \
    $(SED) -n 's,.*libgpg-error-\([1-9]\.[1-9][0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && autoreconf -fi
    cd '$(SOURCE_DIR)' && './configure' \
        $(MXE_CONFIGURE_OPTS) \
		--disable-option-checking \
        --disable-languages \
        --with-ksba-prefix="$(PREFIX)/$(TARGET)" \
        --with-libgpg-error-prefix="$(PREFIX)/$(TARGET)" \
        --with-libgcrypt-prefix="$(PREFIX)/$(TARGET)"
    
    $(MAKE) -C '$(SOURCE_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(SOURCE_DIR)' -j 1 install
    ln -sf '$(PREFIX)/$(TARGET)/bin/ntbtls-config' '$(PREFIX)/bin/$(TARGET)-ntbtls-config'
endef
