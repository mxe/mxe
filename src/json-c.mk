# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := json-c
$(PKG)_WEBSITE  := https://github.com/json-c/json-c/wiki
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.13.1
$(PKG)_CHECKSUM := 94a26340c0785fcff4f46ff38609cf84ebcd670df0c8efd75d039cc951d80132
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION)-nodoc.tar.gz
$(PKG)_URL      := https://$(PKG)_releases.s3.amazonaws.com/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://json-c_releases.s3.amazonaws.com' | \
    $(SED) -r 's,<Key>,\n<Key>,g' | \
    $(SED) -n 's,.*releases/json-c-\([0-9.]*\).tar.gz.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./autogen.sh
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        CFLAGS=-Wno-error
    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(MXE_REMOVE_CRUFT)

    '$(TARGET)-gcc' \
        -W -Wall -Werror -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-json-c.exe' \
        `'$(TARGET)-pkg-config' json-c --cflags --libs`
endef

