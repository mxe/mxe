# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := vo-aacenc
$(PKG)_WEBSITE  := https://github.com/mstorsjo/vo-aacenc
$(PKG)_DESCR    := VO-AACENC
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.3
$(PKG)_CHECKSUM := e51a7477a359f18df7c4f82d195dab4e14e7414cbd48cf79cc195fc446850f36
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/opencore-amr/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/opencore-amr/files/vo-aacenc/' | \
    $(SED) -n 's,.*aacenc-\([0-9.]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
