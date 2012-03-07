# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# libffi
PKG             := libffi
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.10
$(PKG)_CHECKSUM := 97abf70e6a6d315d9259d58ac463663051d471e1
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://sourceware.org/$(PKG)/
$(PKG)_URL      := ftp://sourceware.org/pub/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q --no-check-certificate -O- 'http://github.com/atgreen/libffi/tags' | \
    grep '<a href="/atgreen/libffi/tarball/' | \
    $(SED) -n 's,.*href="/atgreen/libffi/tarball/v\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared
    $(MAKE) -C '$(1)/$(TARGET)' -j '$(JOBS)'
    $(MAKE) -C '$(1)/$(TARGET)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -std=c99 -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-libffi.exe' \
        `'$(TARGET)-pkg-config' libffi --cflags --libs`
endef
