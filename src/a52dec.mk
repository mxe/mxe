# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := a52dec
$(PKG)_WEBSITE  := https://git.adelielinux.org/community/a52dec/
$(PKG)_DESCR    := a52dec (aka. liba52)
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.8.0
$(PKG)_CHECKSUM := 03c181ce9c3fe0d2f5130de18dab9bd8bc63c354071515aa56983c74a9cffcc9
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://distfiles.adelielinux.org/source/a52dec/$(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://distfiles.adelielinux.org/source/a52dec/' | \
    $(SED) -n 's,.*<a href="a52dec-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
