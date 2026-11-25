# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gpgme
$(PKG)_WEBSITE  := https://www.gnupg.org/related_software/gpgme/
$(PKG)_DESCR    := gpgme
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.24.4
$(PKG)_CHECKSUM := 01cdf1b94a80a1a3d37aba1721281b01ceb8fbe9c75d98e7bb8187a1cbf0b24c
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
        --disable-languages \
        CFLAGS='-Wno-incompatible-pointer-types'
    $(MAKE) -C '$(1)/src' -j '$(JOBS)'
    $(MAKE) -C '$(1)/src' -j 1 install
endef
