# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# nettle
PKG             := nettle
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4
$(PKG)_CHECKSUM := 1df0cd013e83f73b78a5521411a67e331de3dfa6
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.lysator.liu.se/~nisse/nettle/
$(PKG)_URL      := http://www.lysator.liu.se/~nisse/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gmp

define $(PKG)_UPDATE
    wget -q -O- 'http://www.lysator.liu.se/~nisse/archive/' | \
    $(SED) -n 's,.*nettle-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --enable-static \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
