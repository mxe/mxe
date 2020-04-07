# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libntlm
$(PKG)_WEBSITE  := https://www.nongnu.org/libntlm/
$(PKG)_DESCR    := Libntlm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.6
$(PKG)_CHECKSUM := f2376b87b06d8755aa3498bb1226083fdb1d2cf4460c3982b05a9aa0b51d6821
$(PKG)_SUBDIR   := libntlm-$($(PKG)_VERSION)
$(PKG)_FILE     := libntlm-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.nongnu.org/libntlm/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.nongnu.org/libntlm/releases/'  | \
    $(SED) -n 's,.*libntlm-\([0-9]\+\)\(\.[0-9]\+\)*\..*,\1\2,p' |\
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
