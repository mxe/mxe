# This file is part of MXE.
# See index.html for further information.

PKG             := json-c
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := d78d38037dd6d9d19388770b5ebe33a8531b32ba
$(PKG)_SUBDIR   := $(PKG)-$(PKG)-$($(PKG)_VERSION)-20120530
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION)-20120530.tar.gz
$(PKG)_URL      := https://github.com/$(PKG)/$(PKG)/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/json-c/json-c/tags' | \
    $(SED) -n 's,.*href="/json-c/json-c/archive/json-c-\([0-9.]*\)-\([0-9]*\).tar.gz.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./autogen.sh
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --build="`config.guess`"\
        --disable-shared
        CFLAGS=-Wno-error
    $(MAKE) -C '$(1)' -j '$(JOBS)' install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-json-c.exe' \
        `'$(TARGET)-pkg-config' json --cflags --libs`
endef
