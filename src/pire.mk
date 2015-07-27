# This file is part of MXE.
# See index.html for further information.

PKG             := pire
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.0.5
$(PKG)_CHECKSUM := fc5f451043c6fc1034f104463a4b9c6c1c46c00c
$(PKG)_SUBDIR   := pire-release-$($(PKG)_VERSION)
$(PKG)_FILE     := pire-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/yandex/pire/archive/release-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi -I'$(PREFIX)/$(TARGET)/share/aclocal'
    cd '$(1)' && ac_cv_func_malloc_0_nonnull=yes ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-extra \
        PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
