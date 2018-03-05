# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := pire
$(PKG)_WEBSITE  := https://github.com/yandex/pire
$(PKG)_DESCR    := PIRE
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.0.5
$(PKG)_CHECKSUM := 85a9bd66fff568554826e4aff9b188ed6124e3ea0530cc561723b36aea2a58e3
$(PKG)_SUBDIR   := pire-release-$($(PKG)_VERSION)
$(PKG)_FILE     := pire-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/yandex/pire/archive/release-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, yandex/pire, release-)
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-extra \
        ac_cv_func_malloc_0_nonnull=yes
    $(MAKE) -C '$(1)/pire' -j '$(JOBS)' bin_PROGRAMS= LDFLAGS='-no-undefined'
    $(MAKE) -C '$(1)/pire' -j 1 install bin_PROGRAMS=

    '$(TARGET)-g++' \
        -W -Wall -Werror \
        '$(1)/samples/pigrep/pigrep.cpp' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        -lpire
endef
