# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libntlm
$(PKG)_WEBSITE  := https://gitlab.com/gsasl/libntlm/
$(PKG)_DESCR    := Libntlm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.7
$(PKG)_CHECKSUM := d805ebb901cbc9ff411e704cbbf6de4d28e7bcb05c9eca2124f582cbff31c0b1
$(PKG)_SUBDIR   := libntlm-$($(PKG)_VERSION)
$(PKG)_FILE     := libntlm-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://download.savannah.nongnu.org/releases/libntlm/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://download.savannah.nongnu.org/releases/libntlm/'  | \
    $(SED) -n 's,.*libntlm-\([0-9]\+\)\(\.[0-9]\+\)*\..*,\1\2,p' |\
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
