# This file is part of MXE.
# See index.html for further information.

PKG             := xapian-core
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 3d2ea66e9930451dcac4b96f321284f3dee98d51
$(PKG)_SUBDIR   := xapian-core-$($(PKG)_VERSION)
$(PKG)_FILE     := xapian-core-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://oligarchy.co.uk/xapian/$($(PKG)_VERSION)/xapian-core-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- http://xapian.org/download | \
    $(SED) -n 's,.*<a HREF="http://oligarchy.co.uk/xapian/\([^/]*\)/xapian-core[^"]*">.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-static
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
