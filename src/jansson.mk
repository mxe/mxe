# This file is part of MXE.
# See index.html for further information.

PKG             := jansson
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.7
$(PKG)_CHECKSUM := 51cd3b57f152132de686bb8c1f4471cc9ca7970e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.digip.org/$(PKG)/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

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
