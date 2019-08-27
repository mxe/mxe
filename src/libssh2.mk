# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libssh2
$(PKG)_WEBSITE  := https://libssh2.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.9.0
$(PKG)_CHECKSUM := d5fb8bd563305fd1074dda90bd053fb2d29fc4bce048d182f96eaa466dfadafd
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
        --with-crypto=libgcrypt \
        LIBS="`$(PREFIX)/$(TARGET)/bin/libgcrypt-config --libs`" \
        PKG_CONFIG='$(TARGET)-pkg-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(MXE_DISABLE_CRUFT)

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-libssh2.exe' \
        `'$(TARGET)-pkg-config' --cflags --libs libssh2`
endef
