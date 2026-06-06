# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := flint
$(PKG)_WEBSITE  := https://www.flintlib.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.5.0
$(PKG)_CHECKSUM := 3982f385f00610a944e0152eb0a29893b2366fa640e8f5f3076c47564cf7e2a6
$(PKG)_GH_CONF  := flintlib/flint/releases,v
$(PKG)_DEPS     := cc gmp mpfr pthreads

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && ./bootstrap.sh
    cd '$(SOURCE_DIR)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-pthread \
        --with-gmp-include='$(PREFIX)/$(TARGET)/include' \
        --with-gmp-lib='$(PREFIX)/$(TARGET)/lib' \
        --with-mpfr-include='$(PREFIX)/$(TARGET)/include' \
        --with-mpfr-lib='$(PREFIX)/$(TARGET)/lib' \
        --without-blas \
        --without-gc \
        --without-ntl
    $(MAKE) -C '$(SOURCE_DIR)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT)
    $(MAKE) -C '$(SOURCE_DIR)' -j 1 install $(MXE_DISABLE_CRUFT)

    '$(TARGET)-gcc' \
        -Wall -Werror -std=c99 -pedantic \
        '$(PWD)/src/$(PKG)-test.c' \
        -o \
        '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
