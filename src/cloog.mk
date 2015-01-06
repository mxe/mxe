# This file is part of MXE.
# See index.html for further information.

PKG             := cloog
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.18.1
$(PKG)_CHECKSUM := 2dc70313e8e2c6610b856d627bce9c9c3f848077
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.bastoul.net/cloog/pages/download/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://gcc.gnu.org/pub/gcc/infrastructure/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gmp isl

# stick to tested versions from gcc
define $(PKG)_UPDATE
    $(WGET) -q -O- 'ftp://gcc.gnu.org/pub/gcc/infrastructure/' | \
    $(SED) -n 's,.*cloog-\([0-9][^>]*\)\.tar.*,\1,p' | \
    $(SORT) -V |
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --enable-static \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-gmp-prefix='$(PREFIX)/$(TARGET)' \
        --with-isl-prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef

$(PKG)_BUILD_SHARED =
