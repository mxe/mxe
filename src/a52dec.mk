# This file is part of MXE.
# See index.html for further information.

PKG             := a52dec
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.7.4
$(PKG)_CHECKSUM := a21d724ab3b3933330194353687df82c475b5dfb997513eef4c25de6c865ec33
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
    cd '$(1)' && rm aclocal.m4 && autoreconf -fi # The autotools files came with a52dec are _ancient_
    cd '$(1)' && ./configure CFLAGS=-std=gnu89 \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
