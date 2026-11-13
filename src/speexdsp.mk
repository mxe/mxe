# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := speexdsp
$(PKG)_WEBSITE  := https://speex.org/
$(PKG)_DESCR    := SpeexDSP
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2rc3
$(PKG)_CHECKSUM := 4ae688600039f5d224bdf2e222d2fbde65608447e4c2f681585e4dca6df692f1
$(PKG)_SUBDIR   := speexdsp-$($(PKG)_VERSION)
$(PKG)_FILE     := speexdsp-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://downloads.xiph.org/releases/speex/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    git ls-remote --tags 'https://gitlab.xiph.org/xiph/speexdsp.git' | \
    $(SED) -n 's,.*refs/tags/SpeexDSP-\([0-9][^^{]*\)$$,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS= doc_DATA=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS= doc_DATA=
endef
