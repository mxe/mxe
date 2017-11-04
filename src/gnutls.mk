# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gnutls
$(PKG)_WEBSITE  := https://www.gnu.org/software/gnutls/
$(PKG)_DESCR    := GnuTLS
$(PKG)_VERSION  := 3.5.16
$(PKG)_CHECKSUM := 0924dec90c37c05f49fec966eba3672dab4d336d879e5c06e06e13325cbfec25
$(PKG)_SUBDIR   := gnutls-$($(PKG)_VERSION)
$(PKG)_FILE     := gnutls-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://gnupg.org/ftp/gcrypt/gnutls/v3.5/$($(PKG)_FILE)
$(PKG)_URL_2    := https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnutls/v3.5/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gettext gmp libgnurx libidn2 libtasn1 libunistring nettle p11-kit unbound zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- https://gnupg.org/ftp/gcrypt/gnutls/v3.5/ | \
    $(SED) -n 's,.*gnutls-\([1-9]\+\.[0-9]\+.[0-9]\+\)\..*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    # AI_ADDRCONFIG referenced by src/serv.c but not provided by mingw.
    # Value taken from https://msdn.microsoft.com/library/windows/desktop/ms737530
    cd '$(SOURCE_DIR)' && autoreconf -fi
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --disable-doc \
        --disable-guile \
        --disable-libdane \
        --disable-nls \
        --disable-rpath \
        --disable-silent-rules \
        --disable-tests \
        --enable-local-libopts \
        --with-libregex-libs="-lgnurx" \
        --with$(if $(BUILD_STATIC),out)-p11-kit \
        CPPFLAGS='-DWINVER=0x0501 -DAI_ADDRCONFIG=0x0400 -DIPV6_V6ONLY=27' \
        LIBS='-lws2_32' \
        ac_cv_prog_AR='$(TARGET)-ar'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-gnutls.exe' \
        `'$(TARGET)-pkg-config' gnutls --cflags --libs`
endef
