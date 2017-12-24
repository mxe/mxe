# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := json-c
$(PKG)_WEBSITE  := https://github.com/json-c/json-c/wiki
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.12.1
$(PKG)_CHECKSUM := 5a617da9aade997938197ef0f8aabd7f97b670c216dc173977e1d56eef9e1291
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION)-nodoc.tar.gz
$(PKG)_URL      := https://s3.amazonaws.com/$(PKG)_releases/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://s3.amazonaws.com/json-c_releases' | \
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
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-json-c.exe' \
        `'$(TARGET)-pkg-config' json-c --cflags --libs`
endef

