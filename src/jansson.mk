# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := jansson
$(PKG)_WEBSITE  := http://www.digip.org/jansson/
$(PKG)_DESCR    := Jansson
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.10
$(PKG)_CHECKSUM := 241125a55f739cd713808c4e0089986b8c3da746da8b384952912ad659fa2f5a
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.digip.org/$(PKG)/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.digip.org/jansson/' | \
    $(SED) -n 's,.*/jansson-\([0-9][^>]*\)\.tar\.bz2.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
