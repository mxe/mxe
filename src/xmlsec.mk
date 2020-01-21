# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := xmlsec
$(PKG)_WEBSITE  := https://www.aleksey.com/xmlsec/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.29
$(PKG)_CHECKSUM := b23ec79b28f3bd8d525eed4b0c75ce1c4de7696563dde7e9dd3cdf2a172cfa3f
$(PKG)_GH_CONF  := lsh123/xmlsec/tags,xmlsec-,,,_
$(PKG)_DEPS     := cc gnutls libgcrypt libltdl libxml2 libxslt openssl

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && autoreconf -fi
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-docs=no \
        --enable-apps=no \
        CFLAGS='-D_WIN32_WINNT=0x0600 -DWINVER=0x0600' \
        LIBS="`$(TARGET)-pkg-config --libs-only-l dlfcn`"

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' V=1 $(MXE_DISABLE_CRUFT) LIBS=-lgcrypt
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install V=1 $(MXE_DISABLE_CRUFT)

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall -ansi -pedantic \
        '$(SOURCE_DIR)/examples/decrypt1.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' xmlsec1-openssl dlfcn --cflags --libs`
endef
