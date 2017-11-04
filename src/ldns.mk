# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ldns
$(PKG)_WEBSITE  := https://nlnetlabs.nl/projects/ldns/
$(PKG)_DESCR    := NLnetLabs ldns
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.7.0
$(PKG)_CHECKSUM := c19f5b1b4fb374cfe34f4845ea11b1e0551ddc67803bd6ddd5d2a20f0997a6cc
$(PKG)_SUBDIR   := ldns-$($(PKG)_VERSION)
$(PKG)_FILE     := ldns-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://nlnetlabs.nl/downloads/ldns/ldns-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc openssl

$(PKG)_UPDATE = \
    $(call GET_LATEST_VERSION, https://nlnetlabs.nl/downloads/ldns)

define $(PKG)_BUILD
    # --disable-dane for openssl < 1.1
    # build and install the library
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --disable-dane-ta-usage \
        --without-drill \
        --without-examples \
        --without-pyldns \
        --without-pyldnsx \
        --without-p5-dns-ldns \
        --with-ssl='$(PREFIX)/$(TARGET)' \
        LIBS="`'$(TARGET)-pkg-config' openssl --libs`"
    $(MAKE) -C '$(BUILD_DIR)' -j 1 setup-builddir
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' lib

    $(if $(BUILD_SHARED), \
        $(MAKE) -C '$(BUILD_DIR)' -j 1 install-config install-h && \
        $(INSTALL) -m644 '$(BUILD_DIR)/lib/libldns.dll.a' '$(PREFIX)/$(TARGET)/lib' && \
        $(INSTALL) -m755 '$(BUILD_DIR)/lib/libldns-2.dll' '$(PREFIX)/$(TARGET)/bin' \
    $(else), \
        $(MAKE) -C '$(BUILD_DIR)' -j 1 install)

    # create pkg-config file and symlink ldns-config
    ln -sf '$(PREFIX)/$(TARGET)/bin/ldns-config' '$(PREFIX)/bin/$(TARGET)-ldns-config'

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: $($(PKG)_DESCR)'; \
     echo 'Requires: openssl'; \
     echo 'Libs: -lldns';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall -Werror -pedantic \
        '$(SOURCE_DIR)/examples/ldns-chaos.c' -I'$(BUILD_DIR)'\
         -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
