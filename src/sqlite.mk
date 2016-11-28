# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sqlite
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3150200
$(PKG)_CHECKSUM := 07b35063b9386865b78226cdaca9a299d938a87aaa8fdc4d73edb0cef30f3149
$(PKG)_SUBDIR   := $(PKG)-autoconf-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-autoconf-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.sqlite.org/2016/$($(PKG)_FILE)
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
