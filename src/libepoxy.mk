# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libepoxy
$(PKG)_WEBSITE  := https://github.com/anholt/libepoxy
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.1
$(PKG)_CHECKSUM := 6700ddedffb827b42c72cce1e0be6fba67b678b19bf256e1b5efd3ea38cc2bb4
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_GITHUB   := https://github.com/anholt/$(PKG)
$(PKG)_URL      := $($(PKG)_GITHUB)/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc xorg-macros

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(libepoxy_GITHUB)/releases' | \
    $(SED) -n 's,.*/archive/v\([0-9.]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi -I'$(PREFIX)/$(TARGET)/share/aclocal'
    cd '$(1)' && \
        CFLAGS='$(if $(BUILD_STATIC),-DEPOXY_STATIC,-DEPOXY_SHARED -DEPOXY_DLL)' \
        ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(MXE_DISABLE_CRUFT)
    $(SED) 's/Cflags:/Cflags: -DEPOXY_$(if $(BUILD_STATIC),STATIC,SHARED)/' \
        -i '$(PREFIX)/$(TARGET)/lib/pkgconfig/epoxy.pc'

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' epoxy --cflags --libs`
endef
