# This file is part of MXE.
# See index.html for further information.

PKG             := lzo
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.08
$(PKG)_CHECKSUM := 64c3e44843a44ffc4533aa89e41516f42bfefa76
$(PKG)_SUBDIR   := lzo-$($(PKG)_VERSION)
$(PKG)_FILE     := lzo-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.oberhumer.com/opensource/lzo/download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.oberhumer.com/opensource/lzo/download/' | \
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
