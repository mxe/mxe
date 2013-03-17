# This file is part of MXE.
# See index.html for further information.

PKG             := json-c
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 4bae2468bfd73a2b2eec7419c75c262b5833f567
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
