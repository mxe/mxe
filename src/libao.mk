# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libao
$(PKG)_WEBSITE  := https://www.xiph.org/libao/
$(PKG)_DESCR    := AO
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.2
$(PKG)_CHECKSUM := df8a6d0e238feeccb26a783e778716fb41a801536fe7b6fce068e313c0e2bf4d
$(PKG)_SUBDIR   := libao-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/xiph/libao/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://downloads.xiph.org/releases' | \
    $(SED) -n 's,.*<a href="libao-\([0-9][0-9.]*\)\.tar\.[gx]z">.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./autogen.sh && \
    ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-wmm
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
