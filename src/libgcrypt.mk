# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libgcrypt
$(PKG)_WEBSITE  := https://directory.fsf.org/wiki/Libgcrypt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.2
$(PKG)_CHECKSUM := c8064cae7558144b13ef0eb87093412380efa16c4ee30ad12ecb54886a524c07
$(PKG)_SUBDIR   := libgcrypt-$($(PKG)_VERSION)
$(PKG)_FILE     := libgcrypt-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://gnupg.org/ftp/gcrypt/libgcrypt/$($(PKG)_FILE)
$(PKG)_URL_2    := https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libgcrypt/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libgpg_error

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gnupg.org/ftp/gcrypt/libgcrypt/' | \
    $(SED) -n 's,.*libgcrypt-\([0-9][^>]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_CONFIGURE
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-gpg-error-prefix='$(PREFIX)/$(TARGET)'
endef

define $(PKG)_MAKE
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    ln -sf '$(PREFIX)/$(TARGET)/bin/libgcrypt-config' '$(PREFIX)/bin/$(TARGET)-libgcrypt-config'

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: $(PKG)'; \
     echo 'Libs: ' "`$(TARGET)-libgcrypt-config --libs`"; \
     echo 'Cflags: ' "`$(TARGET)-libgcrypt-config --cflags`";) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-libgcrypt.exe' \
        `$(TARGET)-pkg-config libgcrypt --cflags --libs`
endef

define $(PKG)_BUILD
    $($(PKG)_CONFIGURE)
    $($(PKG)_MAKE)
endef

define $(PKG)_BUILD_x86_64-w64-mingw32
    cd '$(1)' && autoreconf -fi
    $($(PKG)_CONFIGURE) \
        ac_cv_sys_symbol_underscore=no \
        --disable-padlock-support
    $($(PKG)_MAKE)
endef
