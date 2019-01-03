# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ogg
$(PKG)_WEBSITE  := https://www.xiph.org/ogg/
$(PKG)_DESCR    := OGG
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.3
$(PKG)_CHECKSUM := c2e8a485110b97550f453226ec644ebac6cb29d1caef2902c007edab4308d985
$(PKG)_SUBDIR   := libogg-$($(PKG)_VERSION)
$(PKG)_FILE     := libogg-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://downloads.xiph.org/releases/ogg/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.xiph.org/downloads/' | \
    $(SED) -n 's,.*libogg-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
