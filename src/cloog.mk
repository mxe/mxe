# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cloog
$(PKG)_WEBSITE  := https://www.bastoul.net/cloog/
$(PKG)_DESCR    := CLooG Code Generator
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.18.4
$(PKG)_CHECKSUM := 325adf3710ce2229b7eeb9e84d3b539556d093ae860027185e7af8a8b00a750e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.bastoul.net/cloog/pages/download/$($(PKG)_FILE)
$(PKG)_URL_2    := https://gcc.gnu.org/pub/gcc/infrastructure/$($(PKG)_FILE)
$(PKG)_DEPS     := cc gmp isl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.bastoul.net/cloog/download.php' | \
    $(SED) -n 's,.*cloog-\([0-9][^>]*\)\.tar.*,\1,p' | \
    $(SORT) -V |
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-gmp-prefix='$(PREFIX)/$(TARGET)' \
        --with-isl-prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' $(if $(BUILD_SHARED),LDFLAGS=-no-undefined)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
