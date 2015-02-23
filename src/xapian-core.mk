# This file is part of MXE.
# See index.html for further information.

PKG             := xapian-core
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.19
$(PKG)_CHECKSUM := a8679cd0f708e32f2ec76bcdc198cd9fa2e1d65e
$(PKG)_SUBDIR   := xapian-core-$($(PKG)_VERSION)
$(PKG)_FILE     := xapian-core-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://oligarchy.co.uk/xapian/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- http://xapian.org/download | \
    $(SED) -n 's,.*<a HREF="http://oligarchy.co.uk/xapian/\([^/]*\)/xapian-core[^"]*">.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
