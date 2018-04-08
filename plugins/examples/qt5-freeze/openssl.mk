# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := openssl
$(PKG)_WEBSITE  := https://www.openssl.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.2o
$(PKG)_CHECKSUM := ec3f5c9714ba0fd45cb4e087301eb1336c317e0d20b575a125050470e8089e4d
$(PKG)_PATCHES  := $(realpath $(sort $(wildcard $(dir $(lastword $(MAKEFILE_LIST)))/$(PKG)-[0-9]*.patch)))
$(PKG)_SUBDIR   := openssl-$($(PKG)_VERSION)
$(PKG)_FILE     := openssl-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.openssl.org/source/$($(PKG)_FILE)
$(PKG)_URL_2    := https://www.openssl.org/source/old/$(call tr,$([a-z]),,$($(PKG)_VERSION))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.openssl.org/source/' | \
    $(SED) -n 's,.*openssl-\([0-9][0-9a-z.]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && CC='$(TARGET)-gcc' RC='$(TARGET)-windres' ./Configure \
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
