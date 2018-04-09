# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := xmlsec
$(PKG)_WEBSITE  := https://www.aleksey.com/xmlsec/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.25
$(PKG)_CHECKSUM := 5a2d400043ac5b2aa84b66b6b000704f0f147077afc6546d73181f5c71019985
$(PKG)_GH_CONF  := lsh123/xmlsec/tags,xmlsec-,,,_
$(PKG)_DEPS     := cc gnutls libgcrypt libltdl libxml2 libxslt openssl

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && autoreconf -fi
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-docs=no \
        --enable-apps=no

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1 $(MXE_DISABLE_CRUFT) LIBS=-lgcrypt
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1 $(MXE_DISABLE_CRUFT)

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall -ansi -pedantic \
        '$(SOURCE_DIR)/examples/decrypt1.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' xmlsec1-openssl --cflags --libs`
endef
