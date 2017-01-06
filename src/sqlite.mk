# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sqlite
$(PKG)_WEBSITE  := http://www.sqlite.org/
$(PKG)_DESCR    := SQLite
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3160200
$(PKG)_CHECKSUM := 65cc0c3e9366f50c0679c5ccd31432cea894bc4a3e8947dabab88c8693263615
$(PKG)_SUBDIR   := $(PKG)-autoconf-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-autoconf-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.sqlite.org/2017/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.sqlite.org/download.html' | \
    $(SED) -n 's,.*sqlite-autoconf-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-readline \
        --enable-threadsafe \
        CFLAGS="-Os"
    $(MAKE) -C '$(1)' -j 1 install
endef
