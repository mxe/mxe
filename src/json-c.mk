# This file is part of MXE.
# See index.html for further information.

PKG             := json-c
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := f90f643c8455da21d57b3e8866868a944a93c596
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/downloads/$(PKG)/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) - q -O 'https://github.com/json-c/json-c/downloads' | \
    grep '<a href="/downloads/json-c/json-c/' | \
    $(SED) -n -s,.*href="/downloads/json-c/json-c/json-c-\([0-9.]*\).tar.gz,\1,p' | \
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
