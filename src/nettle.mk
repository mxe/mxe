# This file is part of MXE.
# See index.html for further information.

PKG             := nettle
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 1df0cd013e83f73b78a5521411a67e331de3dfa6
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.lysator.liu.se/~nisse/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gmp

define $(PKG)_UPDATE
    wget -q -O- 'http://www.lysator.liu.se/~nisse/archive/' | \
    $(SED) -n 's,.*nettle-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v 'pre' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        $(LINK_STYLE) \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef

$(PKG)_BUILD_i686-static-mingw32    = $($(PKG)_BUILD)
$(PKG)_BUILD_x86_64-static-mingw32  = $($(PKG)_BUILD)
$(PKG)_BUILD_i686-dynamic-mingw32   = $($(PKG)_BUILD)
$(PKG)_BUILD_x86_64-dynamic-mingw32 = $($(PKG)_BUILD)
