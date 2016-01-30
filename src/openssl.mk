# This file is part of MXE.
# See index.html for further information.

PKG             := openssl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.2f
$(PKG)_CHECKSUM := 932b4ee4def2b434f85435d9e3e19ca8ba99ce9a065a61524b429a9d5e9b2e9c
$(PKG)_SUBDIR   := openssl-$($(PKG)_VERSION)
$(PKG)_FILE     := openssl-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.openssl.org/source/$($(PKG)_FILE)
$(PKG)_URL_2    := http://www.openssl.org/source/old/$(call tr,$([a-z]),,$($(PKG)_VERSION))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libgcrypt zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.openssl.org/source/' | \
    $(SED) -n 's,.*openssl-\([0-9][0-9a-z.]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && CC='$(TARGET)-gcc' ./Configure \
        @openssl-target@ \
        zlib \
        $(if $(BUILD_STATIC),no-,)shared \
        no-capieng \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' all install_sw -j 1 \
        CC='$(TARGET)-gcc' \
        RANLIB='$(TARGET)-ranlib' \
        AR='$(TARGET)-ar rcu' \
        CROSS_COMPILE='$(TARGET)-'

    # no way to configure engines subdir install
    $(if $(BUILD_SHARED),
        rm -rf '$(PREFIX)/$(TARGET)/bin/engines' && \
        mv -vf '$(PREFIX)/$(TARGET)/lib/engines' '$(PREFIX)/$(TARGET)/bin/')
endef

$(PKG)_BUILD_i686-w64-mingw32   = $(subst @openssl-target@,mingw,$($(PKG)_BUILD))
$(PKG)_BUILD_x86_64-w64-mingw32 = $(subst @openssl-target@,mingw64,$($(PKG)_BUILD))
