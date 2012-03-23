# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# cURL
PKG             := curl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.25.0
$(PKG)_CHECKSUM := f6016a24051d98806ca3ddf754592701cb66e00c
$(PKG)_SUBDIR   := curl-$($(PKG)_VERSION)
$(PKG)_FILE     := curl-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://curl.haxx.se/libcurl/
$(PKG)_URL      := http://curl.haxx.se/download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gnutls libidn libssh2

define $(PKG)_UPDATE
    wget -q -O- 'http://curl.haxx.se/download/?C=M;O=D' | \
    $(SED) -n 's,.*curl-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./buildconf
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-gnutls \
        --with-libidn \
        --enable-sspi \
        --with-libssh2
    $(MAKE) -C '$(1)' -j '$(JOBS)' install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-curl.exe' \
        `'$(TARGET)-pkg-config' libcurl --cflags --libs`
endef
