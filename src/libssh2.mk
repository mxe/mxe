# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libssh2
$(PKG)_WEBSITE  := https://libssh2.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.2
$(PKG)_CHECKSUM := 088307d9f6b6c4b8c13f34602e8ff65d21c2dc4d55284dfe15d502c4ee190d67
$(PKG)_SUBDIR   := libssh2-$($(PKG)_VERSION)
$(PKG)_FILE     := libssh2-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://libssh2.org/download/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libgcrypt zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://libssh2.org/download/?C=M;O=D' | \
    grep 'libssh2-' | \
    $(SED) -n 's,.*libssh2-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./buildconf
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-examples-build \
        --without-openssl \
        --with-libgcrypt \
        LIBS="`$(PREFIX)/$(TARGET)/bin/libgcrypt-config --libs`" \
        PKG_CONFIG='$(TARGET)-pkg-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(MXE_DISABLE_CRUFT)

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-libssh2.exe' \
        `'$(TARGET)-pkg-config' --cflags --libs libssh2`
endef
