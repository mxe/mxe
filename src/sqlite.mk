# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sqlite
$(PKG)_WEBSITE  := https://www.sqlite.org/
$(PKG)_DESCR    := SQLite
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3230000
$(PKG)_CHECKSUM := b7711a1800a071674c2bf76898ae8584fc6c9643cfe933cfc1bc54361e3a6e49
$(PKG)_SUBDIR   := $(PKG)-autoconf-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-autoconf-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.sqlite.org/2018/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.sqlite.org/download.html' | \
    $(SED) -n 's,.*sqlite-autoconf-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-readline \
        --enable-threadsafe \
        CFLAGS="-Os -DSQLITE_ENABLE_COLUMN_METADATA"
    $(MAKE) -C '$(1)' -j 1 install
endef
