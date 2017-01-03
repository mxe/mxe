# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sqlite
$(PKG)_WEBSITE  := http://www.sqlite.org/
$(PKG)_DESCR    := SQLite
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3160100
$(PKG)_CHECKSUM := 13fbe45e3088b3955feb2ae68648a0f81586d6d519766b211767a1ffcd268fd0
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
