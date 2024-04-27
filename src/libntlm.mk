# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libntlm
$(PKG)_WEBSITE  := https://gitlab.com/gsasl/libntlm/
$(PKG)_DESCR    := Libntlm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8
$(PKG)_CHECKSUM := ce6569a47a21173ba69c990965f73eb82d9a093eb871f935ab64ee13df47fda1
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
