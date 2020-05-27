# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := npth
$(PKG)_WEBSITE  := https://www.gnupg.org/related_software/npth/
$(PKG)_DESCR    := ntbtls
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.6
$(PKG)_CHECKSUM := 1393abd9adcf0762d34798dc34fdcf4d0d22a8410721e76f1e3afcd1daa4e2d1
$(PKG)_SUBDIR   := npth-$($(PKG)_VERSION)
$(PKG)_FILE     := npth-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://gnupg.org/ftp/gcrypt/npth/$($(PKG)_FILE)
$(PKG)_DEPS     := cc pthreads

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gnupg.org/ftp/gcrypt/npth/' | \
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
    ln -sf '$(PREFIX)/$(TARGET)/bin/npth-config' '$(PREFIX)/bin/$(TARGET)-npth-config'
endef
