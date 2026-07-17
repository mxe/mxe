# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := quictls
$(PKG)_WEBSITE  := https://github.com/quictls/openssl
$(PKG)_DESCR    := QuicTLS - OpenSSL fork with QUIC API support
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1.7-quic1
$(PKG)_CHECKSUM := e7e514ea033c290f09c7250dd43a845bc1e08066b793274f3ad3fe04c76a5206
$(PKG)_GH_CONF  := quictls/openssl/releases,openssl-
$(PKG)_SUBDIR   := openssl-openssl-$($(PKG)_VERSION)
$(PKG)_FILE     := openssl-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/quictls/openssl/archive/refs/tags/openssl-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc zlib

$(PKG)_MAKE = $(MAKE) -C '$(1)' -j '$(JOBS)'\
        CC='$(PREFIX)/bin/$(TARGET)-gcc' \
        RANLIB='$(PREFIX)/bin/$(TARGET)-ranlib' \
        AR='$(PREFIX)/bin/$(TARGET)-ar' \
        RC='$(PREFIX)/bin/$(TARGET)-windres' \
        CROSS_COMPILE='$(PREFIX)/bin/$(TARGET)-'

define $(PKG)_BUILD
    # remove previous install (same as openssl.mk)
    rm -rfv '$(PREFIX)/$(TARGET)/include/openssl'
    rm -rfv '$(PREFIX)/$(TARGET)/bin/engines'
    rm -fv '$(PREFIX)/$(TARGET)/'*/{libcrypto*,libssl*}
    rm -fv '$(PREFIX)/$(TARGET)/lib/pkgconfig/'{libcrypto*,libssl*,openssl*}

    cd '$(1)' && CC='$(PREFIX)/bin/$(TARGET)-gcc' RC='$(PREFIX)/bin/$(TARGET)-windres' ./Configure \
        @quictls-target@ \
        zlib \
        $(if $(BUILD_STATIC),no-module no-,)shared \
        no-capieng \
        no-tests \
        enable-tls1_3 \
        --prefix='$(PREFIX)/$(TARGET)' \
        --libdir='$(PREFIX)/$(TARGET)/lib'
    $($(PKG)_MAKE) build_sw
    $($(PKG)_MAKE) install_sw

    # Build test program
    '$(PREFIX)/bin/$(TARGET)-gcc' \
        -W -Wall -Werror \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(PREFIX)/bin/$(TARGET)-pkg-config' openssl --cflags --libs`
endef

$(PKG)_BUILD_i686-w64-mingw32   = $(subst @quictls-target@,mingw,$($(PKG)_BUILD))
$(PKG)_BUILD_x86_64-w64-mingw32 = $(subst @quictls-target@,mingw64,$($(PKG)_BUILD))
