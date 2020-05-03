# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gnupg
$(PKG)_WEBSITE  := https://gnupg.org/software/index.html
$(PKG)_DESCR    := gnupg
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.20
$(PKG)_CHECKSUM := 04a7c9d48b74c399168ee8270e548588ddbe52218c337703d7f06373d326ca30
$(PKG)_SUBDIR   := gnupg-$($(PKG)_VERSION)
$(PKG)_FILE     := gnupg-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://gnupg.org/ftp/gcrypt/gnupg/$($(PKG)_FILE)
$(PKG)_DEPS     := zlib bzip2 sqlite libassuan ntbtls npth libksba libgpg_error libgcrypt

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gnupg.org/ftp/gcrypt/gnupg/' | \
    $(SED) -n 's,.*gnupg-\([1-9]\.[1-9][0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-maintainer-mode \
		--disable-option-checking \
        --disable-doc \
        --disable-card-support \
        --disable-ccid-driver \
        --disable-ldap \
        --disable-libdns \
        --disable-photo-viewers \
        --with-libassuan-prefix="$(PREFIX)/$(TARGET)" \
        --with-ksba-prefix="$(PREFIX)/$(TARGET)" \
        --with-ntbtls-prefix="$(PREFIX)/$(TARGET)" \
        --with-npth-prefix="$(PREFIX)/$(TARGET)" \
        --with-libgcrypt-prefix="$(PREFIX)/$(TARGET)" \
        --with-libgpg-error-prefix="$(PREFIX)/$(TARGET)"
    $(MAKE) -C '$(SOURCE_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(SOURCE_DIR)' -j 1 install
endef
