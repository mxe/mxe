# This file is part of MXE.
# See index.html for further information.

PKG             := a52dec
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.7.4
$(PKG)_CHECKSUM := 79b33bd8d89dad7436f85b9154ad35667aa37321
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://liba52.sourceforge.net/files/$(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://liba52.sourceforge.net/downloads.html' | \
    $(SED) -n 's,.*files/a52dec-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi # The autotools files came with a52dec are _ancient_
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
