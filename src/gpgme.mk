# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gpgme
$(PKG)_WEBSITE  := https://www.gnupg.org/related_software/gpgme/
$(PKG)_DESCR    := gpgme
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.22.0
$(PKG)_CHECKSUM := 9551e37081ad3bde81018a0d24f245c3f8206990549598fb31a97a68380a7b71
$(PKG)_SUBDIR   := gpgme-$($(PKG)_VERSION)
$(PKG)_FILE     := gpgme-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://gnupg.org/ftp/gcrypt/gpgme/$($(PKG)_FILE)
$(PKG)_URL_2    := https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gpgme/$($(PKG)_FILE)
$(PKG)_DEPS     := cc gettext libgpg_error libassuan

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gnupg.org/ftp/gcrypt/gpgme/' | \
    $(SED) -n 's,.*gpgme-\([1-9]\.[1-9][0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && GPG_ERROR_CONFIG=$(PREFIX)/bin/$(TARGET)-gpg-error-config LIBASSUAN_CONFIG='$(PREFIX)/bin/$(TARGET)-libassuan-config' ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-nls \
        --disable-languages
    $(MAKE) -C '$(1)/src' -j '$(JOBS)'
    $(MAKE) -C '$(1)/src' -j 1 install
endef
