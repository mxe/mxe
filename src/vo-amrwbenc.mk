# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := vo-amrwbenc
$(PKG)_WEBSITE  := https://github.com/mstorsjo/vo-amrwbenc
$(PKG)_DESCR    := VO-AMRWBENC
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.3
$(PKG)_CHECKSUM := 5652b391e0f0e296417b841b02987d3fd33e6c0af342c69542cbb016a71d9d4e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/opencore-amr/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/opencore-amr/files/vo-amrwbenc/' | \
    $(SED) -n 's,.*amrwbenc-\([0-9.]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
