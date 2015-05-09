# This file is part of MXE.
# See index.html for further information.

PKG             := sqlite
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3081001
$(PKG)_CHECKSUM := 86bfed5752783fb24c051f3efac5972ce11023f0
$(PKG)_SUBDIR   := $(PKG)-autoconf-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-autoconf-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.sqlite.org/2015/$($(PKG)_FILE)
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
