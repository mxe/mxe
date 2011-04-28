# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# libevent
PKG             := libevent
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.11
$(PKG)_CHECKSUM := 843b5d395054b9d4d5586220c004c29cdcc37fcf
$(PKG)_SUBDIR   := libevent-$($(PKG)_VERSION)-stable
$(PKG)_FILE     := libevent-$($(PKG)_VERSION)-stable.tar.gz
$(PKG)_WEBSITE  := http://monkey.org/~provos/libevent/
$(PKG)_URL      := http://monkey.org/~provos/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://www.monkey.org/~provos/libevent/' | \
    grep 'libevent-' | \
    $(SED) -n 's,.*libevent-\([0-9][^>]*\)-stable\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= defexec_DATA=
endef
