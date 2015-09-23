# This file is part of MXE.
# See index.html for further information.

PKG             := json-c
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.12
$(PKG)_CHECKSUM := 6fd6d2311d610b279e1bcdd5c6d4f699700159d3e0786de8306af7b4bc94fb35
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION)-nodoc.tar.gz
$(PKG)_URL      := https://s3.amazonaws.com/$(PKG)_releases/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

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
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-json-c.exe' \
        `'$(TARGET)-pkg-config' json-c --cflags --libs`
endef

