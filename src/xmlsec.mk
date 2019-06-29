# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := xmlsec
$(PKG)_WEBSITE  := https://www.aleksey.com/xmlsec/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.28
$(PKG)_CHECKSUM := 88c0ebf5f73e6a2d3ce11dd099fd20adb4a2997f4e9ab8064bb3a2800fd23fab
$(PKG)_GH_CONF  := lsh123/xmlsec/tags,xmlsec-,,,_
$(PKG)_DEPS     := cc gnutls libgcrypt libltdl libxml2 libxslt openssl

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && autoreconf -fi
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-docs=no \
        --enable-apps=no \
        LIBS="`$(TARGET)-pkg-config --libs-only-l dlfcn`"

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1 $(MXE_DISABLE_CRUFT) LIBS=-lgcrypt
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1 $(MXE_DISABLE_CRUFT)

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall -ansi -pedantic \
        '$(SOURCE_DIR)/examples/decrypt1.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' xmlsec1-openssl dlfcn --cflags --libs`
endef
