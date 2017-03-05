# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gettext
$(PKG)_WEBSITE  := https://www.gnu.org/software/gettext/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.19.8.1
$(PKG)_CHECKSUM := ff942af0e438ced4a8b0ea4b0b6e0d6d657157c5e2364de57baa279c1c125c43
$(PKG)_SUBDIR   := gettext-$($(PKG)_VERSION)
$(PKG)_FILE     := gettext-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/gettext/$($(PKG)_FILE)
$(PKG)_URL_2    := https://ftpmirror.gnu.org/gettext/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.gnu.org/gnu/gettext/' | \
    grep 'gettext-' | \
    $(SED) -n 's,.*gettext-\([0-9][^>]*\)\.tar.*,\1,p' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)/gettext-runtime' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-threads=win32 \
        --without-libexpat-prefix \
        --without-libxml2-prefix \
        CONFIG_SHELL=$(SHELL)
    $(MAKE) -C '$(1)/gettext-runtime/intl' -j '$(JOBS)' install
endef

define $(PKG)_BUILD_$(BUILD)
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)' man1_MANS=
    $(MAKE) -C '$(1).build' -j 1 install man1_MANS=
endef
