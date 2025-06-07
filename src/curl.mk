# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := curl
$(PKG)_WEBSITE  := https://curl.haxx.se/libcurl/
$(PKG)_DESCR    := cURL
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.14.1
$(PKG)_CHECKSUM := f4619a1e2474c4bbfedc88a7c2191209c8334b48fa1f4e53fd584cc12e9120dd
$(PKG)_SUBDIR   := curl-$($(PKG)_VERSION)
$(PKG)_FILE     := curl-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://curl.haxx.se/download/$($(PKG)_FILE)
$(PKG)_DEPS     := cc brotli libidn2 libpsl libssh2 nghttp2 pthreads zstd

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://curl.haxx.se/download/?C=M;O=D' | \
    $(SED) -n 's,.*curl-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-schannel \
        --with-libidn2 \
        --enable-sspi \
        --enable-ipv6 \
        --with-libssh2 \
        --with-nghttp2 \
        CPPFLAGS="`'$(TARGET)-pkg-config' libnghttp2 --cflags`" \
        LIBS="`'$(TARGET)-pkg-config' libpsl libbrotlidec pthreads --libs`"
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_DOCS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_DOCS)
    ln -sf '$(PREFIX)/$(TARGET)/bin/curl-config' '$(PREFIX)/bin/$(TARGET)-curl-config'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-curl.exe' \
        `'$(TARGET)-pkg-config' libcurl --cflags --libs`
endef
