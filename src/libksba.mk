# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libksba
$(PKG)_WEBSITE  := https://www.gnupg.org/related_software/libksba/
$(PKG)_DESCR    := libksba
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.5
$(PKG)_CHECKSUM := 41444fd7a6ff73a79ad9728f985e71c9ba8cd3e5e53358e70d5f066d35c1a340
$(PKG)_SUBDIR   := libksba-$($(PKG)_VERSION)
$(PKG)_FILE     := libksba-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://gnupg.org/ftp/gcrypt/libksba/$($(PKG)_FILE)
$(PKG)_DEPS     := cc gettext

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gnupg.org/ftp/gcrypt/libksba/' | \
    $(SED) -n 's,.*libgpg-error-\([1-9]\.[1-9][0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && autoreconf -fi
    cd '$(SOURCE_DIR)' && './configure' \
        $(MXE_CONFIGURE_OPTS) \
		--disable-option-checking \
        --disable-languages
    
    $(MAKE) -C '$(SOURCE_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(SOURCE_DIR)' -j 1 install
    ln -sf '$(PREFIX)/$(TARGET)/bin/ksba-config' '$(PREFIX)/bin/$(TARGET)-ksba-config'
endef
