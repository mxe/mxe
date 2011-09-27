# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# libevent
PKG             := libevent
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.14
$(PKG)_CHECKSUM := b52b466f5a418744faf5f12b0fe3877cb7fb0b6e
$(PKG)_SUBDIR   := libevent-$($(PKG)_VERSION)-stable
$(PKG)_FILE     := libevent-$($(PKG)_VERSION)-stable.tar.gz
$(PKG)_WEBSITE  := http://libevent.org
$(PKG)_URL      := https://github.com/downloads/$(PKG)/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://libevent.org/' | \
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
