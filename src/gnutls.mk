# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gnutls
$(PKG)_WEBSITE  := https://www.gnu.org/software/gnutls/
$(PKG)_DESCR    := GnuTLS
$(PKG)_VERSION  := 3.6.15
$(PKG)_CHECKSUM := 0ea8c3283de8d8335d7ae338ef27c53a916f15f382753b174c18b45ffd481558
$(PKG)_SUBDIR   := gnutls-$($(PKG)_VERSION)
$(PKG)_FILE     := gnutls-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://gnupg.org/ftp/gcrypt/gnutls/v3.6/$($(PKG)_FILE)
$(PKG)_URL_2    := https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnutls/v3.5/$($(PKG)_FILE)
$(PKG)_DEPS     := cc gettext gmp libidn2 libtasn1 libunistring nettle zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- https://gnupg.org/ftp/gcrypt/gnutls/v3.6/ | \
    $(SED) -n 's,.*gnutls-\([1-9]\+\(\.[0-9]\+\)\+\)\..*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && autoreconf -fi
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)'/configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-rpath \
        --disable-nls \
        --disable-guile \
        --disable-doc \
        --disable-tests \
        --enable-local-libopts \
        --without-p11-kit \
        --disable-silent-rules \
        CFLAGS='-D_WIN32_WINNT=0x0600'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-gnutls.exe' \
        `'$(TARGET)-pkg-config' gnutls --cflags --libs`
endef
