# This file is part of MXE.
# See index.html for further information.

PKG             := openssl
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 3f1b1223c9e8189bfe4e186d86449775bd903460
$(PKG)_SUBDIR   := openssl-$($(PKG)_VERSION)
$(PKG)_FILE     := openssl-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.openssl.org/source/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.openssl.org/source/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib libgcrypt

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.openssl.org/source/' | \
    $(SED) -n 's,.*openssl-\([0-9][0-9a-z.]*\)\.tar.*,\1,p' | \
    grep -v '^0\.9\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && CC='$(TARGET)-gcc' ./Configure \
        mingw \
        zlib \
        no-shared \
        no-capieng \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' install -j 1 \
        CC='$(TARGET)-gcc' \
        RANLIB='$(TARGET)-ranlib' \
        AR='$(TARGET)-ar rcu'
endef
