# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := lame
$(PKG)_WEBSITE  := https://lame.sourceforge.io/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.99.5
$(PKG)_CHECKSUM := 24346b4158e4af3bd9f2e194bb23eb473c75fb7377011523353196b19b9a23ff
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://lame.cvs.sourceforge.net/viewvc/lame/lame/' | \
    grep RELEASE_ | \
    $(SED) -n 's,.*RELEASE__\([0-9_][^<]*\)<.*,\1,p' | \
    tr '_' '.' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -i && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-frontend
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
