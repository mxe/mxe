# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cyrus-sasl
$(PKG)_WEBSITE  := https://github.com/stingdau1206/cyrus-sasl
$(PKG)_DESCR    := Cyrus SASL - Simple Authentication and Security Layer (MinGW fixed)
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1.28
$(PKG)_CHECKSUM := 8cef4caf0cad6dd0e368b21ea57ba9fe8812a7b6bd294e68b5b50ae37e6f4401
$(PKG)_GH_CONF  := stingdau1206/cyrus-sasl/releases,v
$(PKG)_SUBDIR   := cyrus-sasl-$($(PKG)_VERSION)
$(PKG)_FILE     := cyrus-sasl-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://github.com/stingdau1206/cyrus-sasl/releases/download/v$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc openssl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/cyrusimap/cyrus-sasl/releases' | \
    $(SED) -n 's,.*releases/tag/cyrus-sasl-\([0-9][^"]*\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # Clean any previous configure
    -$(MAKE) -C '$(SOURCE_DIR)' distclean 2>/dev/null || true

    cd '$(BUILD_DIR)' && \
        PKG_CONFIG_PATH='$(PREFIX)/$(TARGET)/lib/pkgconfig' \
        CPPFLAGS="`'$(TARGET)-pkg-config' openssl --cflags`" \
        LDFLAGS="`'$(TARGET)-pkg-config' openssl --libs-only-L`" \
        LIBS="`'$(TARGET)-pkg-config' openssl --libs-only-l` -lcrypt32" \
        $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-openssl='$(PREFIX)/$(TARGET)' \
        --enable-static \
        --disable-shared \
        --enable-staticdlopen \
        --disable-sample \
        --enable-plain \
        --enable-cram \
        --enable-scram \
        --enable-login \
        --disable-digest \
        --disable-ntlm \
        --disable-anon \
        --disable-otp \
        --disable-gssapi \
        --disable-krb4 \
        --disable-sql \
        --disable-ldapdb \
        --disable-macos-framework \
        --with-dblib=none \
        --without-saslauthd \
        --without-authdaemond \
        --without-pwcheck
    # Build in correct order: lib must be built before plugins
    $(MAKE) -C '$(BUILD_DIR)/include' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)/common' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)/sasldb' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)/lib' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)/plugins' -j '$(JOBS)'
    # Install only necessary components
    $(MAKE) -C '$(BUILD_DIR)/include' -j 1 install
    $(MAKE) -C '$(BUILD_DIR)/lib' -j 1 install
    $(MAKE) -C '$(BUILD_DIR)/plugins' -j 1 install
endef
