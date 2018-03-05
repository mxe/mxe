# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := lzo
$(PKG)_WEBSITE  := https://www.oberhumer.com/opensource/lzo/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.09
$(PKG)_CHECKSUM := f294a7ced313063c057c504257f437c8335c41bfeed23531ee4e6a2b87bcb34c
$(PKG)_SUBDIR   := lzo-$($(PKG)_VERSION)
$(PKG)_FILE     := lzo-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.oberhumer.com/opensource/lzo/download/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.oberhumer.com/opensource/lzo/download/' | \
    grep 'lzo-' | \
    grep -v 'minilzo-' | \
    $(SED) -n 's,.*lzo-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= LDFLAGS=-no-undefined
endef
