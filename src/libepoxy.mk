# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libepoxy
$(PKG)_WEBSITE  := https://github.com/anholt/libepoxy
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.1
$(PKG)_CHECKSUM := 6700ddedffb827b42c72cce1e0be6fba67b678b19bf256e1b5efd3ea38cc2bb4
$(PKG)_GH_CONF  := anholt/libepoxy/releases/latest
# prefix `v` removed from 1.4.1 onwards, remove URL_2 after update
$(PKG)_URL_2    := https://github.com/anholt/libepoxy/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc xorg-macros

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && autoreconf -fi -I'$(PREFIX)/$(TARGET)/share/aclocal'
    cd '$(BUILD_DIR)' && \
        CFLAGS='$(if $(BUILD_STATIC),-DEPOXY_STATIC,-DEPOXY_SHARED -DEPOXY_DLL)' \
        $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_CRUFT)
    $(SED) 's/Cflags:/Cflags: -DEPOXY_$(if $(BUILD_STATIC),STATIC,SHARED)/' \
        -i '$(PREFIX)/$(TARGET)/lib/pkgconfig/epoxy.pc'

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' epoxy --cflags --libs`
endef
