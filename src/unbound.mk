# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := unbound
$(PKG)_WEBSITE  := https://unbound.net
$(PKG)_DESCR    := Unbound is a validating, recursive, and caching DNS resolver.
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.6.7
$(PKG)_CHECKSUM := 4e7bd43d827004c6d51bef73adf941798e4588bdb40de5e79d89034d69751c9f
$(PKG)_SUBDIR   := unbound-$($(PKG)_VERSION)
$(PKG)_FILE     := unbound-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://unbound.net/downloads/unbound-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc expat libsodium openssl zlib

$(PKG)_UPDATE = \
    $(call GET_LATEST_VERSION,https://unbound.net/downloads,unbound-)

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --disable-flto \
        --with-libunbound-only \
        --with-conf_file='C:/Program Files/Unbound/service.conf' \
        --with-rootkey-file='C:/Program Files/Unbound/root.key' \
        --with-rootcert-file='C:/Program Files/Unbound/icannbundle.pem' \
        --with-libexpat='$(PREFIX)/$(TARGET)' \
        --with-libsodium='$(PREFIX)/$(TARGET)' \
        --with-ssl='$(PREFIX)/$(TARGET)' \
        LIBS="`'$(TARGET)-pkg-config' openssl --libs`"

    # fixup libtool
    $(SED) -i 's/global_symbol_pipe=""/global_symbol_pipe=echo/' '$(BUILD_DIR)/libtool'

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: $($(PKG)_DESCR)'; \
     echo 'Requires: expat libsodium openssl zlib'; \
     echo 'Libs: -lunbound -lws2_32 -liphlpapi';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
