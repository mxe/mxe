# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := jansson
$(PKG)_WEBSITE  := http://www.digip.org/jansson/
$(PKG)_DESCR    := Jansson
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.12
$(PKG)_CHECKSUM := 645d72cc5dbebd4df608d33988e55aa42a7661039e19a379fcbe5c79d1aee1d2
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
