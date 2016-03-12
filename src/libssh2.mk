# This file is part of MXE.
# See index.html for further information.

PKG             := libssh2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.7.0
$(PKG)_CHECKSUM := e4561fd43a50539a8c2ceb37841691baf03ecb7daf043766da1b112e4280d584
$(PKG)_SUBDIR   := libssh2-$($(PKG)_VERSION)
$(PKG)_FILE     := libssh2-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.libssh2.org/download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libgcrypt zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.libssh2.org/download/?C=M;O=D' | \
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
        PKG_CONFIG='$(TARGET)-pkg-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(MXE_DISABLE_CRUFT)

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-libssh2.exe' \
        `'$(TARGET)-pkg-config' --cflags --libs libssh2`
endef
